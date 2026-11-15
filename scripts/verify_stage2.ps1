param([string]$PackageOverrides)

$ErrorActionPreference = 'Stop'
& "$PSScriptRoot/verify_stage1.ps1" -PackageOverrides $PackageOverrides

$lakeOptions = @()
if ($PackageOverrides) {
  $path = (Resolve-Path -LiteralPath $PackageOverrides).Path
  $lakeOptions = @("--packages=$path")
}

Push-Location (Split-Path -Parent $PSScriptRoot)
try {
  Write-Output '[Stage 2] Checking the scalar branch and kernel axioms'
  $auditFile = 'scripts/AuditStage002.lean'
  if ((Get-Content -LiteralPath $auditFile -Raw) -match '(?m)\bsorry\b|\badmit\b|^\s*(axiom|constant)\b') {
    throw 'Unfinished proof or axiom declaration found in the Stage 2 audit'
  }
  $audit = & lake @lakeOptions env lean $auditFile
  $auditExit = $LASTEXITCODE
  $audit | Write-Output
  if ($auditExit -ne 0) { throw 'Stage 2 theorem audit failed' }
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
  Write-Output '[PASS] KLEINGORDON-002 verified'
} finally {
  Pop-Location
}
