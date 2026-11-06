---
id: 024
status: cerrada
area: harness
tarea: -
created: 2026-11-05
updated: 2026-11-05
---
# Feature 024 — Docs vivas y feature runner

> Evitar que la documentación vigente mienta y que los agentes pierdan el hilo entre handoffs.

## Objetivo
Separar la documentación vigente de la histórica, detectar deriva automáticamente y registrar dueño, siguiente paso y handoffs dentro del expediente.

## Contexto
`estado-actual.md` declaraba 377 líneas de agentes cuando el repo tenía 295, y `NAVIGATION.md` marcaba vigente un ADR reemplazado. El pipeline no registraba quién tenía la pelota entre agentes.

## Alcance
| Incluye | Excluye |
|---|---|
| Metadata en docs clave, `doc-drift.ps1`, integración en `verify` | Perfiles de proyecto y gate A11y (postergados) |
| `Runner` y `Handoffs` en spec, `trace.py` y gate de cierre | Orquestador/plugin nuevo |

## Criterios de aceptación
| N.º | Criterio verificable | Comando | Evidencia |
|---|---|---|---|
| 1 | Doc drift estricto sin hallazgos | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/doc-drift.ps1 -Strict` | |
| 2 | Verify integra doc drift | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/verify.ps1 -SkipSmokes` | |
| 3 | Plantilla con Runner y Handoffs | `powershell -NoProfile -Command "if (-not (Select-String -Path .opencode/skills/documentacion/references/templates/SPEC.md -Pattern '## Runner' -Quiet)) { exit 1 }; if (-not (Select-String -Path .opencode/skills/documentacion/references/templates/SPEC.md -Pattern '## Handoffs' -Quiet)) { exit 1 }; exit 0"` | |
| 4 | Trazabilidad válida con Runner | `python .opencode/skills/documentacion/scripts/trace.py --repo . check` | |

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
1. Añadir metadata y corregir la deriva actual.
2. Crear `doc-drift.ps1` e integrarlo en `verify`.
3. Extender la spec, `trace.py` y `calidad-cierre` con Runner/Handoffs.
4. Registrar evidencia y cerrar.

## Bitácora
| Criterio | Fecha | Comando | Exit | Commit |
|---|---|---|---|---|
| 1 | 2026-11-05 | powershell -NoProfile -ExecutionPolicy Bypass -File scripts/doc-drift.ps1 -Strict | 0 | cb0649c |
| 2 | 2026-11-05 | powershell -NoProfile -ExecutionPolicy Bypass -File scripts/verify.ps1 -SkipSmokes | 0 | cb0649c |
| 3 | 2026-11-05 | powershell -NoProfile -Command "if (-not (Select-String -Path .opencode/skills/documentacion/references/templates/SPEC.md -Pattern '## Runner' -Quiet)) { exit 1 }; if (-not (Select-String -Path .opencode/skills/documentacion/references/templates/SPEC.md -Pattern '## Handoffs' -Quiet)) { exit 1 }; exit 0" | 0 | cb0649c |
| 4 | 2026-11-05 | python .opencode/skills/documentacion/scripts/trace.py --repo . check | 0 | cb0649c |

## Rollback
Revertir el commit; restaurar docs, `trace.py` y `verify.ps1` desde el commit anterior.

## Cierre
- Fila resumen del changelog.
- Decisión de arquitectura: no aplica.
