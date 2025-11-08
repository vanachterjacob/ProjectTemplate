# MCP (Model Context Protocol) Configuration Guide

**Purpose:** Extend Claude Code capabilities with MCP servers for BC27 development.

## What are MCP Servers?

MCP servers are plugins that give Claude new capabilities beyond built-in tools:
- Database access (query BC tables directly)
- GitHub integration (PRs, issues, code reviews)
- File watching (real-time ESC compliance)
- Web scraping (latest Microsoft Learn docs)
- Custom tools (BC-specific analyzers)

## Recommended MCP Servers for BC27 Development

### 1. GitHub MCP Server ⭐ HIGH PRIORITY

**Purpose:** Automate PR creation, issue tracking, code reviews

**Installation:**
```bash
# Install via npm
npm install -g @modelcontextprotocol/server-github

# Or use npx (no install needed)
npx -y @modelcontextprotocol/server-github
```

**Configuration (.claude/mcp_settings.json):**
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

**Usage:**
```markdown
# After /implement completes
Create PR for feature XYZ with ESC compliance checklist

# Track issues
List open BC27 extension issues assigned to me

# Code review
Review PR #123 for ESC standards compliance
```

**Benefits for BC27:**
- Auto-create PRs after `/implement` with ESC checklist
- Link commits to BC work items
- Auto-review for naming conventions violations

---

### 2. Filesystem MCP Server ⭐ HIGH PRIORITY

**Purpose:** Real-time monitoring of AL file changes

**Installation:**
```bash
npm install -g @modelcontextprotocol/server-filesystem
```

**Configuration:**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/bc27/project"],
      "env": {}
    }
  }
}
```

**Usage:**
```markdown
# Auto-trigger on file save
Watch src/ directory for AL file changes and validate ESC standards

# Monitor specific patterns
Alert when SetLoadFields is used in write operations
```

**Benefits for BC27:**
- Proactive ESC compliance warnings
- Detect prefix violations immediately
- Monitor app.json changes (ID ranges)

---

### 3. Web Search/Scraper MCP

**Purpose:** Fetch latest BC27 docs from Microsoft Learn

**Installation:**
```bash
npm install -g @modelcontextprotocol/server-brave-search
# Or use built-in WebFetch/WebSearch (already available)
```

**Configuration:**
```json
{
  "mcpServers": {
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "${BRAVE_API_KEY}"
      }
    }
  }
}
```

**Usage:**
```markdown
# Check latest BC27 events
Search Microsoft Learn for "Business Central 27 Sales Post event"

# Verify API changes
Check if OnAfterPostSalesDoc signature changed in BC27
```

**Benefits for BC27:**
- Always current event signatures
- Breaking changes detection
- New BC27 features discovery

---

### 4. Database/SQL MCP (PostgreSQL/SQL Server)

**Purpose:** Query BC27 database directly for schema analysis

**Installation:**
```bash
npm install -g @modelcontextprotocol/server-postgres
# Or SQL Server variant
```

**Configuration:**
```json
{
  "mcpServers": {
    "database": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "PGHOST": "localhost",
        "PGDATABASE": "BCDEMO",
        "PGUSER": "${DB_USER}",
        "PGPASSWORD": "${DB_PASSWORD}"
      }
    }
  }
}
```

**Usage:**
```markdown
# Validate table extensions
Show me the schema for "Sales Header" table

# Test SetLoadFields
Execute this query and verify only requested fields are loaded

# Performance analysis
Show execution plan for my custom ledger query
```

**Benefits for BC27:**
- Validate table extension compatibility
- Test performance patterns before deploy
- Schema-driven code generation

---

### 5. Custom BC27 Event Discovery MCP (Future)

**Purpose:** Specialized MCP for BC event discovery and subscription

**Concept:**
```json
{
  "mcpServers": {
    "bc27-events": {
      "command": "node",
      "args": ["./mcp-servers/bc27-events/index.js"],
      "env": {
        "BC_SYMBOLS_PATH": "${BC_SYMBOLS_PATH}"
      }
    }
  }
}
```

**Capabilities:**
- Parse BC symbols for all events
- Generate event subscriber templates
- Validate event signatures
- Find related events (e.g., all sales posting events)

**Status:** 🚧 Potential future enhancement

---

## Installation Instructions

### Step 1: Create MCP Settings File

Create `.claude/mcp_settings.json` in your BC27 project:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "${PROJECT_ROOT}"],
      "env": {}
    }
  }
}
```

