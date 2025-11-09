# BC26 Development Template - Auto Installation Script (PowerShell)
# Installs .cursor rules, .claude commands, hooks, and configuration files
# Usage: .\install-rules.ps1 -TargetDirectory "C:\Path\To\Project" -ProjectPrefix "ABC" [-RepoUrl "https://..."]

param(
    [Parameter(Mandatory=$true, HelpMessage="Path to your AL project")]
    [string]$TargetDirectory,

    [Parameter(Mandatory=$true, HelpMessage="3-letter customer prefix (e.g., CON for Contoso)")]
    [ValidatePattern('^[A-Z]{3}$')]
    [string]$ProjectPrefix,

    [Parameter(Mandatory=$false, HelpMessage="Git repository URL to pull latest template")]
    [string]$RepoUrl = "",

    [Parameter(Mandatory=$false, HelpMessage="Git branch to clone (default: main)")]
    [string]$RepoBranch = "main"
)

$ErrorActionPreference = "Stop"

# Get script and template directories
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TemplateDir = Split-Path -Parent $ScriptDir

# Color functions
function Write-Info { param([string]$Message) Write-Host "[INFO] $Message" -ForegroundColor Blue }
function Write-Success { param([string]$Message) Write-Host "[SUCCESS] $Message" -ForegroundColor Green }
function Write-Warning { param([string]$Message) Write-Host "[WARNING] $Message" -ForegroundColor Yellow }
function Write-ErrorMsg { param([string]$Message) Write-Host "[ERROR] $Message" -ForegroundColor Red }

# Resolve target directory
$TargetDirectory = Resolve-Path -Path $TargetDirectory -ErrorAction SilentlyContinue

if (-not $TargetDirectory) {
    Write-ErrorMsg "Target directory does not exist: $TargetDirectory"
    exit 1
}

# Check if target is an AL project (has app.json)
if (-not (Test-Path (Join-Path $TargetDirectory "app.json"))) {
    Write-Warning "No app.json found in target directory. Are you sure this is an AL project?"
    $continue = Read-Host "Continue anyway? (y/N)"
    if ($continue -ne 'y' -and $continue -ne 'Y') {
        Write-Info "Installation cancelled."
        exit 0
    }
}

Write-Info "Starting BC26 Development Template installation..."
Write-Info "Target Directory: $TargetDirectory"
Write-Info "Project Prefix: $ProjectPrefix"

# Step 1: Pull from git if repo URL provided
if ($RepoUrl) {
    Write-Info "Pulling latest template from repository..."
    Write-Info "Repository: $RepoUrl"
    Write-Info "Branch: $RepoBranch"
    $TempCloneDir = Join-Path $env:TEMP "bc26-template-$(Get-Random)"

    try {
        git clone -b $RepoBranch $RepoUrl $TempCloneDir 2>$null
        Write-Success "Repository cloned successfully (branch: $RepoBranch)"
        $TemplateDir = $TempCloneDir
    } catch {
        Write-Warning "Failed to clone repository. Using local template instead."
    }
}

# Step 2: Check for existing files and warn
$ExistingFiles = @()
if (Test-Path (Join-Path $TargetDirectory ".cursor\rules")) { $ExistingFiles += ".cursor\rules" }
if (Test-Path (Join-Path $TargetDirectory ".claude\commands")) { $ExistingFiles += ".claude\commands" }
if (Test-Path (Join-Path $TargetDirectory "CLAUDE.md")) { $ExistingFiles += "CLAUDE.md" }
if (Test-Path (Join-Path $TargetDirectory ".cursorignore")) { $ExistingFiles += ".cursorignore" }

if ($ExistingFiles.Count -gt 0) {
    Write-Warning "The following files/folders already exist and will be OVERWRITTEN:"
    $ExistingFiles | ForEach-Object { Write-Host "  - $_" }
    $continue = Read-Host "Continue? (y/N)"
    if ($continue -ne 'y' -and $continue -ne 'Y') {
        Write-Info "Installation cancelled."
        exit 0
    }
}

# Step 3: Create directory structure
Write-Info "Creating directory structure..."
$Directories = @(
    ".cursor\rules",
    ".cursor\hooks",
    ".claude\commands",
    ".claude\subagents",
    ".claude\skills",
    ".agent\specs",
    ".agent\plans",
    ".agent\tasks",
    "BC27"
)

