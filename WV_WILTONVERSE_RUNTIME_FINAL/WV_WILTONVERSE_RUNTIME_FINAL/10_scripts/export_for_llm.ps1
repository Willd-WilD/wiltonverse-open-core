# Wiltonverse - export_for_llm.ps1
$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression.FileSystem

$Root = Split-Path -Parent $PSScriptRoot
$ExportDir = Join-Path $Root "07_export"
$ZipPath = Join-Path $ExportDir "llm_portable_pack.zip"
$TempDir = Join-Path $ExportDir "llm_portable_pack"

$Required = @(
    "00_manifest",
    "01_state",
    "02_governance",
    "03_registry",
    "04_runtime",
    "05_benchmarks",
    "06_operator",
    "07_export/latest_state_summary.md",
    "07_export/reproduction_instructions.md",
    "07_export/known_limitations.md",
    "10_scripts",
    "11_docs"
)
foreach ($Rel in $Required) {
    if (!(Test-Path (Join-Path $Root $Rel))) { throw "Missing export item: $Rel" }
}

if (Test-Path $TempDir) { Remove-Item $TempDir -Recurse -Force }
if (Test-Path $ZipPath) { Remove-Item $ZipPath -Force }
New-Item -ItemType Directory -Force -Path $TempDir | Out-Null

foreach ($Rel in $Required) {
    $Source = Join-Path $Root $Rel
    $Target = Join-Path $TempDir $Rel
    if ((Get-Item $Source) -is [System.IO.DirectoryInfo]) {
        Copy-Item $Source -Destination $Target -Recurse -Force
    } else {
        $Parent = Split-Path -Parent $Target
        New-Item -ItemType Directory -Force -Path $Parent | Out-Null
        Copy-Item $Source -Destination $Target -Force
    }
}

[System.IO.Compression.ZipFile]::CreateFromDirectory($TempDir, $ZipPath)
Write-Host "Portable LLM pack created: $ZipPath" -ForegroundColor Green
