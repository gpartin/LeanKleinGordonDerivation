param([string]$PackageOverrides)

$ErrorActionPreference = 'Stop'
& "$PSScriptRoot/verify_stage3.ps1" -PackageOverrides $PackageOverrides

$lakeOptions = @()
if ($PackageOverrides) {
  $path = (Resolve-Path -LiteralPath $PackageOverrides).Path
  $lakeOptions = @("--packages=$path")
}

Push-Location (Split-Path -Parent $PSScriptRoot)
try {
  Write-Output '[Stage 4] Checking the continuum readout and kernel axioms'
  $auditFile = 'scripts/AuditStage004.lean'
  if ((Get-Content -LiteralPath $auditFile -Raw) -match '(?m)\bsorry\b|\badmit\b|^\s*(axiom|constant)\b') {
    throw 'Unfinished proof or axiom declaration found in the Stage 4 audit'
  }
  $audit = & lake @lakeOptions env lean $auditFile
  $auditExit = $LASTEXITCODE
  $audit | Write-Output
  if ($auditExit -ne 0) { throw 'Stage 4 theorem audit failed' }
  $reports = [regex]::Matches(($audit -join "`n"),
    '(?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)')
  if ($reports.Count -ne 5) { throw 'Expected five kernel axiom reports' }
  foreach ($report in $reports) {
    if (!$report.Groups[1].Success) { continue }
    foreach ($name in $report.Groups[1].Value.Split(',')) {
      if ($name.Trim() -notin @('propext', 'Classical.choice', 'Quot.sound')) {
        throw "Unexpected kernel axiom: $name"
      }
    }
  }
  Write-Output '[PASS] KLEINGORDON-004 verified'
} finally {
  Pop-Location
}
