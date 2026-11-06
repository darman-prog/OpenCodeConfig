# Gate A11y mínimo

Para UI web. No sustituye WCAG 2.2 AA ni la revisión manual: evita que vuelvan errores automáticos obvios.

## Cuándo

- Cambio visible de UI web.
- Tokens, tema, foco, modales, formularios o navegación.
- Antes de `calidad-cierre`.

## Contrato

El proyecto declara:

```json
"scripts": {
  "test:a11y": "rtk playwright test tests/a11y"
}
```

El test deja `docs/harness/a11y/latest.json`:

```json
{
  "date": "2026-11-05",
  "routes": ["/", "/login"],
  "critical": 0,
  "serious": 0,
  "keyboard": { "traps": 0, "unreachable": 0, "focusLost": 0 },
  "contrast": { "failures": 0 },
  "reducedMotion": "pass"
}
```

## Runner

```powershell
.\scripts\smoke-a11y.ps1
```

- Sin `test:a11y` ni reporte: `SKIP` y exit 0.
- Con `-Require`: falta de script o reporte es `FAIL`.
- Falla si `critical > 0`, hay trampa de foco, control inalcanzable, foco perdido o fallo de contraste.
- `serious > 0` queda como `WARN`.

## Mínimo Playwright

```ts
import { test, expect } from "@playwright/test"
import AxeBuilder from "@axe-core/playwright"
import fs from "node:fs"

test("a11y base", async ({ page }) => {
  await page.goto("/")
  const axe = await new AxeBuilder({ page })
    .withTags(["wcag2a", "wcag2aa", "wcag22aa"])
    .analyze()
  // Copia este resultado al reporte junto con las aserciones de teclado.
  fs.mkdirSync("docs/harness/a11y", { recursive: true })
  fs.writeFileSync("docs/harness/a11y/latest.json", JSON.stringify({
    date: new Date().toISOString().slice(0, 10),
    routes: ["/"],
    critical: axe.violations.filter(v => v.impact === "critical").length,
    serious: axe.violations.filter(v => v.impact === "serious").length,
    keyboard: { traps: 0, unreachable: 0, focusLost: 0 },
    contrast: { failures: 0 },
    reducedMotion: "pass"
  }, null, 2))
  expect(axe.violations.filter(v => ["critical", "serious"].includes(v.impact ?? ""))).toEqual([])
})
```

Añade aserciones explícitas de teclado y foco; axe no las deduce.
