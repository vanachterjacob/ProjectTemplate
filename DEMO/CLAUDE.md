# BC26 Development Template - Claude Context

## Project Purpose
Centralized configuration template for Business Central 26 (SaaS) extension development with Claude Code and Cursor integration.

## Key Information
- **Prefix:** CON (MUST be replaced with 3-letter customer code per project)
- **BC Version:** 26 SaaS
- **Object ID Range:** 77100-77200 (dummy range, replaced by Object Ninja for production)
- **Symbols Location:** C:\Temp\BC26Objects\BaseApp
- **Publisher:** [Your Publisher Name] (replace in 000-project-overview.mdc)

## Quick Start - Installing Template into AL Project

**New Project Setup:**
1. `/auto-install-rules` - Interactive installer (asks for target dir + prefix)
   - OR run directly: `bash scripts/install-rules.sh <target_dir> <prefix> [repo_url]`
   - OR Windows: `powershell scripts/install-rules.ps1 -TargetDirectory <path> -ProjectPrefix <prefix>`
2. Reload VS Code/Cursor to activate configuration
3. Test with `/specify test-feature`

**What Gets Installed:**
- `.cursor/rules/` - ESC standards (auto-loaded by file patterns)
- `.cursor/hooks/` - Quality & security hooks
- `.claude/commands/` - Workflow slash commands
- `CLAUDE.md` - AI context documentation
- `.cursorignore` - File exclusions
- `~/.cursor/hooks.json` - Hooks configuration
- All CON prefixes replaced with your project prefix

**Git Integration:**
- Optionally pull latest template from public repo
- Script warns before overwriting existing files

## Development Workflow
1. `/specify [feature-name]` - Create user-focused specification
2. `/plan [spec-name]` - Create technical architecture plan
3. `/tasks [plan-name] [phase]` - Break plan into code tasks
4. `/implement [task-file] [task-id|next]` - Implement code sequentially
5. `/review [file-or-folder-path]` - ESC compliance check
6. `/update_doc [init|update]` - Maintain .agent/ documentation

## Critical ESC Standards
**ALWAYS enforce these rules:**
- ✅ Use CON prefix consistently (customer-specific, replace CON with actual prefix)
- ✅ English-only development (no Dutch in code)
- ✅ Early exit pattern mandatory (avoid nested if statements)
- ✅ TryFunction for all error handling
- ✅ ConfirmManagement.GetResponseOrDefault() instead of Confirm()
- ✅ SetLoadFields ONLY for read-only operations (never before Modify/Insert/Delete)
- ✅ Complete document extensions (ALL Sales/Purchase tables and pages)
- ✅ Performance tested with production-scale data
- ✅ LinterCop compliant

## File Structure
```
ProjectTemplate/
├── CLAUDE.md                    # This file - AI context
├── .cursorignore                # Files excluded from AI context/indexing
│
├── .cursor/                     # Cursor AI configuration
│   ├── rules/                   # MDC rules (auto-loaded by file pattern)
│   │   ├── 000-project-overview.mdc      # Always applied
│   │   ├── 001-naming-conventions.mdc    # For src/**/*.al
│   │   ├── 002-development-patterns.mdc  # For src/**/*.al
│   │   ├── 003-document-extensions.mdc   # For *Sales*, *Purchase*
│   │   ├── 004-performance.mdc           # For src/**/*.al
│   │   ├── 005-bc26-symbols.mdc          # @-mention only
│   │   ├── 006-tools-review.mdc          # @-mention only
│   │   └── 007-deployment-security.mdc   # For *Install*, *Upgrade*
│   │
│   └── hooks/                   # Cursor Agent hooks (validation, security)
│       ├── hooks.example.json   # Copy to ~/.cursor/hooks.json
│       ├── after-file-edit.ps1  # ESC validation after edits
│       ├── before-read-file.ps1 # Block sensitive files
│       ├── before-shell-execution.ps1  # Prevent dangerous commands
│       ├── after-agent-response.ps1    # Usage analytics
│       └── README.md            # Hook installation guide
│
├── .claude/                     # Claude Code configuration
│   ├── commands/                # Slash commands for workflows
│   ├── subagents/              # Specialized AI agents
│   ├── skills/                 # Auto-invoked capabilities
│   ├── settings.json           # Team-shared settings
│   └── settings.local.json     # Personal overrides
│
├── .agent/                      # Generated documentation (created by commands)
│   ├── specs/                  # User-focused specifications
│   ├── plans/                  # Technical plans
│   ├── tasks/                  # Task breakdowns
│   └── README.md               # Documentation index
│
└── src/                         # AL source code (when present in project)
    ├── AGENTS.md                # Auto-loaded context for src/ files
    └── _Examples/               # Example code patterns
        └── AGENTS.md            # Module-specific context
```

