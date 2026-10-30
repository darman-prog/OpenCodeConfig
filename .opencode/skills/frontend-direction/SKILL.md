---
name: frontend-direction
description: Direccion visual antes de codigo: brief, 3 referencias, 2 anti-referencias y 3 propuestas; el usuario elige y se escribe DESIGN.md seed.
---

# Frontend Direction

## Cuando

- Proyecto nuevo sin `DESIGN.md` ni identidad visual.
- Rediseño o una pantalla que debe sentirse propia.
- Ya hay un mundo visual y quieres 3 expresiones distintas del mismo mundo.

## Entradas

`PRODUCT.md`, `DESIGN.md` si existe, pantallas clave y las restricciones de marca. Si no hay referencias, el agente propone 3 concretas (URL, imagen, tipografía o paleta) y 2 anti-referencias; no inventa citas.

## Proceso

1. Lee producto, sistema existente y pantallas; no escribas código.
2. Formula una tesis visual en una frase: qué debe sentir el operador y qué no.
3. Propone 3 direcciones con nombre, tesis, paleta, tipografía, layout, motion y forma de componentes.
4. Para cada una: 3 referencias concretas, 2 anti-referencias y qué se toma de cada referencia sin copiarla.
5. El usuario elige, steer o pide otra ronda. Sin elección no hay dirección.
6. Escribe `DIRECTION-BRIEF.md` y un `DESIGN.md` seed con tokens, reglas y componentes; marca lo que queda por validar.
7. Para. La implementación es de `frontend-build`.

## Reglas

- Las referencias son evidencia, no plantillas: extrae principios, no clones.
- Una idea distintiva por mundo; nada de estética genérica de SaaS.
- Respeta tokens, marca y restricciones del proyecto; si el proyecto ya tiene mundo, no lo reemplaces sin aprobación.
- Teiba: mantiene “Estación de campo”; la dirección propone 3 expresiones del mismo mundo, no 3 mundos nuevos.
- No instales dependencias ni escribas componentes en esta fase.

## Gate

Sin `DIRECTION-BRIEF.md` aprobado y `DESIGN.md` seed, no se construye. Si el usuario no elige, se detiene; no se elige por él.

## Apoyo

`impeccable new-work` puede profundizar el workshop si hace falta; `investigacion-web` sirve para referencias verificables. Esta skill no emite veredicto de review.
