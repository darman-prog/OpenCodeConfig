# smoke-routing.ps1 — Verifica en runtime que cada prompt gatilla la skill esperada.
#
# Uso: .\scripts\smoke-routing.ps1 [-Model opencode-go/deepseek-v4.1-flash] [-Frontend] [-Skill "frontend-*"] [-Changed]
# Cada caso corre `opencode run` una vez (modelo barato) y exige que la skill
# esperada aparezca entre las declaradas. Exit 0 = todo PASS; exit 1 = hay FAILs.
# Los casos espejan los gatillos de scripts/trigger-probes.json (verificacion estatica).

param(
  [string]$Model = "opencode-go/deepseek-v4.1-flash",
  [string]$Skill = "",
  [switch]$Frontend,
  [switch]$Changed
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot

# Atajo: las tres skills de frontend y sus 6 smokes.
if ($Frontend -and -not $Skill) { $Skill = 'frontend-*' }

# Deriva las skills tocadas desde git. Devuelve un modo explicito para distinguir
# "sin cambios" (0 casos) de "cambio de ruteo" (matriz completa).
function Get-ChangedSkills {
  $full = @{ mode = 'full'; skills = @() }
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) { return $full }
  $root = git -C $Root rev-parse --show-toplevel 2>$null
  if ($LASTEXITCODE -ne 0 -or -not $root) { return $full }

  $files = @()
  $files += git -C $Root diff --name-only 2>$null
  if ($LASTEXITCODE -ne 0) { return $full }
  $files += git -C $Root diff --name-only --cached 2>$null
  if ($LASTEXITCODE -ne 0) { return $full }
  $files += git -C $Root ls-files --others --exclude-standard 2>$null
  if ($LASTEXITCODE -ne 0) { return $full }

  $files = @($files | Where-Object { $_ } | ForEach-Object { $_ -replace '\\', '/' } | Sort-Object -Unique)
  if ($files.Count -eq 0) { return @{ mode = 'none'; skills = @() } }

  # Un cambio en la tabla, los agentes o los scripts de ruteo invalida el filtro.
  if ($files | Where-Object { $_ -match '^(OPENCODE\.md|scripts/(trigger-probes\.json|smoke-routing\.ps1|verify\.ps1)$|\.opencode/agents/)' }) {
    return $full
  }

  return @{
    mode = 'skills'
    skills = @($files | ForEach-Object {
      $m = [regex]::Match($_, '^\.opencode/skills/([^/]+)/')
      if ($m.Success) { $m.Groups[1].Value }
    } | Sort-Object -Unique)
  }
}

$cases = @(
  @{ prompt = "analiza este CSV y resume sus métricas";              skill = "analisis-datos" },
  @{ prompt = "automatiza estas tareas repetitivas con un script";   skill = "automatizacion" },
  @{ prompt = "quiero usar Notion en este proyecto";                 skill = "activacion-mcp" },
  @{ prompt = "define un MVP y ordena el roadmap";                   skill = "criterio-proyecto" },
  @{ prompt = "necesito un plan tecnico con dependencias y riesgos"; skill = "ingenieria-software" },
  @{ prompt = "resume este texto en 3 bullets para ahorrar tokens";  skill = "uso-eficiente" },
  @{ prompt = "mide la experiencia de usuario con SUS y UMUX-Lite";  skill = "evaluacion-experiencia" },
  @{ prompt = "retomar un cambio auditable en docs/features";    skill = "documentacion" },
  @{ prompt = "necesito correr los tests unitarios";                 skill = "testing" },
  @{ prompt = "disena un formulario de registro moderno y accesible"; skill = "frontend-build" },
  # Ruteo UI por intencion: crear no debe cargar el veredicto; revisar y ajustar tienen skills distintas.
  @{ prompt = "crea una landing para un producto SaaS"; skill = "frontend-build"; notSkill = @("frontend-design-review") },
  @{ prompt = "revisa el diseno de esta pantalla contra el design system"; skill = "frontend-design-review" },
  @{ prompt = "ajusta el espaciado de un boton existente"; skill = "frontend-build" },
  @{ prompt = "define la direccion visual de una UI nueva"; skill = "frontend-direction" },
  @{ prompt = "construye una pantalla usando tokens y primitivas"; skill = "frontend-build" },
  # Casos adyacentes: el prompt roza otra skill; debe declarar la correcta, no la evidentemente cercana.
  @{ prompt = "revisa la calidad del codigo de este modulo";       skill = "code-quality" },
  @{ prompt = "refactoriza este modulo con logica duplicada";      skill = "refactoring" },
  @{ prompt = "arregla este fallo intermitente de la API";          skill = "debugging" },
  @{ prompt = "escribe un README de este modulo";                  skill = "documentacion" },
  @{ prompt = "actualiza el indice del project-brain";              skill = "contexto-proyecto" },
  @{ prompt = "aplica TDD a este modulo nuevo";                    skill = "tdd" }
)

