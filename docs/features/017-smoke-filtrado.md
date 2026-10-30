---
id: 017
status: cerrada
area: harness
tarea: -
created: 2026-10-29
updated: 2026-10-29
---
# Card 017 — Smokes filtrados por skill o cambios

> Evita correr los 21 `opencode run` cuando solo cambió una skill.

## Cambio
- `smoke-routing.ps1`: `-Skill` (lista/comodines) y `-Changed` (git diff, staged y untracked).
- `-Changed` corre solo las skills tocadas; si cambia `OPENCODE.md`, `.opencode/agents/` o los scripts de ruteo, corre la matriz completa.
- `verify.ps1` pasa los filtros; sin filtros sigue corriendo los 21 casos.

## Evidencia
- `-Skill frontend-build`: 4/4; `-Skill "frontend-*"`: 6/6; `-Skill no-existe`: 0 y exit 0.
- `-Changed` con una skill: solo sus casos; sin cambios: 0 casos.
- `harness-budget` y `verify -SkipSmokes` en verde.

## Rollback
Revertir los dos scripts, esta tarjeta y su fila de índice/changelog.
