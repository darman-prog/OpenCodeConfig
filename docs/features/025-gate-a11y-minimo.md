---
id: 025
status: cerrada
area: ui
tarea: -
created: 2026-11-05
updated: 2026-11-05
---
# Feature 025 — Gate A11y mínimo

> Convertir la checklist de accesibilidad en un gate repetible para UI web con Playwright.

## Objetivo
Bloquear errores automáticos de accesibilidad y producir un reporte estándar sin convertir axe en una falsa certificación WCAG.

## Contexto
`accesibilidad` define el canon y `frontend-design-review` evalúa, pero no había una comprobación ejecutable ni un reporte común. El fallo de contraste del theme V2 pasó por revisión manual.

## Alcance
| Incluye | Excluye |
|---|---|
| Contrato de reporte, `smoke-a11y.ps1`, gate en `calidad-cierre`/`workflow` | Motor propio de accesibilidad, crawler o plugin |
| `SKIP` sin Playwright y `-SelfTest` | Sustituir revisión manual/NVDA |

## Criterios de aceptación
| N.º | Criterio verificable | Comando | Evidencia |
|---|---|---|---|
| 1 | Contrato PASS/FAIL validado | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/smoke-a11y.ps1 -SelfTest` | |
| 2 | Sin Playwright el harness no bloquea | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/smoke-a11y.ps1` | |
| 3 | Harness completo en verde | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/verify.ps1 -SkipSmokes` | |
| 4 | La skill apunta al gate | `powershell -NoProfile -ExecutionPolicy Bypass -Command "if (-not (Select-String -Path .opencode/skills/accesibilidad/SKILL.md -Pattern 'GATE-A11Y' -Quiet)) { exit 1 }; exit 0"` | |

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
1. Crear el contrato y el runner.
2. Enganchar el gate en `calidad-cierre` y `workflow`.
3. Probar PASS/FAIL y SKIP.
4. Verificar, registrar y cerrar.

## Bitácora
| Criterio | Fecha | Comando | Exit | Commit |
|---|---|---|---|---|
| 1 | 2026-11-05 | powershell -NoProfile -ExecutionPolicy Bypass -File scripts/smoke-a11y.ps1 -SelfTest | 0 | 9317c96 |
| 2 | 2026-11-05 | powershell -NoProfile -ExecutionPolicy Bypass -File scripts/smoke-a11y.ps1 | 0 | 9317c96 |
| 3 | 2026-11-05 | powershell -NoProfile -ExecutionPolicy Bypass -File scripts/verify.ps1 -SkipSmokes | 0 | 9317c96 |
| 4 | 2026-11-05 | powershell -NoProfile -ExecutionPolicy Bypass -Command "if (-not (Select-String -Path .opencode/skills/accesibilidad/SKILL.md -Pattern 'GATE-A11Y' -Quiet)) { exit 1 }; exit 0" | 0 | 9317c96 |

## Rollback
Revertir el commit; eliminar `smoke-a11y.ps1`, `GATE-A11Y.md` y los enganches de skills.

## Cierre
- Fila resumen del changelog.
- Decisión de arquitectura: no aplica.
