param([string]$PackageOverrides)

$ErrorActionPreference = 'Stop'
& "$PSScriptRoot/verify_stage5.ps1" -PackageOverrides $PackageOverrides

$lakeOptions = @()
if ($PackageOverrides) {
  $path = (Resolve-Path -LiteralPath $PackageOverrides).Path
  $lakeOptions = @("--packages=$path")
}

Push-Location (Split-Path -Parent $PSScriptRoot)
try {
  Write-Output '[Stage 6] Checking the mass-zero specialization and the zero-chi lattice response and kernel axioms'
  $auditFile = 'scripts/AuditStage006.lean'
  if ((Get-Content -LiteralPath $auditFile -Raw) -match '(?m)\bsorry\b|\badmit\b|^\s*(axiom|constant)\b') {
    throw 'Unfinished proof or axiom declaration found in the Stage 6 audit'
  }
  $audit = & lake @lakeOptions env lean $auditFile
  $auditExit = $LASTEXITCODE
  $audit | Write-Output
  if ($auditExit -ne 0) { throw 'Stage 6 theorem audit failed' }
  $reports = [regex]::Matches(($audit -join "`n"),
    '(?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)')
  if ($reports.Count -ne 4) { throw 'Expected four kernel axiom reports' }
  foreach ($report in $reports) {
    if (!$report.Groups[1].Success) { continue }
    foreach ($name in $report.Groups[1].Value.Split(',')) {
      if ($name.Trim() -notin @('propext', 'Classical.choice', 'Quot.sound')) {
        throw "Unexpected kernel axiom: $name"
      }
    }
  }
  Write-Output '[PASS] KLEINGORDON-006 verified'
} finally {
  Pop-Location
}
