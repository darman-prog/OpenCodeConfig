/**
 * Notificaciones de escritorio nativas de Windows para OpenCode.
 *
 * Por que existe: OpenCode delega las notificaciones al terminal (OSC 777).
 * Windows Terminal 1.24 no soporta esa secuencia, asi que el toast nativo nunca
 * aparece. Este plugin emite el toast por WinRT y solo cuando el terminal que
 * hospeda la sesion no esta en primer plano.
 *
 * V2: escucha session.execution.* (session.idle no es fiable) y permission.asked.
 */

import { appendFileSync } from "node:fs";
import { spawn } from "node:child_process";

// AppID de PowerShell: permite mostrar el toast sin instalar ni registrar nada.
const APP_ID =
  "{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\\WindowsPowerShell\\v1.0\\powershell.exe";

const DEBUG_EVENTS = process.env.OPENCODE_PLUGIN_DEBUG === "1";
const DEBUG_FILE = process.env.OPENCODE_PLUGIN_DEBUG_FILE;

// La sonda escribe solo cuando el smoke define OPENCODE_PLUGIN_DEBUG_FILE.
function debug(message) {
  if (!DEBUG_FILE) return;
  try {
    appendFileSync(DEBUG_FILE, `${new Date().toISOString()} [notify-windows] ${message}\n`);
  } catch {
    // La sonda nunca debe romper el plugin.
  }
}

const PS_SCRIPT = `
$ErrorActionPreference = 'Stop'
Add-Type @'
using System;
using System.Runtime.InteropServices;
public class FgWin {
  [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
}
'@
$handle = [FgWin]::GetForegroundWindow()
$fgPid = 0
[void][FgWin]::GetWindowThreadProcessId($handle, [ref]$fgPid)
$fg = (Get-Process -Id $fgPid -ErrorAction SilentlyContinue).ProcessName
if ($fg -and $env:OC_TERM_PROC -and $fg -match $env:OC_TERM_PROC) { exit 0 }
try {
  [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType=WindowsRuntime] | Out-Null
  [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType=WindowsRuntime] | Out-Null
  $template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
  $texts = $template.GetElementsByTagName('text')
  $null = $texts.Item(0).AppendChild($template.CreateTextNode($env:OC_NOTIFY_TITLE))
  $null = $texts.Item(1).AppendChild($template.CreateTextNode($env:OC_NOTIFY_BODY))
  # El toast sin nodo <audio> llega mudo; este fallback suena aunque falle el audio de la TUI.
  $audio = $template.CreateElement('audio')
  $null = $audio.SetAttribute('src', 'ms-winsoundevent:Notification.Default')
  $null = $template.DocumentElement.AppendChild($audio)
  $toast = [Windows.UI.Notifications.ToastNotification]::new($template)
  [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($env:OC_APP_ID).Show($toast)
} catch {
  exit 1
}
`;

// Proceso del terminal que hospeda esta sesion: si esta en primer plano, no molestar.
const TERM_PATTERN = (() => {
  const names = [];
  if (process.env.WT_SESSION) names.push("WindowsTerminal");
  if (process.env.WEZTERM_EXECUTABLE) names.push("wezterm-gui");
  if (process.env.ALACRITTY_WINDOW_ID) names.push("alacritty");
  if (process.env.GHOSTTY_RESOURCES_DIR) names.push("ghostty");
  if (process.env.TERM_PROGRAM === "vscode") names.push("Code");
  if (process.env.OPENCODE_APP) names.push("OpenCode");
  return names.join("|");
})();

function notify(title, body) {
  try {
    const encoded = Buffer.from(PS_SCRIPT, "utf16le").toString("base64");
    const child = spawn(
      "powershell.exe",
      ["-NoProfile", "-NonInteractive", "-WindowStyle", "Hidden", "-EncodedCommand", encoded],
      {
        windowsHide: true,
        stdio: ["ignore", "ignore", "pipe"],
        env: {
          ...process.env,
          OC_NOTIFY_TITLE: title,
          OC_NOTIFY_BODY: body,
          OC_APP_ID: APP_ID,
          OC_TERM_PROC: TERM_PATTERN,
        },
      },
    );
    let stderr = "";
    child.stderr?.on("data", (data) => {
      stderr += String(data);
    });
    child.on("error", () => {});
    child.on("exit", (code) => {
      if (code !== 0) console.log("[notify-windows] fallo al notificar:", code, stderr.slice(0, 300));
    });
  } catch {
    // Una notificacion nunca debe romper la sesion.
  }
}

function propsOf(event) {
  return event?.properties ?? event?.data ?? {};
}

function sessionIdOf(event) {
  const props = propsOf(event);
  return props.sessionID ?? props.session?.id ?? props.id;
}

function parentIdOf(event) {
  const props = propsOf(event);
  return props.info?.parentID ?? props.session?.parentID ?? props.parentID;
}

export default {
  id: "notify-windows",
  setup(ctx) {
    console.log("[notify-windows] plugin loaded");
    debug("setup start");
    const controller = new AbortController();
    // sessionID -> parentID: permite ignorar el done de sesiones hijas (subagentes).
    const parents = new Map();
    const notified = new Set();

    const finishSession = (sessionID, status) => {
      if (!sessionID || notified.has(sessionID)) return;
      if (parents.get(sessionID)) return; // subagente: el done del principal llega aparte
      notified.add(sessionID);
      const body =
        status === "failed"
          ? "Sesion fallida"
          : status === "interrupted"
            ? "Sesion interrumpida"
            : "Sesion completada";
      debug(`notify session=${sessionID} body=${body}`);
      notify("OpenCode", body);
    };

    void (async () => {
      for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
        const type = event?.type ?? "";
        const props = propsOf(event);
        const sessionID = sessionIdOf(event);
        debug(`event ${type} session=${sessionID ?? "-"} props=${JSON.stringify(props).slice(0, 240)}`);
        if (DEBUG_EVENTS) {
          console.log(`[notify-windows] event ${type}`, JSON.stringify(props).slice(0, 400));
        }

        if (type === "session.created" || type === "session.updated") {
          if (sessionID) parents.set(sessionID, parentIdOf(event));
          continue;
        }

        if (type === "session.deleted") {
          if (sessionID) parents.delete(sessionID);
          continue;
        }

        if (
          type === "session.execution.succeeded" ||
          type === "session.execution.failed" ||
          type === "session.execution.interrupted"
        ) {
          finishSession(sessionID, type.split(".").pop());
          continue;
        }

        if (type === "permission.asked" || type === "permission.updated") {
          const kind = props.permission ?? props.type ?? "una herramienta";
          debug(`notify permission session=${sessionID ?? "-"} kind=${kind}`);
          notify("OpenCode", `Pide permiso para: ${kind}`);
        }
      }
    })().catch(() => {});
    return () => controller.abort();
  },
};
