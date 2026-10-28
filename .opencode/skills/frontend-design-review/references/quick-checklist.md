# Quick Checklist

Antes de aprobar UI:

## Design System
- [ ] Fuente de verdad identificada: Figma/Storybook si existe; si no, tokens y componentes del repo.
- [ ] Componentes del sistema reutilizados; variantes existentes respetadas.
- [ ] Tokens usados (sin hex ni pixeles hardcodeados).
- [ ] Desviaciones documentadas con su motivo.

## Estados y responsive
- [ ] loading, empty, error, success, disabled y permisos cubiertos cuando aplican.
- [ ] Mobile-first: sin scroll horizontal y usable en los breakpoints del proyecto.
- [ ] Reflow correcto a 200% de zoom y con texto ampliado.
- [ ] Touch targets >=24x24 CSS (44x44 recomendado en tactil).

## Accesibilidad (canon: skill `accesibilidad`, WCAG 2.2 AA)
- [ ] Contraste >=4.5:1 en texto y >=3:1 en UI/graficos; nunca solo color para estado.
- [ ] Teclado completo, orden de foco logico y foco visible.
- [ ] Labels reales, nombres accesibles y errores anunciados.
- [ ] `prefers-reduced-motion` respetado.
- [ ] Modales con focus trap, `Esc` y retorno de foco al trigger.

## Calidad visual
- [ ] Direccion conceptual clara (sin estetica generica de AI).
- [ ] Tipografia y paleta coherentes con el sistema.
- [ ] Motion intencional, no decorativo.
- [ ] Composicion con jerarquia; no solo cards repetidas.

## Frictionless
- [ ] Tarea principal completable en <=3 interacciones.
- [ ] Una accion primaria clara por vista.

## Trustworthy
- [ ] Disclaimer AI solo si el producto genera o presenta contenido AI.
- [ ] Errores accionables que explican el problema y la recuperacion.
