# BC27 Template Quick Install - One-Liner Installation (PowerShell)
#
# USAGE:
#   Quick interactive install:
#     Invoke-WebRequest -Uri "https://raw.githubusercontent.com/vanachterjacob/ProjectTemplate/main/quick-install.ps1" -OutFile "$env:TEMP\quick-install.ps1"; & "$env:TEMP\quick-install.ps1"
#
#   Non-interactive install:
#     Invoke-WebRequest -Uri "https://raw.githubusercontent.com/vanachterjacob/ProjectTemplate/main/quick-install.ps1" -OutFile "$env:TEMP\quick-install.ps1"; & "$env:TEMP\quick-install.ps1" -TargetProject "C:\Projects\MyProject" -ProjectPrefix "ABC"
#
#   With project type:
#     Invoke-WebRequest -Uri "https://raw.githubusercontent.com/vanachterjacob/ProjectTemplate/main/quick-install.ps1" -OutFile "$env:TEMP\quick-install.ps1"; & "$env:TEMP\quick-install.ps1" -TargetProject "C:\Projects\MyProject" -ProjectPrefix "ABC" -ProjectType "sales"
#
####################################################################################################

param(
    [Parameter(Mandatory = $false)]
    [string]$TargetProject = "",
    
    [Parameter(Mandatory = $false)]
    [ValidatePattern('^[A-Z]{3}$')]
    [string]$ProjectPrefix = "",
    
    [Parameter(Mandatory = $false)]
    [string]$ProjectType = ""
)

$ErrorActionPreference = "Stop"

# Configuration
$REPO_URL = "https://github.com/vanachterjacob/ProjectTemplate.git"
$REPO_BRANCH = "main"
$TEMP_DIR = ""

# Helper functions
function Write-Info { param([string]$Message) Write-Host "ℹ $Message" -ForegroundColor Blue }
function Write-Success { param([string]$Message) Write-Host "✓ $Message" -ForegroundColor Green }
function Write-Warning { param([string]$Message) Write-Host "⚠ $Message" -ForegroundColor Yellow }
function Write-Error { param([string]$Message) Write-Host "✗ $Message" -ForegroundColor Red }
function Write-Header { param([string]$Message) Write-Host $Message -ForegroundColor Cyan }

# Cleanup function
function Cleanup {
    if ($TEMP_DIR -and (Test-Path $TEMP_DIR)) {
        Write-Info "Cleaning up temporary files..."
        Remove-Item -Path $TEMP_DIR -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Register cleanup on exit
Register-EngineEvent PowerShell.Exiting -Action { Cleanup } | Out-Null

# Banner
Write-Host ""
Write-Header "╔════════════════════════════════════════════════════════════════╗"
Write-Header "║          BC27 Development Template - Quick Install            ║"
Write-Header "╚════════════════════════════════════════════════════════════════╝"
Write-Host ""

# Interactive mode if no arguments provided
if ([string]::IsNullOrWhiteSpace($TargetProject)) {
    Write-Info "Interactive installation mode"
    Write-Host ""
    
    # Ask for target project
    while ($true) {
        Write-Host "Enter the full path to your AL project:" -ForegroundColor Cyan
        Write-Host "(e.g., C:\Projects\MyProject)" -ForegroundColor Yellow
        $input = Read-Host
        
        if ([string]::IsNullOrWhiteSpace($input)) {
            Write-Error "Project path cannot be empty"
            continue
        }
        
        # Expand environment variables and resolve path
        $input = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($input)
        
        # Create directory if it doesn't exist
        if (-not (Test-Path $input)) {
            Write-Host ""
            Write-Warning "Directory does not exist: $input"
            $create = Read-Host "Create it? (y/N)"
            if ($create -eq 'y' -or $create -eq 'Y') {
                New-Item -ItemType Directory -Path $input -Force | Out-Null
                Write-Success "Directory created"
            }
            else {
                continue
            }
        }
        
        $TargetProject = $input
        break
    }
    
    Write-Host ""
    
    # Ask for project prefix
    while ($true) {
        Write-Host "Enter your 3-letter project prefix:" -ForegroundColor Cyan
        Write-Host "(e.g., ABC, CON, FAB - must be UPPERCASE)" -ForegroundColor Yellow
        $input = Read-Host
        
        if ($input -match '^[A-Z]{3}$') {
            $ProjectPrefix = $input
            break
        }
        else {
            Write-Error "Prefix must be exactly 3 uppercase letters"
        }
    }
    
    Write-Host ""
}

# Validate inputs
if ([string]::IsNullOrWhiteSpace($TargetProject)) {
    Write-Error "Target project path is required"
    exit 1
}

if ([string]::IsNullOrWhiteSpace($ProjectPrefix)) {
    Write-Error "Project prefix is required"
    exit 1
}

if ($ProjectPrefix -notmatch '^[A-Z]{3}$') {
    Write-Error "Project prefix must be exactly 3 uppercase letters (e.g., ABC, CON, FAB)"
    exit 1
}

# Resolve target project path
try {
    $TargetProject = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($TargetProject)
}
catch {
    Write-Error "Invalid path: $TargetProject"
    exit 1
}

# Show configuration
Write-Host ""
Write-Header "Installation Configuration:"
Write-Host "  Target: $TargetProject" -ForegroundColor Cyan
Write-Host "  Prefix: $ProjectPrefix" -ForegroundColor Cyan
if (-not [string]::IsNullOrWhiteSpace($ProjectType)) {
    Write-Host "  Type: $ProjectType" -ForegroundColor Cyan
}
Write-Host ""

# Confirm
if ([Environment]::UserInteractive) {
    $confirm = Read-Host "Continue with installation? (Y/n)"
    if ($confirm -eq 'n' -or $confirm -eq 'N') {
        Write-Info "Installation cancelled"
        exit 0
    }
    Write-Host ""
}

# Step 1: Clone repository
Write-Info "Downloading BC27 template from GitHub..."
$TEMP_DIR = Join-Path $env:TEMP "bc27-template-$(Get-Random)"

try {
    # Check if git is available
    $gitAvailable = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitAvailable) {
        Write-Error "Git is not installed or not in PATH. Please install Git for Windows."
        exit 1
    }
    
    # Clone repository
    $cloneOutput = git clone -q -b $REPO_BRANCH --depth 1 $REPO_URL $TEMP_DIR 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Git clone failed"
    }
    
    Write-Success "Template downloaded"
}
catch {
    Write-Error "Failed to clone repository from $REPO_URL"
    Write-Info "Please check your internet connection and try again"
    Cleanup
    exit 1
}

