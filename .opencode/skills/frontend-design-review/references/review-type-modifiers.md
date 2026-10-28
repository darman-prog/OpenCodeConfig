# Review Type Modifiers

Adjust focus based on review context:

## PR Review
- **Focus**: Code implementation, design system component usage, design token usage, accessibility in code
- **Check**: Proper imports, design tokens used (not hardcoded), ARIA attributes present
- **Verify**: Component matches Figma/Storybook if it exists; otherwise repo tokens and components

## Creative Frontend Review
- **Focus**: Aesthetic direction, typography choices, visual distinctiveness, motion design
- **Check**: Clear conceptual intent, avoiding generic AI patterns, cohesive execution
- **Verify**: Implementation complexity matches vision (maximalist needs elaborate code, minimalist needs precision)

## Design Review
- **Focus**: User flows, interaction patterns, visual hierarchy, navigation, design system alignment
- **Check**: Task completion path, action hierarchy, progressive disclosure
- **Verify**: All components exist in design system or have documented exceptions

## Accessibility Audit
- **Focus**: Deep dive Quality Craft pillar; canon en la skill `accesibilidad` (WCAG 2.2 AA)
- **Check**: Keyboard testing, screen reader testing, contrast ratios, ARIA patterns
- **Test with**: Screen readers (NVDA, JAWS, Narrator), keyboard only, 200% zoom
- **Verify**: Design system accessibility features are properly implemented

## Design System Compliance Audit
- **Focus**: Deep dive design system usage
- **Check**: All components match the source of truth, design tokens used throughout, no hardcoded values
- **Test**: Compare side-by-side with Figma/Storybook if it exists; otherwise with repo tokens and components
- **Verify**: Component variants, spacing, colors, typography all match the applicable system
- **Document**: Any deviations with rationale and plan to align
