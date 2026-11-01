#!/usr/bin/env python3
"""
html_to_pdf.py — Convierte un archivo HTML (+ CSS embebido o enlazado) a PDF
usando WeasyPrint, el motor recomendado por la skill habilidades-ofimaticas.

Uso:
    python html_to_pdf.py entrada.html salida.pdf          (Windows)
    python3 html_to_pdf.py entrada.html salida.pdf         (Linux/macOS)
    --pdfa            variante archivable PDF/A-3b (requiere WeasyPrint >= 53)
    --css extra.css   hoja de estilos adicional (repetible)

Requisito: WeasyPrint instalado (python -m pip install weasyprint).
En Windows necesita ademas Pango/GTK; si no puedes instalarlo, usa
Playwright/Puppeteer o el navegador del sistema para generar el PDF.

Limitacion clave: WeasyPrint NO ejecuta JavaScript. Si el HTML depende de JS
para pintar contenido (graficas de Chart.js, tablas cargadas por fetch, etc.),
hay que pre-renderizar ese contenido a HTML estatico antes de convertir.
"""

from __future__ import annotations

import argparse
import sys
from typing import List, Optional


def ensure_weasyprint():
    """Comprueba que WeasyPrint esta importable; si no, informa y aborta."""
    try:
        import weasyprint  # noqa: F401
    except (ImportError, OSError) as exc:
        # No se auto-instala: descargar/instalar paquetes como efecto lateral
        # del script es un peligro (y en Windows pip solo no trae Pango/GTK).
        # OSError cubre el caso de WeasyPrint instalado sin librerias nativas.
        print(
            "WeasyPrint no esta disponible. Instala con: python -m pip install weasyprint\n"
            "En Windows requiere Pango/GTK; si no puedes instalarlo, usa\n"
            "Playwright/Puppeteer o el navegador del sistema.",
            file=sys.stderr,
        )
        # Exit 2 distingue "falta dependencia" de otros fallos de conversion.
        raise SystemExit(2) from exc


def convert(html_path: str, pdf_path: str, extra_css: Optional[List[str]], pdfa: bool) -> None:
    from weasyprint import CSS, HTML

    css_objects = [CSS(filename=path) for path in (extra_css or [])]
    html = HTML(filename=html_path)

    kwargs = {}
    if pdfa:
        # PDF/A-3b para documentos archivables (certificados, actas). La API de
        # WeasyPrint espera la clave pdf_variant y el valor pdf/a-3b (con barra);
        # otra combinacion (p. ej. variant="pdf-a-3b") hace que la opcion se ignore.
        kwargs["pdf_variant"] = "pdf/a-3b"

    html.write_pdf(pdf_path, stylesheets=css_objects or None, **kwargs)
    print(f"PDF generado: {pdf_path}")


def main():
    parser = argparse.ArgumentParser(description="Convierte HTML/CSS a PDF con WeasyPrint")
    parser.add_argument("entrada", help="Ruta al archivo .html de entrada")
    parser.add_argument("salida", help="Ruta al archivo .pdf de salida")
    parser.add_argument(
        "--css", action="append", default=None,
        help="Hoja de estilos CSS adicional (se puede repetir la bandera varias veces)",
    )
    parser.add_argument(
        "--pdfa", action="store_true",
        help="Genera PDF/A-3b (archivable, fuentes embebidas; requiere WeasyPrint >= 53)",
    )
    args = parser.parse_args()

    ensure_weasyprint()
    convert(args.entrada, args.salida, args.css, args.pdfa)


if __name__ == "__main__":
    main()
