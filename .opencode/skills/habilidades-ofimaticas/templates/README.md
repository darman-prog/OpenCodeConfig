# Templates — habilidades-ofimaticas

Anti-alucinacion: COPIA el template, no generes desde cero. Solo reemplaza contenido y paleta.

| Archivo | Cuando copiar | Comando | Que cambiar |
|---------|---------------|---------|-------------|
| `reporte-print.html` | `html -> pdf`, informe/reporte con KPIs, tablas y figuras | `python html_to_pdf.py reporte.html reporte.pdf` (o `weasyprint`/`playwright pdf`) | `<main>` + `:root { --primary/--accent }` segun paleta aprobada |
| `plantilla-base.html` | `html -> pdf`, documento minimal con portada: certificado, invitacion, boletin, one-pager | `python html_to_pdf.py documento.pdf` tras adaptar | contenido de ejemplo en `<body>` + colores/typografia a los tokens de `SKILL.md` |
| `html_to_pdf.py` | convertir cualquier HTML local a PDF con WeasyPrint | `python html_to_pdf.py entrada.html salida.pdf [--css extra.css] [--pdfa]` | nada: es script. Si falta WeasyPrint (Pango/GTK en Windows), informa y usa `weasyprint` CLI o `playwright pdf` |
| `generar-docx.py` | `.docx` simple / Word rapido | `pip install python-docx; python generar-docx.py` -> `reporte.docx` | `PALETTE` + bloque `# Contenido ejemplo — REEMPLAZA` |
| `generar-pptx.py` | `.pptx` / diapositivas | `pip install python-pptx; python generar-pptx.py` -> `presentacion.pptx` | `PALETTE` + `add_bullet_slide(...)` |
| `../../informe-docx/references/ejemplo.js` | Informe Word complejo: portada, indice, figuras, codigo | copiar como `build.js` en carpeta temporal; `node build.js` (requiere paquete `docx` del harness global) | contenido + tema del kit (`institucional/sobrio/campo/academico`); anchos de tabla suman `contentWidth()` |

WeasyPrint avanzado (cabeceras dinamicas, `@page` nombradas, `@font-face`, errores comunes):
`../references/html-css-avanzado.md`, bajo demanda.

Enrutamiento DOCX: documento rapido -> `generar-docx.py`; informe tecnico/academico
complejo -> `informe-docx` (ver `../../informe-docx/SKILL.md`). Nunca ambas para el mismo
documento.

## Paleta contextual (ver SKILL.md)
Agente propone 1 paleta segun contexto y pide confirmacion antes de generar. Variables:
- HTML: `:root { --primary: #...; --accent: #...; }`
- Python: `PALETTE = {"primary": "...", "accent": "..."}`

Heuristica: `corporativo #1A56DB`, `financiero #0F2A44/#0E9F6E`, `educativo #0E7490/#D97706`, `creativo #7C3AED/#DB2777`, `salud #047857`.

## Verificacion rapida
- HTML (`reporte-print`): abrir en Chrome -> Print Preview -> debe paginar A4 con header/footer y tablas sin cortes.
- HTML (`plantilla-base`): la portada (pagina 1) no lleva cabecera/pie (`@page :first`); el resto numerado `Página X de Y`.
- DOCX: abrir en Word -> estilos `Heading 1-3` deben existir, no formato directo.
- PPTX: `13.33x7.5` (16:9), margen 48px, texto >=18pt.
