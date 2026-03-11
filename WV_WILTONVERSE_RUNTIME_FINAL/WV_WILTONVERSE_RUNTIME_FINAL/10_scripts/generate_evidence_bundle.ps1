# Wiltonverse - generate_evidence_bundle.ps1
$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression.FileSystem
$Root = Split-Path -Parent $PSScriptRoot
$EvidenceDir = Join-Path $Root "08_evidence"
$BundleTemp = Join-Path $EvidenceDir "evidence_bundle_tmp"
$BundlePath = Join-Path $EvidenceDir "evidence_bundle.zip"

$Required = @(
    "08_evidence/environment_check_report.json",
    "08_evidence/hash_inventory.txt",
    "08_evidence/compile_report.json",
    "08_evidence/state_snapshot.json",
    "08_evidence/benchmark_results.json",
    "08_evidence/verification_report.json",
    "09_logs/heartbeat_log.jsonl",
    "09_logs/runtime_event_log.jsonl"
)
foreach ($Rel in $Required) {
    if (!(Test-Path (Join-Path $Root $Rel))) {
        throw "Missing evidence artifact: $Rel"
    }
}

if (Test-Path $BundleTemp) { Remove-Item $BundleTemp -Recurse -Force }
if (Test-Path $BundlePath) { Remove-Item $BundlePath -Force }

New-Item -ItemType Directory -Force -Path $BundleTemp | Out-Null
foreach ($Rel in $Required) {
    $Source = Join-Path $Root $Rel
    $Target = Join-Path $BundleTemp $Rel
    $TargetDir = Split-Path -Parent $Target
    New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
    Copy-Item $Source $Target -Force
}

[System.IO.Compression.ZipFile]::CreateFromDirectory($BundleTemp, $BundlePath)
$BundleHash = (Get-FileHash -Algorithm SHA256 -Path $BundlePath).Hash.ToLower()

$Report = [ordered]@{
    bundle_created_at_utc = (Get-Date).ToUniversalTime().ToString("o")
    included_items = $Required
    bundle_hash = $BundleHash
    verdict = "PASS"
}
$Report | ConvertTo-Json -Depth 8 | Set-Content -Path (Join-Path $EvidenceDir "evidence_bundle_report.json") -Encoding UTF8
Write-Host "Evidence bundle created: $BundlePath" -ForegroundColor Green