foreach ($Dir in $Directories) {
    $FullPath = Join-Path $TargetDirectory $Dir
    if (-not (Test-Path $FullPath)) {
        New-Item -ItemType Directory -Path $FullPath -Force | Out-Null
    }
}

# Step 4: Copy files
Write-Info "Copying configuration files..."

# Copy .cursor/rules
$SourceRules = Join-Path $TemplateDir ".cursor\rules"
if (Test-Path $SourceRules) {
    Copy-Item -Path "$SourceRules\*" -Destination (Join-Path $TargetDirectory ".cursor\rules") -Force -Recurse
    $FileCount = (Get-ChildItem $SourceRules).Count
    Write-Success "Copied .cursor\rules\ ($FileCount files)"
}

# Copy .cursor/hooks
$SourceHooks = Join-Path $TemplateDir ".cursor\hooks"
if (Test-Path $SourceHooks) {
    Copy-Item -Path "$SourceHooks\*" -Destination (Join-Path $TargetDirectory ".cursor\hooks") -Force -Recurse
    $FileCount = (Get-ChildItem $SourceHooks).Count
    Write-Success "Copied .cursor\hooks\ ($FileCount files)"
}

# Copy .claude/commands
$SourceCommands = Join-Path $TemplateDir ".claude\commands"
if (Test-Path $SourceCommands) {
    Copy-Item -Path "$SourceCommands\*" -Destination (Join-Path $TargetDirectory ".claude\commands") -Force -Recurse
    $FileCount = (Get-ChildItem $SourceCommands).Count
    Write-Success "Copied .claude\commands\ ($FileCount files)"
}

# Copy .claude/settings.json if exists
$SourceSettings = Join-Path $TemplateDir ".claude\settings.json"
if (Test-Path $SourceSettings) {
    Copy-Item -Path $SourceSettings -Destination (Join-Path $TargetDirectory ".claude\settings.json") -Force
    Write-Success "Copied .claude\settings.json"
}

# Copy CLAUDE.md
$SourceClaudeMd = Join-Path $TemplateDir "CLAUDE.md"
if (Test-Path $SourceClaudeMd) {
    Copy-Item -Path $SourceClaudeMd -Destination (Join-Path $TargetDirectory "CLAUDE.md") -Force
    Write-Success "Copied CLAUDE.md"
}

# Copy .cursorignore
$SourceIgnore = Join-Path $TemplateDir ".cursorignore"
if (Test-Path $SourceIgnore) {
    Copy-Item -Path $SourceIgnore -Destination (Join-Path $TargetDirectory ".cursorignore") -Force
    Write-Success "Copied .cursorignore"
}

# Copy .claudeignore
$SourceClaudeIgnore = Join-Path $TemplateDir ".claudeignore"
if (Test-Path $SourceClaudeIgnore) {
    Copy-Item -Path $SourceClaudeIgnore -Destination (Join-Path $TargetDirectory ".claudeignore") -Force
    Write-Success "Copied .claudeignore"
}

# Copy docs/ directory
$SourceDocs = Join-Path $TemplateDir "docs"
if (Test-Path $SourceDocs) {
    $TargetDocs = Join-Path $TargetDirectory "docs"
    if (-not (Test-Path $TargetDocs)) {
        New-Item -ItemType Directory -Path $TargetDocs -Force | Out-Null
    }
    Copy-Item -Path "$SourceDocs\*" -Destination $TargetDocs -Recurse -Force
    Write-Success "Copied docs/ directory (QUICKSTART.md, LLM_OPTIMIZATION_GUIDE.md, planning/)"
}

# Copy src/AGENTS.md template if it exists and src/ folder exists
$SourceAgentsMd = Join-Path $TemplateDir "src\AGENTS.md"
$TargetSrcDir = Join-Path $TargetDirectory "src"
if ((Test-Path $SourceAgentsMd) -and (Test-Path $TargetSrcDir)) {
    Copy-Item -Path $SourceAgentsMd -Destination (Join-Path $TargetDirectory "src\AGENTS.md") -Force
    Write-Success "Copied src\AGENTS.md template"
}