### Step 2: Set Environment Variables

Add to your shell profile (`.bashrc`, `.zshrc`, or `.profile`):

```bash
# GitHub MCP
export GITHUB_TOKEN="ghp_your_token_here"

# BC27 Symbols
export BC_SYMBOLS_PATH="/path/to/bc27/symbols"

# Project root (auto-detected by Claude Code)
export PROJECT_ROOT="$(pwd)"
```

### Step 3: Restart Claude Code

```bash
# Reload VS Code/Cursor to activate MCP servers
code --reload

# Or restart Claude Code CLI
claude-code --reload
```

### Step 4: Verify MCP Servers

```markdown
# Ask Claude to list available MCP tools
What MCP servers are active?

# Test GitHub MCP
List my GitHub repositories

# Test filesystem MCP
Watch ./src directory for changes
```

---

## Integration with BC27 Template

### Auto-Install MCP Servers

Update `install-rules.sh` to optionally install MCP:

```bash
# Run installation with MCP setup
bash scripts/install-rules.sh /path/to/project ABC --with-mcp

# Manual MCP setup later
bash scripts/setup-mcp.sh
```

### Workflow Integration

**Before:**
```markdown
/implement customer-ledger-entries next
# Claude writes code
# You manually create PR
# You manually review ESC compliance
```

**After (with MCP):**
```markdown
/implement customer-ledger-entries next
# Claude writes code
# GitHub MCP: Auto-creates PR with ESC checklist
# Filesystem MCP: Validates ESC standards in real-time
# Database MCP: Verifies ledger schema compatibility
```

---

## Best Practices

### 1. Security
```bash
# NEVER commit tokens to git
echo "mcp_settings.json" >> .gitignore
echo ".env" >> .gitignore

# Use environment variables
export GITHUB_TOKEN="${GITHUB_TOKEN}"
```

### 2. Performance
```markdown
# Don't load all MCP servers at once
# Enable only what you need for current task

# Sales feature → GitHub MCP only
# Performance review → Database MCP only
# ESC compliance → Filesystem MCP only
```

### 3. Testing
```markdown
# Test MCP in isolation before workflows
List GitHub repos
Watch ./src for changes

# Then integrate with /implement
```

---

## Troubleshooting

### MCP Server Not Found
```bash
# Verify npm packages installed
npm list -g | grep @modelcontextprotocol

# Reinstall if missing
npm install -g @modelcontextprotocol/server-github
```

### Authentication Errors
```bash
# Check environment variables
echo $GITHUB_TOKEN
echo $BC_SYMBOLS_PATH

# Verify token has correct scopes
# GitHub: repo, workflow, admin:org
```

### Claude Can't Access MCP
```bash
# Restart Claude Code
code --reload

# Check MCP settings file exists
ls -la .claude/mcp_settings.json

# Validate JSON syntax
cat .claude/mcp_settings.json | jq
```

---

## Roadmap

**Phase 1: Essential MCP (Current)**
- ✅ GitHub MCP for PR automation
- ✅ Filesystem MCP for ESC validation
- ⏳ Documentation in CLAUDE.md

**Phase 2: BC27-Specific MCP (Future)**
- 🚧 Custom event discovery MCP
- 🚧 AL code analyzer MCP
- 🚧 ESC compliance MCP server

**Phase 3: Advanced Integration (Future)**
- 🚧 Auto-deploy to BC27 sandbox via MCP
- 🚧 Integration with Object Ninja via MCP
- 🚧 LinterCop automation via MCP

---

## Resources

**Official MCP Documentation:**
- https://github.com/anthropics/anthropic-mcp
- https://modelcontextprotocol.io/

**Available MCP Servers:**
- GitHub: https://github.com/modelcontextprotocol/servers/tree/main/src/github
- Filesystem: https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem
- PostgreSQL: https://github.com/modelcontextprotocol/servers/tree/main/src/postgres
- Brave Search: https://github.com/modelcontextprotocol/servers/tree/main/src/brave-search

**BC27 Template:**
- CLAUDE.md - AI context overview
- LLM_OPTIMIZATION_GUIDE.md - Token efficiency
- .claude/skills/context-presets/ - Fast context loading

---

**Version:** 1.0.0
**Last Updated:** 2025-01-08
**Maintained by:** BC27 Development Template Project
