# AGENTS.md

Archivo de contexto agnóstico del repo: válido para cualquier agente (humano o IA).
OpenCode suma el global `~/.config/opencode/OPENCODE.md` (Skill Gate, estilo y agentes). Este `AGENTS.md` es el único fichero de reglas por proyecto.

## Stack
Ver `.opencode/` para skills y config. Si esta seccion sigue vacia al iniciar un proyecto, el agente debe preguntar el stack al usuario (flujo en skill `uso-eficiente`, seccion "Onboarding de stack") y luego proponer `/init`.

## Comandos
- `opencode` (TUI) · `/init` (regenerar este archivo si cambia el stack) · `.\sync-global.ps1` (sincronizar skills/agentes/commands/plugins al harness global; reiniciar TUI despues) · `.\scripts\new-feature.ps1` (wrapper de `trace.py`)
- Plugins: `.\scripts\smoke-plugins.ps1` (contrato V2) · `-Runtime` (RTK + notify con una sesion headless).
- Docs vivas: `.\scripts\doc-drift.ps1` (avisa) · `-Strict` (bloquea si hay deriva).
- A11y web: `.\scripts\smoke-a11y.ps1` (SKIP sin Playwright).
- Trazabilidad: `python` 3.8+ y `trace.py` de la skill `documentacion` (`init`, `task`, `start`, `record`, `close`, `drop`, `check`, `adopt`).

## Contexto
Ante la duda: lee este archivo y `docs/project-brain/NAVIGATION.md` (si existe) antes de preguntar o asumir.
Fuera del repo: no explores rutas externas salvo que la tarea nombre la ruta o el repo no responda.
`grep`/`glob` antes que `read`; no re-leas archivos ya vistos: este archivo es cache.

## Manejo de `.gitignore`
Puedes crear `.gitignore` (raiz o subdirectorios) y agregar entradas. **Nunca elimines ni sobrescribas las existentes**: si hay conflicto, consulta al usuario.
