---
id: 015
status: cerrada
area: ui
tarea: -
created: 2026-10-28
updated: 2026-10-28
---
# Card 015 — Pilot better-ui en Teiba
> Validar que `better-ui` se subordina al `Docs/DESIGN.md` de Teiba antes de rutearlo.
## Target
- Rama `pilot/better-ui-composer`; `frontend/src/features/agent/Composer.tsx:61-68`.
- Cambio: `transition-[background-color,scale] duration-150 ease-out` + `motion-safe:enabled:active:scale-[0.96]`.
- Se mantiene `strokeWidth={1.5}`, radio 6 y sin sombras.
## Rechazado
- Sombras (`Docs/DESIGN.md:160-166`), radio compuesto (`:166`), icono 2px (`:193`); gana el proyecto.
## Evidencia
- Baseline y post: lint 0, typecheck 0, test 32/32, build 0, detect `[]` 0.
- CSS: `scale:.96` bajo `@media (prefers-reduced-motion:no-preference)`; `transition-property:background-color,scale`; `hover:hover`.
- El pilot no tocó `Docs/DESIGN.md` ni `frontend/package.json`; el working tree ya traía cambios previos.
## Resultado
**PASS**. Sin commit en Teiba: la UI completa sigue sin trackear; el cambio queda en la rama.
## Rollback
Revertir la línea del botón o descartar la rama.
