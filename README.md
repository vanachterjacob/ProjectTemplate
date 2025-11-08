# BC27 Development Template

Centralized configuration template for Business Central 27 (SaaS) extension development with AI-assisted coding (Cursor AI and Claude Code).

## 🎯 Purpose

This template provides BC27 extension developers with:
- **ESC Standards Compliance** - Automated enforcement of development standards
- **AI Context Files** - Cursor rules (.mdc) and Claude commands for intelligent assistance
- **BC27 Base Code Index** - Complete documentation of all 73 BC27 modules
- **Event Discovery** - 210+ events across 10 modules with keyword search and LLM guidance
- **Development Workflows** - Structured process from specification to implementation
- **Quality Automation** - Hooks for validation, security, and compliance checks

## 📋 Quick Start

### Prerequisites
- Visual Studio Code or Cursor IDE
- AL Language extension for VS Code
- Business Central 27 development environment
- Windows (primary support), Linux/Mac (community support)

### Installation

**Option 1: Quick Install (Recommended)**
```powershell
# Download this template
git clone https://github.com/yourorg/ProjectTemplate.git
cd ProjectTemplate

# Run installation wizard
.\install-to-project.ps1

# When prompted, enter:
# - Path to your AL project
# - Your 3-letter prefix (e.g., ABC, CON, FAB)
```

**Option 2: Manual Installation**
```bash
# Copy template files to your project
cp -r .cursor/rules/ /path/to/your-project/.cursor/rules/
cp -r .claude/commands/ /path/to/your-project/.claude/commands/
cp -r BC27/ /path/to/your-project/BC27/
cp CLAUDE.md .cursorignore /path/to/your-project/

# Update prefix in all files (replace ABC with your prefix)
find /path/to/your-project/.cursor -type f -exec sed -i 's/ABC/YOUR_PREFIX/g' {} \;
```

**Option 3: Via Claude Code**
```bash
# In Claude Code CLI
/auto-install-rules
```

### Configuration

After installation:
1. **Reload IDE** - Restart Cursor/VS Code to activate rules
2. **Verify Prefix** - Check `.cursor/rules/000-project-overview.mdc` has your prefix
3. **Check app.json** - Ensure object ID ranges are configured
4. **Test Workflow** - Run `/specify test-feature` to verify installation

## 🚀 Development Workflow

### Step-by-Step Process

```bash
# 1. Create feature specification (user-focused)
/specify customer-credit-limit

# 2. Create technical plan (architecture)
/plan customer-credit-limit

# 3. Break into tasks (implementation steps)
/tasks customer-credit-limit all

# 4. Implement code (sequential execution)
/implement customer-credit-limit next

# 5. Review code (ESC compliance check)
/review src/CustomerCredit/

# 6. Commit changes
git add .
git commit -m "feat: add customer credit limit feature"
```

### Available Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `/specify` | Create user specification | `/specify feature-name` |
| `/plan` | Create technical architecture | `/plan feature-name` |
| `/tasks` | Break plan into tasks | `/tasks feature-name all` |
| `/implement` | Write code from tasks | `/implement feature-name next` |
| `/review` | ESC compliance check | `/review src/` |
| `/update_doc` | Maintain documentation | `/update_doc update` |

## 📁 Template Structure

