---
id: 018
status: en-curso
area: harness
tarea: -
created: 2026-10-31
updated: 2026-10-31
---
# Feature 018 — Integracion de ofimatica PPTX y HTML a PDF

> Fusiona el paquete ofimatica-pptx-html-pdf.skill en la skill manual habilidades-ofimaticas sin duplicar ruteo.

## Objetivo
Incorporar el criterio de diseno y el flujo HTML->PDF del paquete en `habilidades-ofimaticas`: conservar `reporte-print.html` y anadir `plantilla-base.html`, `html_to_pdf.py` y la referencia avanzada de WeasyPrint.

## Contexto
El paquete es un ZIP con 4 archivos de texto (SKILL.md, plantilla A4, referencia y script). La skill existente ya cubre DOCX/PPTX/PDF y es manual; crear otra skill duplicaria gatillos y romperia la politica de activacion manual. Defectos corregidos del script: `variant` invalido (API real `pdf_variant`), auto-install via pip, usage `python3` no portable y tipos de Python 3.10+.

## Alcance
| Incluye | Excluye |
|---|---|
| Extraer y normalizar plantilla, script y referencia; reescribir `SKILL.md`; actualizar README; borrar el ZIP; spec, indice y changelog | Skill nueva, cambios en `OPENCODE.md`, probes, smokes, presupuestos o agentes; instalacion global de WeasyPrint |

## Criterios de aceptación
| N.º | Criterio verificable | Comando | Evidencia |
|---|---|---|---|
| 1 | Archivos extraidos y ZIP eliminado | `powershell -NoProfile -Command "$b='.opencode\skills\habilidades-ofimaticas'; $ok=(Test-Path ($b+'\templates\plantilla-base.html')) -and (Test-Path ($b+'\templates\html_to_pdf.py')) -and (Test-Path ($b+'\references\html-css-avanzado.md')) -and -not (Test-Path ($b+'\templates\ofimatica-pptx-html-pdf.skill')); if ($ok) { exit 0 } else { exit 1 }"` | exit 0 |
| 2 | Guardarrail en verde (38 skills, tope 180 lineas, description manual) | `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\harness-budget.ps1` | exit 0 |
| 3 | Script sin auto-install y con `pdf_variant` correcto | `powershell -NoProfile -Command "$t=Get-Content '.opencode\skills\habilidades-ofimaticas\templates\html_to_pdf.py' -Raw; $ok=($t -notmatch 'subprocess') -and ($t -notmatch '--break-system-packages') -and ($t -match 'pdf_variant') -and ($t -match 'pdf/a-3b'); if ($ok) { exit 0 } else { exit 1 }"` | exit 0 |
| 4 | Plantilla base con A4, paginacion y utilidades | `powershell -NoProfile -Command "$t=Get-Content '.opencode\skills\habilidades-ofimaticas\templates\plantilla-base.html' -Raw; $ok=($t -match '@page') -and ($t -match 'counter') -and ($t -match 'evitar-corte') -and ($t -match 'salto-pagina'); if ($ok) { exit 0 } else { exit 1 }"` | exit 0 |
| 5 | SKILL.md <=180 lineas con gatillos intactos | `powershell -NoProfile -Command "$l=(Get-Content '.opencode\skills\habilidades-ofimaticas\SKILL.md').Count; $d=(Get-Content '.opencode\skills\habilidades-ofimaticas\SKILL.md' -TotalCount 4)[2]; $ok=($l -le 180) -and ($d -match 'PDF') -and ($d -match 'PowerPoint') -and ($d -match 'editorial'); if ($ok) { exit 0 } else { exit 1 }"` | exit 0 |
| 6 | Sync global e identidad repo/global | `.\sync-global.ps1` | exit 0 |
| 7 | Activos nuevos presentes en el global | `powershell -NoProfile -Command "$g=Join-Path $env:USERPROFILE '.config\opencode\skills\habilidades-ofimaticas'; $ok=(Test-Path ($g+'\templates\plantilla-base.html')) -and (Test-Path ($g+'\templates\html_to_pdf.py')) -and (Test-Path ($g+'\references\html-css-avanzado.md')); if ($ok) { exit 0 } else { exit 1 }"` | exit 0 |
| 8 | Smoke manual declara la skill | `powershell -NoProfile -Command "$out = opencode run --model opencode-go/deepseek-v4.1-flash 'usa habilidades-ofimaticas para generar un PDF A4 con portada'; if ($out -match 'habilidades-ofimaticas') { exit 0 } else { exit 1 }"` | exit 0 |

## Pasos
1. Extraer el ZIP a temp y copiar `plantilla-base.html`, `html_to_pdf.py` y `html-css-avanzado.md`; borrar el ZIP.
2. Corregir el script (sin auto-install, `pdf_variant`, Python 3.8+) y anadir alias `.evitar-corte`/`.salto-pagina` a `reporte-print.html`.
3. Reescribir `SKILL.md` (<=180 lineas) y `templates/README.md` con enrutamiento y criterios.
4. Crear la spec 018, registrar criterios y cerrar; actualizar changelog y estado-actual.

## Bitácora
| Criterio | Fecha | Comando | Exit | Commit |
|---|---|---|---|---|

## Rollback
`git revert` de los commits de la rama; recuperar el ZIP redescargandolo (no estaba en git); `.\sync-global.ps1`; reiniciar TUI.

## Cierre
- Fila resumen del changelog.
- Decisión de arquitectura: no aplica (fusion reversible, sin contrato/API).
