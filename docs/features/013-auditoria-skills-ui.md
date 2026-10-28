---
id: 013
status: cerrada
area: harness
tarea: -
created: 2026-10-28
updated: 2026-10-28
---
# Feature 013 — Auditoría de skills UI

> Alinear ruteo, contratos y gate de estilo de las skills UI; integrar impeccable y sus subagentes.

## Objetivo
Que una tarea UI cargue solo las skills que necesita, que el canon WCAG sea único y que una UI nueva no se implemente sin autoridad visual.

## Contexto
La fila UI obligaba a cuatro skills que se declaran incompatibles; el launcher de impeccable estaba hardcodeado a `.opencode/skills`; faltaba `impeccable context`; el vendor espera subagentes que el harness no tenía; `DESIGN.md` podía faltar sin bloquear.

## Alcance
| Incluye | Excluye |
|---|---|
| Ruteo por intención, checklist de review, referencias de accesibilidad, integración de impeccable, gate de autoridad visual, subagentes vendor, pruebas y registro | Cambios en el pack vendor `impeccable`; `asset-producer` y `manual-edit-applier`; rediseño de la cadena |

## Criterios de aceptación
| N.º | Criterio verificable | Comando | Evidencia |
|---|---|---|---|
| 1 | Ruteo UI separado y `accesibilidad` obligatoria | `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\harness-budget.ps1` | exit 0 |
| 2 | `ui-ux` ya no promete lo que delega | `powershell -NoProfile -Command "$d=(Get-Content .opencode\skills\ui-ux\SKILL.md -TotalCount 4) -join ' '; if ($d -match 'responsive','microinteracciones','feedback') { exit 1 } else { exit 0 }"` | exit 0 |
| 3 | Review alineado a WCAG y al repo | `powershell -NoProfile -Command "$p='.opencode\skills\frontend-design-review\references\quick-checklist.md'; if ((Select-String -Path $p -Pattern 'Grade C','Grade B' -Quiet) -or -not (Select-String -Path $p -Pattern 'accesibilidad' -Quiet)) { exit 1 } else { exit 0 }"` | exit 0 |
| 4 | Sin referencias fantasma en `accesibilidad` | `powershell -NoProfile -Command "if (Select-String -Path .opencode\skills\accesibilidad\SKILL.md -Pattern 'regla ya en ui-ux','regla de ui-ux' -Quiet) { exit 1 } else { exit 0 }"` | exit 0 |
| 5 | Impeccable resuelve base dir, contexto y detector | `powershell -NoProfile -Command "if (-not (Select-String -Path .opencode\skills\impeccable-doctrina\SKILL.md -Pattern 'context' -Quiet)) { exit 1 }; if (Select-String -Path .opencode\skills\workflow\SKILL.md,.opencode\skills\calidad-cierre\SKILL.md,.opencode\agents\ui-ux.md -Pattern '\.opencode/skills/impeccable/scripts' -Quiet) { exit 1 } else { exit 0 }"` | exit 0 |
| 6 | Gate de autoridad visual documentado y exigido | `powershell -NoProfile -Command "if (-not (Select-String -Path OPENCODE.md -Pattern 'document --seed' -Quiet)) { exit 1 }; if (-not (Select-String -Path .opencode\skills\calidad-cierre\SKILL.md -Pattern 'DESIGN.md' -Quiet)) { exit 1 } else { exit 0 }"` | exit 0 |
| 7 | Subagentes vendor existentes y en el roster | `powershell -NoProfile -Command "if (-not (Test-Path .opencode\agents\impeccable-finish-reviewer.md) -or -not (Test-Path .opencode\agents\impeccable-documenter.md)) { exit 1 }; if (-not (Select-String -Path OPENCODE.md -Pattern 'impeccable-finish-reviewer' -Quiet)) { exit 1 } else { exit 0 }"` | exit 0 |
| 8 | Guardarraíl, identidad global y smokes | `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify.ps1` | exit 0 |

## Pasos
1. Ruteo por intención, `ui-ux`, review y accesibilidad.
2. Impeccable, gate de autoridad visual y subagentes vendor.
3. Pruebas, registro y cierre.

## Bitácora
| Criterio | Fecha | Comando | Exit | Commit |
|---|---|---|---|---|
| 1 | 2026-10-28 | powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\harness-budget.ps1 | 0 | 2491a2e |
| 2 | 2026-10-28 | powershell -NoProfile -Command "$d=(Get-Content .opencode\skills\ui-ux\SKILL.md -TotalCount 4) -join ' '; if ($d -match 'responsive','microinteracciones','feedback') { exit 1 } else { exit 0 }" | 0 | 2491a2e |
| 3 | 2026-10-28 | powershell -NoProfile -Command "$p='.opencode\skills\frontend-design-review\references\quick-checklist.md'; if ((Select-String -Path $p -Pattern 'Grade C','Grade B' -Quiet) -or -not (Select-String -Path $p -Pattern 'accesibilidad' -Quiet)) { exit 1 } else { exit 0 }" | 0 | 2491a2e |
| 4 | 2026-10-28 | powershell -NoProfile -Command "if (Select-String -Path .opencode\skills\accesibilidad\SKILL.md -Pattern 'regla ya en ui-ux','regla de ui-ux' -Quiet) { exit 1 } else { exit 0 }" | 0 | 2491a2e |
| 5 | 2026-10-28 | powershell -NoProfile -Command "if (-not (Select-String -Path .opencode\skills\impeccable-doctrina\SKILL.md -Pattern 'context' -Quiet)) { exit 1 }; if (Select-String -Path .opencode\skills\workflow\SKILL.md,.opencode\skills\calidad-cierre\SKILL.md,.opencode\agents\ui-ux.md -Pattern '\.opencode/skills/impeccable/scripts' -Quiet) { exit 1 } else { exit 0 }" | 0 | 2491a2e |
| 6 | 2026-10-28 | powershell -NoProfile -Command "if (-not (Select-String -Path OPENCODE.md -Pattern 'document --seed' -Quiet)) { exit 1 }; if (-not (Select-String -Path .opencode\skills\calidad-cierre\SKILL.md -Pattern 'DESIGN.md' -Quiet)) { exit 1 } else { exit 0 }" | 0 | 2491a2e |
| 7 | 2026-10-28 | powershell -NoProfile -Command "if (-not (Test-Path .opencode\agents\impeccable-finish-reviewer.md) -or -not (Test-Path .opencode\agents\impeccable-documenter.md)) { exit 1 }; if (-not (Select-String -Path OPENCODE.md -Pattern 'impeccable-finish-reviewer' -Quiet)) { exit 1 } else { exit 0 }" | 0 | 2491a2e |
| 8 | 2026-10-28 | powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify.ps1 | 0 | 2491a2e |

## Rollback
`git revert` de los commits de la auditoría UI (2491a2e y los de cierre/documentación posteriores). Sin cambios de esquema ni datos.
`.\sync-global.ps1` para restaurar el global y reiniciar la TUI.

## Cierre
- Fila resumen del changelog.
- Decisiones de arquitectura: `ADR 005` (subagentes vendor) y `ADR 006` (gate de autoridad visual).
- Evidencia: bitácora 8/8 con exit 0; `verify.ps1` 19/19.
