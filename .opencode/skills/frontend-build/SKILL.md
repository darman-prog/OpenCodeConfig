---
name: frontend-build
description: Construccion frontend UI visible: estructura, tokens, primitivas, estados, responsive y WCAG; sin estilos ad-hoc. No decide direccion ni emite veredicto.
---

# Frontend Build

## Cuando

- Ya existe `DESIGN.md`/direccion aprobada y hay que construir o reconstruir pantallas.
- Hay que convertir una pantalla en componentes consistentes con el sistema.

## Entradas

`DESIGN.md`, `DIRECTION-BRIEF.md`, tokens, primitivas, showcase y las pantallas clave. Si el proyecto no tiene sistema, usa `src/shared/ui` y los patrones existentes como starter; no crees una capa nueva sin aprobación.

## Reglas

- Compón con tokens y primitivas. No introduzcas hex, fuentes, sombras ni radios fuera de `DESIGN.md`.
- Primitivas mínimas: `Button`, `Surface`, `Field`, `Chip`, `StatusTag`, `EmptyState`, `LoadingState`, `ErrorBanner`.
- Cada pantalla cubre loading, empty, error, success, disabled y permisos cuando apliquen; mobile-first y sin scroll horizontal.
- `accesibilidad` es el canon WCAG 2.2 AA: foco, teclado, contraste, labels, 44×44 y reduced-motion.
- Un token o patrón nuevo primero entra en `DESIGN.md` y en el showcase; después se usa.
- La estructura vive en [STRUCTURE.md](references/STRUCTURE.md); la jerarquía y los contenedores en [CRITERIOS-UI-UX.md](references/CRITERIOS-UI-UX.md).
- El pulido de detalle vive en [BETTER-UI.md](references/BETTER-UI.md) y el proyecto tiene precedencia; elegir librerías: [COMPONENT-RESEARCH.md](references/COMPONENT-RESEARCH.md).
- No uses `transition-all` ni animaciones sin `prefers-reduced-motion`.
- No decidas la dirección visual ni emitas el veredicto de review.

## Gate

`check-ui-tokens` en 0 sobre los archivos tocados, build/tests en verde, `impeccable detect` sin hallazgos sin justificar y capturas desktop/móvil. Sin capturas no hay review.

## Apoyo

`frontend-design-review` da el veredicto; `accesibilidad` el canon; [BETTER-UI.md](references/BETTER-UI.md) las recetas de pulido. Los ejemplos Tailwind/React/Motion del pulido son ilustrativos: adáptalos al stack.
