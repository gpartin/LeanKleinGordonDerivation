param([string]$PackageOverrides)

$ErrorActionPreference = 'Stop'
$lakeOptions = @()
if ($PackageOverrides) {
  $path = (Resolve-Path -LiteralPath $PackageOverrides).Path
  $lakeOptions = @("--packages=$path")
}

Push-Location (Split-Path -Parent $PSScriptRoot)
try {
  Write-Output '[1/3] Building KLEINGORDON-001'
  & lake @lakeOptions --wfail build KleinGordonFormal
  if ($LASTEXITCODE -ne 0) { throw 'Lean build failed' }

  Write-Output '[2/3] Checking the promoted Lean sources'
  $files = @(Get-Item KleinGordonFormal.lean, scripts/AuditStage001.lean) +
    @(Get-ChildItem -Recurse -File -Filter '*.lean' KleinGordonFormal)
  $source = ($files | ForEach-Object { Get-Content -Raw $_.FullName }) -join "`n"
  if ($source -match '(?m)\bsorry\b|\badmit\b|^\s*(axiom|constant)\b') {
    throw 'Unfinished proof or axiom declaration found'
  }

  Write-Output '[3/3] Checking the Stage 1 theorems and kernel axioms'
  $audit = & lake @lakeOptions env lean scripts/AuditStage001.lean
  $auditExit = $LASTEXITCODE
  $audit | Write-Output
  if ($auditExit -ne 0) { throw 'Stage 1 theorem audit failed' }

  $reports = [regex]::Matches(($audit -join "`n"),
    '(?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)')
  if ($reports.Count -ne 3) { throw 'Expected three kernel axiom reports' }
  foreach ($report in $reports) {
    if (!$report.Groups[1].Success) { continue }
    foreach ($name in $report.Groups[1].Value.Split(',')) {
      if ($name.Trim() -notin @('propext', 'Classical.choice', 'Quot.sound')) {
        throw "Unexpected kernel axiom: $name"
      }
    }
  }
  Write-Output '[PASS] KLEINGORDON-001 verified'
} finally {
  Pop-Location
}
