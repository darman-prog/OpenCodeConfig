# HTML/CSS → PDF con WeasyPrint: referencia avanzada

Lee este archivo cuando el documento necesite algo más que la plantilla base:
numeración condicional, páginas con distinta cabecera, fuentes personalizadas,
o cuando algo no se renderiza como se espera.

## 1. Cabeceras y pies de página (margin boxes)

`@page` define hasta 16 "cajas de margen" con nombres fijos. Las más usadas:

```css
@page {
  @top-left    { content: "Confidencial"; }
  @top-center  { content: "Informe trimestral"; }
  @top-right   { content: string(seccion); }        /* ver "running headers" abajo */
  @bottom-center { content: counter(page) " / " counter(pages); }
}
```

**Cabecera que muestra el título de la sección actual** (como en libros impresos):

```css
h2 { string-set: seccion content(); }
@page { @top-right { content: string(seccion); } }
```

## 2. Páginas con distinto diseño (`@page` nombradas)

Útil para portada / índice / cuerpo con cabeceras distintas:

```css
@page portada { margin: 0; }
@page cuerpo   { margin: 2.2cm 2cm; }

.portada { page: portada; break-after: page; }
.cuerpo  { page: cuerpo; }
```

## 3. Fuentes personalizadas

WeasyPrint puede usar fuentes del sistema instaladas; si la fuente no está
instalada, declara un `@font-face` apuntando a un archivo `.ttf`/`.otf` real
(ruta local o URL accesible). No asumas que una web font se resuelve sin conexión.

```css
@font-face {
  font-family: "Inter";
  src: url("fuentes/Inter-Regular.ttf");
}
body { font-family: "Inter", sans-serif; }
```

Si el documento se leerá en varios idiomas o alfabetos (árabe, cirílico, CJK,
emoji), la fuente elegida debe cubrir esos rangos Unicode — si no, esos
caracteres se ven como cuadros vacíos. Verifica esto pidiéndole al modelo
generar una página de prueba con esos caracteres antes de dar el documento
por terminado.

## 4. Controlar cortes de página

- `break-inside: avoid` — en tablas, tarjetas o bloques que no deben partirse entre dos páginas.
- `break-before: page` / `break-after: page` — fuerza inicio de página nueva.
- `orphans` / `widows` — mínimo de líneas de un párrafo que deben quedar juntas al principio/final de página (por defecto usa 2–3).

## 5. Limitaciones reales de WeasyPrint (para no prometer algo que no puede hacer)

- **En Windows requiere Pango/GTK.** `pip install weasyprint` no trae las
  librerías nativas; si `import weasyprint` falla con `OSError`, instala GTK
  o usa Playwright/Puppeteer. En Linux/macOS `pip` basta en la mayoría de casos.
- **No ejecuta JavaScript.** Si el HTML de origen pinta contenido con JS
  (gráficas de Chart.js/D3, datos por `fetch`), ese contenido no aparecerá.
  Solución: generar el HTML ya con el contenido final estático (por ejemplo,
  crear el SVG/imagen del gráfico aparte e insertarlo con `<img>`), o usar un
  motor con navegador real (Playwright/Puppeteer) si está disponible en el
  entorno y el caso lo justifica.
- **CSS Grid**: soporta la mayoría de casos reales, pero *subgrid* y
  `grid-template-areas` muy complejos pueden fallar — si el layout se ve raro,
  prueba a resolverlo con flexbox, que tiene soporte completo.
- **Texto bidireccional / RTL** (árabe, hebreo mezclado con LTR) no está
  soportado de forma fiable.
- **`:hover`, `:focus`, `:active`** se aceptan como CSS válido pero no hacen
  nada (un PDF no es interactivo).
- Los pseudo-selectores de tabla como `visibility: collapse` no están soportados.

## 6. PDF/A (archivable)

Para actas, certificados o documentos que deban archivarse a largo plazo:

```python
html.write_pdf("salida.pdf", pdf_variant="pdf/a-3b")
```

Esto embebe todas las fuentes automáticamente y añade metadatos de
conformidad. No uses variantes PDF/A si el documento es de uso normal — el
archivo pesa más y no aporta nada.

## 7. Errores comunes y su causa

| Síntoma | Causa típica |
|---|---|
| Imágenes no aparecen | Ruta relativa mal resuelta — usa rutas absolutas o `base_url` en `HTML(string=..., base_url=...)` |
| Página en blanco al final | Un elemento con `break-before: page` al final del documento, o margen negativo |
| El PDF se ve pero le faltan las cabeceras | Falta `@page :first { @top-center { content: none } }` si no quieres cabecera en portada — o el `content` de la caja está vacío por selector mal escrito |
| Tipografía se ve con la fuente por defecto | El nombre en `font-family` no coincide con el `@font-face` declarado, o el archivo de fuente no se resolvió |
| Tabla larga corta mal entre páginas | Falta `break-inside: avoid` en las filas, o la tabla es muy ancha — considera `<thead>` que se repite automáticamente en cada página nueva (esto sí lo hace WeasyPrint por defecto) |
