# ADR 010: OpenCode V2 con plugins V2 y fuente espejo

## Contexto
El harness pasó a OpenCode 2.2.5. La API V1 de plugins ya no se ejecuta: `rtk.ts` y `notify-windows.js` fallaban al cargar desde el global y desde el proyecto, perdiendo la compresión de RTK y las notificaciones. Mantener V1 congela el runtime y obliga a revisar cada mejora de V2.

## Decisión
Usar V2 y portar los dos plugins a su contrato nativo (`export default { id, setup }`).
La fuente vive en `.opencode/plugins-src/`; el único runtime es `~/.config/opencode/plugins/`, espejado por `sync-global.ps1`. No se mantiene la doble implementación V1/V2.

## Consecuencias
- Positivas: RTK y notificaciones vuelven a funcionar; una sola copia por plugin evita IDs duplicados y el repo conserva la fuente.
- Negativas: no hay rollback directo a V1; habría que reinstalar `opencode-ai@1.19.3` y recuperar los plugins antiguos.
- Operativas: `scripts/smoke-plugins.ps1 -Runtime` valida hooks y eventos; `verify.ps1` comprueba el contrato y el espejo.

## Alternativas descartadas
- Quedarse en V1.19.3: congela el runtime y no aprovecha V2.
- V2 sin plugins: pierde compresión de salidas y notificaciones.
- Mantener plugins duales V1/V2: más código y una ventana de rollback que no se va a usar.
