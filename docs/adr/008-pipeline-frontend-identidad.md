# ADR 008: Dirección y sistema antes de código para frontend

## Contexto
Las UIs salían genéricas porque el flujo cargaba skills de checklist y permitía saltar de la idea al código sin dirección, referencias ni sistema. Teiba ya tiene un mundo visual fuerte en `Docs/DESIGN.md`, pero el código no lo expresaba con primitivas y tokens.

## Decisión
Adoptar un pipeline de tres gates: `frontend-direction` (brief, 3 referencias, 2 anti-referencias, 3 expresiones y elección), `frontend-build` (tokens, primitivas, showcase, `check-ui-tokens` bloqueante) y `frontend-design-review` (capturas + WCAG + detector). Pilot en una sección de `SageView`; rating ≥4/5 antes de podar skills o propagar.

## Consecuencias
Más fricción inicial y dependencia de capturas y criterio del usuario. Se añaden 2 skills y un script de tokens; se retiran 3 skills después del PASS. Sin dependencias runtime nuevas.

## Alternativas descartadas
- Más skills/checklists: no resuelve la falta de dirección.
- Solo `impeccable`: potente, pero pesado y sin sistema de componentes propio.
- Aprobar sin capturas/rating: repite el problema de UI genérica.