# -Skill/-Frontend tienen prioridad; -Changed solo se usa sin filtro explicito.
$changed = $null
if (-not $Skill -and $Changed) { $changed = Get-ChangedSkills }
if ($Skill) {
  $filters = @($Skill -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
  $cases = @($cases | Where-Object { $case = $_; @($filters | Where-Object { $case.skill -like $_ }).Count -gt 0 })
  Write-Host "Filtro -Skill: $($filters -join ', ')"
} elseif ($Changed -and $changed.mode -eq 'skills') {
  $cases = @($cases | Where-Object { $changed.skills -contains $_.skill })
  Write-Host "Filtro -Changed: $($changed.skills -join ', ')"
} elseif ($Changed -and $changed.mode -eq 'none') {
  $cases = @()
  Write-Host "Filtro -Changed: sin cambios; 0 casos."
} elseif ($Changed) {
  Write-Host "Filtro -Changed: cambio de ruteo o git no disponible; matriz completa."
}

if ($cases.Count -eq 0) {
  Write-Host "Smokes de ruteo: 0 casos (filtro sin coincidencias)."
  exit 0
}

$pass = 0
$fail = @()

foreach ($c in $cases) {
  $q = 'Reply with just the skill name(s) you would load for: ' + $c.prompt
  Write-Host "`n[CASO] $($c.skill): $($c.prompt)"
  # El shim npm de opencode es un .ps1 que escribe errores de PowerShell en stderr;
  # con $ErrorActionPreference = "Stop" eso terminaria la llamada: se baja a Continue solo aqui.
  $prevEAP = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  # Solo stdout cuenta para el PASS: un error por stderr que mencione la skill
  #eria un falso PASS. La llamada directa (no Start-Process) es la que funciona
  #con el shim .ps1 de npm en Windows.
  $out = ""
  # El gateway puede rechazar por capacidad; eso no es un fallo de ruteo.
  for ($attempt = 1; $attempt -le 5; $attempt++) {
    $outFile = Join-Path $env:TEMP ("smoke-out-" + [guid]::NewGuid().ToString("N") + ".txt")
    $errFile = "$outFile.err"
    try {
      & opencode run --model $Model $q 1> $outFile 2> $errFile
      $out = if (Test-Path -LiteralPath $outFile) { Get-Content -LiteralPath $outFile -Raw } else { "" }
    } catch {
      $out = ""
    } finally {
      Remove-Item -LiteralPath $outFile, $errFile -Force -ErrorAction SilentlyContinue
    }
    # El modelo barato varia: se reintenta una salida vacia, un error de capacidad
    # o una seleccion incompleta. Un fallo sistematico sigue fallando tras 5 intentos.
    $attemptOk = $out -and ($out -match [regex]::Escape($c.skill))
    if ($attemptOk -and $c.ContainsKey('notSkill')) {
      foreach ($n in @($c.notSkill)) {
        if ($out -match [regex]::Escape($n)) { $attemptOk = $false }
      }
    }
    if ($attemptOk -and $out -notmatch 'cell is at capacity|Upstream request failed') { break }
    if ($attempt -lt 5) { Start-Sleep -Seconds 5 }
  }
  # El nombre de la skill debe aparecer entre las declaradas (acepta backticks y coma).
  if ($out -match [regex]::Escape($c.skill)) {
    # La no-activacion tambien es contrato: crear UI no debe cargar el veredicto de review.
    $forbidden = @()
    if ($c.ContainsKey('notSkill')) {
      foreach ($n in @($c.notSkill)) {
        if ($out -match [regex]::Escape($n)) { $forbidden += $n }
      }
    }
    if ($forbidden.Count -eq 0) {
      Write-Host "  PASS ($($c.skill) declarado)"
      $pass++
    } else {
      Write-Host "  FAIL (no esperado: $($forbidden -join ', '))"
      $fail += "$($c.skill) + $($forbidden -join ', ')"
    }
  } else {
    Write-Host "  FAIL (esperado: $($c.skill))"
    $fail += $c.skill
  }
  $ErrorActionPreference = $prevEAP
}

Write-Host ""
Write-Host "Smokes de ruteo: $pass/$($cases.Count) PASS"
if ($fail.Count -gt 0) {
  Write-Host "FAIL en: $($fail -join ', ')"
  exit 1
}
Write-Host "OK: todas las skills esperadas se declararon."
