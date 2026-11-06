---
status: vigente
last_reviewed: 2026-11-05
---

# Registro de features implementadas

Lectura rápida por unidad funcional implementada. Cada fila enlaza su evidencia;
el detalle vive en la spec o tarjeta correspondiente, no en este índice.
El trabajo abierto vive en `BACKLOG.md`; al cerrar, su fila se borra y queda este registro.

## Activas

| Fecha | Cambio | Estado | Área | Alcance | Registro | Evidencia |
|---|---|---|---|---|---|---|

## Cerradas

| Fecha | Cambio | Estado | Área | Alcance | Registro | Evidencia |
|---|---|---|---|---|---|---|
| 2026-10-14 | Ciclo DDR de feature-spec | cerrada | docs | Fuente multi-sesión, Skill Gate y tope 75 | [001-ciclo-ddr-feature-spec.md](001-ciclo-ddr-feature-spec.md) | criterios verificados |
| 2026-10-15 | Registro funcional e índice | cerrada | docs | Índice, tarjeta single-session y plantilla visual | [002-registro-funcional-features.md](002-registro-funcional-features.md) | tarjeta cerrada + commit `0f794f5` |
| 2026-10-18 | Convivencia OpenCode ↔ Antigravity | cerrada (superada por 005) | harness | 3 ficheros y skills compartidos | [003-convivencia-opencode-antigravity.md](003-convivencia-opencode-antigravity.md) | cerrada con evidencia |
| 2026-10-18 | Tokens y fiabilidad de ruteo | cerrada | harness | Medición, tope chars/4, smokes, verify | [004-mejoras-tokens-ruteo.md](004-mejoras-tokens-ruteo.md) | cerrada con evidencia |
| 2026-10-18 | Plantilla vs proyectos | cerrada | harness | Decisión de alcance + runbook de migración | [008-plantilla-vs-proyectos.md](008-plantilla-vs-proyectos.md) | cerrada con evidencia |
| 2026-10-18 | Consolidación de política | cerrada | docs | Umbral con un canon y pipeline en dos ficheros | [007-consolidacion-politica.md](007-consolidacion-politica.md) | cerrada con evidencia |
| 2026-10-18 | Registro y taxonomía | cerrada | docs | Tarjetas por defecto, ADR en el índice, glosario | [006-registro-y-taxonomia.md](006-registro-y-taxonomia.md) | cerrada con evidencia |
| 2026-10-18 | Simplificación OpenCode-only | cerrada | harness | Una sola raíz de skills, sin docs de convivencia | [005-simplificacion-opencode-only.md](005-simplificacion-opencode-only.md) | cerrada con evidencia |
| 2026-10-19 | Recorte de tokens en descripciones y ruteo | cerrada | harness | 37 descripciones + tabla del Skill Gate | [009-recorte-tokens-descripciones.md](009-recorte-tokens-descripciones.md) | guardarraíl exit 0; 3719 → 2228 tokens |
| 2026-10-19 | Gate anti-slop en el cierre | cerrada | harness | DoD, `calidad-cierre` y preset High-Craft | [010-gate-anti-slop.md](010-gate-anti-slop.md) | guardarraíl exit 0 |
| 2026-10-22 | Trazabilidad portable y auditoria | cerrada | harness | Pendiente de detallar | [011-trazabilidad-portable.md](011-trazabilidad-portable.md) | - |
| 2026-10-22 | Alineación de la doctrina con el umbral auditable | cerrada | docs | OPENCODE, skills, probe y smoke + Python en AGENTS | [012-alineacion-doctrina-auditable.md](012-alineacion-doctrina-auditable.md) | guardarraíl exit 0; smokes 16/16 |
| 2026-10-28 | Auditoria de skills UI | cerrada | harness | Ruteo 3 filas, gate de estilo, 2 subagentes vendor | [013-auditoria-skills-ui.md](013-auditoria-skills-ui.md) | 8/8 criterios exit 0; verify 19/19 |
| 2026-10-28 | Pilot better-ui en Teiba | cerrada | ui | Press/transición en Composer; sombras/radio/icono rechazados | [015-pilot-better-ui-teiba.md](015-pilot-better-ui-teiba.md) | PASS; tests 32/32; detect `[]` |
| 2026-10-28 | Adopcion de better-ui | cerrada | harness | Vendor, adaptador, ruteo opcional y pilot Teiba | [014-adopcion-better-ui.md](014-adopcion-better-ui.md) | 6/6 criterios exit 0; verify 20/20 |
| 2026-10-29 | Pipeline frontend con identidad | cerrada | ui | Dirección, sistema, showcase y pilot SageView | [016-pipeline-frontend-identidad.md](016-pipeline-frontend-identidad.md) | 6/6 criterios; rating 4/5; verify 21/21 |
| 2026-10-29 | Smokes filtrados por skill o cambios | cerrada | harness | `-Skill`/`-Changed`; matriz completa al cerrar ruteo | [017-smoke-filtrado.md](017-smoke-filtrado.md) | `-Skill frontend-build` 4/4; `-Changed` OK |
| 2026-10-31 | Integracion de ofimatica PPTX y HTML a PDF | cerrada | harness | Fusion en skill manual; plantilla-base, script y referencia | [018-integracion-ofimatica-pptx-html-pdf.md](018-integracion-ofimatica-pptx-html-pdf.md) | 8/8 criterios exit 0; sync identidad OK |
| 2026-11-04 | Cero-friccion OPENCODE global | cerrada | harness | Paso 0 global + sync + guia solo-AGENTS | [019-cero-friccion-opencode-global.md](019-cero-friccion-opencode-global.md) | 4/4 criterios exit 0; verify OK |
| 2026-11-05 | Theme V2 y colores de agentes | cerrada | harness | `darmandev` en base+dark; hex en agentes | [020-theme-v2-colores-agentes.md](020-theme-v2-colores-agentes.md) | debug agents con hex; JSON OK; sin avisos de theme |
| 2026-11-05 | Plugins V2 y smoke de eventos | cerrada | harness | RTK + notify con contrato V2; fuente espejo | [021-plugins-v2.md](021-plugins-v2.md) | smoke estático y runtime PASS; verify OK |
| 2026-11-05 | Config nativa V2 | cerrada | harness | instructions global, permissions, compaction y MCP | [022-config-v2-nativa.md](022-config-v2-nativa.md) | debug config OK; verify -SkipSmokes PASS |
| 2026-11-05 | Agentes V2 nativos | cerrada | harness | `permissions` V2 en los 10 agentes; guardarraíl y roster | [023-agentes-v2.md](023-agentes-v2.md) | debug agents OK; verify -SkipSmokes PASS |
| 2026-11-05 | Docs vivas y feature runner | cerrada | harness | Metadata, `doc-drift`, `Runner` y handoffs | [024-docs-vivas-y-runner.md](024-docs-vivas-y-runner.md) | 4/4 criterios exit 0; verify -SkipSmokes PASS |
| 2026-11-05 | Gate A11y minimo | cerrada | ui | Reporte axe/teclado/contraste, `SKIP` sin Playwright | [025-gate-a11y-minimo.md](025-gate-a11y-minimo.md) | 4/4 criterios exit 0; verify -SkipSmokes PASS |

