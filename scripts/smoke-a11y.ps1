<#
.SYNOPSIS
  Gate A11y minimo para proyectos web: ejecuta test:a11y y valida el reporte.

.DESCRIPTION
  Contrato: package.json puede declarar "test:a11y" y debe dejar
  docs/harness/a11y/latest.json. Sin Playwright/script, sale SKIP y no bloquea.
  Con -Require, la ausencia de reporte o de script es FAIL.
#>
param(
    [string]$Root = (Split-Path -Parent $PSScriptRoot),
    [string]$Report = "docs\harness\a11y\latest.json",
    [switch]$Require,
    [switch]$SelfTest
)

$ErrorActionPreference = "Stop"

# Prueba el propio contrato con un reporte PASS y otro FAIL; no requiere navegador.
if ($SelfTest) {
    $tmp = Join-Path $env:TEMP "a11y-selftest-$PID"
    New-Item -ItemType Directory -Force -Path $tmp | Out-Null
    try {
        $ok = '{"critical":0,"serious":0,"keyboard":{"traps":0,"unreachable":0,"focusLost":0},"contrast":{"failures":0},"reducedMotion":"pass"}'
        Set-Content -LiteralPath (Join-Path $tmp 'a11y.json') -Value $ok -Encoding utf8
        & powershell -NoProfile -ExecutionPolicy Bypass -File $PSCommandPath -Root $tmp -Report a11y.json
        if ($LASTEXITCODE -ne 0) { Write-Host "SELFTEST FAIL: reporte PASS rechazado"; exit 1 }

        $bad = '{"critical":1,"keyboard":{"traps":1,"unreachable":0,"focusLost":0},"contrast":{"failures":2}}'
        Set-Content -LiteralPath (Join-Path $tmp 'a11y.json') -Value $bad -Encoding utf8
        & powershell -NoProfile -ExecutionPolicy Bypass -File $PSCommandPath -Root $tmp -Report a11y.json
        if ($LASTEXITCODE -eq 0) { Write-Host "SELFTEST FAIL: reporte FAIL aceptado"; exit 1 }
        Write-Host "SELFTEST PASS: contrato A11y PASS/FAIL"
        exit 0
    } finally {
        Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue
    }
}
$reportPath = Join-Path $Root $Report
$pkgPath = Join-Path $Root "package.json"
$script = $null

if (Test-Path -LiteralPath $pkgPath) {
    try {
        $pkg = Get-Content -LiteralPath $pkgPath -Raw | ConvertFrom-Json
        $script = $pkg.scripts.'test:a11y'
    } catch {
        Write-Host "FAIL: package.json no se puede leer"
        exit 1
    }
}

if ($script) {
    Write-Host "A11Y: ejecutando npm run test:a11y"
    Push-Location $Root
    try {
        & npm run test:a11y
        $code = $LASTEXITCODE
    } finally {
        Pop-Location
    }
    if ($code -ne 0) {
        Write-Host "FAIL: test:a11y termino con exit $code"
        exit 1
    }
} elseif ($Require) {
    Write-Host "FAIL: el proyecto no declara test:a11y"
    exit 1
} else {
    Write-Host "A11Y: sin script test:a11y"
}

if (-not (Test-Path -LiteralPath $reportPath)) {
    if ($Require) {
        Write-Host "FAIL: falta el reporte $Report"
        exit 1
    }
    Write-Host "SKIP: falta $Report; agrega test:a11y o genera el reporte"
    exit 0
}

try {
    $r = Get-Content -LiteralPath $reportPath -Raw | ConvertFrom-Json
} catch {
    Write-Host "FAIL: $Report no es JSON valido"
    exit 1
}

$failures = @()
if ($null -eq $r.critical -or [int]$r.critical -ne 0) {
    $failures += "axe critical=$($r.critical)"
}
if ($null -eq $r.keyboard) {
    $failures += "falta keyboard"
} else {
    foreach ($key in @('traps', 'unreachable', 'focusLost')) {
        $value = $r.keyboard.$key
        if ($null -eq $value -or [int]$value -ne 0) {
            $failures += "keyboard.$key=$value"
        }
    }
}
if ($null -eq $r.contrast -or [int]$r.contrast.failures -ne 0) {
    $failures += "contrast.failures=$($r.contrast.failures)"
}
if ($r.reducedMotion -and $r.reducedMotion -ne 'pass') {
    $failures += "reducedMotion=$($r.reducedMotion)"
}
if ($r.serious -and [int]$r.serious -gt 0) {
    Write-Host "WARN: axe serious=$($r.serious)"
}

if ($failures.Count -gt 0) {
    Write-Host "FAIL A11Y:"
    $failures | ForEach-Object { Write-Host " - $_" }
    exit 1
}
Write-Host "PASS A11Y: critical=0, keyboard=0, contrast=0"
exit 0
