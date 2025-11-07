####################################################################################################
# BC26 Template Installation - Quick Setup Script
####################################################################################################
#
# INSTRUCTIONS:
# 1. Edit the variables below with your project details
# 2. Save this file
# 3. Run: .\install-to-project.ps1
#
####################################################################################################

# ===========================
# CONFIGURATION - EDIT THESE!
# ===========================

# Full path to your AL project
$TargetProject = "C:\Projects\Play AV\Play"

# Your 3-letter project prefix (must be uppercase, e.g., PLY, PAV, ABC)
$ProjectPrefix = "PLY"

# (Optional) Git repository URL to pull latest template
# Leave empty "" to use local template files
$GitRepoUrl = ""

# ===========================
# DO NOT EDIT BELOW THIS LINE
# ===========================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "BC26 Template Installation" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Target Project: $TargetProject" -ForegroundColor Yellow
Write-Host "Project Prefix: $ProjectPrefix" -ForegroundColor Yellow
Write-Host "Git Repo: $(if ($GitRepoUrl) { $GitRepoUrl } else { '(using local template)' })" -ForegroundColor Yellow
Write-Host ""

# Validate configuration
if (-not $TargetProject) {
    Write-Host "[ERROR] TargetProject is not set. Please edit the script and set the TargetProject variable." -ForegroundColor Red
    exit 1
}

if (-not $ProjectPrefix) {
    Write-Host "[ERROR] ProjectPrefix is not set. Please edit the script and set the ProjectPrefix variable." -ForegroundColor Red
    exit 1
}

if ($ProjectPrefix -notmatch '^[A-Z]{3}$') {
    Write-Host "[ERROR] ProjectPrefix must be exactly 3 uppercase letters (e.g., PLY, ABC, CON)" -ForegroundColor Red
    Write-Host "Current value: '$ProjectPrefix'" -ForegroundColor Red
    exit 1
}

# Get the directory where this script is located
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Path to the main installation script
$InstallScriptPath = Join-Path $ScriptDir "scripts\install-rules.ps1"

# Check if installation script exists
if (-not (Test-Path $InstallScriptPath)) {
    Write-Host "[ERROR] Installation script not found at: $InstallScriptPath" -ForegroundColor Red
    Write-Host "Make sure you're running this script from the ProjectTemplate directory." -ForegroundColor Red
    exit 1
}

# Confirm before proceeding
Write-Host "Press any key to start installation, or Ctrl+C to cancel..." -ForegroundColor Green
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Write-Host ""

# Run the installation script
try {
    if ($GitRepoUrl) {
        & $InstallScriptPath -TargetDirectory $TargetProject -ProjectPrefix $ProjectPrefix -RepoUrl $GitRepoUrl
    } else {
        & $InstallScriptPath -TargetDirectory $TargetProject -ProjectPrefix $ProjectPrefix
    }

    Write-Host ""
    Write-Host "=====================================" -ForegroundColor Green
    Write-Host "Installation completed successfully!" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Reload VS Code/Cursor" -ForegroundColor White
    Write-Host "2. Test with: /specify test-feature" -ForegroundColor White
    Write-Host "3. Review CLAUDE.md in your project" -ForegroundColor White
    Write-Host ""
} catch {
    Write-Host ""
    Write-Host "[ERROR] Installation failed: $_" -ForegroundColor Red
    exit 1
}
