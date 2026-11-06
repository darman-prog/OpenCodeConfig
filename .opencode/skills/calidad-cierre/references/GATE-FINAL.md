# Gate final

## Orden de revisión

1. Alcance y criterios de aceptación: se leen del plan entregado o de la entrada de changelog del cambio; si no hay ninguno, se acuerdan con el usuario antes de cerrar.
2. Evidencia por criterio: archivo, test, salida o comprobación; nunca “parece correcto”.
3. Diff y archivos modificados: cambios ajenos, secretos, artefactos y documentación.
4. Regresiones y edge cases proporcionales a riesgo.
5. Capas, contratos, migraciones y seguridad cuando correspondan.
6. Validaciones: tests, lint, typecheck, build o revisión manual; identifica lo no ejecutado.
7. Runner: `dueño`, `siguiente` y `Handoffs`; si el último handoff sigue `abierto`, bloquea.
8. Docs vivas: si el cambio tocó un documento del cerebro o del harness, actualiza `last_reviewed` y `source`.
9. UI web: si el proyecto tiene Playwright, ejecuta `scripts/smoke-a11y.ps1`; `critical`, foco y contraste deben quedar en 0. Sin Playwright, `SKIP` no bloquea.

## Salida obligatoria

```text
APROBADO
Evidencia: ...
Acción: ninguna; listo para cerrar.
```

o

```text
BLOQUEADO
Evidencia: ...
Acción: ...
```

Un hallazgo que impide cumplir alcance, seguridad, compatibilidad, datos o validación bloquea. Las mejoras no esenciales pueden quedar como seguimiento y no deben convertirse en un falso bloqueo.
