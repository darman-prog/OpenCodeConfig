# verify.ps1 — Verificacion completa del harness en un comando.
#
# Uso: .\scripts\verify.ps1 [-SkipSmokes] [-Frontend] [-Skill "frontend-*"] [-Changed]
#   1. Guardarrail de presupuesto (fail-closed: exit 1 si hay violaciones).
#   2. Identidad repo <-> global: mismas skills, mismo contenido (solo lee).
#   3. Plugins V2: contrato, espejo global y sin copias duplicadas.
#   4. Doc drift: metadata, enlaces, ADR y cifras vigentes.
#   5. Smokes de ruteo: matriz completa por defecto; -Frontend/-Skill/-Changed filtran.
#   6. Aviso de sesion desactualizada: la config no es hot-reload.
#
# Exit 0 = todo verde. Exit 1 = hay algo que arreglar.

param(
  [switch]$SkipSmokes,
  [string]$Skill = "",
  [switch]$Frontend,
  [switch]$Changed
)

$ErrorActionPreference = "Continue"
$Root = Split-Path -Parent $PSScriptRoot
$globalDir = Join-Path $env:USERPROFILE ".config\opencode"
$fail = 0

Write-Host "=" * 60
Write-Host "VERIFICACION DEL HARNESS"
Write-Host "=" * 60

# ── 1) Guardarrail de presupuesto ─────────────────────────────────────────
Write-Host "`n[1/5] Guardarrail de presupuesto..."
$budget = Join-Path $Root "scripts\harness-budget.ps1"
& powershell -NoProfile -ExecutionPolicy Bypass -File $budget
if ($LASTEXITCODE -ne 0) {
  Write-Host "  FAIL: el guardarrail reporta violaciones (arriba)."
  $fail++
} else {
  Write-Host "  PASS: presupuesto y contratos en verde."
}

# ── 2) Identidad repo <-> global (solo lee) ───────────────────────────────
Write-Host "`n[2/5] Identidad repo <-> global..."
$repoSkills = Join-Path $Root ".opencode\skills"
$globalSkills = Join-Path $globalDir "skills"
if (-not (Test-Path -LiteralPath $globalSkills)) {
  Write-Host "  FAIL: no existe $globalSkills (ejecuta .\sync-global.ps1)."
  $fail++
} else {
  $repoFiles = @(Get-ChildItem -LiteralPath $repoSkills -Recurse -File -Filter SKILL.md)
  $globalFiles = @(Get-ChildItem -LiteralPath $globalSkills -Recurse -File -Filter SKILL.md)
  $diff = @()
  foreach ($rf in $repoFiles) {
    $rel = $rf.FullName.Substring($repoSkills.Length).TrimStart('\')
    $target = Join-Path $globalSkills $rel
    if (-not (Test-Path -LiteralPath $target)) { $diff += "falta en el global: $rel"; continue }
    $a = ((Get-Content -LiteralPath $rf.FullName -Raw) -replace "`r`n", "`n")
    $b = ((Get-Content -LiteralPath $target -Raw) -replace "`r`n", "`n")
    if ($a -ne $b) { $diff += "difiere del repo: $rel" }
  }
  if ($repoFiles.Count -ne $globalFiles.Count) {
    $diff += "el global tiene $($globalFiles.Count) SKILL.md y el repo $($repoFiles.Count)"
  }
  if ($diff.Count -gt 0) {
    Write-Host "  FAIL: el global no es espejo del repo:"
    $diff | Select-Object -First 5 | ForEach-Object { Write-Host "   - $_" }
    Write-Host "  Solucion: .\sync-global.ps1 -ForcePurge"
    $fail++
  } else {
    Write-Host "  PASS: $($repoFiles.Count) skills identicas en repo y global."
  }
}

# ── 3) Plugins V2: contrato y espejo global ───────────────────────────────
Write-Host "`n[3/5] Plugins V2..."
$pluginSmoke = Join-Path $Root "scripts\smoke-plugins.ps1"
& powershell -NoProfile -ExecutionPolicy Bypass -File $pluginSmoke
if ($LASTEXITCODE -ne 0) {
  Write-Host "  FAIL: plugin V2 con contrato o espejo incorrecto (arriba)."
  $fail++
} else {
  Write-Host "  PASS: contrato V2 y espejo global."
}

# ── 4) Doc drift: metadata, enlaces, ADR y cifras ─────────────────────────
Write-Host "`n[4/5] Doc drift..."
$drift = Join-Path $Root "scripts\doc-drift.ps1"
& powershell -NoProfile -ExecutionPolicy Bypass -File $drift -Strict
if ($LASTEXITCODE -ne 0) {
  Write-Host "  FAIL: hay documentacion desactualizada (arriba)."
  $fail++
} else {
  Write-Host "  PASS: docs alineadas con el repo."
}

# ── 5) Smokes de ruteo ───────────────────────────────────────────────────
Write-Host "`n[5/5] Smokes de ruteo..."
if ($SkipSmokes) {
  Write-Host "  OMITIDOS (-SkipSmokes)."
} else {
  $smoke = Join-Path $Root "scripts\smoke-routing.ps1"
  $smokeArgs = @()
  if ($Skill) { $smokeArgs += @('-Skill', $Skill) }
  if ($Frontend) { $smokeArgs += '-Frontend' }
  if ($Changed) { $smokeArgs += '-Changed' }
  & powershell -NoProfile -ExecutionPolicy Bypass -File $smoke @smokeArgs
  if ($LASTEXITCODE -ne 0) {
    Write-Host "  FAIL: hay smokes de ruteo que no pasan (arriba)."
    $fail++
  } else {
    Write-Host "  PASS: todas las skills esperadas se declararon."
  }
}

# ── Aviso de sesion desactualizada ────────────────────────────────────────
Write-Host ""
Write-Host "Recordatorio: V2 recarga config, agentes, skills y plugins al guardar."
Write-Host "Si no ves el cambio, reinicia la TUI o ejecuta: opencode service restart."

Write-Host ""
Write-Host "=" * 60
if ($fail -gt 0) {
  Write-Host "VERIFICACION FALLIDA: $fail comprobacion(es) con errores."
  exit 1
}
Write-Host "VERIFICACION OK: guardarrail, identidad global, plugins, doc drift y smokes en verde."
exit 0
