---
id: 022
status: cerrada
date: 2026-11-05
tipo: migración
area: harness
tarea: -
---
# Cambio — Config nativa V2

> Config global y de proyecto en sintaxis V2: instrucciones globales, permisos ordenados, compaction por tokens y MCP anidado.

## Cambio
- Global: `instructions: ["~/.config/opencode/OPENCODE.md"]`, `permissions` con `external_directory` ask, `experimental.todo`, `mcp.servers` y `update`.
- Proyecto: sin `instructions`; `permissions` V2; `compaction.keep.tokens: 8000` + `buffer: 8000`; `mcp.servers.playwright`.
- Perfiles QA/Notion/Stitch adaptados a `mcp.servers`.
- Guardarraíl: exige `permissions` V2, `external_directory` ask, `todo`, `keep/buffer` y ausencia de `prune`; guía de migración actualizada.

## Por qué
V2 ignora `compaction.prune`, usa `permissions` y `mcp.servers`, y por defecto permite rutas externas; sin estos cambios se pierde la política de seguridad y la inyección de `OPENCODE.md`.

## Cómo verificar
- `opencode debug config` muestra `instructions`, `permissions`, `experimental.todo` y `keep/buffer`.
- `powershell -File scripts\harness-budget.ps1` y `verify.ps1 -SkipSmokes` → exit 0.

## Dónde mirar
`~/.config/opencode/opencode.jsonc`, `.opencode/opencode.json`, perfiles `opencode.qa.json`/`opencode.notion.json`, `scripts/harness-budget.ps1`, `docs/guias/migrar-proyecto-al-harness.md`.

## Rollback
Global: `opencode.jsonc.bak-2026-11-05`; proyecto: revertir el commit; reiniciar OpenCode.

## Evidencia
`opencode debug config` cargó la política; `opencode run --standalone` respondió OK; verify -SkipSmokes PASS.