# Step 2: Run installation script
Write-Info "Running installation script..."
Write-Host ""

$INSTALL_SCRIPT = Join-Path $TEMP_DIR "scripts\install-rules.ps1"

if (-not (Test-Path $INSTALL_SCRIPT)) {
    Write-Error "Installation script not found in repository"
    Cleanup
    exit 1
}

# Run installer
try {
    if (-not [string]::IsNullOrWhiteSpace($ProjectType)) {
        # Non-interactive with project type
        # Note: install-rules.ps1 doesn't currently support project type parameter
        # This would need to be added to install-rules.ps1 if needed
        & $INSTALL_SCRIPT -TargetDirectory $TargetProject -ProjectPrefix $ProjectPrefix
    }
    else {
        # Interactive (will ask for project type if needed)
        & $INSTALL_SCRIPT -TargetDirectory $TargetProject -ProjectPrefix $ProjectPrefix
    }
    
    if ($LASTEXITCODE -ne 0) {
        throw "Installation script failed"
    }
}
catch {
    Write-Error "Installation failed: $_"
    Cleanup
    exit 1
}

# Success message
Write-Host ""
Write-Header "╔════════════════════════════════════════════════════════════════╗"
Write-Header "║              Installation Complete! 🎉                         ║"
Write-Header "╚════════════════════════════════════════════════════════════════╝"
Write-Host ""
Write-Success "BC27 Development Template installed successfully"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  1. cd $TargetProject" -ForegroundColor White
Write-Host "  2. code .  (or open in Cursor/VS Code)" -ForegroundColor White
Write-Host "  3. Reload your IDE to activate the configuration" -ForegroundColor White
Write-Host ""
Write-Host "Quick start:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  /specify my-first-feature  # Create specification" -ForegroundColor Yellow
Write-Host "  /plan my-first-feature    # Create technical plan" -ForegroundColor Yellow
Write-Host "  /tasks my-first-feature   # Break into tasks" -ForegroundColor Yellow
Write-Host ""
Write-Host "Memory features:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  # your instruction       # Quick memory add" -ForegroundColor Yellow
Write-Host "  /memory                   # Edit memory files" -ForegroundColor Yellow
Write-Host "  @sales-context           # Load sales context" -ForegroundColor Yellow
Write-Host ""
Write-Host "Documentation:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  📖 CLAUDE.md - AI instructions and workflows" -ForegroundColor White
Write-Host "  📖 BC27\BC27_LLM_QUICKREF.md - Token-optimized BC27 reference" -ForegroundColor White
Write-Host "  📖 .claude\memories\README.md - Memory system guide" -ForegroundColor White
Write-Host ""
Write-Info "Happy coding with BC27! 🚀"
Write-Host ""

# Cleanup
Cleanup

