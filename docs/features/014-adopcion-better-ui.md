---
id: 014
status: cerrada
area: harness
tarea: -
created: 2026-10-28
updated: 2026-10-28
---
# Feature 014 — Adopción de better-ui

> Actualización 2026-10-29: la skill se retiró y su contenido vive como referencia en `frontend-build/references/BETTER-UI.md`; se conserva la licencia MIT y la fuente. Ver feature 016 y ADR 008.

> Incorporar `better-ui` como capa opcional de pulido, con adaptador, licencia y pilot real en Teiba.

## Objetivo
Tener recetas exactas de radios, sombras, iconos, hover y motion cuando la interacción ya funciona y el sistema visual existe, sin duplicar dirección, accesibilidad ni veredicto.

## Contexto
La skill externa (`jakubkrehel/skills`, MIT, commit `592aedc`) aporta valores concretos que no están completos en `impeccable`; asume la familia `better-*`, que no tenemos. Teiba tiene un `Docs/DESIGN.md` estricto: sin sombras, radios 4–8 e iconos 1.5px.

## Alcance
| Incluye | Excluye |
|---|---|
| Vendor de `better-ui`, adaptador, referencias, licencia, ruteo opcional, probe/smoke y pilot en Teiba | Familia `better-*`, cambios en `impeccable`/`accesibilidad`, dependencias runtime |

## Criterios de aceptación
| N.º | Criterio verificable | Comando | Evidencia |
|---|---|---|---|
| 1 | Vendor, licencia MIT y fuente fijada | `powershell -NoProfile -Command "$d='.opencode\skills\better-ui'; $ok=(Test-Path (Join-Path $d 'SKILL.md')) -and (Test-Path (Join-Path $d 'LICENSE')) -and (Select-String -Path (Join-Path $d 'LICENSE') -Pattern 'MIT License' -Quiet) -and (Select-String -Path (Join-Path $d 'LICENSE') -Pattern 'Jakub Krehel' -Quiet) -and (Select-String -Path (Join-Path $d 'SOURCE.md') -Pattern '592aedc' -Quiet); if ($ok) { exit 0 } else { exit 1 }"` | exit 0 |
| 2 | Adaptador con precedencia, mapeo y sin segundo gate | `powershell -NoProfile -Command "$p='.opencode\skills\better-ui\SKILL.md'; $ok=(Select-String -Path $p -Pattern 'DESIGN.md' -Quiet) -and (Select-String -Path $p -Pattern 'accesibilidad' -Quiet) -and (Select-String -Path $p -Pattern 'frontend-design-review' -Quiet) -and (Select-String -Path $p -Pattern 'no es un segundo gate' -Quiet); if ($ok) { exit 0 } else { exit 1 }"` | exit 0 |
| 3 | Ruteo opcional, 39 skills y probe cubierto | `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\harness-budget.ps1` | exit 0 |
| 4 | Pilot Teiba PASS en el Composer | `powershell -NoProfile -Command "$p='docs\features\015-pilot-better-ui-teiba.md'; $ok=(Test-Path $p) -and (Select-String -Path $p -Pattern 'PASS' -Quiet) -and (Select-String -Path $p -Pattern 'Composer.tsx' -Quiet) -and (Select-String -Path $p -Pattern 'motion-safe' -Quiet); if ($ok) { exit 0 } else { exit 1 }"` | exit 0 |
| 5 | Guardarraíl, identidad y smokes | `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify.ps1` | exit 0 |
| 6 | Registro cerrado | `python .opencode\skills\documentacion\scripts\trace.py check` | exit 0 |

## Pasos
1. Vendorizar `better-ui` y adaptar el `SKILL.md`.
2. Ruteo opcional, probe y smoke.
3. Pilot en Teiba (`Composer`).
4. Docs, ADR, registro y cierre.

## Bitácora
| Criterio | Fecha | Comando | Exit | Commit |
|---|---|---|---|---|
| 1 | 2026-10-28 | powershell -NoProfile -Command "$d='.opencode\skills\better-ui'; $ok=(Test-Path (Join-Path $d 'SKILL.md')) -and (Test-Path (Join-Path $d 'LICENSE')) -and (Select-String -Path (Join-Path $d 'LICENSE') -Pattern 'MIT License' -Quiet) -and (Select-String -Path (Join-Path $d 'LICENSE') -Pattern 'Jakub Krehel' -Quiet) -and (Select-String -Path (Join-Path $d 'SOURCE.md') -Pattern '592aedc' -Quiet); if ($ok) { exit 0 } else { exit 1 }" | 0 | 7e7cbf6 |
| 2 | 2026-10-28 | powershell -NoProfile -Command "$p='.opencode\skills\better-ui\SKILL.md'; $ok=(Select-String -Path $p -Pattern 'DESIGN.md' -Quiet) -and (Select-String -Path $p -Pattern 'accesibilidad' -Quiet) -and (Select-String -Path $p -Pattern 'frontend-design-review' -Quiet) -and (Select-String -Path $p -Pattern 'no es un segundo gate' -Quiet); if ($ok) { exit 0 } else { exit 1 }" | 0 | 7e7cbf6 |
| 3 | 2026-10-28 | powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\harness-budget.ps1 | 0 | 7e7cbf6 |
| 4 | 2026-10-28 | powershell -NoProfile -Command "$p='docs\features\015-pilot-better-ui-teiba.md'; $ok=(Test-Path $p) -and (Select-String -Path $p -Pattern 'PASS' -Quiet) -and (Select-String -Path $p -Pattern 'Composer.tsx' -Quiet) -and (Select-String -Path $p -Pattern 'motion-safe' -Quiet); if ($ok) { exit 0 } else { exit 1 }" | 0 | 7e7cbf6 |
| 5 | 2026-10-28 | powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify.ps1 | 0 | 7e7cbf6 |
| 6 | 2026-10-28 | python .opencode\skills\documentacion\scripts\trace.py check | 0 | 7e7cbf6 |

## Rollback
`git revert` de los commits de la adopción; `.\sync-global.ps1`; reiniciar la TUI.
En Teiba, descartar la rama `pilot/better-ui-composer`; no toca el resto del proyecto.

## Cierre
- Fila resumen del changelog.
- Decisión de arquitectura: `ADR 007`.
- Pilot: `docs/features/015-pilot-better-ui-teiba.md`.
