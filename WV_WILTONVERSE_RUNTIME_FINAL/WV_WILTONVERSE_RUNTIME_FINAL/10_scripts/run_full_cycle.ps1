# Wiltonverse - run_full_cycle.ps1
$ErrorActionPreference = "Stop"
$ScriptDir = $PSScriptRoot

& (Join-Path $ScriptDir "check_environment.ps1")
& (Join-Path $ScriptDir "compile_pack.ps1")
& (Join-Path $ScriptDir "build_state_snapshot.ps1")
& (Join-Path $ScriptDir "run_heartbeat.ps1")
& (Join-Path $ScriptDir "run_benchmark.ps1")
& (Join-Path $ScriptDir "verify_pack.ps1")
& (Join-Path $ScriptDir "generate_evidence_bundle.ps1")

Write-Host "Full local execution cycle completed successfully." -ForegroundColor Green
