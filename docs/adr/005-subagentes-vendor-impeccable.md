# ADR 005: Subagentes vendor de impeccable en OpenCode

## Contexto
`critique` exige dos evaluaciones aisladas y `new-work` exige finish-reviewer y documenter; el harness no tenia esos agentes. Ejecutar inline pierde el aislamiento y incumple el contrato del vendor.

## Decision
Crear `impeccable-finish-reviewer` (solo lectura) e `impeccable-documenter` (escribe DESIGN.md y su sidecar). Para `critique`, usar dos `general` aislados. `asset-producer` y `manual-edit-applier` quedan fuera hasta que se usen imagenes o `live`.

## Consecuencias
+2 agentes, `MAX_AGENTS_TOTAL` 350→400, roster y allowlists actualizados, mantenimiento y sync global. El coste solo se paga al invocarlos.

## Alternativas descartadas
- Degraded inline: pierde el aislamiento obligatorio.
- Limitar comandos: pierde `critique`/`new-work`.
- Cuatro agentes: coste sin uso demostrado.
