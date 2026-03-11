# WiltonVerse - check_environment.ps1
# Run this FIRST before any other script.
# It verifies your machine is ready to execute the runtime pack.
# No files are created or modified. Read-only verification only.

$ErrorActionPreference = "Continue"
$Root = Split-Path -Parent $PSScriptRoot
$Pass = 0
$Fail = 0
$Results = @()

function Check {
    param([string]$Label, [bool]$Result, [string]$Fix)
    if ($Result) {
        Write-Host "  [OK]  $Label" -ForegroundColor Green
        $script:Pass++
    } else {
        Write-Host "  [!!]  $Label" -ForegroundColor Red
        Write-Host "        FIX: $Fix" -ForegroundColor Yellow
        $script:Fail++
    }
    $script:Results += [ordered]@{ check = $Label; pass = $Result; fix = $Fix }
}

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "  WiltonVerse - Environment Check" -ForegroundColor Cyan
Write-Host "  $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

# --- PowerShell Version ---
Write-Host "[ PowerShell ]" -ForegroundColor White
$psVersion = $PSVersionTable.PSVersion.Major
Check "PowerShell >= 5" ($psVersion -ge 5) "Update Windows or install PowerShell 7 from microsoft.com/powershell"

# --- Git ---
Write-Host ""
Write-Host "[ Git ]" -ForegroundColor White
$gitExists = $null -ne (Get-Command git -ErrorAction SilentlyContinue)
Check "Git installed" $gitExists "Install from https://git-scm.com"
if ($gitExists) {
    $gitVersion = git --version
    Check "Git version readable" ($gitVersion -match "git version") "Reinstall Git"
}

# --- Python ---
Write-Host ""
Write-Host "[ Python ]" -ForegroundColor White
$pyCmd = $null
foreach ($cmd in @("python", "python3", "py")) {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) { $pyCmd = $cmd; break }
}
Check "Python installed" ($null -ne $pyCmd) "Install from https://python.org (check 'Add to PATH')"
if ($null -ne $pyCmd) {
    $pyVersion = & $pyCmd --version 2>&1
    $pyMajor = [int]($pyVersion -replace "Python (\d+)\..*", '$1')
    Check "Python >= 3" ($pyMajor -ge 3) "Install Python 3.x from python.org"
    
    # Check yaml module
    $yamlCheck = & $pyCmd -c "import yaml; print('ok')" 2>&1
    Check "PyYAML available" ($yamlCheck -eq "ok") "Run in terminal: $pyCmd -m pip install pyyaml"
    
    # Check hashlib (built-in)
    $hashlibCheck = & $pyCmd -c "import hashlib; print('ok')" 2>&1
    Check "hashlib available (built-in)" ($hashlibCheck -eq "ok") "Should be built-in - reinstall Python if missing"
}

# --- File System ---
Write-Host ""
Write-Host "[ Pack Structure ]" -ForegroundColor White
$RequiredDirs = @("00_manifest","01_state","02_governance","03_registry","04_runtime","05_benchmarks","06_operator","07_export","08_evidence","09_logs","10_scripts","11_docs","12_schemas")
$RequiredFiles = @(
    "00_manifest/canonical_manifest.yaml",
    "01_state/system_state_latest.yaml",
    "02_governance/governance_rules.yaml",
    "02_governance/truth_policy.yaml",
    "03_registry/module_registry.yaml",
    "04_runtime/runtime_config.yaml",
    "07_export/reproduction_instructions.md",
    "07_export/known_limitations.md"
)
foreach ($Dir in $RequiredDirs) {
    Check "Folder exists: $Dir" (Test-Path (Join-Path $Root $Dir)) "Create folder manually: mkdir $Dir"
}
foreach ($File in $RequiredFiles) {
    Check "File exists: $File" (Test-Path (Join-Path $Root $File)) "File missing - re-extract the zip"
}

# --- Write-up Permissions ---
Write-Host ""
Write-Host "[ Write Permissions ]" -ForegroundColor White
$testFile = Join-Path $Root "08_evidence\.write_test"
try {
    "test" | Set-Content -Path $testFile -ErrorAction Stop
    Remove-Item $testFile -ErrorAction SilentlyContinue
    Check "Can write to 08_evidence/" $true ""
} catch {
    Check "Can write to 08_evidence/" $false "Run PowerShell as Administrator or check folder permissions"
}
$testFile2 = Join-Path $Root "09_logs\.write_test"
try {
    "test" | Set-Content -Path $testFile2 -ErrorAction Stop
    Remove-Item $testFile2 -ErrorAction SilentlyContinue
    Check "Can write to 09_logs/" $true ""
} catch {
    Check "Can write to 09_logs/" $false "Run PowerShell as Administrator or check folder permissions"
}

# --- Summary ---
Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
$Total = $Pass + $Fail
if ($Fail -eq 0) {
    Write-Host "  RESULT: ALL $Total CHECKS PASSED - Ready to execute" -ForegroundColor Green
} else {
    Write-Host "  RESULT: $Fail of $Total checks FAILED" -ForegroundColor Red
    Write-Host "  Fix the items marked [!!] before running other scripts." -ForegroundColor Yellow
}
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

# Save report
$ReportPath = Join-Path $Root "08_evidence\environment_check_report.json"
$Results | ConvertTo-Json -Depth 4 | Set-Content -Path $ReportPath -Encoding UTF8
Write-Host "Report saved to: $ReportPath" -ForegroundColor Gray
Write-Host ""
