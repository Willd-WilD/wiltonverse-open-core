# Wiltonverse - compile_pack.ps1
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$EvidenceDir = Join-Path $Root "08_evidence"
$LogDir = Join-Path $Root "09_logs"
New-Item -ItemType Directory -Force -Path $EvidenceDir | Out-Null
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$Required = @(
    "00_manifest/canonical_manifest.yaml",
    "01_state/system_state_latest.yaml",
    "01_state/changelog.yaml",
    "02_governance/governance_rules.yaml",
    "02_governance/truth_policy.yaml",
    "02_governance/evidence_policy.yaml",
    "03_registry/module_registry.yaml",
    "04_runtime/runtime_config.yaml",
    "05_benchmarks/benchmark_suite.yaml",
    "06_operator/operator_profile.yaml",
    "07_export/latest_state_summary.md",
    "07_export/reproduction_instructions.md",
    "07_export/known_limitations.md"
)

$Hashes = @()
$Missing = @()

foreach ($Rel in $Required) {
    $Full = Join-Path $Root $Rel
    if (!(Test-Path $Full)) {
        $Missing += $Rel
    } else {
        $Hash = (Get-FileHash -Algorithm SHA256 -Path $Full).Hash.ToLower()
        $Hashes += [ordered]@{ path = $Rel; sha256 = $Hash }
    }
}

if ($Missing.Count -gt 0) {
    throw "Missing required artifacts: $($Missing -join ', ')"
}

$HashFile = Join-Path $EvidenceDir "hash_inventory.txt"
$Hashes | ForEach-Object { "$($_.path)=$($_.sha256)" } | Set-Content -Path $HashFile -Encoding UTF8

$Report = [ordered]@{
    ts_utc = (Get-Date).ToUniversalTime().ToString("o")
    required_artifact_count = $Required.Count
    missing = @()
    hash_inventory = "08_evidence/hash_inventory.txt"
    verdict = "PASS"
}
$Report | ConvertTo-Json -Depth 6 | Set-Content -Path (Join-Path $EvidenceDir "compile_report.json") -Encoding UTF8
"compile_pack.ps1 PASS at $(Get-Date -Format o)" | Set-Content -Path (Join-Path $LogDir "compile.log") -Encoding UTF8

Write-Host "Compile completed successfully." -ForegroundColor Green
