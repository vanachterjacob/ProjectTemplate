#!/bin/bash

# BC26 Development Template - Auto Installation Script
# Installs .cursor rules, .claude commands, hooks, and configuration files
# Usage: ./install-rules.sh <target_directory> <project_prefix> [repo_url]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Function to show usage
show_usage() {
    echo "BC26 Development Template - Auto Installation"
    echo ""
    echo "Usage: $0 <target_directory> <project_prefix> [repo_url] [repo_branch]"
    echo ""
    echo "Arguments:"
    echo "  target_directory  : Path to your AL project (e.g., /path/to/MyProject)"
    echo "  project_prefix    : 3-letter customer prefix (e.g., CON for Contoso)"
    echo "  repo_url          : (Optional) Git repository URL to pull latest template"
    echo "  repo_branch       : (Optional) Git branch to clone (default: main)"
    echo ""
    echo "Examples:"
    echo "  $0 /home/user/MyALProject CON"
    echo "  $0 . ABC https://github.com/yourorg/ProjectTemplate.git"
    echo "  $0 . ABC https://github.com/yourorg/ProjectTemplate.git develop"
    echo ""
    exit 1
}

# Check arguments
if [ $# -lt 2 ]; then
    show_usage
fi

TARGET_DIR="$1"
PROJECT_PREFIX="$2"
REPO_URL="${3:-}"
REPO_BRANCH="${4:-main}"

# Validate project prefix (3 letters, uppercase)
if [[ ! "$PROJECT_PREFIX" =~ ^[A-Z]{3}$ ]]; then
    print_error "Project prefix must be exactly 3 uppercase letters (e.g., CON, ABC, FAB)"
    exit 1
fi

# Resolve target directory
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")"

# Check if target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    print_error "Target directory does not exist: $TARGET_DIR"
    exit 1
fi

# Check if target is an AL project (has app.json)
if [ ! -f "$TARGET_DIR/app.json" ]; then
    print_warning "No app.json found in target directory. Are you sure this is an AL project?"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Installation cancelled."
        exit 0
    fi
fi

print_info "Starting BC26 Development Template installation..."
print_info "Target Directory: $TARGET_DIR"
print_info "Project Prefix: $PROJECT_PREFIX"

# Step 1: Pull from git if repo URL provided
if [ -n "$REPO_URL" ]; then
    print_info "Pulling latest template from repository..."
    print_info "Repository: $REPO_URL"
    print_info "Branch: $REPO_BRANCH"
    TEMP_CLONE_DIR=$(mktemp -d)

    if git clone -b "$REPO_BRANCH" "$REPO_URL" "$TEMP_CLONE_DIR" 2>/dev/null; then
        print_success "Repository cloned successfully (branch: $REPO_BRANCH)"
        TEMPLATE_DIR="$TEMP_CLONE_DIR"
    else
        print_warning "Failed to clone repository. Using local template instead."
    fi
fi

# Step 2: Check for existing files and warn
EXISTING_FILES=()
[ -d "$TARGET_DIR/.cursor/rules" ] && EXISTING_FILES+=(".cursor/rules")
[ -d "$TARGET_DIR/.claude/commands" ] && EXISTING_FILES+=(".claude/commands")
[ -f "$TARGET_DIR/CLAUDE.md" ] && EXISTING_FILES+=("CLAUDE.md")
[ -f "$TARGET_DIR/.cursorignore" ] && EXISTING_FILES+=(".cursorignore")

if [ ${#EXISTING_FILES[@]} -gt 0 ]; then
    print_warning "The following files/folders already exist and will be OVERWRITTEN:"
    for file in "${EXISTING_FILES[@]}"; do
        echo "  - $file"
    done
    read -p "Continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Installation cancelled."
        exit 0
    fi
fi

# Step 3: Create directory structure
print_info "Creating directory structure..."
mkdir -p "$TARGET_DIR/.cursor/rules"
mkdir -p "$TARGET_DIR/.cursor/hooks"
mkdir -p "$TARGET_DIR/.claude/commands"
mkdir -p "$TARGET_DIR/.claude/subagents"
mkdir -p "$TARGET_DIR/.claude/skills"
mkdir -p "$TARGET_DIR/.agent/specs"
mkdir -p "$TARGET_DIR/.agent/plans"
mkdir -p "$TARGET_DIR/.agent/tasks"
mkdir -p "$TARGET_DIR/BC27"

# Step 4: Copy files
print_info "Copying configuration files..."

# Copy .cursor/rules
if [ -d "$TEMPLATE_DIR/.cursor/rules" ]; then
    cp -r "$TEMPLATE_DIR/.cursor/rules"/* "$TARGET_DIR/.cursor/rules/"
    print_success "Copied .cursor/rules/ (${GREEN}$(ls -1 "$TEMPLATE_DIR/.cursor/rules" | wc -l)${NC} files)"
fi

# Copy .cursor/hooks
if [ -d "$TEMPLATE_DIR/.cursor/hooks" ]; then
    cp -r "$TEMPLATE_DIR/.cursor/hooks"/* "$TARGET_DIR/.cursor/hooks/"
    print_success "Copied .cursor/hooks/ (${GREEN}$(ls -1 "$TEMPLATE_DIR/.cursor/hooks" | wc -l)${NC} files)"
fi

# Copy .claude/commands
if [ -d "$TEMPLATE_DIR/.claude/commands" ]; then
    cp -r "$TEMPLATE_DIR/.claude/commands"/* "$TARGET_DIR/.claude/commands/"
    print_success "Copied .claude/commands/ (${GREEN}$(ls -1 "$TEMPLATE_DIR/.claude/commands" | wc -l)${NC} files)"
fi

# Copy .claude/settings.json if exists
if [ -f "$TEMPLATE_DIR/.claude/settings.json" ]; then
    cp "$TEMPLATE_DIR/.claude/settings.json" "$TARGET_DIR/.claude/settings.json"
    print_success "Copied .claude/settings.json"
fi

# Copy CLAUDE.md
if [ -f "$TEMPLATE_DIR/CLAUDE.md" ]; then
    cp "$TEMPLATE_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
    print_success "Copied CLAUDE.md"
fi

# Copy .cursorignore
if [ -f "$TEMPLATE_DIR/.cursorignore" ]; then
    cp "$TEMPLATE_DIR/.cursorignore" "$TARGET_DIR/.cursorignore"
    print_success "Copied .cursorignore"
fi

# Copy .claudeignore
if [ -f "$TEMPLATE_DIR/.claudeignore" ]; then
    cp "$TEMPLATE_DIR/.claudeignore" "$TARGET_DIR/.claudeignore"
    print_success "Copied .claudeignore"
fi

# Copy LLM_OPTIMIZATION_GUIDE.md
if [ -f "$TEMPLATE_DIR/LLM_OPTIMIZATION_GUIDE.md" ]; then
    cp "$TEMPLATE_DIR/LLM_OPTIMIZATION_GUIDE.md" "$TARGET_DIR/LLM_OPTIMIZATION_GUIDE.md"
    print_success "Copied LLM_OPTIMIZATION_GUIDE.md"
fi

# Copy src/AGENTS.md template if it exists and src/ folder exists
if [ -f "$TEMPLATE_DIR/src/AGENTS.md" ] && [ -d "$TARGET_DIR/src" ]; then
    cp "$TEMPLATE_DIR/src/AGENTS.md" "$TARGET_DIR/src/AGENTS.md"
    print_success "Copied src/AGENTS.md template"
fi

# Copy BC27 documentation if it exists
if [ -d "$TEMPLATE_DIR/BC27" ]; then
    cp -r "$TEMPLATE_DIR/BC27"/* "$TARGET_DIR/BC27/"
    BC27_COUNT=$(ls -1 "$TEMPLATE_DIR/BC27" | wc -l)
    print_success "Copied BC27/ documentation (${GREEN}${BC27_COUNT}${NC} files)"
fi

# Step 5: Replace ABC prefix with project prefix
print_info "Replacing ABC prefix with $PROJECT_PREFIX in all files..."

# Find all relevant files and replace ABC with project prefix
find "$TARGET_DIR/.cursor" "$TARGET_DIR/.claude" -type f \( -name "*.mdc" -o -name "*.md" -o -name "*.json" \) -exec sed -i "s/ABC/$PROJECT_PREFIX/g" {} \;

if [ -f "$TARGET_DIR/CLAUDE.md" ]; then
    sed -i "s/ABC/$PROJECT_PREFIX/g" "$TARGET_DIR/CLAUDE.md"
fi

if [ -f "$TARGET_DIR/src/AGENTS.md" ]; then
    sed -i "s/ABC/$PROJECT_PREFIX/g" "$TARGET_DIR/src/AGENTS.md"
fi

print_success "Prefix replacement complete (ABC → $PROJECT_PREFIX)"

# Step 6: Install hooks to user's home directory
print_info "Installing Cursor hooks..."

# Determine OS and set hooks directory
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows (Git Bash)
    HOOKS_DIR="$HOME/.cursor"
else
    # Linux/Mac
    HOOKS_DIR="$HOME/.cursor"
fi

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"

# Check if hooks.json already exists
if [ -f "$HOOKS_DIR/hooks.json" ]; then
    print_warning "Hooks configuration already exists at $HOOKS_DIR/hooks.json"
    read -p "Overwrite existing hooks? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$TARGET_DIR/.cursor/hooks/hooks.example.json" "$HOOKS_DIR/hooks.json"
        # Update paths in hooks.json to point to the project's .cursor/hooks directory
        sed -i "s|/path/to/project/.cursor/hooks|$TARGET_DIR/.cursor/hooks|g" "$HOOKS_DIR/hooks.json"
        print_success "Hooks installed to $HOOKS_DIR/hooks.json"
    else
        print_info "Skipped hooks installation. You can manually configure hooks later."
    fi
else
    cp "$TARGET_DIR/.cursor/hooks/hooks.example.json" "$HOOKS_DIR/hooks.json"
    # Update paths in hooks.json to point to the project's .cursor/hooks directory
    sed -i "s|/path/to/project/.cursor/hooks|$TARGET_DIR/.cursor/hooks|g" "$HOOKS_DIR/hooks.json"
    print_success "Hooks installed to $HOOKS_DIR/hooks.json"
fi

# Make hook scripts executable
chmod +x "$TARGET_DIR/.cursor/hooks"/*.ps1 2>/dev/null || true
chmod +x "$TARGET_DIR/.cursor/hooks"/*.sh 2>/dev/null || true

# Step 7: Cleanup temp directory if we cloned from git
if [ -n "$REPO_URL" ] && [ -d "$TEMP_CLONE_DIR" ]; then
    rm -rf "$TEMP_CLONE_DIR"
    print_info "Cleaned up temporary files"
fi

# Step 8: Create .agent/README.md if it doesn't exist
if [ ! -f "$TARGET_DIR/.agent/README.md" ]; then
    cat > "$TARGET_DIR/.agent/README.md" << 'EOF'
# .agent/ Directory

This directory contains AI-generated documentation for the BC26 project.

## Structure

- **specs/** - User-focused feature specifications (created by `/specify`)
- **plans/** - Technical architecture plans (created by `/plan`)
- **tasks/** - Task breakdowns for implementation (created by `/tasks`)

## Usage

Documentation files are automatically created and updated by Claude Code slash commands:

1. `/specify [feature-name]` - Creates user-focused specification
2. `/plan [spec-name]` - Creates technical plan from specification
3. `/tasks [plan-name] [phase]` - Breaks plan into tasks
4. `/implement [task-file] [task-id|next]` - Implements tasks sequentially
5. `/update_doc [init|update]` - Maintains this documentation structure

## Git

This directory is tracked in git to share AI context across the team.
EOF
    print_success "Created .agent/README.md"
fi

# Final success message
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_success "BC26 Development Template installation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ Installed components:"
echo "   • .cursor/rules/ - ESC standard rules (auto-loaded) + LLM optimization"
echo "   • .cursor/hooks/ - Quality & security hooks"
echo "   • .claude/commands/ - Workflow slash commands"
echo "   • CLAUDE.md - AI context documentation (with LLM optimization)"
echo "   • .cursorignore - Context exclusions for Cursor AI"
echo "   • .claudeignore - Context exclusions for Claude Code"
echo "   • LLM_OPTIMIZATION_GUIDE.md - Token efficiency guide"
echo "   • BC27/ - Base code index (18 files: 11 core + 7 module-specific)"
echo "      - BC27_LLM_QUICKREF.md ⭐ Token-optimized quick reference"
echo "   • Hooks configured in $HOOKS_DIR/hooks.json"
echo ""
echo "📝 Project Prefix: $PROJECT_PREFIX"
echo ""
echo "🚀 Next steps:"
echo "   1. Reload VS Code/Cursor to activate the configuration"
echo "   2. Test with: /specify test-feature"
echo "   3. Review CLAUDE.md for project guidelines"
echo "   4. Verify app.json has correct idRanges for $PROJECT_PREFIX"
echo ""
echo "📚 Available commands:"
echo "   • /specify [feature-name] - Create feature specification"
echo "   • /plan [spec-name] - Create technical plan"
echo "   • /tasks [plan-name] [phase] - Break down tasks"
echo "   • /implement [task-file] [task-id|next] - Implement code"
echo "   • /review [file-or-folder] - ESC compliance check"
echo "   • /update_doc [init|update] - Maintain documentation"
echo ""
echo "📖 Documentation:"
echo "   • BC27/ - Business Central 27 base code index (18 files)"
echo "      ⚡ Start with: BC27/BC27_LLM_QUICKREF.md (token-optimized, 80-90% savings)"
echo "      Navigation: BC27/BC27_INDEX_README.md"
echo "      Event search: BC27_EVENT_INDEX.md (210+ events)"
echo "      For extensions: BC27_EVENT_CATALOG.md → events/BC27_EVENTS_[MODULE].md"
echo "      For architecture: BC27_ARCHITECTURE.md → BC27_MODULES_OVERVIEW.md"
echo ""
echo "⚡ LLM Optimization:"
echo "   • LLM_OPTIMIZATION_GUIDE.md - Complete token efficiency guide"
echo "   • .cursor/rules/011-llm-optimization.mdc - Context loading strategies"
echo "   • .claudeignore / .cursorignore - Exclude ~50% of files from AI context"
echo "   • Token savings: 60-96% for typical AI code assistant queries"
echo ""
echo "⚡ Hooks active:"
echo "   • after-file-edit.ps1 - ESC validation"
echo "   • before-read-file.ps1 - Security (blocks sensitive files)"
echo "   • before-shell-execution.ps1 - Safety (prevents dangerous commands)"
echo "   • after-agent-response.ps1 - Usage analytics"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
