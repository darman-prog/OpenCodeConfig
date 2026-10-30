---
name: frontend-design-review
description: Auditar UI contra el design system: 3 pilares, estados UI, responsive y WCAG 2.2 AA.
acknowledgments: |
  Design review principles and quality pillar framework created by @Quirinevwm (https://github.com/Quirinevwm).
  Creative frontend guidance inspired by Anthropic's frontend-design skill
  (https://github.com/anthropics/skills/tree/main/skills/frontend-design). Licensed under respective terms.
---

# Frontend Design Review

> Adaptada de `microsoft/skills` (`.github/skills/frontend-design-review`, licencia MIT). Ajustes locales: description al presupuesto, **WCAG 2.2 AA** como canonico (skill `accesibilidad`) y regla anti-doble-review.
> **Anti-doble-review:** esta skill aporta el **formato y scoring** del review (3 pilares + compliance + evidencia); la creacion de UI nueva y los checks perceptuales/tecnicos son de `impeccable-doctrina`/`impeccable` (`shape`, `critique`, `audit`, `detect`). No corras ambos sobre el mismo cambio: usa esta para el veredicto estructurado.
> Si el proyecto no usa Figma/Storybook, evalua contra los tokens y componentes reales del repo.

Review UI implementations against design quality standards and your design system. Para crear UI nueva (modo creativo) usa la skill `impeccable`.

## Alcance

Evaluar UI existente: compliance con el design system, los tres pilares (Frictionless, Quality Craft, Trustworthy), accesibilidad y calidad de codigo UI. La creacion de UI nueva es de `impeccable`.

---

## Creacion de UI nueva

Fuera de alcance de esta skill: la direccion estetica, tipografia, color, motion y composicion las gobierna `impeccable` (comandos `shape`/`new-work`, `colorize`, `typeset`, `animate`, `layout`, `delight`, con su `craft-floor`). Aqui solo se evalua el resultado.

---

## Design Review

### Design System Context

1. Si existe Figma/Storybook, usalo como especificacion; si no, la fuente es el codigo: tokens, componentes y patrones reales.
2. Verifica que se usen tokens (no valores hardcodeados) y que existan las variantes y estados del sistema.
3. Si falta un componente, comprueba si uno existente se adapta; documenta la excepcion y su motivo.
4. Si no hay `DESIGN.md` ni tokens/componentes, no inventes criterios: reporta "no visual system" y redirige a `document` o `document --seed`.
5. Si existe `frontend-build`, úsalo como contrato: tokens, primitivas y cero estilos ad-hoc.

**Durante el review:**
1. Compara con la fuente de verdad aplicable (Figma/Storybook o repo).
2. Verifica tokens, estados (loading, empty, error, success, disabled/permisos) y responsive.
3. Marca desviaciones; no las implementes en esta skill.

### Review Process

1. Identify user task
2. Check design system for matching patterns
3. Evaluate aesthetic direction
4. Identify scope (component, feature, or flow)
5. Evaluate each pillar
6. Score and prioritize issues (blocking/major/minor)
7. Provide recommendations with design system examples

### Core Principles

- **Task completion**: Minimum clicks. Every screen answers "What can I do?" and "What happens next?"
- **Action hierarchy**: 1-2 primary actions per view. Progressive disclosure for secondary.
- **Onboarding**: Explain features on introduction. Smart defaults over configuration.
- **Navigation**: Clear entry/exit points. Back/cancel always available. Breadcrumbs for deep flows.

---

## Quality Pillars

### 1. Frictionless Insight to Action

**Evaluate:** Task completable in ≤3 interactions? Primary action obvious and singular?

**Red flags:** Excessive clicks, multiple competing primary buttons, buried actions, dead ends.

### 2. Quality is Craft

**Evaluate:**
- Design system compliance: matches the source of truth (Figma/Storybook or repo tokens), uses design tokens.
- Aesthetic direction: identidad reconocible, tipografía y color cohesivos, motion intencional; no solo compliance de tokens.
- States and responsive: loading, empty, error, success, disabled/permisos; mobile-first, sin scroll horizontal y reflow a 200% de zoom.
- Accessibility: cumple el checklist canonico de la skill `accesibilidad` (WCAG 2.2 AA).

**Red flags:** Generic AI aesthetics, hardcoded values, implementation doesn't match the system, broken reflow, missing states, missing focus indicators.

### 3. Trustworthy Building

**Evaluate:**
- AI transparency: solo si el producto genera o presenta contenido AI; en ese caso, disclaimer visible.
- Error transparency: actionable error messages.

**Red flags:** Falta el disclaimer AI cuando aplica, errores opacos sin guia.

---

Sin capturas desktop/móvil no hay veredicto: `Not verified` no es un pass. Si `check-ui-tokens` falla en los archivos del cambio, el veredicto es bloqueante.

## Review Output Format

See [references/review-output-format.md](references/review-output-format.md) for the full review template.

## Review Type Modifiers

See [references/review-type-modifiers.md](references/review-type-modifiers.md) for context-specific review focus areas (PR, Creative, Design, Accessibility).

## Quick Checklist

See [references/quick-checklist.md](references/quick-checklist.md) for the pre-approval checklist covering design system compliance, states, responsive, aesthetic quality, frictionless and trustworthy pillars.

## Pattern Examples

See [references/pattern-examples.md](references/pattern-examples.md) for good/bad examples of creative frontend and design system review work.

---

## Acknowledgments

Creative frontend principles inspired by [Anthropic's frontend-design skill](https://github.com/anthropics/skills/tree/main/skills/frontend-design). Design review principles and quality pillar framework created by [@Quirinevwm](https://github.com/Quirinevwm) for systematic UI evaluation.
