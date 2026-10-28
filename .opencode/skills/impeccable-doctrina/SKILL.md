---
name: impeccable-doctrina
description: Flujo de comandos UI visible con impeccable, detector local y reglas de slop de diseno.
---

# Impeccable (wrapper para OpenCode)

Wrapper propio sobre el CLI oficial. El launcher vive en la base dir de la skill `impeccable` (en este repo `.opencode/skills/impeccable`; en global `~/.config/opencode/skills/impeccable`). OpenCode no recibe hook automatico post-edicion; este wrapper obliga al detector manual y fija el flujo del proyecto.

> **Relacion con `impeccable`**: esta skill define el **flujo** (cuando y en que orden). La skill `impeccable` (oficial) define **como ejecutar** cada comando. Cargalas juntas.

## Reglas no negociables

1. **Contexto primero**: antes del primer comando de la sesion, ejecuta `<base-dir>/scripts/impeccable context` (Windows: `impeccable.cmd`) y sigue sus directivas. No lo repitas.
2. **Detector reutilizado**: `critique` y `audit` ya corren el detector; reutiliza esa salida. Si ningun comando lo corrio, una sola pasada al cerrar: `detect <archivo>`; exit 0 limpio, exit 2 = resuelve o justifica con el ignore mas estrecho. En nativo no hay detector: aplica la revision de plataforma.
3. **Autoridad visual**: si falta `DESIGN.md`, no inventes un mundo. Con codigo/tokens, `document` (scan). Sin nada, `document --seed` (workshop + eleccion del usuario). Sin seed, scan o bypass demo/spike justificado, no se edita UI nueva.
4. **polish solo sobre features terminadas** (sin TODOs). Si el pase reestructura layout, el comando correcto era `critique` o `layout`.

## Subagentes en OpenCode

- `critique`: dos `general` aislados para A/B; nunca inline si el Task existe.
- `new-work`: `impeccable-finish-reviewer` y `impeccable-documenter`.
- `live`: `impeccable-manual-edit-applier`; imagenes: `impeccable-asset-producer` (solo si aplica).
- Si un agente no esta disponible, ejecuta su variante `reference/degraded/*` inline y declara `DEGRADED` en el informe.

## Enrutamiento

- `audit` -> `harden` / `polish` / `optimize` (P0-P3).
- `critique` -> `polish` / `distill`.
- `bolder` <-> `quieter`; decide rumbo, no quedes neutro.
- `init` -> `shape`; `document` (scan) para sistemas existentes, `document --seed` para nuevos.

## Comandos

Catalogo y sintaxis: `impeccable` (oficial). Este wrapper solo fija el orden y los gates de arriba.

## Detector y red

El launcher es local; si falta el binario, `impeccable.cmd` lo descarga con verificacion SHA256 (requiere red). En este repo el binario esta en `scripts/bin/windows-x64`.

## Integracion con este repo

- Convive con `convenciones-frontend`, `accesibilidad` y el checklist de `ui-ux`; no reemplaza esas reglas.
- Mantenimiento y atajos: `references/CLI.md`.
- Preset High-Craft opcional: `references/PRESET-LINEAR.md` (se adopta pidiendolo; nunca es default).