# Copy BC27 documentation if it exists
$SourceBC27 = Join-Path $TemplateDir "BC27"
if (Test-Path $SourceBC27) {
    Copy-Item -Path "$SourceBC27\*" -Destination (Join-Path $TargetDirectory "BC27") -Force -Recurse
    $FileCount = (Get-ChildItem $SourceBC27).Count
    Write-Success "Copied BC27\ documentation ($FileCount files)"
}

# Step 5: Replace ABC prefix with project prefix
Write-Info "Replacing ABC prefix with $ProjectPrefix in all files..."

# Function to replace text in file
function Replace-InFile {
    param([string]$FilePath, [string]$Find, [string]$Replace)

    $content = Get-Content $FilePath -Raw -Encoding UTF8
    $content = $content -replace $Find, $Replace
    Set-Content -Path $FilePath -Value $content -Encoding UTF8 -NoNewline
}

# Find all relevant files and replace ABC with project prefix
$FilesToReplace = Get-ChildItem -Path (Join-Path $TargetDirectory ".cursor"), (Join-Path $TargetDirectory ".claude") `
    -Include "*.mdc", "*.md", "*.json" -Recurse

foreach ($File in $FilesToReplace) {
    Replace-InFile -FilePath $File.FullName -Find "ABC" -Replace $ProjectPrefix
}

$ClaudeMdPath = Join-Path $TargetDirectory "CLAUDE.md"
if (Test-Path $ClaudeMdPath) {
    Replace-InFile -FilePath $ClaudeMdPath -Find "ABC" -Replace $ProjectPrefix
}

$AgentsMdPath = Join-Path $TargetDirectory "src\AGENTS.md"
if (Test-Path $AgentsMdPath) {
    Replace-InFile -FilePath $AgentsMdPath -Find "ABC" -Replace $ProjectPrefix
}

Write-Success "Prefix replacement complete (ABC → $ProjectPrefix)"

# Step 6: Install hooks to user's home directory
Write-Info "Installing Cursor hooks..."

$HooksDir = Join-Path $env:USERPROFILE ".cursor"
if (-not (Test-Path $HooksDir)) {
    New-Item -ItemType Directory -Path $HooksDir -Force | Out-Null
}

$HooksJsonPath = Join-Path $HooksDir "hooks.json"
$ExampleHooksPath = Join-Path $TargetDirectory ".cursor\hooks\hooks.example.json"

if (Test-Path $HooksJsonPath) {
    Write-Warning "Hooks configuration already exists at $HooksJsonPath"
    $overwrite = Read-Host "Overwrite existing hooks? (y/N)"
    if ($overwrite -eq 'y' -or $overwrite -eq 'Y') {
        Copy-Item -Path $ExampleHooksPath -Destination $HooksJsonPath -Force
        # Update paths in hooks.json to point to the project's .cursor/hooks directory
        $hooksContent = Get-Content $HooksJsonPath -Raw
        $hooksContent = $hooksContent -replace '/path/to/project/.cursor/hooks', "$TargetDirectory\.cursor\hooks"
        Set-Content -Path $HooksJsonPath -Value $hooksContent -NoNewline
        Write-Success "Hooks installed to $HooksJsonPath"
    } else {
        Write-Info "Skipped hooks installation. You can manually configure hooks later."
    }
} else {
    Copy-Item -Path $ExampleHooksPath -Destination $HooksJsonPath -Force
    # Update paths in hooks.json to point to the project's .cursor/hooks directory
    $hooksContent = Get-Content $HooksJsonPath -Raw
    $hooksContent = $hooksContent -replace '/path/to/project/.cursor/hooks', "$TargetDirectory\.cursor\hooks"
    Set-Content -Path $HooksJsonPath -Value $hooksContent -NoNewline
    Write-Success "Hooks installed to $HooksJsonPath"
}

# Step 7: Cleanup temp directory if we cloned from git
if ($RepoUrl -and $TempCloneDir -and (Test-Path $TempCloneDir)) {
    Remove-Item -Path $TempCloneDir -Recurse -Force
    Write-Info "Cleaned up temporary files"
}

# Step 8: Create .agent/README.md if it doesn't exist
$AgentReadmePath = Join-Path $TargetDirectory ".agent\README.md"
if (-not (Test-Path $AgentReadmePath)) {
    $ReadmeContent = @"
# .agent/ Directory

This directory contains AI-generated documentation for the BC26 project.

## Structure

- **specs/** - User-focused feature specifications (created by ``/specify``)
- **plans/** - Technical architecture plans (created by ``/plan``)
- **tasks/** - Task breakdowns for implementation (created by ``/tasks``)

## Usage

Documentation files are automatically created and updated by Claude Code slash commands:

1. ``/specify [feature-name]`` - Creates user-focused specification
2. ``/plan [spec-name]`` - Creates technical plan from specification
3. ``/tasks [plan-name] [phase]`` - Breaks plan into tasks
4. ``/implement [task-file] [task-id|next]`` - Implements tasks sequentially
5. ``/update_doc [init|update]`` - Maintains this documentation structure

## Git

This directory is tracked in git to share AI context across the team.
"@
    Set-Content -Path $AgentReadmePath -Value $ReadmeContent -Encoding UTF8
    Write-Success "Created .agent\README.md"
}

# Final success message
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Success "BC26 Development Template installation complete!"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""
Write-Host "✅ Installed components:" -ForegroundColor Green
Write-Host "   • .cursor\rules\ - ESC standard rules (auto-loaded) + LLM optimization"
Write-Host "   • .cursor\hooks\ - Quality & security hooks"
Write-Host "   • .claude\commands\ - Workflow slash commands"
Write-Host "   • CLAUDE.md - AI context documentation (with LLM optimization)"
Write-Host "   • .cursorignore - Context exclusions for Cursor AI"
Write-Host "   • .claudeignore - Context exclusions for Claude Code"
Write-Host "   • docs\ - Documentation (QUICKSTART, LLM_OPTIMIZATION_GUIDE, planning)"
Write-Host "   • BC27\ - Base code index (18 files: 11 core + 7 module-specific)"
Write-Host "      - BC27_LLM_QUICKREF.md ⭐ Token-optimized quick reference"
Write-Host "   • Hooks configured in $HooksDir\hooks.json"
Write-Host ""
Write-Host "📝 Project Prefix: $ProjectPrefix" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 Next steps:" -ForegroundColor Yellow
Write-Host "   1. Reload VS Code/Cursor to activate the configuration"
Write-Host "   2. Test with: /specify test-feature"
Write-Host "   3. Review CLAUDE.md for project guidelines"
Write-Host "   4. Verify app.json has correct idRanges for $ProjectPrefix"
Write-Host ""
Write-Host "📚 Available commands:" -ForegroundColor Magenta
Write-Host "   • /specify [feature-name] - Create feature specification"
Write-Host "   • /plan [spec-name] - Create technical plan"
Write-Host "   • /tasks [plan-name] [phase] - Break down tasks"
Write-Host "   • /implement [task-file] [task-id|next] - Implement code"
Write-Host "   • /review [file-or-folder] - ESC compliance check"
Write-Host "   • /update_doc [init|update] - Maintain documentation"
Write-Host ""
Write-Host "📖 Documentation:" -ForegroundColor Cyan
Write-Host "   • BC27\ - Business Central 27 base code index (18 files)"
Write-Host "      ⚡ Start with: BC27\BC27_LLM_QUICKREF.md (token-optimized, 80-90% savings)"
Write-Host "      Navigation: BC27\BC27_INDEX_README.md"
Write-Host "      Event search: BC27_EVENT_INDEX.md (210+ events)"
Write-Host "      For extensions: BC27_EVENT_CATALOG.md → events\BC27_EVENTS_[MODULE].md"
Write-Host "      For architecture: BC27_ARCHITECTURE.md → BC27_MODULES_OVERVIEW.md"
Write-Host ""
Write-Host "⚡ LLM Optimization:" -ForegroundColor Yellow
Write-Host "   • docs\LLM_OPTIMIZATION_GUIDE.md - Complete token efficiency guide"
Write-Host "   • .cursor\rules\011-llm-optimization.mdc - Context loading strategies"
Write-Host "   • .claudeignore / .cursorignore - Exclude ~50% of files from AI context"
Write-Host "   • Token savings: 60-96% for typical AI code assistant queries"
Write-Host ""
Write-Host "⚡ Hooks active:" -ForegroundColor Blue
Write-Host "   • after-file-edit.ps1 - ESC validation"
Write-Host "   • before-read-file.ps1 - Security (blocks sensitive files)"
Write-Host "   • before-shell-execution.ps1 - Safety (prevents dangerous commands)"
Write-Host "   • after-agent-response.ps1 - Usage analytics"
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
