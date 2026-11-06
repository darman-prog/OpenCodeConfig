---
id: 020
status: cerrada
date: 2026-11-05
tipo: modificación
area: harness
tarea: -
---
# Cambio — Theme V2 y colores de agentes

> `darmandev` migrado a formato V2 y colores de agentes en hex, para que `build` y `plan` dejen de salir grises.

## Cambio
Agentes: `color: success/info/accent` → hex (`#9ece6a`, `#7dcfff`, `#7aa2f7`) en proyecto y global.
Theme: `.config/opencode/themes/darmandev.json` y `.opencode/themes/darmandev.json` reescritos a `base` + `dark`.
`cli.json` toma `"theme": { "name": "darmandev", "mode": "dark" }`; el README refleja la activación V2.

## Por qué
V2 exige hex en `color` y otro esquema de theme (`base`, `light`/`dark` + escalas). Los nombres semánticos caen a gris; el esquema V1 se ignora parcialmente.

## Cómo verificar
- `opencode debug agents` → `build` y `plan` con color hex, no gris.
- `/themes` en TUI muestra `darmandev` activo; fondo/acentos de la paleta Tokio Night.
- Sin avisos "configuration normalization" de theme en el log del día.

## Dónde mirar
- `.opencode/agents/{build,plan,ui-ux}.md` y espejo global
- `~/.config/opencode/cli.json` · `~/.config/opencode/themes/darmandev.json` · `.opencode/themes/darmandev.json`
- README del directorio `themes/` para el mapa V1 → V2

## Rollback
- `darmandev.v1.json.bak` guarda el theme V1 (global).
- Revertir los `color:` a los nombres semánticos solo vale en versión V1 de OpenCode; en V2 volvería el gris.

## Evidencia
- `opencode debug agents` → build `#9ece6a`, plan `#7dcfff`, ui-ux `#7aa2f7`
- Validación JSON: `ConvertFrom-Json` OK en global y proyecto
- Log del día sin errores de theme
