---
id: 021
status: cerrada
date: 2026-11-05
tipo: migración
area: harness
tarea: -
---
# Cambio — Plugins V2 y smoke de eventos

> RTK y notificaciones migrados a la API de plugins V2, con una sola copia runtime y smoke propio.

## Cambio
- `plugins-src/rtk.ts`: `export default { id, setup }`; `ctx.tool.hook("execute.before")` reescribe con `rtk rewrite` sin depender de Bun.
- `plugins-src/notify-windows.js`: `ctx.event.subscribe()`; `session.execution.succeeded/failed/interrupted` + `permission.asked`; conserva el mapa de subagentes.
- La fuente queda en `.opencode/plugins-src/`; el runtime solo en `~/.config/opencode/plugins/`; `sync-global.ps1` espeja y comprueba identidad.
- `scripts/smoke-plugins.ps1`: contrato V2, espejo global y `-Runtime` con una sesión headless.
- Guardarraíl y `verify.ps1` validan plugins y copias duplicadas.

## Por qué
V2 no ejecuta plugins V1: el harness perdía RTK y notificaciones, y cargaba 4 copias en error.

## Cómo verificar
- `powershell -File scripts\smoke-plugins.ps1 -Runtime` → PASS.
- `powershell -File scripts\verify.ps1 -SkipSmokes` → PASS.
- `/plugins` en TUI sin `PluginModule.LoadError`.

## Dónde mirar
`.opencode/plugins-src/`, `~/.config/opencode/plugins/`, `sync-global.ps1`, `scripts/smoke-plugins.ps1`, `scripts/harness-budget.ps1`, `scripts/verify.ps1`.

## Rollback
Revertir el commit; volver a V1 exige reinstalar `opencode-ai@1.19.3` y recuperar los plugins del historial de git.

## Evidencia
Smoke estático PASS; smoke runtime PASS; `rtk rewrite` reescribió `npx vitest run`; `session.execution.succeeded` confirmado en la sonda.
