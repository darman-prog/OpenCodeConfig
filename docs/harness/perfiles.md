---
status: vigente
last_reviewed: 2026-11-05
confidence: confirmado
source: decision de usuario 2026-11-05; commit pendiente
---
# Perfiles de proyecto

> El perfil ajusta los gates del harness, no las reglas base de seguridad ni de calidad.

## Declaración

En el `AGENTS.md` del proyecto:

```md
## Perfil
`personal`
```

Valores admitidos: `personal` y `equipo`. Si falta, se asume `personal` y el guardarraíl lo avisa.

## Matriz

| Comportamiento | `personal` | `equipo` |
|---|---|---|
| Rama de trabajo | opcional; `main` solo con instrucción explícita | obligatoria (`feat/`, `fix/`, etc.) |
| Push a `main` | permitido solo con tu OK | prohibido; merge vía PR |
| PR | no obligatorio | obligatorio con objetivo, impacto, riesgos y tests |
| Tests/lint/typecheck | proporcionales al riesgo | obligatorios antes del PR |
| `auditor` pre-merge | seguridad, arquitectura o contratos | siempre |
| Registro del cambio | tarjeta o changelog según tamaño | spec para cambios auditables |
| Gate A11y | si hay UI y Playwright | obligatorio en UI web |
| Documentación | solo la afectada | docs del cerebro y ADR al día |

## Reglas

- El perfil se declara una sola vez en `AGENTS.md`; no se duplica en `OPENCODE.md` ni en la config global.
- Cambiar de perfil es una decisión del proyecto: edita `AGENTS.md`, no la config de la máquina.
- Un perfil no relaja seguridad, secretos, permisos ni rollback.
- Si el perfil no cambia el comportamiento real en 30 días, elimínalo: no es decoración.
