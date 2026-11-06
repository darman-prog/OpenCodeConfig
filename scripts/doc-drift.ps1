<#
.SYNOPSIS
  Detecta deriva documental: metadata incompleta, enlaces rotos, ADR reemplazados y cifras viejas.

.DESCRIPTION
  Sin -Strict informa WARN/FAIL y sale con 0; con -Strict falla si hay cualquier aviso.
  Solo revisa documentos vigentes clave, no el historico ni las tarjetas cerradas.
#>
param(
    [switch]$Strict,
    [string]$Root = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = "Stop"
$issues = @()
function AddIssue($level, $message) {
    $script:issues += [pscustomobject]@{ Level = $level; Message = $message }
}

$docs = @(
    @{ Path = 'docs\project-brain\NAVIGATION.md'; Name = 'NAVIGATION.md' },
    @{ Path = 'docs\project-brain\ARCHITECTURE.md'; Name = 'ARCHITECTURE.md' },
    @{ Path = 'docs\harness\estado-actual.md'; Name = 'estado-actual.md' },
    @{ Path = 'docs\harness\presupuestos.md'; Name = 'presupuestos.md' },
    @{ Path = 'docs\harness\pipeline.md'; Name = 'pipeline.md' },
    @{ Path = 'docs\harness\pipeline-referencia.md'; Name = 'pipeline-referencia.md' },
    @{ Path = 'docs\harness\perfiles.md'; Name = 'perfiles.md' }
)
$allowedStatus = @('vigente', 'pendiente', 'obsoleto', 'en_revision')
$allowedConfidence = @('confirmado', 'supuesto', 'inferido')

# Lee solo el frontmatter delimitado por las dos primeras lineas '---'.
function Read-Frontmatter($path) {
    $lines = Get-Content -LiteralPath $path
    if ($lines.Count -lt 3 -or $lines[0] -notmatch '^\s*---\s*$') { return $null }
    $fm = @{}
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^\s*---\s*$') { return $fm }
        if ($lines[$i] -match '^([A-Za-z_]+):\s*(.*)$') {
            $fm[$Matches[1]] = $Matches[2].Trim()
        }
    }
    return $null
}

foreach ($doc in $docs) {
    $full = Join-Path $Root $doc.Path
    if (-not (Test-Path -LiteralPath $full)) {
        AddIssue 'FAIL' "falta $($doc.Path)"
        continue
    }
    $fm = Read-Frontmatter $full
    if ($null -eq $fm) {
        AddIssue 'FAIL' "$($doc.Name): frontmatter ausente o sin cierre"
        continue
    }
    foreach ($key in @('status', 'last_reviewed', 'confidence', 'source')) {
        if (-not $fm.ContainsKey($key) -or [string]::IsNullOrWhiteSpace($fm[$key])) {
            AddIssue 'FAIL' "$($doc.Name): falta '$key'"
        }
    }
    if ($fm.ContainsKey('status') -and $fm['status'] -notin $allowedStatus) {
        AddIssue 'FAIL' "$($doc.Name): status invalido '$($fm['status'])'"
    }
    if ($fm.ContainsKey('confidence') -and $fm['confidence'] -notin $allowedConfidence) {
        AddIssue 'FAIL' "$($doc.Name): confidence invalido '$($fm['confidence'])'"
    }
    if ($fm.ContainsKey('last_reviewed')) {
        try {
            $reviewed = [datetime]::ParseExact($fm['last_reviewed'], 'yyyy-MM-dd', $null)
            if ($reviewed -gt (Get-Date).Date) { AddIssue 'WARN' "$($doc.Name): last_reviewed futuro" }
        } catch {
            AddIssue 'FAIL' "$($doc.Name): last_reviewed invalido '$($fm['last_reviewed'])'"
        }
    }
}

# Enlaces relativos del mapa: si apuntan a un archivo/carpeta inexistente, el mapa miente.
$navPath = Join-Path $Root 'docs\project-brain\NAVIGATION.md'
if (Test-Path -LiteralPath $navPath) {
    $navRaw = Get-Content -LiteralPath $navPath -Raw
    foreach ($m in [regex]::Matches($navRaw, '\[[^\]]+\]\(([^)#]+)(?:#[^)]*)?\)')) {
        $target = $m.Groups[1].Value.Trim()
        if ($target -match '^(https?:|mailto:)') { continue }
        $targetPath = Join-Path (Split-Path -Parent $navPath) $target
        if (-not (Test-Path -LiteralPath $targetPath)) {
            AddIssue 'FAIL' "NAVIGATION.md: enlace roto '$target'"
        }
    }
}

