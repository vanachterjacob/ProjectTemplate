#!/bin/bash

# BC27 Development Template - Memory Setup Script
# Sets up Claude Code #memory files based on project type
# Usage: ./setup-memories.sh <target_directory> <project_prefix> [project_type]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_info() { echo -e "${BLUE}[MEMORY]${NC} $1"; }
print_success() { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }

# Check arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 <target_directory> <project_prefix> [project_type]"
    echo ""
    echo "Project types: sales, warehouse, api, manufacturing, posting, general"
    exit 1
fi

TARGET_DIR="$1"
PROJECT_PREFIX="$2"
PROJECT_TYPE="${3:-}"

echo ""
echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   Claude Code Memory Setup                ║${NC}"
echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo ""

# If project type not provided, ask user
if [ -z "$PROJECT_TYPE" ]; then
    echo -e "${CYAN}What type of BC27 project is this?${NC}"
    echo ""
    echo "  1) Sales & Customer Management"
    echo "  2) Warehouse & Inventory"
    echo "  3) API & Integration"
    echo "  4) Manufacturing & Production"
    echo "  5) Posting & Financial"
    echo "  6) General / Multiple Areas"
    echo "  7) Skip memory setup"
    echo ""
    read -p "Select (1-7): " -n 1 -r
    echo ""
    echo ""

    case $REPLY in
        1) PROJECT_TYPE="sales" ;;
        2) PROJECT_TYPE="warehouse" ;;
        3) PROJECT_TYPE="api" ;;
        4) PROJECT_TYPE="manufacturing" ;;
        5) PROJECT_TYPE="posting" ;;
        6) PROJECT_TYPE="general" ;;
        7)
            print_info "Skipping memory setup"
            exit 0
            ;;
        *)
            print_error "Invalid selection"
            exit 1
            ;;
    esac
fi

print_info "Project Type: ${CYAN}${PROJECT_TYPE}${NC}"
echo ""

# Ask about ESC strict mode
echo -e "${CYAN}Enable ESC Strict Compliance Mode?${NC}"
echo "  (Enforces maximum ESC standards - recommended for production)"
echo ""
read -p "Enable strict mode? (Y/n): " -n 1 -r
echo ""
ESC_STRICT=false
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    ESC_STRICT=true
    print_success "ESC Strict Mode enabled"
else
    print_info "ESC Strict Mode disabled"
fi
echo ""

# Create .claude directory if not exists
mkdir -p "$TARGET_DIR/.claude"

# Create project CLAUDE.md with imports
CLAUDE_MD="$TARGET_DIR/.claude/CLAUDE.md"

print_info "Creating project memory file..."

cat > "$CLAUDE_MD" << EOF
# Project Memory - ${PROJECT_PREFIX} Extension

## Auto-Loaded Context

This file is automatically loaded by Claude Code for this project.

EOF

# Add project type memory
if [ "$PROJECT_TYPE" != "general" ]; then
    MEMORY_TEMPLATE="$TEMPLATE_DIR/.claude/memories/templates/${PROJECT_TYPE}-project.md"
    if [ -f "$MEMORY_TEMPLATE" ]; then
        cat "$MEMORY_TEMPLATE" >> "$CLAUDE_MD"
        print_success "Loaded ${PROJECT_TYPE} project memory"
    fi
fi

# Add ESC strict mode if enabled
if [ "$ESC_STRICT" = true ]; then
    ESC_TEMPLATE="$TEMPLATE_DIR/.claude/memories/templates/esc-strict-mode.md"
    if [ -f "$ESC_TEMPLATE" ]; then
        echo "" >> "$CLAUDE_MD"
        echo "---" >> "$CLAUDE_MD"
        echo "" >> "$CLAUDE_MD"
        cat "$ESC_TEMPLATE" >> "$CLAUDE_MD"
        print_success "Enabled ESC Strict Compliance Mode"
    fi
fi

# Add customer configuration section
echo "" >> "$CLAUDE_MD"
echo "---" >> "$CLAUDE_MD"
echo "" >> "$CLAUDE_MD"
echo "## Project Configuration" >> "$CLAUDE_MD"
echo "" >> "$CLAUDE_MD"
echo "- **Prefix**: $PROJECT_PREFIX" >> "$CLAUDE_MD"
echo "- **BC Version**: Business Central 27 (SaaS)" >> "$CLAUDE_MD"
echo "- **Development Range**: 77100-77200 (dummy IDs)" >> "$CLAUDE_MD"
echo "" >> "$CLAUDE_MD"
echo "## Remember" >> "$CLAUDE_MD"
echo "" >> "$CLAUDE_MD"
echo "- Use \`#\` to quickly add memories during development" >> "$CLAUDE_MD"
echo "- Use \`/memory\` to edit memory files" >> "$CLAUDE_MD"
echo "- Load context with skills: \`@${PROJECT_TYPE}-context\`" >> "$CLAUDE_MD"
echo "" >> "$CLAUDE_MD"

print_success "Created .claude/CLAUDE.md"

# Offer to create user memory (optional)
echo ""
echo -e "${CYAN}Create personal user memory (stored in ~/.claude/)?${NC}"
echo "  (Personal preferences like coding style, shortcuts)"
echo ""
read -p "Create user memory? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    USER_CLAUDE_DIR="$HOME/.claude"
    mkdir -p "$USER_CLAUDE_DIR"
    USER_CLAUDE_MD="$USER_CLAUDE_DIR/CLAUDE.md"

    if [ -f "$USER_CLAUDE_MD" ]; then
        print_warning "User memory already exists at $USER_CLAUDE_MD"
        print_info "You can edit it with: /memory"
    else
        cat > "$USER_CLAUDE_MD" << 'EOF'
# Personal Claude Code Memory

## My Preferences

- I prefer clear, concise code comments
- Use 4-space indentation (AL default)
- Always add XML documentation to public procedures
- Write unit tests for business logic

## My Shortcuts

When I say "standard setup", create:
- Table extension
- Page extension
- Event subscribers
- Permission set

## My Style

- Descriptive variable names (avoid abbreviations)
- Early exit pattern always
- TryFunction for validation
- Detailed error messages

EOF
        print_success "Created user memory at $USER_CLAUDE_MD"
        print_info "Edit with: /memory"
    fi
fi

# Summary
echo ""
echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   Memory Setup Complete                    ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✅ Project Memory:${NC} .claude/CLAUDE.md"
echo -e "${GREEN}✅ Type:${NC} $PROJECT_TYPE"
echo -e "${GREEN}✅ ESC Strict:${NC} $ESC_STRICT"
echo ""
echo -e "${YELLOW}Quick Usage:${NC}"
echo "  # Add quick memory"
echo "  ${CYAN}# Always validate email addresses${NC}"
echo ""
echo "  # Edit memories"
echo "  ${CYAN}/memory${NC}"
echo ""
echo "  # Load context"
echo "  ${CYAN}@${PROJECT_TYPE}-context${NC}"
echo ""
echo -e "${BLUE}Memory is now active!${NC} Claude Code will use it automatically."
echo ""
