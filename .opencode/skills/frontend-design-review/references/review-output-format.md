# Review Output Format

```
## Frontend Design Review: [Component/Feature Name]

### Context
- **Purpose**: What problem does this solve? Who uses it?
- **Aesthetic Direction**: [If new design: describe the bold conceptual direction]
- **User Task**: What is the user trying to accomplish?

### Summary
[Pass/Needs Work/Blocked] - [One-line assessment]

### Design System Compliance (if applicable)
- [ ] Fuente de verdad: Figma/Storybook si existe; si no, tokens y componentes del repo
- [ ] Componentes y variantes del sistema reutilizados
- [ ] Tokens usados (no valores hardcodeados) - verificado en codigo
- [ ] Espaciado, color y tipografia coinciden con la fuente aplicable
- [ ] Excepciones documentadas con su motivo

### States & Responsive
- [ ] loading, empty, error, success, disabled y permisos cuando aplican
- [ ] Mobile-first: sin scroll horizontal y con reflow a 200% de zoom
- [ ] Touch targets y texto ampliado verificados

### Aesthetic Quality (especially for redesigns)
- [ ] Clear conceptual direction (not generic AI aesthetic)
- [ ] Distinctive typography choices
- [ ] Cohesive color palette with CSS variables
- [ ] Intentional motion and micro-interactions
- [ ] Spatial composition creates visual interest
- [ ] Backgrounds and visual details add atmosphere

### Pillar Assessment

| Pillar | Status | Notes |
|--------|--------|-------|
| Frictionless | 🟢/🟠/⚫ | Task completion efficient, primary action clear |
| Quality Craft | 🟢/🟠/⚫ | System compliant, states/responsive covered, accessible (canon `accesibilidad`) |
| Trustworthy | 🟢/🟠/⚫ | AI disclaimer solo si aplica, errors actionable |

**Legend:** 🟢 Pass | 🟠 Needs attention | ⚫ Blocking issue

### Design Critique
**Verdict:** [Pass / Needs work / Reach out to design for more support]

**Rationale:** [Brief explanation based on pillar assessment, design system compliance, and aesthetic direction]

**Criteria:**
- **Pass**: All pillars 🟢 or minor 🟠 that don't block user tasks, design system compliant, clear aesthetic direction
- **Needs work**: Multiple 🟠 or any critical workflow issues, design system deviations, or generic aesthetic choices
- **Reach out to design for more support**: Any ⚫ blocking issues, fundamental pattern problems, major design system violations, or need for aesthetic direction

### Issues

**Blocking (must fix before merge):**
1. [Pillar/Design System/Aesthetic] Issue description + recommendation with link

**Major (should fix):**
1. [Pillar/Design System/Aesthetic] Issue description + pattern suggestion with reference

**Minor (consider for refinement):**
1. [Pillar/Design System/Aesthetic] Issue description + optional improvement

### Recommendations
- [Design system component to use with link]
- [Specific code change with design token reference]
- [Typography recommendation for better aesthetic direction]
- [Motion/animation suggestion]
- [Link to design system source: Figma/Storybook or repo tokens]
```
