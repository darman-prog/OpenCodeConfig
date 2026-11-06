---
id: 019
status: cerrada
area: harness
tarea: B-001
created: 2026-11-04
updated: 2026-11-04
---
# Feature 019 — Cero-friccion OPENCODE global

> OPENCODE solo global; proyectos solo AGENTS, sin buscar ni crear local.

## Objetivo
Cero-friccion: agentes leen global + AGENTS sin bloquear fuera de la plantilla.

## Contexto
Agentes globales heredaron `Lee OPENCODE.md` local; fuera de la plantilla falla. Decidido: canonico en `~/.config/opencode/OPENCODE.md`, jamas local.

## Alcance
| Incluye | Excluye |
|---|---|
| Paso 0 global en agentes, regla uso-eficiente, sync, guardarraíl, guia | Modelos, permisos, contratos API |

## Criterios de aceptación
| N.º | Criterio verificable | Comando | Evidencia |
|---|---|---|---|
| 1 | Agentes apuntan al global y prohiben crear local | powershell -NoProfile -Command "if (-not (Select-String -Path .opencode\agents\build.md -Pattern 'global' -Quiet)) { exit 1 }; exit 0" |  |
| 2 | uso-eficiente nunca crea OPENCODE, solo AGENTS | powershell -NoProfile -Command "if (Select-String -Path .opencode\skills\uso-eficiente\SKILL.md -Pattern 'crea.*OPENCODE' -Quiet) { exit 1 }; exit 0" |  |
| 3 | sync copia OPENCODE al global | powershell -NoProfile -Command "if (-not (Select-String -Path sync-global.ps1 -Pattern 'OPENCODE.md' -Quiet)) { exit 1 }; exit 0" |  |
| 4 | Guardarrail y verify en verde | powershell -NoProfile -ExecutionPolicy Bypass -File scripts\verify.ps1 -SkipSmokes |  |

## Pasos
1. Paso 0 global en 10 agentes + uso-eficiente/comunicacion-asertiva.
2. sync-global copia OPENCODE + guia solo-AGENTS.
3. Guardarrail/verify adaptados + prueba vacio + auditor.

## Bitácora
| Criterio | Fecha | Comando | Exit | Commit |
|---|---|---|---|---|
| 1 | 2026-11-04 | powershell -NoProfile -Command "if (-not (Select-String -Path .opencode\agents\build.md -Pattern 'global' -Quiet)) { exit 1 }; exit 0" | 0 | b67715a |
| 2 | 2026-11-04 | powershell -NoProfile -Command "if (Select-String -Path .opencode\skills\uso-eficiente\SKILL.md -Pattern 'crea.*OPENCODE' -Quiet) { exit 1 }; exit 0" | 0 | b67715a |
| 3 | 2026-11-04 | powershell -NoProfile -Command "if (-not (Select-String -Path sync-global.ps1 -Pattern 'OPENCODE.md' -Quiet)) { exit 1 }; exit 0" | 0 | b67715a |
| 4 | 2026-11-04 | powershell -NoProfile -ExecutionPolicy Bypass -File scripts\verify.ps1 -SkipSmokes | 0 | b67715a |

## Rollback
Revertir commit; `sync-global.ps1` sin copia no rompe proyectos (global previo intacto).

## Cierre
- Fila resumen del changelog.
- Decisión de arquitectura: `ADR 009`.
