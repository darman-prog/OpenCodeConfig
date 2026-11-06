import { appendFileSync } from "node:fs"
import { execFile } from "node:child_process"
import { promisify } from "node:util"

const execFileAsync = promisify(execFile)
// rtk rewrite es local; 2 s evita que una anomalia frene la shell.
const REWRITE_TIMEOUT_MS = 2000
const DEBUG_FILE = process.env.OPENCODE_PLUGIN_DEBUG_FILE

// La sonda escribe solo cuando el smoke define OPENCODE_PLUGIN_DEBUG_FILE.
function debug(message) {
  if (!DEBUG_FILE) return
  try {
    appendFileSync(DEBUG_FILE, `${new Date().toISOString()} [rtk] ${message}\n`)
  } catch {
    // La sonda nunca debe romper el plugin.
  }
}

// Devuelve el comando reescrito solo si rtk propone un cambio real.
// rtk rewrite puede salir con codigo != 0 y aun asi escribir el comando en stdout.
function rewriteCommand(command) {
  return new Promise((resolve) => {
    execFile(
      "rtk",
      ["rewrite", command],
      {
        encoding: "utf8",
        timeout: REWRITE_TIMEOUT_MS,
        windowsHide: true,
        maxBuffer: 1024 * 1024,
      },
      (_error, stdout) => {
        const rewritten = String(stdout ?? "").trim()
        resolve(rewritten && rewritten !== command ? rewritten : null)
      },
    )
  })
}

export default {
  id: "rtk",
  async setup(ctx) {
    debug("setup start")
    try {
      // `rtk --version` funciona en Windows; `which` no existe alli.
      await execFileAsync("rtk", ["--version"], { timeout: 1500, windowsHide: true })
      debug("rtk binary ok")
    } catch (error) {
      debug(`rtk binary missing: ${String(error)}`)
      console.warn("[rtk] rtk binary not found in PATH - plugin disabled")
      return
    }

    await ctx.tool.hook("execute.before", async (event) => {
      debug(`tool event tool=${event.tool} input=${JSON.stringify(event.input).slice(0, 200)}`)
      const tool = String(event.tool ?? "").toLowerCase()
      if (tool !== "shell" && tool !== "bash") return
      const input = event.input
      if (!input || typeof input !== "object") return
      const command = input.command
      if (typeof command !== "string" || !command) return

      try {
        const rewritten = await rewriteCommand(command)
        debug(`rewrite command=${command} -> ${rewritten ?? "(sin cambio)"}`)
        if (rewritten) input.command = rewritten
      } catch (error) {
        debug(`rewrite failed: ${String(error)}`)
        // Si rtk falla, el comando original sigue sin cambios.
      }
    })
    debug("hook registered")
    console.log("[rtk] plugin loaded")
  },
}
