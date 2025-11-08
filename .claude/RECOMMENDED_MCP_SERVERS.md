# Recommended MCP Servers for BC27 Development

Quick reference for installing and using MCP servers with this template.

## Priority 1: Essential for BC27 Workflow

### 1. GitHub MCP Server ⭐⭐⭐

**Install:**
```bash
# No installation needed - uses npx
npx -y @modelcontextprotocol/server-github
```

**Setup (.claude/mcp_settings.json):**
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

**BC27 Use Cases:**
- Auto-create PRs after `/implement` with ESC compliance checklist
- Track BC extension issues and work items
- Automated code reviews for naming conventions
- Link commits to customer requirements

**Example:**
```markdown
# After implementing a feature
Create PR for "Customer Credit Limit Extension" with:
- Title: "feat(sales): Add credit limit validation to sales orders"
- Body: ESC compliance checklist (prefix, patterns, performance)
- Reviewers: @team-lead
```

---

### 2. Filesystem MCP Server ⭐⭐⭐

**Install:**
```bash
npx -y @modelcontextprotocol/server-filesystem
```

**Setup:**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "."],
      "env": {}
    }
  }
}
```

**BC27 Use Cases:**
- Real-time ESC compliance validation on file save
- Monitor app.json for ID range violations
- Detect ABC prefix inconsistencies
- Alert on security anti-patterns (Confirm vs ConfirmManagement)

**Example:**
```markdown
# Proactive monitoring
Watch ./src directory and alert if:
- SetLoadFields used before Modify()
- English-only rule violated (Dutch comments/vars)
- Early exit pattern missing in long procedures
```

---

## Priority 2: Performance & Quality

### 3. Brave Search MCP (Alternative to WebFetch) ⭐⭐

**Install:**
```bash
npx -y @modelcontextprotocol/server-brave-search
```

**Setup:**
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

**BC27 Use Cases:**
- Verify latest BC27 event signatures on Microsoft Learn
- Check for breaking changes in BC updates
- Search ESC compliance guidelines
- Find BC community solutions (mibuso, yammer)

**Example:**
```markdown
# Before using an event
Search "Business Central 27 OnAfterPostSalesDoc signature" on Microsoft Learn
Verify parameters match our BC27_EVENT_CATALOG.md
```

**Note:** Built-in `WebFetch` and `WebSearch` tools may be sufficient. Only add if you need more control.

---

## Priority 3: Database Analysis (Optional)

### 4. PostgreSQL/SQL Server MCP ⭐

**Install:**
```bash
# For PostgreSQL
npx -y @modelcontextprotocol/server-postgres

# For SQL Server (community MCP - check availability)
# npm install -g mcp-server-mssql
```

**Setup (PostgreSQL example):**
```json
{
  "mcpServers": {
    "database": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "PGHOST": "localhost",
        "PGPORT": "5432",
        "PGDATABASE": "BCDEMO",
        "PGUSER": "${DB_USER}",
        "PGPASSWORD": "${DB_PASSWORD}"
      }
    }
  }
}
```

**BC27 Use Cases:**
- Validate table extension field types match base table
- Test SetLoadFields performance impact
- Analyze custom ledger query plans
- Schema-driven code generation

**Example:**
```markdown
# Before extending Sales Header
Show schema for "Sales Header" table in BC27
Verify field 77100 (ABC_CustomField) doesn't conflict

# Performance testing
Execute this query with SetLoadFields and show execution plan
```

**⚠️ Security Warning:**
- Only connect to development/test databases
- NEVER use production credentials
- Add database MCP config to `.gitignore`

---

## Priority 4: Future BC27-Specific MCP

### 5. Custom BC27 Event Discovery MCP 🚧 (To Be Built)

**Concept:**
A specialized MCP server that:
- Parses BC27 symbol files for all events
- Generates event subscriber code templates
- Validates event signatures against base app
- Discovers related events (e.g., all sales posting events)

**Potential Implementation:**
```javascript
// mcp-servers/bc27-events/index.js
const { Server } = require('@modelcontextprotocol/sdk');

class BC27EventDiscoveryServer extends Server {
  async findEvents(query) {
    // Parse BC symbols for events matching query
    const symbolsPath = process.env.BC_SYMBOLS_PATH;
    // ... parse and return events
  }

  async generateSubscriber(eventName) {
    // Generate ESC-compliant event subscriber template
    // ... with prefix, error handling, early exit
  }
}
```

**BC27 Use Cases:**
- `/find-events sales posting` → Lists all sales posting events
- `Generate subscriber for OnAfterPostSalesDoc` → ESC template
- `Validate subscriber signatures` → Check against symbols

**Status:** Concept only - not yet implemented

**Alternative (Current):** Use existing workflow in `010-event-discovery.mdc`

---

## Quick Setup Guide

### Step 1: Create MCP Settings

Create `.claude/mcp_settings.json`:

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
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "."],
      "env": {}
    }
  }
}
```

### Step 2: Set Environment Variables

```bash
# Add to ~/.bashrc or ~/.zshrc
export GITHUB_TOKEN="ghp_your_token_here"
export BC_SYMBOLS_PATH="/c/Temp/BC26Objects/BaseApp"
```

### Step 3: Add to .gitignore

```bash
echo "mcp_settings.json" >> .gitignore
echo ".env" >> .gitignore
```

### Step 4: Test MCP

```markdown
# In Claude Code
List my GitHub repositories
Watch ./src for AL file changes
```

---

## MCP + BC27 Template = Maximum Efficiency

### Without MCP (Current Workflow)
```markdown
1. /specify feature-name
2. /plan feature-name
3. /tasks feature-name data-model
4. /implement feature-name next
5. Manually create PR
6. Manually run ESC checks
7. Manually verify events
```

**Time:** ~2-3 hours for medium feature

### With MCP (Enhanced Workflow)
```markdown
1. /specify feature-name
2. /plan feature-name (with event search via MCP)
3. /tasks feature-name data-model
4. /implement feature-name next
   → Filesystem MCP validates ESC in real-time
   → GitHub MCP auto-creates PR with checklist
   → Database MCP verifies schema compatibility
```

**Time:** ~1-1.5 hours for same feature (40-50% faster!)

---

## Recommended Combination

**For Most BC27 Projects:**
```json
{
  "mcpServers": {
    "github": { ... },      // Essential for PR automation
    "filesystem": { ... }   // Essential for ESC validation
  }
}
```

**For Advanced BC27 Projects:**
```json
{
  "mcpServers": {
    "github": { ... },      // PR automation
    "filesystem": { ... },  // ESC validation
    "brave-search": { ... }, // Latest docs
    "database": { ... }     // Schema validation (dev DB only!)
  }
}
```

---

## Resources

- **Full Guide:** `.claude/MCP_CONFIGURATION.md`
- **MCP Documentation:** https://modelcontextprotocol.io/
- **Available Servers:** https://github.com/modelcontextprotocol/servers
- **BC27 Template:** `CLAUDE.md` for AI context

---

**Last Updated:** 2025-01-08
**Version:** 1.0.0
