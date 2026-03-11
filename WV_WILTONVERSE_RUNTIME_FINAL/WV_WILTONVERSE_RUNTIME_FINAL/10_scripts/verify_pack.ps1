# Wiltonverse - verify_pack.ps1
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$EvidenceDir = Join-Path $Root "08_evidence"
$LogDir = Join-Path $Root "09_logs"
New-Item -ItemType Directory -Force -Path $EvidenceDir | Out-Null
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$Required = @(
    "00_manifest/canonical_manifest.yaml",
    "01_state/system_state_latest.yaml",
    "02_governance/governance_rules.yaml",
    "02_governance/truth_policy.yaml",
    "02_governance/evidence_policy.yaml",
    "03_registry/module_registry.yaml",
    "08_evidence/hash_inventory.txt",
    "08_evidence/state_snapshot.json"
)

$Missing = @()
foreach ($Rel in $Required) {
    if (!(Test-Path (Join-Path $Root $Rel))) { $Missing += $Rel }
}

$Integrity = @()
$HashInventoryPath = Join-Path $Root "08_evidence/hash_inventory.txt"
if (Test-Path $HashInventoryPath) {
    $Lines = Get-Content $HashInventoryPath
    foreach ($Line in $Lines) {
        if ($Line -match "^(.*)=(.*)$") {
            $RelPath = $Matches[1]
            $Expected = $Matches[2]
            $Full = Join-Path $Root $RelPath
            if (Test-Path $Full) {
                $Actual = (Get-FileHash -Algorithm SHA256 -Path $Full).Hash.ToLower()
                $Integrity += [ordered]@{
                    path = $RelPath
                    expected = $Expected
                    actual = $Actual
                    match = ($Expected -eq $Actual)
                }
            } else {
                $Integrity += [ordered]@{
                    path = $RelPath
                    expected = $Expected
                    actual = $null
                    match = $false
                }
            }
        }
    }
}

$IntegrityFail = ($Integrity | Where-Object { -not $_.match }).Count
$Verdict = if (($Missing.Count -eq 0) -and ($IntegrityFail -eq 0)) { "PASS" } else { "FAIL" }

$Report = [ordered]@{
    ts_utc = (Get-Date).ToUniversalTime().ToString("o")
    required_files_present = ($Missing.Count -eq 0)
    missing = $Missing
    hash_inventory_exists = (Test-Path $HashInventoryPath)
    integrity_checks = $Integrity
    verdict = $Verdict
}

$ReportPath = Join-Path $EvidenceDir "verification_report.json"
$Report | ConvertTo-Json -Depth 8 | Set-Content -Path $ReportPath -Encoding UTF8
"verify_pack.ps1 $Verdict at $(Get-Date -Format o)" | Set-Content -Path (Join-Path $LogDir "verify.log") -Encoding UTF8

if ($Verdict -ne "PASS") { throw "Verification failed. Review 08_evidence/verification_report.json" }
Write-Host "Verification passed." -ForegroundColor Green
