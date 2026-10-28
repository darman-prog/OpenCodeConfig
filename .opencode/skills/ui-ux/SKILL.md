---
name: ui-ux
description: Criterios de UI: jerarquía, contenedores, estados y coherencia; ejecución en impeccable, veredicto en frontend-design-review.
---

# UI/UX
- No usar cuando: pides una revision heuristica de una UI existente (eso es `frontend-design-review`) o comparar librerias de componentes (eso es `investigacion-web` con la metodologia de `ui-ux`).

Antes de cambiar una interfaz, inspecciona componentes, tokens, patrones y estados existentes. Conserva la coherencia del sistema antes de introducir variantes.

- Decide la jerarquía y el flujo antes del pulido visual.
- `accesibilidad` es el canon de semántica, teclado, foco, contraste y WCAG 2.2 AA; esta skill no los duplica.
- Verifica comportamiento por capacidades y tamaños, no por dispositivos; la guía de adaptación es `impeccable adapt`.
- Verifica que existan los estados de carga, vacío, error, éxito, deshabilitado y permisos; su implementación es de `convenciones-frontend` e `impeccable harden`.
- Verifica feedback comprensible y microinteracciones que no dependan solo de color o movimiento; el canon es `accesibilidad` e `impeccable animate`.

Carga [CRITERIOS-UI-UX.md](references/CRITERIOS-UI-UX.md) bajo demanda. Estructura de codigo: `convenciones-frontend`; accesibilidad: `accesibilidad`; ejecucion de diseno: `impeccable-doctrina`/`impeccable`; review estructurado: `frontend-design-review`; elegir librerías externas: [COMPONENT-RESEARCH.md](references/COMPONENT-RESEARCH.md).
