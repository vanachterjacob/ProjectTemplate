#!/bin/bash

####################################################################################################
# BC27 Template Quick Install - One-Liner Installation
####################################################################################################
#
# USAGE:
#   Quick interactive install:
#     curl -sSL https://raw.githubusercontent.com/vanachterjacob/ProjectTemplate/main/quick-install.sh | bash
#
#   Non-interactive install:
#     curl -sSL https://raw.githubusercontent.com/vanachterjacob/ProjectTemplate/main/quick-install.sh | bash -s -- /path/to/project ABC
#
#   With project type:
#     curl -sSL https://raw.githubusercontent.com/vanachterjacob/ProjectTemplate/main/quick-install.sh | bash -s -- /path/to/project ABC sales
#
####################################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_header() { echo -e "${CYAN}${BOLD}$1${NC}"; }

# Configuration
REPO_URL="https://github.com/vanachterjacob/ProjectTemplate.git"
REPO_BRANCH="main"
TEMP_DIR=""

# Cleanup on exit
cleanup() {
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        print_info "Cleaning up temporary files..."
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT

# Parse arguments
TARGET_PROJECT="${1:-}"
PROJECT_PREFIX="${2:-}"
PROJECT_TYPE="${3:-}"

# Banner
echo ""
print_header "╔════════════════════════════════════════════════════════════════╗"
print_header "║          BC27 Development Template - Quick Install            ║"
print_header "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Interactive mode if no arguments provided
if [ -z "$TARGET_PROJECT" ]; then
    print_info "Interactive installation mode"
    echo ""

    # Ask for target project
    while true; do
        echo -e "${CYAN}Enter the full path to your AL project:${NC}"
        echo -e "${YELLOW}(e.g., /home/user/MyProject or C:/Projects/MyProject)${NC}"
        read -r TARGET_PROJECT

        if [ -z "$TARGET_PROJECT" ]; then
            print_error "Project path cannot be empty"
            continue
        fi

        # Expand ~ to home directory
        TARGET_PROJECT="${TARGET_PROJECT/#\~/$HOME}"

        # Create directory if it doesn't exist
        if [ ! -d "$TARGET_PROJECT" ]; then
            echo ""
            print_warning "Directory does not exist: $TARGET_PROJECT"
            read -p "Create it? (y/N): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                mkdir -p "$TARGET_PROJECT"
                print_success "Directory created"
            else
                continue
            fi
        fi

        break
    done

    echo ""

    # Ask for project prefix
    while true; do
        echo -e "${CYAN}Enter your 3-letter project prefix:${NC}"
        echo -e "${YELLOW}(e.g., ABC, CON, FAB - must be UPPERCASE)${NC}"
        read -r PROJECT_PREFIX

        if [[ ! "$PROJECT_PREFIX" =~ ^[A-Z]{3}$ ]]; then
            print_error "Prefix must be exactly 3 uppercase letters"
            continue
        fi

        break
    done

    echo ""
fi

# Validate inputs
if [ -z "$TARGET_PROJECT" ]; then
    print_error "Target project path is required"
    exit 1
fi

if [ -z "$PROJECT_PREFIX" ]; then
    print_error "Project prefix is required"
    exit 1
fi

if [[ ! "$PROJECT_PREFIX" =~ ^[A-Z]{3}$ ]]; then
    print_error "Project prefix must be exactly 3 uppercase letters (e.g., ABC, CON, FAB)"
    exit 1
fi

# Expand ~ in path
TARGET_PROJECT="${TARGET_PROJECT/#\~/$HOME}"

# Show configuration
echo ""
print_header "Installation Configuration:"
echo -e "  ${CYAN}Target:${NC} $TARGET_PROJECT"
echo -e "  ${CYAN}Prefix:${NC} $PROJECT_PREFIX"
if [ -n "$PROJECT_TYPE" ]; then
    echo -e "  ${CYAN}Type:${NC} $PROJECT_TYPE"
fi
echo ""

# Confirm
if [ -t 0 ]; then  # Check if running interactively
    read -p "Continue with installation? (Y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        print_info "Installation cancelled"
        exit 0
    fi
    echo ""
fi

# Step 1: Clone repository
print_info "Downloading BC27 template from GitHub..."
TEMP_DIR=$(mktemp -d)

if ! git clone -q -b "$REPO_BRANCH" --depth 1 "$REPO_URL" "$TEMP_DIR" 2>/dev/null; then
    print_error "Failed to clone repository from $REPO_URL"
    print_info "Please check your internet connection and try again"
    exit 1
fi

print_success "Template downloaded"

# Step 2: Run installation script
print_info "Running installation script..."
echo ""

INSTALL_SCRIPT="$TEMP_DIR/scripts/install-rules.sh"

if [ ! -f "$INSTALL_SCRIPT" ]; then
    print_error "Installation script not found in repository"
    exit 1
fi

chmod +x "$INSTALL_SCRIPT"

# Run installer
if [ -n "$PROJECT_TYPE" ]; then
    # Non-interactive with project type
    bash "$INSTALL_SCRIPT" "$TARGET_PROJECT" "$PROJECT_PREFIX" <<EOF
y
$PROJECT_TYPE
y
y
EOF
else
    # Interactive (will ask for project type)
    bash "$INSTALL_SCRIPT" "$TARGET_PROJECT" "$PROJECT_PREFIX"
fi

# Success message
echo ""
print_header "╔════════════════════════════════════════════════════════════════╗"
print_header "║              Installation Complete! 🎉                         ║"
print_header "╚════════════════════════════════════════════════════════════════╝"
echo ""
print_success "BC27 Development Template installed successfully"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo ""
echo -e "  1. ${BOLD}cd $TARGET_PROJECT${NC}"
echo -e "  2. ${BOLD}code .${NC}  (or open in Cursor/VS Code)"
echo -e "  3. Reload your IDE to activate the configuration"
echo ""
echo -e "${CYAN}Quick start:${NC}"
echo ""
echo -e "  ${BOLD}/specify${NC} my-first-feature  ${YELLOW}# Create specification${NC}"
echo -e "  ${BOLD}/plan${NC} my-first-feature    ${YELLOW}# Create technical plan${NC}"
echo -e "  ${BOLD}/tasks${NC} my-first-feature   ${YELLOW}# Break into tasks${NC}"
echo ""
echo -e "${CYAN}Memory features:${NC}"
echo ""
echo -e "  ${BOLD}#${NC} your instruction       ${YELLOW}# Quick memory add${NC}"
echo -e "  ${BOLD}/memory${NC}                   ${YELLOW}# Edit memory files${NC}"
echo -e "  ${BOLD}@sales-context${NC}           ${YELLOW}# Load sales context${NC}"
echo ""
echo -e "${CYAN}Documentation:${NC}"
echo ""
echo -e "  📖 ${BOLD}CLAUDE.md${NC} - AI instructions and workflows"
echo -e "  📖 ${BOLD}BC27/BC27_LLM_QUICKREF.md${NC} - Token-optimized BC27 reference"
echo -e "  📖 ${BOLD}.claude/memories/README.md${NC} - Memory system guide"
echo ""
print_info "Happy coding with BC27! 🚀"
echo ""
