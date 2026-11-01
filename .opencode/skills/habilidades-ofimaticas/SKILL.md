---
name: habilidades-ofimaticas
description: Word, PDF, PowerPoint y HTML a PDF con calidad editorial. Solo por petición explícita.
---

# Habilidades Ofimaticas

> **Activacion manual exclusiva:** Esta skill NO se carga automaticamente. Solo se activa cuando el usuario la menciona explicitamente (`habilidades-ofimaticas`, `ofimatica`, `ofimaticas` o `/habilidades-ofimaticas`). `backend-expert` y `ui-ux` deben ignorarla salvo invocacion directa. No auto-activar por detectar `docx`/`pdf`/`pptx` en la tarea.

## Enrutamiento por formato (elige UNO)

| El usuario quiere... | Ruta |
|---|---|
| Algo que se proyecta o se editara en PowerPoint/Slides/Keynote | `.pptx` -> `templates/generar-pptx.py` |
| Documento fijo impresible o archivado (informe, certificado, invitacion, boletin, one-pager) | HTML -> PDF -> ver seccion "HTML -> PDF" |
| Documento Word corto (nota, acta, rapido) | `templates/generar-docx.py` |
| Informe Word complejo (portada, indice, figuras, codigo) | `informe-docx` (kit `docx-js`), nunca junto a `generar-docx` |
| Tablas de datos simples sin diseno visual, mayormente desde codigo | `reportlab` nativo solo si HTML no aplica |

Si hay duda real (p. ej. "propuesta comercial"), pregunta en 1 frase si es diapositiva o documento; no asumas.

## Criterio de diseno compartido (evitar la estetica generica de IA)

Aplica a slides y documentos:
- **Jerarquia tipografica real**: 2-3 tamanos con proposito (titulo, subtitulo, cuerpo); no todo igual con negrita.
- **Paleta intencional**: 1 acento + 1-2 neutros derivada del contexto/marca; no el azul-morado degradado por defecto.
- **Espacio en blanco como herramienta**; contraste AA que no dependa solo del color (impresion B/N).
- **Una idea por slide**; texto minimo, detalle en notas del orador o doc aparte.
- **Imagenes/graficas con proposito**, no clipart de relleno; portada y cierre coherentes con el tema.

## Stack y mecanica

- `.pptx`: `python-pptx` via `templates/generar-pptx.py` para la mecanica; esta skill aporta el criterio de diseno encima.
- `.docx` simple: `python-docx` via `templates/generar-docx.py`; informe complejo parte de `../informe-docx/references/ejemplo.js`.
- `HTML -> PDF`: WeasyPrint (preferido, CSS Paged Media: `@page`, cabeceras/pies numerados) o Playwright/Puppeteer (fidelidad Chrome). En Windows WeasyPrint requiere Pango/GTK ademas de `pip`; si no esta disponible, usa Playwright.
- `PDF nativo`: `reportlab` solo si HTML no aplica (`pdf` no es una skill del harness; no la busques).

## Regla anti-alucinacion (obligatoria)

- COPIA la plantilla y reemplaza solo contenido y paleta; no generes CSS print ni layouts desde cero:
  - `templates/reporte-print.html` -> informe/reporte con KPIs, tablas y figuras.
  - `templates/plantilla-base.html` -> documento minimal con portada (certificado, invitacion, one-pager).
- `.docx` simple -> COPIA `templates/generar-docx.py`; `.pptx` -> COPIA `templates/generar-pptx.py`; informe Word complejo -> parte de `../informe-docx/references/ejemplo.js`.
- Referencia siempre los tokens de `templates/README.md`; conversion con `templates/html_to_pdf.py`; WeasyPrint avanzado en [referencia avanzada](references/html-css-avanzado.md) (leelo bajo demanda, no de entrada).

## Tokens y paleta contextual

Templates usan CSS variables / constantes `PRIMARY, ACCENT, NEUTRAL_DARK, NEUTRAL_LIGHT`.

Antes de generar: infiere contexto, propone 1 paleta con justificacion en 1 linea y pide confirmacion. No generar sin aprobar paleta (los colores de marca del usuario tienen prioridad).
- `corporativo/formal` -> `#1A56DB + #374151` (confianza, sobrio)
- `financiero/datos` -> `#0F2A44 + #0E9F6E` (solidez, lectura de tablas)
- `educativo/academico` -> `#0E7490 + #D97706` (claridad, enfasis)
- `creativo/marketing` -> `#7C3AED + #DB2777` (energia, contraste)
- `salud/minimal` -> `#047857 + #57534E` (calma, limpio)
Reemplaza solo `--primary/--accent` (HTML) o `PALETTE` (Python) tras confirmacion.

