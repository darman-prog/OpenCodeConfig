# ADR 006: Gate de autoridad visual antes de UI nueva

## Contexto
Sin `DESIGN.md`, el modelo improvisa y cae en patrones genericos. `init` no escribe `DESIGN.md` y `shape` no elige estetica; el usuario debe decidir el mundo visual antes de implementar.

## Decision
Bloquear UI nueva o rediseno hasta que exista `DESIGN.md` (scan o seed) o un bypass aprobado. El seed se crea con `document --seed`, que ejecuta el workshop de `new-work`: 2-3 preguntas y 3 direcciones; el usuario elige. Tras implementar, `document` (scan) captura los tokens reales.

## Consecuencias
Mas friccion en proyectos nuevos; el bypass es obligatorio para demos/spikes. El seed se marca como tal y se re-documenta al haber codigo. No hay estilo por defecto.

## Alternativas descartadas
- Gate blando: el modelo asume una direccion y sigue.
- Auto-seed desde preset: convierte el preset en default.
- `DESIGN.md` final solo despues del build: se implementa sin contrato.
