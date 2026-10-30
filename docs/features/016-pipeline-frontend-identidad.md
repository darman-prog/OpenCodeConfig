---
id: 016
status: en-curso
area: ui
tarea: -
created: 2026-10-28
updated: 2026-10-28
---
# Feature 016 — Pipeline frontend con identidad

> Dirección, sistema y review con capturas antes de escribir UI; pilot en SageView.

## Objetivo
Reemplazar el checklist de UI por un pipeline que obligue a dirección visual, primitivas y evidencia antes de codificar; reducir la carga de skills sin perder accesibilidad ni review.

## Contexto
Las skills cargaban 4–6 cuerpos y el agente podía saltar de la idea al código. Teiba ya tiene el mundo “Estación de campo” en `Docs/DESIGN.md`, pero el código no lo expresa con un sistema. El pilot reconstruye una sección de `SageView` con 7 primitivas.

## Alcance
| Incluye | Excluye |
|---|---|
| `frontend-direction`, `frontend-build`, pilot SageView, showcase, token check y gates | Migrar todo Teiba, Angular/Vue, borrar `impeccable` o `accesibilidad` |

## Criterios de aceptación
| N.º | Criterio verificable | Comando | Evidencia |
|---|---|---|---|
| 1 | Brief con 3 expresiones y elección | `powershell -NoProfile -Command "$p='C:\Users\damez\Downloads\Universidad\quinto_semestre\BaseDeDatos2\ProyectoCurso\Teiba\Docs\features\006-pipeline-frontend-sage.md'; $ok=(Test-Path $p) -and (Select-String -Path $p -Pattern 'A. Instrumento' -Quiet) -and (Select-String -Path $p -Pattern 'B. Bitácora' -Quiet) -and (Select-String -Path $p -Pattern 'C. Panel' -Quiet); if ($ok) { exit 0 } else { exit 1 }"` | exit 0 |
| 2 | Showcase y token check | `powershell -NoProfile -Command "$r='C:\Users\damez\Downloads\Universidad\quinto_semestre\BaseDeDatos2\ProyectoCurso\Teiba\frontend'; Push-Location $r; npm run check:ui; $c=$LASTEXITCODE; Pop-Location; exit $c"` | exit 0 |
| 3 | Pilot técnico: lint, typecheck, test, build y detector | `powershell -NoProfile -Command "$r='C:\Users\damez\Downloads\Universidad\quinto_semestre\BaseDeDatos2\ProyectoCurso\Teiba\frontend'; Push-Location $r; npm run check:ui; $a=$LASTEXITCODE; npm run lint; $b=$LASTEXITCODE; npm run typecheck; $c=$LASTEXITCODE; npm run test -- --run; $d=$LASTEXITCODE; npm run build; $e=$LASTEXITCODE; npm run detect:ui; $f=$LASTEXITCODE; Pop-Location; if (($a -eq 0) -and ($b -eq 0) -and ($c -eq 0) -and ($d -eq 0) -and ($e -eq 0) -and ($f -eq 0)) { exit 0 } else { exit 1 }"` | exit 0 |
| 4 | Rating de identidad ≥4/5 | `powershell -NoProfile -Command "$p='C:\Users\damez\Downloads\Universidad\quinto_semestre\BaseDeDatos2\ProyectoCurso\Teiba\Docs\features\006-pipeline-frontend-sage.md'; if (Select-String -Path $p -Pattern 'Rating: [45]/5' -Quiet) { exit 0 } else { exit 1 }"` | pendiente |
| 5 | Harness en verde (41 skills, 22 smokes) | `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify.ps1` | exit 0 |
| 6 | Poda posterior al PASS | `powershell -NoProfile -Command "if ((Test-Path .opencode\skills\ui-ux) -or (Test-Path .opencode\skills\convenciones-frontend) -or (Test-Path .opencode\skills\better-ui)) { exit 1 } else { exit 0 }"` | pendiente |

## Pasos
1. Crear `frontend-direction` y `frontend-build`; ruteo experimental y probes.
2. Escribir el brief de Teiba y el sistema/showcase/token check.
3. Reconstruir una sección de `SageView` con las primitivas.
4. Capturas + review + rating ≥4; go/no-go.
5. Podar `ui-ux`, `convenciones-frontend` y `better-ui`; cerrar spec.

## Bitácora
| Criterio | Fecha | Comando | Exit | Commit |
|---|---|---|---|---|
| 1 | 2026-10-29 | powershell -NoProfile -Command "$p='C:\Users\damez\Downloads\Universidad\quinto_semestre\BaseDeDatos2\ProyectoCurso\Teiba\Docs\features\006-pipeline-frontend-sage.md'; $ok=(Test-Path $p) -and (Select-String -Path $p -Pattern 'A. Instrumento' -Quiet) -and (Select-String -Path $p -Pattern 'B. Bitácora' -Quiet) -and (Select-String -Path $p -Pattern 'C. Panel' -Quiet); if ($ok) { exit 0 } else { exit 1 }" | 0 | 2fd35c0 |
| 2 | 2026-10-29 | powershell -NoProfile -Command "$r='C:\Users\damez\Downloads\Universidad\quinto_semestre\BaseDeDatos2\ProyectoCurso\Teiba\frontend'; Push-Location $r; npm run check:ui; $c=$LASTEXITCODE; Pop-Location; exit $c" | 0 | 2fd35c0 |
| 3 | 2026-10-29 | powershell -NoProfile -Command "$r='C:\Users\damez\Downloads\Universidad\quinto_semestre\BaseDeDatos2\ProyectoCurso\Teiba\frontend'; Push-Location $r; npm run check:ui; $a=$LASTEXITCODE; npm run lint; $b=$LASTEXITCODE; npm run typecheck; $c=$LASTEXITCODE; npm run test -- --run; $d=$LASTEXITCODE; npm run build; $e=$LASTEXITCODE; npm run detect:ui; $f=$LASTEXITCODE; Pop-Location; if (($a -eq 0) -and ($b -eq 0) -and ($c -eq 0) -and ($d -eq 0) -and ($e -eq 0) -and ($f -eq 0)) { exit 0 } else { exit 1 }" | 0 | 2fd35c0 |
| 5 | 2026-10-29 | powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify.ps1 | 0 | 2fd35c0 |

## Rollback
`git revert` de los commits del pipeline; `.\sync-global.ps1`; reiniciar TUI.
En Teiba, descartar `pilot/frontend-pipeline-sage`; no toca el resto de la UI.

## Cierre
- Rating, capturas y veredicto de `frontend-design-review`.
- ADR 008; changelog; poda solo si PASS.
