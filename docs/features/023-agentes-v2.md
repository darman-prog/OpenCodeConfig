---
id: 023
status: cerrada
date: 2026-11-05
tipo: migración
area: harness
tarea: -
---
# Cambio — Agentes V2 nativos

> Frontmatter de los 10 agentes migrado a `permissions` V2, sin depender de la traducción V1.

## Cambio
- `permission` V1 → `permissions` V2; `bash` → `shell`, `task` → `subagent`.
- Reglas compactas en una línea; mismo orden y efecto que la versión V1.
- Guardarraíl lee V2, exige `subagent * deny`, retira `scout` y actualiza el check de solo lectura.
- Roster y docs: `Task` → `subagent`; agentes suman 295 líneas (antes 377).

## Por qué
V2 marca el frontmatter V1 como deprecado; sin migrarlo, los permisos dependen de traducción automática y pueden desaparecer en una versión futura.

## Cómo verificar
- `opencode debug agents` → 10 agentes con `permissions` y `subagent * deny`.
- `scripts/harness-budget.ps1` y `verify.ps1 -SkipSmokes` → exit 0.
- `opencode run --standalone --agent build "Responde solo: OK"` → OK.

## Dónde mirar
`.opencode/agents/*.md`, `scripts/harness-budget.ps1`, `OPENCODE.md`, `docs/harness/estado-actual.md`, `docs/harness/presupuestos.md`.

## Rollback
Revertir el commit; V2 seguiría traduciendo V1 con avisos.

## Evidencia
`opencode debug agents` con `permissions`; build respondió OK; guardarraíl y verify en verde.
