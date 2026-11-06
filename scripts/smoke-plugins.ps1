<#
.SYNOPSIS
  Smoke de los plugins V2: estatico por defecto; con -Runtime tambien prueba hooks y eventos.

.DESCRIPTION
  Verifica que plugins-src y el espejo global coincidan, que el contrato V2 exista
  y que no queden copias locales en .opencode/plugins. Con -Runtime lanza una
  sesion headless que ejecuta un comando (RTK) y cierra una sesion (notify).
  No imprime la salida del modelo; solo PASS/FAIL y la lista de fallos.
#>
param(
    [switch]$Runtime,
    [string]$Model = "opencode-go/deepseek-v4.1-flash"
)

$ErrorActionPreference = "Stop"
$repo = Split-Path -Parent $PSScriptRoot
$src = Join-Path $repo ".opencode\plugins-src"
$global = Join-Path $env:USERPROFILE ".config\opencode\plugins"
$expected = @("rtk.ts", "notify-windows.js")
$fail = @()

function Check($cond, $msg) {
    if (-not $cond) { $script:fail += $msg }
}

foreach ($name in $expected) {
    $file = Join-Path $src $name
    $target = Join-Path $global $name
    Check (Test-Path -LiteralPath $file) "falta $file"
    Check (Test-Path -LiteralPath $target) "falta $target"
    if ((Test-Path -LiteralPath $file) -and (Test-Path -LiteralPath $target)) {
        Check ((Get-FileHash -LiteralPath $file).Hash -eq (Get-FileHash -LiteralPath $target).Hash) "$name difiere entre repo y global"
    }
    if (Test-Path -LiteralPath $file) {
        $text = Get-Content -LiteralPath $file -Raw
        Check ($text -match '(?m)^\s*id:\s*["'']') "$name sin 'id:'"
        Check ($text -match '(?m)^\s*(?:async\s+)?setup\s*\(') "$name sin 'setup('"
        Check (-not ($text -match '(?m)^\s*export\s+const\s+')) "$name usa export con nombre (V1)"
    }
}

$localPlugins = Join-Path $repo ".opencode\plugins"
if (Test-Path -LiteralPath $localPlugins) {
    $loose = @(Get-ChildItem -LiteralPath $localPlugins -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -in @('.ts', '.js') })
    Check ($loose.Count -eq 0) "hay plugins duplicados en .opencode/plugins; usa plugins-src + sync global"
}

if ($fail.Count -gt 0) {
    Write-Host "SMOKE PLUGINS: FAIL estatico"
    $fail | ForEach-Object { Write-Host " - $_" }
    exit 1
}
Write-Host "PASS plugins: contrato V2 y espejo global OK"

if (-not $Runtime) { exit 0 }

$debugFile = Join-Path $env:TEMP "opencode-plugin-smoke-$PID.log"
Remove-Item -LiteralPath $debugFile -ErrorAction SilentlyContinue
$oldDebugFile = $env:OPENCODE_PLUGIN_DEBUG_FILE
$oldDebug = $env:OPENCODE_PLUGIN_DEBUG
$exitCode = 1
try {
    $env:OPENCODE_PLUGIN_DEBUG_FILE = $debugFile
    $env:OPENCODE_PLUGIN_DEBUG = "1"
    $prompt = "Usa la shell para ejecutar este comando exacto y devuelve solo su salida: npx vitest run --version"
    & opencode run --standalone --auto --model $Model --format json $prompt 2>&1 | Out-Null
    $exitCode = $LASTEXITCODE
} finally {
    if ($null -eq $oldDebugFile) { Remove-Item Env:OPENCODE_PLUGIN_DEBUG_FILE -ErrorAction SilentlyContinue } else { $env:OPENCODE_PLUGIN_DEBUG_FILE = $oldDebugFile }
    if ($null -eq $oldDebug) { Remove-Item Env:OPENCODE_PLUGIN_DEBUG -ErrorAction SilentlyContinue } else { $env:OPENCODE_PLUGIN_DEBUG = $oldDebug }
}

Check ($exitCode -eq 0) "opencode run termino con exit $exitCode"
Check (Test-Path -LiteralPath $debugFile) "no se genero $debugFile"
if (Test-Path -LiteralPath $debugFile) {
    $log = Get-Content -LiteralPath $debugFile -Raw
    Check ($log -match '\[rtk\] hook registered') "RTK no registro el hook execute.before"
    Check ($log -match '\[rtk\] rewrite command=') "RTK no ejecuto rtk rewrite"
    Check ($log -match '\[notify-windows\] event session\.execution\.succeeded') "notify no recibio session.execution.succeeded"
    Check ($log -match '\[notify-windows\] notify session=') "notify no disparo el toast de fin de sesion"
}

if ($fail.Count -gt 0) {
    Write-Host "SMOKE PLUGINS: FAIL runtime"
    $fail | ForEach-Object { Write-Host " - $_" }
    exit 1
}
Write-Host "PASS plugins: runtime RTK + notify OK"
exit 0
