# ADR 007: better-ui como capa de pulido opcional

> Actualización 2026-10-29: `better-ui` deja de ser skill y pasa a referencia de `frontend-build/references/BETTER-UI.md`; la decisión de fondo (capa opcional, licencia MIT y precedencia del proyecto) sigue vigente. Ver ADR 008.

## Contexto
`better-ui` (`jakubkrehel/skills`, MIT, commit `592aedc`) aporta valores exactos de radios, sombras, iconos y motion que no están completos en `impeccable`. Asume la familia `better-*`, que no tenemos, y compite con `accesibilidad` en motion y con `frontend-design-review` en el veredicto. Teiba probó el subconjunto compatible con su `Docs/DESIGN.md`.

## Decisión
Adoptar solo `better-ui`, vendorizado con adaptador corto, referencias upstream, licencia y fuente fijada. Ruteo opcional en crear/ajustar; nunca en revisar/auditar. Mapear la familia a nuestras skills y usar sus HIGH como insumo de `frontend-design-review`, no como gate propio.

## Consecuencias
+1 skill, +1 probe y +1 smoke; 39 skills y 20 smokes. Sin runtime ni dependencias. La licencia y el drift se mantienen a mano. El pilot de Teiba pasa: se aplica press/transición y se rechazan sombras, radio compuesto e icono 2px.

## Alternativas descartadas
- Referencia dentro de `ui-ux`: menos descubrimiento y sin gatillo propio.
- Familia `better-*` completa: duplica accesibilidad, tipografía, layout y review.
- No adoptar: se pierden recetas concretas de pulido.
