---
id: 026
status: cerrada
area: harness
tarea: -
created: 2026-11-05
updated: 2026-11-05
---
# Feature 026 — Perfiles de proyecto

> Dos perfiles explícitos (`personal` y `equipo`) para que el harness no aplique el mismo rigor a contextos distintos.

## Objetivo
Declarar en `AGENTS.md` cómo se trabaja el proyecto y ajustar ramas, PR, tests, auditoría y A11y sin duplicar reglas ni relajar seguridad.

## Contexto
El harness asumía un único flujo. Un repo personal no necesita PR obligatorio; un repo de equipo sí. La política debe ser explícita y verificable, no inferida.

## Alcance
| Incluye | Excluye |
|---|---|
| `perfiles.md`, `## Perfil` en AGENTS, reglas en workflow/calidad-cierre y onboarding | Perfil `cliente` o perfiles por máquina |
| Validación en guardarraíl y doc-drift | Configuración global distinta por perfil |

## Criterios de aceptación
| N.º | Criterio verificable | Comando | Evidencia |
|---|---|---|---|
| 1 | Guardarraíl exige perfil válido | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/harness-budget.ps1` | |
| 2 | Docs vivas sin deriva | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/doc-drift.ps1 -Strict` | |
| 3 | Harness completo en verde | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/verify.ps1 -SkipSmokes` | |
| 4 | Perfil declarado y documentado | `powershell -NoProfile -ExecutionPolicy Bypass -Command "if (-not (Test-Path docs/harness/perfiles.md)) { exit 1 }; if (-not (Select-String -Path AGENTS.md -Pattern '^## Perfil' -Quiet)) { exit 1 }; exit 0"` | |

## Runner
| Campo | Valor |
|---|---|
| estado | cerrada |
| dueño | - |
| paso | 4/4 |
| siguiente | - |
| bloqueado_por | - |
| ultimo_handoff | - |

## Handoffs
| Fecha | De | A | Accion | Evidencia | Estado |
|---|---|---|---|---|---|

## Pasos
1. Crear `perfiles.md` y declarar el perfil en `AGENTS.md`.
2. Extender guardarraíl, workflow, calidad-cierre e inicio-proyecto.
3. Ajustar docs vivas y verificar.
4. Registrar y cerrar.

## Bitácora
| Criterio | Fecha | Comando | Exit | Commit |
|---|---|---|---|---|
| 1 | 2026-11-05 | powershell -NoProfile -ExecutionPolicy Bypass -File scripts/harness-budget.ps1 | 0 | ce0b8d7 |
| 2 | 2026-11-05 | powershell -NoProfile -ExecutionPolicy Bypass -File scripts/doc-drift.ps1 -Strict | 0 | ce0b8d7 |
| 3 | 2026-11-05 | powershell -NoProfile -ExecutionPolicy Bypass -File scripts/verify.ps1 -SkipSmokes | 0 | ce0b8d7 |
| 4 | 2026-11-05 | powershell -NoProfile -ExecutionPolicy Bypass -Command "if (-not (Test-Path docs/harness/perfiles.md)) { exit 1 }; if (-not (Select-String -Path AGENTS.md -Pattern '^## Perfil' -Quiet)) { exit 1 }; exit 0" | 0 | ce0b8d7 |

## Rollback
Revertir el commit; retirar `## Perfil` y las referencias a `perfiles.md`; el harness vuelve al flujo único.

## Cierre
- Fila resumen del changelog.
- Decisión de arquitectura: no aplica.