```
ProjectTemplate/
├── README.md                          # This file (human-readable guide)
├── CLAUDE.md                          # AI context (for LLMs only)
├── QUICKSTART.md                      # 5-minute quick start guide
│
├── .cursor/                           # Cursor IDE configuration
│   ├── rules/                         # MDC rules (auto-loaded by AI)
│   │   ├── 000-project-overview.mdc  # Always applied
│   │   ├── 001-naming-conventions.mdc # For *.al files
│   │   ├── 002-development-patterns.mdc # For *.al files
│   │   ├── 003-document-extensions.mdc # For *Sales*, *Purchase*
│   │   ├── 004-performance.mdc       # For *.al files
│   │   ├── 005-bc26-symbols.mdc      # @-mention only
│   │   ├── 006-tools-review.mdc      # @-mention only
│   │   ├── 007-deployment-security.mdc # For *Install*, *Upgrade*
│   │   ├── 008-bc27-quick-reference.mdc # Auto-loads for *.al
│   │   └── 009-bc27-architecture.mdc  # @-mention only
│   │
│   └── hooks/                         # Quality & security automation
│       ├── after-file-edit.ps1       # ESC validation
│       ├── before-read-file.ps1      # Security (sensitive files)
│       ├── before-commit.ps1         # Secret scanning
│       └── README.md                 # Hook setup guide
│
├── .claude/                           # Claude Code configuration
│   ├── commands/                      # Slash commands (/specify, /plan, etc.)
│   ├── settings.json                  # Team-shared configuration
│   └── settings.local.example.json    # Personal overrides template
│
├── BC27/                              # Complete BC27 base code index (17 files)
│   ├── BC27_INDEX_README.md          # Navigation guide (start here)
│   ├── BC27_ARCHITECTURE.md          # System design & patterns
│   ├── BC27_MODULES_OVERVIEW.md      # All 73 modules detailed
│   ├── BC27_MODULES_BY_CATEGORY.md   # Organized by function
│   ├── BC27_DEPENDENCY_REFERENCE.md  # Module relationships
│   ├── BC27_FEATURES_INDEX.md        # 200+ features matrix
│   ├── BC27_INTEGRATION_GUIDE.md     # External integrations
│   ├── BC27_EVENT_CATALOG.md         # Core posting & document events (~50)
│   ├── BC27_EVENT_INDEX.md           # Master keyword index (210+ events)
│   ├── BC27_EXTENSION_POINTS.md      # Table/page extension patterns
│   └── events/                        # Module-specific event catalogs (7 files)
│       ├── BC27_EVENTS_MANUFACTURING.md  # 30+ production events
│       ├── BC27_EVENTS_SERVICE.md        # 20+ service events
│       ├── BC27_EVENTS_JOBS.md           # 15+ jobs events
│       ├── BC27_EVENTS_API.md            # 25+ API events
│       ├── BC27_EVENTS_FIXEDASSETS.md    # 15+ FA events
│       ├── BC27_EVENTS_WAREHOUSE.md      # 18+ warehouse events
│       └── BC27_EVENTS_ASSEMBLY.md       # 12+ assembly events
│
└── src/                               # Your AL source code (when present)
    ├── AGENTS.md                      # Auto-loaded context
    └── _Examples/                     # Example implementations
        ├── CustomerCredit/            # Complete feature example
        └── AGENTS.md                  # Module-specific context
```

## 🎓 Learning Resources

### BC27 Documentation
- **Quick Start:** `BC27/BC27_INDEX_README.md` - Navigation guide
- **Architecture:** `BC27/BC27_ARCHITECTURE.md` - System design
- **Modules:** `BC27/BC27_MODULES_OVERVIEW.md` - All 73 modules
- **Features:** `BC27/BC27_FEATURES_INDEX.md` - Complete feature matrix

### Event Discovery (Extension Points)
- **Event Index:** `BC27/BC27_EVENT_INDEX.md` - Search 210+ events by keyword
- **Core Events:** `BC27/BC27_EVENT_CATALOG.md` - Posting & document events
- **Extension Points:** `BC27/BC27_EXTENSION_POINTS.md` - Table/page patterns
- **Module Events:** `BC27/events/BC27_EVENTS_*.md` - 7 module-specific catalogs
- **Discovery Guide:** `.cursor/rules/010-event-discovery.mdc` - How to find any event

### ESC Standards
- **Naming:** `.cursor/rules/001-naming-conventions.mdc`
- **Patterns:** `.cursor/rules/002-development-patterns.mdc`
- **Performance:** `.cursor/rules/004-performance.mdc`
- **Security:** `.cursor/rules/007-deployment-security.mdc`

### Development Context
- **AI Context:** `CLAUDE.md` - Complete guide for AI assistants
- **Quick Start:** `QUICKSTART.md` - 5-minute setup guide
- **Hooks:** `.cursor/hooks/README.md` - Automation setup

## ✅ ESC Standards Checklist

