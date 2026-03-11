# Wiltonverse - run_benchmark.ps1
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$EvidenceDir = Join-Path $Root "08_evidence"
$DocsDir = Join-Path $Root "11_docs"
New-Item -ItemType Directory -Force -Path $EvidenceDir | Out-Null
New-Item -ItemType Directory -Force -Path $DocsDir | Out-Null

function Has-Text {
    param([string]$Path, [string]$Pattern)
    if (!(Test-Path $Path)) { return $false }
    return ((Select-String -Path $Path -Pattern $Pattern -SimpleMatch | Measure-Object).Count -ge 1)
}

$Checks = @(
    @{ id = "B001"; name = "Required Artifact Presence"; pass = (Test-Path (Join-Path $Root "00_manifest/canonical_manifest.yaml")) -and (Test-Path (Join-Path $Root "03_registry/module_registry.yaml")) },
    @{ id = "B002"; name = "Truth-State Coverage"; pass = (Has-Text (Join-Path $Root "03_registry/module_registry.yaml") "truth_state") -and (Has-Text (Join-Path $Root "01_state/system_state_latest.yaml") "truth_state") },
    @{ id = "B003"; name = "Governance Rule Presence"; pass = (Has-Text (Join-Path $Root "02_governance/governance_rules.yaml") "hard_rules") -and (Has-Text (Join-Path $Root "02_governance/governance_rules.yaml") "rollback_guard") },
    @{ id = "B004"; name = "Runtime Log Emission"; pass = (Test-Path (Join-Path $Root "09_logs/heartbeat_log.jsonl")) },
    @{ id = "B005"; name = "Portable Pack Readiness"; pass = (Test-Path (Join-Path $Root "07_export/latest_state_summary.md")) -and (Test-Path (Join-Path $Root "07_export/reproduction_instructions.md")) -and (Test-Path (Join-Path $Root "07_export/known_limitations.md")) },
    @{ id = "B006"; name = "State Snapshot Presence"; pass = (Test-Path (Join-Path $Root "08_evidence/state_snapshot.json")) },
    @{ id = "B007"; name = "Environment Check Presence"; pass = (Test-Path (Join-Path $Root "08_evidence/environment_check_report.json")) },
    @{ id = "B008"; name = "Hash Inventory Presence"; pass = (Test-Path (Join-Path $Root "08_evidence/hash_inventory.txt")) }
)

$Passed = ($Checks | Where-Object { $_.pass }).Count
$Score = if ($Checks.Count -eq 0) { 0 } else { [math]::Round(($Passed / $Checks.Count) * 100, 2) }

$Results = [ordered]@{
    ts_utc = (Get-Date).ToUniversalTime().ToString("o")
    total = $Checks.Count
    passed = $Passed
    score_pct = $Score
    checks = $Checks
}
$OutJson = Join-Path $EvidenceDir "benchmark_results.json"
$OutMd = Join-Path $DocsDir "benchmark_summary.md"

$Results | ConvertTo-Json -Depth 8 | Set-Content -Path $OutJson -Encoding UTF8
"# Benchmark Summary`n`nScore: $Score%`n" | Set-Content -Path $OutMd -Encoding UTF8
foreach ($Check in $Checks) {
    $flag = if ($Check.pass) { "PASS" } else { "FAIL" }
    "- [$flag] $($Check.id) :: $($Check.name)" | Add-Content -Path $OutMd
}

Write-Host "Benchmark completed successfully." -ForegroundColor Green