Tipografia base: `Inter, Helvetica, Arial, sans-serif`; cuerpo `11pt/14pt 400 1.5`, `H1 18-22pt 700`, `H2 14-16pt 600`, `H3 12pt 600`. Spacing `4/8`, radius `6px`. Papel A4 vertical con margenes segun plantilla (`reporte-print` 20/18mm; `plantilla-base` 2.2/2/2.4/2cm); ajusta al destino (A4/Letter). Presentacion `16:9`. Las plantillas de ejemplo pueden traer otra tipografia (Georgia/Helvetica): reemplazala por estos tokens salvo peticion expresa.

## Word (.docx)

- Usa estilos con nombre (`Normal`, `Heading 1-3`, `Caption`, `Table Grid`), nunca formato directo suelto.
- Margenes `2.54cm`, interlineado `1.15`, viudas/huerfanas controladas, numeracion en pie.
- Tablas con `Light Grid Accent` + fila encabezado con `primary`; imagenes ancladas con `caption`.

## PowerPoint (.pptx)

- Master unico `16:9` (`13.33x7.5"`), margen `48px`, grid 12 col; usa layouts `title` y `content` del template, no slides en blanco desde cero.
- Max `6 lineas / 6 palabras` por bullet, cuerpo `>=24pt`, titulo `32-44pt`; jerarquia + whitespace; icono > texto largo; notas del orador para el detalle.
- Paleta limitada `1 primario + 1 acento + 2 neutros`.
- Antes de entregar revisa cada slide: una idea por slide (necesitar subtitulos a/b/c = son dos slides); mismo tipo de letra para titulos y otro para cuerpo en todas las slides; logo/pie en posicion consistente; portada y cierre coherentes, no solo texto centrado por defecto.

## HTML -> PDF (caso principal)

Todo HTML que ira a PDF debe ser print-first:
- CSS obligatorio: `@page { size: A4; margin: ... }`, `@media print`, unidades `mm/pt`, `break-inside: avoid` en `figure/table/section`.
- `reporte-print.html`: header/footer propios en el cuerpo + `@page` con `counter(page)`; contenido en `<main>`.
- `plantilla-base.html`: cabecera/pie via `@page` (`@top-center`/`@bottom-right`) y `@page :first` sin cabecera para la portada (`.portada`); reemplaza las secciones de ejemplo dentro de `<body>`; si no usas portada, quita `@page :first` o perderas numeracion en pagina 1.
- Utilidades en ambas: `.evitar-corte` (tabla/tarjeta que no se parte entre paginas) y `.salto-pagina` (seccion que empieza en pagina nueva).
- HTML semantico, CSS autocontenido en `<style>` (sin CDN para WeasyPrint), tablas con `border-collapse`; WeasyPrint NO ejecuta JavaScript: pre-renderiza graficas y datos a HTML/SVG/imagen estatica antes de convertir.
- Conversion: `python templates/html_to_pdf.py entrada.html salida.pdf` (`--css extra.css` repetible; `--pdfa` para PDF/A-3b archivable, WeasyPrint >= 53). Si falta WeasyPrint (en Windows falla por Pango/GTK con `OSError`), el script lo informa sin instalar nada: usa `weasyprint` CLI, `playwright pdf` o el navegador del sistema.
- Avanzado (cabeceras dinamicas por seccion, `@page` nombradas, `@font-face`, errores comunes): [references/html-css-avanzado.md](references/html-css-avanzado.md) bajo demanda.
- Checklist de entrega: tamano de pagina correcto para el destinatario (A4 vs Letter); numeracion si >1-2 paginas; ninguna tabla/tarjeta/bloque cortado entre dos paginas; fuentes embebidas o de sistema disponibles; contraste valido en impresion B/N. WeasyPrint no falla ruidosamente (una imagen con ruta rota no aparece): abre el PDF y revisa paginacion antes de entregar.

## PDF nativo

Solo si HTML no aplica. Usa mismos tokens tipograficos y margenes que las plantillas HTML.

## Recursos

- `templates/README.md` — tokens, tabla de plantillas y verificacion rapida.
- [referencia avanzada](references/html-css-avanzado.md) — WeasyPrint avanzado y errores comunes.
- `templates/html_to_pdf.py` — conversion HTML->PDF con WeasyPrint (sin auto-install).