Before every commit, verify:
- [ ] **Prefix** - ABC (or your prefix) used consistently
- [ ] **English-only** - No Dutch in code or comments
- [ ] **Early exit** - Avoid nested if statements
- [ ] **TryFunction** - All error-prone operations wrapped
- [ ] **ConfirmManagement** - Never use Confirm() directly
- [ ] **SetLoadFields** - Only for read-only operations
- [ ] **Document extensions** - ALL tables/pages extended (Sales/Purchase)
- [ ] **Performance** - Tested with production-scale data
- [ ] **LinterCop** - All warnings resolved

## 🔧 Configuration

### Project-Specific Settings

Edit `.cursor/rules/000-project-overview.mdc`:
```yaml
- **Publisher:** [Your Publisher Name]
- **Prefix:** ABC
- **BC Version:** 27 (SaaS)
```

### Object ID Ranges

Edit `app.json`:
```json
{
  "idRanges": [
    {
      "from": 77100,
      "to": 77200
    }
  ]
}
```

**Note:** Use dummy range (77100-77200) during development. Object Ninja assigns production IDs from customer range.

### BC27 Symbols Location

**Default:** `C:\Temp\BC26Objects\BaseApp` (also valid for BC27)

If symbols are in different location, update `.claude/settings.json`:
```json
{
  "environmentVariables": {
    "BC_SYMBOLS_PATH": "C:\\Your\\Path\\To\\Symbols"
  }
}
```

## 🛡️ Security & Quality

### Automated Checks
- **after-file-edit.ps1** - Validates ESC standards after AI edits
- **before-read-file.ps1** - Blocks reading sensitive files (.env, credentials)
- **before-commit.ps1** - Scans for secrets before commit

### Permission Model
**Team-shared** (settings.json):
- ✅ Allow: Read symbols, dotnet build, WebFetch (trusted domains)
- 🛑 Deny: Write .git/, app.json, .alpackages/
- ❓ Ask: Edit app.json, git push, git reset --hard

**Personal** (settings.local.json):
- Customize per developer
- Override team settings as needed

## 🐛 Troubleshooting

### Installation Issues
```powershell
# Script fails - run as administrator
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# Prefix not replaced - check sed/PowerShell availability
Get-Command sed

# Hooks not working - verify path
Test-Path ~/.cursor/hooks.json
```

### Runtime Issues
```bash
# Rules not loading - reload IDE
Ctrl+Shift+P → "Developer: Reload Window"

# Symbols not found - verify path exists
Test-Path C:\Temp\BC26Objects\BaseApp

# Hook errors - check PowerShell execution policy
Get-ExecutionPolicy
```

### Common Errors
- **"ABC prefix violation"** → Update `.cursor/rules/000-project-overview.mdc`
- **"SetLoadFields before Modify"** → See `.cursor/rules/004-performance.mdc`
- **"Incomplete document extension"** → See `.cursor/rules/003-document-extensions.mdc`

## 🤝 Contributing

Improvements welcome! Guidelines:
1. Keep rule files <150 lines where possible
2. Test with Cursor AI and Claude Code
3. Use concrete examples (not abstract descriptions)
4. Update README.md and CLAUDE.md
5. Document new features thoroughly

## 📄 License

This template is free to use for Business Central development projects.

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/yourorg/ProjectTemplate/issues)
- **Discussions:** [GitHub Discussions](https://github.com/yourorg/ProjectTemplate/discussions)
- **Documentation:** See `CLAUDE.md` for complete AI context

---

**Version:** 3.1.0
**BC Version:** 27 (SaaS) - Compatible with BC26+
**Last Updated:** 2025-11-08
**Focus:** BC27 with forward compatibility

### Version History
- **v3.1.0** (2025-11-08): BC27 event catalog expansion - 210+ events across 10 modules
  - Added 3 module-specific event catalogs (Fixed Assets, Warehouse, Assembly)
  - Enhanced event discovery with keyword search index
  - Added LLM guidance for finding undocumented events
- **v3.0.0** (2025-11-07): Major refactor - BC27 focus, English docs, improved structure
  - Added initial event catalogs (Manufacturing, Service, Jobs, API)
  - Added BC27_EVENT_CATALOG.md and BC27_EXTENSION_POINTS.md
- **v2.2.0** (2025-11-07): BC27 comprehensive base code index (73 modules)
- **v2.1.0** (2025-11-07): Automated installation system
- **v2.0.0** (2025-11-07): Hooks, subagents, skills
- **v1.0.0** (2025-11-07): Initial release
