---
status: vigente
last_reviewed: 2026-11-05
confidence: confirmado
source: commit cb0649c + revision 2026-11-05
---

# Contexto del proyecto — HarnessConfig (plantilla de OpenCode)

Fuente de verdad organizada. **Carga solo lo relevante; nunca todo el directorio.**
Este repo no es una app: su conocimiento vive en `docs/harness/` y este mapa lo enruta.

> **Para quién:** agentes y devs — un mapa de 1 min antes de bucear el repo.

## Documentos

| Doc | Contenido | Cargar cuando | Estado |
| --- | --- | --- | --- |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Capas del harness, invariantes y flujo de una tarea | dónde va un cambio, qué no se rompe, permisos | vigente |
| [estado-actual.md](../harness/estado-actual.md) | Inventario vigente: agentes, skills, guardarraíl, sync, config global | "qué existe hoy", antes de tocar el harness | vigente |
| [pipeline.md](../harness/pipeline.md) | El paso a paso operativo por actor (fases 1-5) | cómo se ejecuta una tarea | vigente |
| [pipeline-referencia.md](../harness/pipeline-referencia.md) | Detalle por sección (routing, estados, permisos, fricciones) | cómo se ejecuta una tarea, quién delega a quién | vigente |
| [perfiles.md](../harness/perfiles.md) | Perfiles `personal`/`equipo`: ramas, PR, tests, auditor y A11y | onboarding, cambio de proyecto o gates distintos | vigente |
| [presupuestos.md](../harness/presupuestos.md) | Los 9 topes del harness y su porqué | antes de añadir líneas, palabras, archivos o mover skills de carpeta | vigente |
| [changelog.md](../harness/changelog.md) | Historial de cambios del harness (append-only: un cambio por entrada) | "¿se hizo ya?", por qué algo cambió | vigente |
| [notion.md](../harness/notion.md) | Reglas de sincronización con Notion vía MCP | perfil Notion activo y tarea en Notion | vigente |
| [migrar-proyecto-al-harness.md](../guias/migrar-proyecto-al-harness.md) | Migrar un proyecto al esquema vigente del harness | quieres llevar un proyecto al esquema actual | vigente |
| [stitch.md](../harness/stitch.md) | Stitch MCP global deshabilitado + activación por sesión: key, smoke y troubleshooting | activar o depurar Stitch; montar su API key | vigente |
| [auditoria-v2.md](../harness/auditoria-v2.md) | Auditoría del 2026-09-18 | trazar por qué el harness es como es | obsoleto (histórico) |
| [specs/](../specs/) | `001` tokens, `002` review de UI, `003` retirada de sdd-lite, `004` runbook de instalación | trazar decisiones antiguas | obsoleto (histórico) |
| [features/](../features/) | Registro DDR: [INDEX.md](../features/INDEX.md) con specs y tarjetas; cola de trabajo abierto en [BACKLOG.md](../features/BACKLOG.md) | definir, reanudar o cerrar una feature | vigente |
| [features/BACKLOG.md](../features/BACKLOG.md) | Trabajo abierto por área: `pendiente`, `en-curso`, `bloqueada` | "¿qué falta por hacer?" | vigente |
| [ADR-001](../adr/001-rtk-dependencia-de-maquina.md) | RTK como dependencia de máquina | integración o cambio de RTK | vigente |
| [ADR-002](../adr/002-Version1-opencode.md) | OpenCode V1.19.3 (reemplazado por V2) | histórico: no usar para decidir la versión | reemplazado por ADR-010 |
| [ADR-003](../adr/003-retencion-respaldos-opencode.md) | Respaldos de `opencode.db`: fuera del repo, sin credenciales y verificados | archivar o restaurar el historial de sesiones | vigente |
| [ADR-004](../adr/004-trazabilidad-portable.md) | Trazabilidad portable: backlog, expediente y bitácora mecánica | reanudar o auditar un cambio | vigente |
| [ADR-005](../adr/005-subagentes-vendor-impeccable.md) | Subagentes vendor de impeccable en OpenCode | tocar `critique`, `new-work` o el roster | vigente |
| [ADR-006](../adr/006-gate-autoridad-visual.md) | Gate de autoridad visual antes de UI nueva | crear o rediseñar UI sin `DESIGN.md` | vigente |
| [ADR-007](../adr/007-adopcion-better-ui.md) | better-ui como capa de pulido opcional | pulir UI con recetas externas | vigente (referencia; ver 008) |
| [ADR-008](../adr/008-pipeline-frontend-identidad.md) | Dirección y sistema antes de código para frontend | crear o rediseñar UI con identidad | vigente |
| [ADR-009](../adr/009-cero-friccion-opencode-global.md) | OPENCODE solo global, AGENTS por proyecto | entender la inyección de reglas | vigente |
| [ADR-010](../adr/010-migracion-opencode-v2.md) | OpenCode V2 con plugins V2 y fuente espejo | tocar versión, plugins o sync | vigente |

## Reglas del cerebro

- Actualización solo tras cambio verificado (`calidad-cierre`), nunca por edición.
- Solo se actualizan los documentos afectados por el cambio.
- Datos sin evidencia llevan `confidence: supuesto` y `status: pendiente`.
- Contradicción doc/código: reportar, no corregir automáticamente.
- Este mapa se mantiene ≤ 60 líneas; si crece, resumir filas.
- La intención de un cambio largo vive en su feature-spec (`../features/`), no aquí; las decisiones de arquitectura, en `adr/`.
