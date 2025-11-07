#!/bin/bash

####################################################################################################
# BC26 Template Installation - Quick Setup Script
####################################################################################################
#
# INSTRUCTIONS:
# 1. Edit the variables below with your project details
# 2. Save this file
# 3. Run: bash install-to-project.sh
#
####################################################################################################

# ===========================
# CONFIGURATION - EDIT THESE!
# ===========================

# Full path to your AL project
TARGET_PROJECT="/home/user/Projects/MyALProject"

# Your 3-letter project prefix (must be uppercase, e.g., PLY, PAV, ABC)
PROJECT_PREFIX="PLY"

# (Optional) Git repository URL to pull latest template
# Leave empty "" to use local template files
GIT_REPO_URL=""

# ===========================
# DO NOT EDIT BELOW THIS LINE
# ===========================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

echo ""
echo -e "${CYAN}=====================================${NC}"
echo -e "${CYAN}BC26 Template Installation${NC}"
echo -e "${CYAN}=====================================${NC}"
echo ""
echo -e "${YELLOW}Target Project: $TARGET_PROJECT${NC}"
echo -e "${YELLOW}Project Prefix: $PROJECT_PREFIX${NC}"
echo -e "${YELLOW}Git Repo: $([ -n "$GIT_REPO_URL" ] && echo "$GIT_REPO_URL" || echo "(using local template)")${NC}"
echo ""

# Validate configuration
if [ -z "$TARGET_PROJECT" ]; then
    echo -e "${RED}[ERROR] TARGET_PROJECT is not set. Please edit the script and set the TARGET_PROJECT variable.${NC}"
    exit 1
fi

if [ -z "$PROJECT_PREFIX" ]; then
    echo -e "${RED}[ERROR] PROJECT_PREFIX is not set. Please edit the script and set the PROJECT_PREFIX variable.${NC}"
    exit 1
fi

if [[ ! "$PROJECT_PREFIX" =~ ^[A-Z]{3}$ ]]; then
    echo -e "${RED}[ERROR] PROJECT_PREFIX must be exactly 3 uppercase letters (e.g., PLY, ABC, CON)${NC}"
    echo -e "${RED}Current value: '$PROJECT_PREFIX'${NC}"
    exit 1
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Path to the main installation script
INSTALL_SCRIPT_PATH="$SCRIPT_DIR/scripts/install-rules.sh"

# Check if installation script exists
if [ ! -f "$INSTALL_SCRIPT_PATH" ]; then
    echo -e "${RED}[ERROR] Installation script not found at: $INSTALL_SCRIPT_PATH${NC}"
    echo -e "${RED}Make sure you're running this script from the ProjectTemplate directory.${NC}"
    exit 1
fi

# Make installation script executable if needed
chmod +x "$INSTALL_SCRIPT_PATH" 2>/dev/null || true

# Confirm before proceeding
echo -e "${GREEN}Press any key to start installation, or Ctrl+C to cancel...${NC}"
read -n 1 -s -r
echo ""

# Run the installation script
if [ -n "$GIT_REPO_URL" ]; then
    bash "$INSTALL_SCRIPT_PATH" "$TARGET_PROJECT" "$PROJECT_PREFIX" "$GIT_REPO_URL"
else
    bash "$INSTALL_SCRIPT_PATH" "$TARGET_PROJECT" "$PROJECT_PREFIX"
fi

echo ""
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}Installation completed successfully!${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "${WHITE}1. Reload VS Code/Cursor${NC}"
echo -e "${WHITE}2. Test with: /specify test-feature${NC}"
echo -e "${WHITE}3. Review CLAUDE.md in your project${NC}"
echo ""
