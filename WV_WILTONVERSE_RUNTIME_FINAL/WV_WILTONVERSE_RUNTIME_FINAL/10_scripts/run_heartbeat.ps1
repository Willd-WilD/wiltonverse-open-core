# Wiltonverse - run_heartbeat.ps1
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$LogDir = Join-Path $Root "09_logs"
$EvidenceDir = Join-Path $Root "08_evidence"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
New-Item -ItemType Directory -Force -Path $EvidenceDir | Out-Null

$StateFile = Join-Path $Root "01_state/system_state_latest.yaml"
if (!(Test-Path $StateFile)) { throw "Missing state file: $StateFile" }

$StateHash = (Get-FileHash -Algorithm SHA256 -Path $StateFile).Hash.ToLower()
$HeartbeatPath = Join-Path $LogDir "heartbeat_log.jsonl"
$RuntimePath = Join-Path $LogDir "runtime_event_log.jsonl"

$Event = [ordered]@{
    ts_utc = (Get-Date).ToUniversalTime().ToString("o")
    event = "heartbeat"
    state_file = "01_state/system_state_latest.yaml"
    state_hash = $StateHash
    truth_state = "DECLARED"
}
($Event | ConvertTo-Json -Compress) | Add-Content -Path $HeartbeatPath -Encoding UTF8
($Event | ConvertTo-Json -Compress) | Add-Content -Path $RuntimePath -Encoding UTF8

if (!(Test-Path (Join-Path $EvidenceDir "state_snapshot.json"))) {
    & (Join-Path $PSScriptRoot "build_state_snapshot.ps1")
}

Write-Host "Heartbeat emitted successfully." -ForegroundColor Green
