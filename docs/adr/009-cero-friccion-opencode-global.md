# ADR 009: OPENCODE solo global, AGENTS por proyecto
Estado: vigente | Fecha: 2026-11-04
## Contexto
Agentes globales pedian `./OPENCODE.md` local inexistente fuera de la plantilla.
## Decisión
Canonico en `~/.config/opencode/OPENCODE.md` (fuente = plantilla, `sync` lo copia); proyectos solo `AGENTS.md`.
## Consecuencias
Cero setup fuera; el local se ignora. `sync` suma una copia.
## Alternativas descartadas
- Crear minimo por proyecto: friccion que el usuario rechazo.
- Ruta absoluta en proyecto: acopla al home del autor.
