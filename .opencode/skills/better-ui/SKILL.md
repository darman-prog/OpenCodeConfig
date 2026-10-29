---
name: better-ui
description: Pulido visual: radios, sombras, iconos, hover y motion con valores exactos; usar tras ui-ux; no da direccion ni veredicto.
---

# Better UI (capa de pulido)

> Adaptacion de `jakubkrehel/skills` (`better-ui`), MIT, commit `592aedc` (2026-10-25). Texto completo: [PRINCIPLES.md](references/PRINCIPLES.md). Licencia: `LICENSE`.

## Cuando

- La interaccion ya funciona y el sistema visual existe (`DESIGN.md`/tokens).
- Pides pulir detalles: radios, sombras, iconos, hover, press, entradas/salidas, transitions.
- No para decidir direccion visual, no para auditar WCAG y no para emitir veredicto.

## Precedencia

1. `DESIGN.md`, tokens y convencion deliberada del proyecto.
2. `accesibilidad` (WCAG 2.2 AA, foco, `prefers-reduced-motion`).
3. `impeccable`/`craft-floor` (direccion y piso de calidad).
4. `better-ui` (valores exactos de pulido).

El veredicto es de `frontend-design-review`; el gate de cierre, de `calidad-cierre`.

## Mapeo de la familia

- `better-accessibility` -> `accesibilidad`
- `better-typography` -> `impeccable typeset`
- `better-layout` -> `impeccable layout`
- `better-colors` -> `impeccable colorize` + `accesibilidad`
- `better-interface` -> `frontend-design-review`
- `better-writing` -> no se adopta

## Reglas que si aplican

- Radios concentricos: `outer = inner + padding + border`; si el padding supera 24px o es asimetrico, capas separadas.
- Sombras de elevacion con capas transparentes; `border: 1px solid transparent` para `forced-colors`.
- Imagenes: outline 1px `oklch(0 0 0 / 0.1)` o `oklch(1 0 0 / 0.1)`.
- Press: `0.96` en 150ms `ease-out`; deshabilitado no escala.
- Entradas infrecuentes: 300ms, stagger 100ms, opacity + 4px blur + 12px translateY; salidas 150ms.
- Transiciones para estado interactivo; keyframes solo para secuencias.
- `transition-property` nombrada, nunca `all`.
- Hover solo bajo `@media (hover: hover)`.
- `overscroll-behavior: contain` en overlays.
- Iconos: stroke 1.5/2/2.5 segun peso; `currentColor`; outline/fill para estado; RTL solo direccional.
- Movimiento, scale y blur solo con `prefers-reduced-motion: no-preference`; fallback opacity.

## Limites

- Los valores son defaults; si el proyecto tiene otro valor, gana el proyecto.
- Los ejemplos Tailwind/React/Motion son ilustrativos; adaptalos al stack y no instales dependencias por esta skill.
- El `Reporting` upstream (HIGH/MEDIUM/LOW, Block/Approve) es insumo para `frontend-design-review`; no es un segundo gate.
- Sin browser, reporta `Not verified`; no inventes evidencia.

Recetas completas: [PRINCIPLES.md](references/PRINCIPLES.md), [surfaces.md](references/surfaces.md), [animations.md](references/animations.md), [enter-exit.md](references/enter-exit.md), [icon-transitions.md](references/icon-transitions.md), [performance.md](references/performance.md), [icons.md](references/icons.md).