## Decisiones (ADR)

| Fecha | Decisión | Estado | Ámbito | Registro |
|---|---|---|---|---|
| 2026-09-28 | RTK como dependencia de máquina | vigente | Rendimiento/costes del harness | [ADR-001](../adr/001-rtk-dependencia-de-maquina.md) |
| 2026-10-18 | OpenCode V1.19.3 (la V2 rompe los plugins) | reemplazado por ADR-010 | Versión del runtime | [ADR-002](../adr/002-Version1-opencode.md) |
| 2026-11-05 | Theme `darmandev` en formato V2 | vigente | Theme del harness | [020-theme-v2-colores-agentes.md](020-theme-v2-colores-agentes.md) |
| 2026-10-19 | Respaldos de `opencode.db`: fuera del repo, sin credenciales y verificados | vigente | Persistencia local y privacidad | [ADR-003](../adr/003-retencion-respaldos-opencode.md) |
| 2026-10-22 | Trazabilidad portable: backlog, expediente y bitácora mecánica | vigente | Documentación y auditoría | [ADR-004](../adr/004-trazabilidad-portable.md) |
| 2026-10-28 | Subagentes vendor de impeccable en OpenCode | vigente | UI y orquestación | [ADR-005](../adr/005-subagentes-vendor-impeccable.md) |
| 2026-10-28 | Gate de autoridad visual antes de UI nueva | vigente | UI y proceso | [ADR-006](../adr/006-gate-autoridad-visual.md) |
| 2026-10-28 | better-ui como capa de pulido opcional | vigente (referencia; ver 008) | UI y dependencias | [ADR-007](../adr/007-adopcion-better-ui.md) |
| 2026-10-28 | Dirección y sistema antes de código para frontend | vigente | UI y proceso | [ADR-008](../adr/008-pipeline-frontend-identidad.md) |
| 2026-11-04 | OPENCODE solo global, AGENTS por proyecto | vigente | Harness y proceso | [ADR-009](../adr/009-cero-friccion-opencode-global.md) |
| 2026-11-05 | OpenCode V2 con plugins V2 y fuente espejo | vigente | Runtime y plugins | [ADR-010](../adr/010-migracion-opencode-v2.md) |

## Reglas

- Una fila por unidad funcional implementada; los micro-fixes quedan en el changelog.
- El trabajo abierto vive en `BACKLOG.md`; al cerrar, la fila se borra y el registro conserva `tarea: B-NNN`.
- Un cambio auditable usa **spec** (60 líneas o menos, con bitácora por criterio); uno pequeño, **tarjeta** (25 líneas o menos). El umbral canónico: `documentacion` §docs/features.
- Toda spec o tarjeta declara `area` y `tarea` (`-` si no vino del backlog).
- Una decisión irreversible o global se registra como **ADR**; un procedimiento, como guía en `docs/guias/`.
- Si las secciones activas y cerradas superan 40 filas, mueve las cerradas antiguas a `ARCHIVE.md` y conserva aquí solo el resumen.

## Archivado

Vacío por ahora. `ARCHIVE.md` aún no existe; se creará append-only cuando el índice necesite poda.