## ESC Standards Reference
**Cursor rules load intelligently based on file patterns:**
- **000-project-overview.mdc** - Always loaded (project basics)
- **001-naming-conventions.mdc** - Auto-loads for *.al files
- **002-development-patterns.mdc** - Auto-loads for *.al files
- **003-document-extensions.mdc** - Auto-loads for *Sales*, *Purchase*, *Document* files
- **004-performance.mdc** - Auto-loads for *.al files
- **005-bc26-symbols.mdc** - Load via @-mention when needed (avoids context bloat)
- **006-tools-review.mdc** - Load via @-mention for code review
- **007-deployment-security.mdc** - Auto-loads for *Install*, *Upgrade*, *Permission* files

**AGENTS.md files (lightweight context):**
- **src/AGENTS.md** - Auto-loads when working in src/ directory
- **src/ModuleName/AGENTS.md** - Add module-specific context as needed

## Local Resources
- **BC26 Base Symbols:** C:\Temp\BC26Objects\BaseApp (Microsoft 26.3.36158.37931)
- **Additional Modules:** ALAppExtensions, BCIntrastatCore, Continia modules
- **No MCP Dependencies:** Fully offline capable
- **Access via:** Read(//mnt/c/Temp/BC26Objects/**) or Read(//c/Temp/BC26Objects/**)

## Object Naming Patterns
**Tables:**
- `CON <Object Name>` (e.g., `CON Customer Credit`)
- Extension: `CON <Base Object Name>` (e.g., `CON Customer`)

**Pages:**
- Card: `CON <Entity> Card`
- List: `CON <Entity> List`
- Document: `CON <Doc Type> <Doc Name>` (e.g., `CON Sales Invoice`)

**Codeunits:**
- Business Logic: `CON <Feature> Mgt.`
- Event Subscribers: `CON <Feature> Subscribers`
- Install/Upgrade: `CON Install`, `CON Upgrade`

**Variables:**
- Record: `<TableName>` (e.g., `Customer`, `SalesHeader`)
- Multiple: `<TableName>2` or descriptive (e.g., `ShipToCustomer`)
- Temporary: `Temp<TableName>` (e.g., `TempItemLedgerEntry`)

## Performance Rules
**Read Operations:**
- ❌ NEVER use SetLoadFields before Modify(), Insert(), Delete()
- ✅ ONLY use SetLoadFields for read-only queries
- ✅ Use FindSet(false, false) for read-only iterations
- ✅ Limit query results, avoid full table scans

**Complexity:**
- Max cyclomatic complexity: 15
- Max method length: 150 lines
- Avoid nested loops with large datasets
- Background processing for operations >5 seconds

## Document Extension Checklist
**When extending Sales/Purchase documents, ALWAYS extend ALL:**

**Tables:** Header, Line, Comment Line, Header Archive, Line Archive
**Pages:** Document, Document Subform, List, Card (if applicable), Statistics, Posted versions
**Reports/Events:** Validate events, Post events, Print events

**Incomplete extensions = Critical ESC violation**

## Tools Integration
- **Object Ninja:** Final ID assignment from customer range
- **LinterCop:** Continuous compliance checking (LC0011, LC0007, LC0034, etc.)
- **XLIFF Sync:** Translation management (only tool for translations)
- **AL Extensions:** Use `waldo.crs-al-language-extension` for snippets

## Git Workflow
**NEVER include in commits:**
- Build artifacts (/.alpackages/, *.app)
- Local settings (/.vscode/, /.vs/)
- Symbol caches
- Temporary files

**DO commit:**
- Source code (/src/)
- Configuration files (app.json, .ruleset.json)
- Cursor rules (/.cursor/rules/)
- Claude commands (/.claude/commands/)
- Documentation (README.md, CLAUDE.md)

## Security Patterns
- ✅ Always validate permissions before operations
- ✅ Use SecretText for sensitive data
- ✅ Validate all external inputs
- ✅ Implement proper error messages (no sensitive data leak)
- ✅ Test with limited permission sets

## Integration Best Practices
- ✅ Exponential backoff for retries (2s, 4s, 8s, 16s)
- ✅ Always verify API call results
- ✅ Implement timeout handling
- ✅ Log integration errors properly
- ✅ Use TryFunction for external calls

## When Starting New Feature
1. **Load context:** Read .cursor/rules/000-project-overview.mdc for current PREFIX
2. **Verify symbols:** Confirm C:\Temp\BC26Objects access
3. **Check app.json:** Verify available ID range
4. **Follow workflow:** /specify → /plan → /tasks → /implement
5. **Review standards:** Reference relevant .cursor/rules/*.mdc files
6. **Final review:** Run /review before committing

## Common Mistakes to Avoid
❌ Using Confirm() instead of ConfirmManagement
❌ SetLoadFields before Modify/Insert/Delete operations
❌ Incomplete document extensions (missing tables/pages)
❌ Dutch language in code or comments
❌ Manually assigning production object IDs
❌ Nested if statements instead of early exit
❌ Missing TryFunction for error-prone operations
❌ Performance testing only with small datasets

## Template Customization
**For each new project:**
1. Replace `CON` with actual 3-letter customer prefix in 000-project-overview.mdc
2. Update `[Your Publisher Name]` in 000-project-overview.mdc
3. Configure app.json with correct ID ranges
4. Verify BC26 symbols path accessibility
5. Review and adjust .claude/settings.json permissions
6. Test workflow with simple feature (/specify → /implement)

## Cursor Advanced Features

### Hooks (Quality & Security)
**Location:** `.cursor/hooks/` (copy to `~/.cursor/hooks.json` to activate)

**Available hooks:**
- `after-file-edit.ps1` - ESC validation after AI edits code
- `before-read-file.ps1` - Block sensitive files (.env, *.app, credentials)
- `before-shell-execution.ps1` - Prevent dangerous git operations
- `after-agent-response.ps1` - Usage analytics and cost tracking

**Benefits:**
- ✅ Automatic ESC standard validation
- ✅ Security: blocks reading of sensitive files
- ✅ Safety: prevents force push, hard reset
- ✅ Analytics: track token usage and costs

**Installation:** See `.cursor/hooks/README.md`

### File Exclusions (.cursorignore)
**Location:** `.cursorignore` in project root

**Purpose:** Exclude files from AI context and indexing:
- Build artifacts (*.app, .alpackages/)
- Symbols (too large, use local C:\Temp)
- Sensitive files (.env, credentials.json)
- Large data files (*.csv, *.xlsx)

**Benefits:**
- ✅ Faster AI responses (less context)
- ✅ Lower costs (fewer tokens)
- ✅ Better accuracy (no noise from build artifacts)
- ✅ Security (sensitive files never exposed to AI)

### Intelligent Rule Loading
**All rules now use `globs` for smart loading:**
- Rules only load when relevant files are edited
- Reduces context usage by ~60%
- Faster responses, lower costs

**Example:** Document extension rules only load when editing Sales/Purchase files

### AGENTS.md Files
**Lightweight alternative to MDC rules:**
- Create `AGENTS.md` in any directory
- Auto-loads when files in that directory are referenced
- No YAML frontmatter needed
- Perfect for module-specific context

**Use cases:**
- Module-specific guidelines
- Feature-specific patterns
- Example references
- Team documentation

## Support and Documentation
- **Cursor Rules:** https://cursor.com/docs/context/rules
- **Cursor Hooks:** https://cursor.com/docs/agent/hooks
- **Cursor Indexing:** https://cursor.com/docs/context/codebase-indexing
- **Claude Code Commands:** https://code.claude.com/docs/en/slash-commands
- **Claude Code Hooks:** https://code.claude.com/docs/en/hooks
- **BC26 Documentation:** Microsoft Learn - Business Central
- **ESC Standards:** See .cursor/rules/ files

---

**Version:** 2.1.0
**BC Version:** 26 (SaaS)
**Last Updated:** 2025-11-07
**Template Purpose:** AI-assisted BC26 development with ESC standards compliance
**New in 2.1:** Cursor hooks, intelligent rule loading, .cursorignore, AGENTS.md support
