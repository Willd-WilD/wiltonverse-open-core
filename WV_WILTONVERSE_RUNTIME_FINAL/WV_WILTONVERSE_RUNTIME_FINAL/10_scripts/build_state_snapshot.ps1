# Wiltonverse - build_state_snapshot.ps1
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$EvidenceDir = Join-Path $Root "08_evidence"
New-Item -ItemType Directory -Force -Path $EvidenceDir | Out-Null

$Manifest = Join-Path $Root "00_manifest/canonical_manifest.yaml"
$State = Join-Path $Root "01_state/system_state_latest.yaml"
$Registry = Join-Path $Root "03_registry/module_registry.yaml"
$Governance = Join-Path $Root "02_governance/governance_rules.yaml"

foreach ($File in @($Manifest,$State,$Registry,$Governance)) {
    if (!(Test-Path $File)) { throw "Missing required file for snapshot: $File" }
}

$Snapshot = [ordered]@{
    ts_utc = (Get-Date).ToUniversalTime().ToString("o")
    manifest_hash = (Get-FileHash -Algorithm SHA256 -Path $Manifest).Hash.ToLower()
    state_hash = (Get-FileHash -Algorithm SHA256 -Path $State).Hash.ToLower()
    registry_hash = (Get-FileHash -Algorithm SHA256 -Path $Registry).Hash.ToLower()
    governance_hash = (Get-FileHash -Algorithm SHA256 -Path $Governance).Hash.ToLower()
    truth_state = "DECLARED"
    note = "Local state snapshot generated from canonical files"
}
$SnapshotPath = Join-Path $EvidenceDir "state_snapshot.json"
$Snapshot | ConvertTo-Json -Depth 6 | Set-Content -Path $SnapshotPath -Encoding UTF8
Write-Host "State snapshot written to $SnapshotPath" -ForegroundColor Green