# Un ADR reemplazado no puede seguir como 'vigente' en el mapa ni en el indice.
$adrDir = Join-Path $Root 'docs\adr'
if (Test-Path -LiteralPath $adrDir) {
    foreach ($adr in @(Get-ChildItem -LiteralPath $adrDir -Filter '*.md' -File)) {
        $adrText = Get-Content -LiteralPath $adr.FullName -Raw
        $replacement = [regex]::Match($adrText, 'reemplazado por \[ADR-(\d+)\]')
        if (-not $replacement.Success) { continue }
        # El ADR que importa es el del archivo; el reemplazo solo dispara la revision.
        $sourceId = [regex]::Match($adr.Name, '^(\d+)').Groups[1].Value
        foreach ($indexPath in @('docs\project-brain\NAVIGATION.md', 'docs\features\INDEX.md')) {
            $indexFull = Join-Path $Root $indexPath
            if (-not (Test-Path -LiteralPath $indexFull)) { continue }
            $badLine = Get-Content -LiteralPath $indexFull |
                Where-Object { $_ -match "ADR-0*$sourceId" -and $_ -match '\|\s*vigente\s*\|' } |
                Select-Object -First 1
            if ($badLine) {
                AddIssue 'FAIL' "${indexPath}: ADR-$sourceId esta reemplazado pero figura vigente"
            }
        }
    }
}

# Las cifras de estado-actual deben salir del repo, no de la memoria.
$estadoPath = Join-Path $Root 'docs\harness\estado-actual.md'
if (Test-Path -LiteralPath $estadoPath) {
    $estado = Get-Content -LiteralPath $estadoPath -Raw
    $agentFiles = @(Get-ChildItem -LiteralPath (Join-Path $Root '.opencode\agents') -Filter '*.md' -File)
    $agentLines = ($agentFiles | ForEach-Object { (Get-Content -LiteralPath $_.FullName).Count } | Measure-Object -Sum).Sum
    $actual = @{
        OpenCode   = (Get-Content -LiteralPath (Join-Path $Root 'OPENCODE.md')).Count
        Agents     = (Get-Content -LiteralPath (Join-Path $Root 'AGENTS.md')).Count
        AgentCount = $agentFiles.Count
        AgentLines = $agentLines
        Skills     = @(Get-ChildItem -LiteralPath (Join-Path $Root '.opencode\skills') -Recurse -Filter 'SKILL.md' -File).Count
    }
    $checks = @(
        @{ Label = 'OPENCODE.md'; Pattern = '\|\s*`OPENCODE\.md`\s*\|\s*(\d+)\s*l'; Value = $actual.OpenCode },
        @{ Label = 'AGENTS.md'; Pattern = '\|\s*`AGENTS\.md`[^|]*\|\s*(\d+)\s*l'; Value = $actual.Agents },
        @{ Label = 'Agentes (archivos)'; Pattern = '\|\s*Agentes\s*\|\s*(\d+)\s+archivos'; Value = $actual.AgentCount },
        @{ Label = 'Agentes (lineas)'; Pattern = '\|\s*Agentes\s*\|[^|]*?\s(\d+)\s+l'; Value = $actual.AgentLines },
        @{ Label = 'Skills'; Pattern = '\|\s*Skills\s*\|\s*(\d+)'; Value = $actual.Skills }
    )
    foreach ($check in $checks) {
        $m = [regex]::Match($estado, $check.Pattern)
        if (-not $m.Success) {
            AddIssue 'WARN' "estado-actual.md: no se encontro la cifra de $($check.Label)"
        } elseif ([int]$m.Groups[1].Value -ne [int]$check.Value) {
            AddIssue 'FAIL' "estado-actual.md: $($check.Label) dice $($m.Groups[1].Value), el repo tiene $($check.Value)"
        }
    }
}

if ($issues.Count -eq 0) {
    Write-Host "DOC DRIFT OK: metadata, enlaces, ADR y cifras vigentes"
    exit 0
}

foreach ($issue in $issues) {
    Write-Host "$($issue.Level): $($issue.Message)"
}
if ($Strict) { exit 1 }
exit 0
