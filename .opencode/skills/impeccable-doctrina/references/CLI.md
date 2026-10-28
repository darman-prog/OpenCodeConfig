# CLI de Impeccable (detector, excepciones y mantenimiento)

Sintaxis exacta del CLI oficial. El flujo y cuando usar cada comando vive en `SKILL.md`.
La ruta del launcher es la base dir que reporta el loader para la skill `impeccable`:
en este repo `.opencode/skills/impeccable`; en global `~/.config/opencode/skills/impeccable`.
En Windows sin `sh`, usa `scripts/impeccable.cmd`.

## Detector CLI (equivalente terminal del hook)

```bash
<base-dir>/scripts/impeccable detect src/                     # carpeta o archivo
<base-dir>/scripts/impeccable detect src/index.html          # archivo concreto
<base-dir>/scripts/impeccable detect --json src/              # para scripts/CI
<base-dir>/scripts/impeccable detect --scope type src/        # dominio: type, layout, ...
<base-dir>/scripts/impeccable detect --no-design-system src/  # un scan sin DESIGN.md
```

## Excepciones (siempre la mas estrecha primero)

```bash
<base-dir>/scripts/impeccable ignores add-value overused-font Inter --reason "Fuente de marca"
<base-dir>/scripts/impeccable ignores add-file "src/legacy/**"
<base-dir>/scripts/impeccable ignores add-rule side-tab
<base-dir>/scripts/impeccable ignores list
```

Inline en el archivo (viaja con el archivo): `<!-- impeccable-disable overused-font: razon -->`.
Config compartida: `.impeccable/config.json` (se commitea). Local: `config.local.json` (gitignored).
Si la config puede estar rota (claves malas, paths movidos): `/impeccable doctor`.

## Mantenimiento y atajos

- El launcher es local; si falta el binario, lo descarga con verificacion SHA256 (requiere red). `update` tambien requiere red.
- Comandos fijables como atajo: `/impeccable pin audit` -> crea `/audit`.
- Los comandos de `reference/` de la skill oficial muestran `.opencode/skills/...`; sustituye esa ruta por la base dir que reporta el loader.
