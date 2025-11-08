#!/bin/bash

# BC27 MCP Server Setup Script
# Configures Model Context Protocol servers for Claude Code
# Usage: ./setup-mcp.sh [target_directory] [--github] [--filesystem] [--all]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Show usage
show_usage() {
    echo "BC27 MCP Server Setup"
    echo ""
    echo "Usage: $0 [target_directory] [--github] [--filesystem] [--search] [--all]"
    echo ""
    echo "Arguments:"
    echo "  target_directory : Path to your AL project (default: current directory)"
    echo "  --github         : Install GitHub MCP server"
    echo "  --filesystem     : Install Filesystem MCP server"
    echo "  --search         : Install Brave Search MCP server"
    echo "  --all            : Install all recommended MCP servers"
    echo ""
    echo "Examples:"
    echo "  $0 . --github --filesystem"
    echo "  $0 /path/to/project --all"
    echo ""
    exit 1
}

# Parse arguments
TARGET_DIR="${1:-.}"
INSTALL_GITHUB=false
INSTALL_FILESYSTEM=false
INSTALL_SEARCH=false

shift || true

while [[ $# -gt 0 ]]; do
    case $1 in
        --github)
            INSTALL_GITHUB=true
            shift
            ;;
        --filesystem)
            INSTALL_FILESYSTEM=true
            shift
            ;;
        --search)
            INSTALL_SEARCH=true
            shift
            ;;
        --all)
            INSTALL_GITHUB=true
            INSTALL_FILESYSTEM=true
            INSTALL_SEARCH=true
            shift
            ;;
        --help)
            show_usage
            ;;
        *)
            print_warning "Unknown option: $1"
            shift
            ;;
    esac
done

# If no options specified, show interactive menu
if [ "$INSTALL_GITHUB" = false ] && [ "$INSTALL_FILESYSTEM" = false ] && [ "$INSTALL_SEARCH" = false ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "         BC27 MCP Server Setup - Interactive"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Select MCP servers to install:"
    echo ""

    read -p "Install GitHub MCP (PR automation)? [Y/n] " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Nn]$ ]] && INSTALL_GITHUB=true

    read -p "Install Filesystem MCP (ESC validation)? [Y/n] " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Nn]$ ]] && INSTALL_FILESYSTEM=true

    read -p "Install Brave Search MCP (Latest BC27 docs)? [y/N] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] && INSTALL_SEARCH=true

    echo ""
fi

# Resolve target directory
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")"

if [ ! -d "$TARGET_DIR" ]; then
    print_error "Target directory does not exist: $TARGET_DIR"
    exit 1
fi

print_info "Target Directory: $TARGET_DIR"
echo ""

# Create .claude directory if needed
mkdir -p "$TARGET_DIR/.claude"

# Build mcp_settings.json
MCP_CONFIG="$TARGET_DIR/.claude/mcp_settings.json"

print_info "Creating MCP configuration..."

cat > "$MCP_CONFIG" << 'EOF'
{
  "mcpServers": {
EOF

FIRST=true

# Add GitHub MCP
if [ "$INSTALL_GITHUB" = true ]; then
    if [ "$FIRST" = false ]; then
        echo "," >> "$MCP_CONFIG"
    fi
    cat >> "$MCP_CONFIG" << 'EOF'
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
EOF
    FIRST=false
    print_success "Added GitHub MCP server"
fi

# Add Filesystem MCP
if [ "$INSTALL_FILESYSTEM" = true ]; then
    if [ "$FIRST" = false ]; then
        echo "," >> "$MCP_CONFIG"
    fi
    cat >> "$MCP_CONFIG" << EOF
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "$TARGET_DIR"],
      "env": {}
    }
EOF
    FIRST=false
    print_success "Added Filesystem MCP server"
fi

# Add Brave Search MCP
if [ "$INSTALL_SEARCH" = true ]; then
    if [ "$FIRST" = false ]; then
        echo "," >> "$MCP_CONFIG"
    fi
    cat >> "$MCP_CONFIG" << 'EOF'
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "${BRAVE_API_KEY}"
      }
    }
EOF
    FIRST=false
    print_success "Added Brave Search MCP server"
fi

# Close JSON
cat >> "$MCP_CONFIG" << 'EOF'
  }
}
EOF

print_success "MCP configuration created: $MCP_CONFIG"
echo ""

# Add to .gitignore if not already there
if [ -f "$TARGET_DIR/.gitignore" ]; then
    if ! grep -q "mcp_settings.json" "$TARGET_DIR/.gitignore"; then
        echo "mcp_settings.json" >> "$TARGET_DIR/.gitignore"
        print_info "Added mcp_settings.json to .gitignore"
    fi
    if ! grep -q "^.env$" "$TARGET_DIR/.gitignore"; then
        echo ".env" >> "$TARGET_DIR/.gitignore"
        print_info "Added .env to .gitignore"
    fi
fi

# Display environment variable setup instructions
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "         Next Steps: Configure Environment"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ "$INSTALL_GITHUB" = true ]; then
    echo "1. Create GitHub Personal Access Token:"
    echo "   - Go to: https://github.com/settings/tokens"
    echo "   - Create token with scopes: repo, workflow"
    echo "   - Add to ~/.bashrc or ~/.zshrc:"
    echo "     export GITHUB_TOKEN=\"ghp_your_token_here\""
    echo ""
fi

if [ "$INSTALL_SEARCH" = true ]; then
    echo "2. Get Brave Search API Key:"
    echo "   - Go to: https://brave.com/search/api/"
    echo "   - Sign up and get API key"
    echo "   - Add to ~/.bashrc or ~/.zshrc:"
    echo "     export BRAVE_API_KEY=\"your_api_key_here\""
    echo ""
fi

echo "3. Reload your shell:"
echo "   source ~/.bashrc  # or ~/.zshrc"
echo ""

echo "4. Restart VS Code/Cursor:"
echo "   code --reload"
echo ""

echo "5. Test MCP servers in Claude Code:"
if [ "$INSTALL_GITHUB" = true ]; then
    echo "   - \"List my GitHub repositories\""
fi
if [ "$INSTALL_FILESYSTEM" = true ]; then
    echo "   - \"Watch ./src directory for changes\""
fi
if [ "$INSTALL_SEARCH" = true ]; then
    echo "   - \"Search for latest BC27 events on Microsoft Learn\""
fi
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_success "MCP setup complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📚 Documentation:"
echo "   - Full guide: .claude/MCP_CONFIGURATION.md"
echo "   - Quick reference: .claude/RECOMMENDED_MCP_SERVERS.md"
echo "   - AI context: CLAUDE.md (section on MCP Servers)"
echo ""
