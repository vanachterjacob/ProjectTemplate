# BC26 Development Template - Claude Context

## Project Purpose
Centralized configuration template for Business Central 26 (SaaS) extension development with Claude Code and Cursor integration.

## Key Information
- **Prefix:** ABC (MUST be replaced with 3-letter customer code per project)
- **BC Version:** 26 SaaS
- **Object ID Range:** 77100-77200 (dummy range, replaced by Object Ninja for production)
- **Symbols Location:** C:\Temp\BC26Objects\BaseApp
- **Publisher:** [Your Publisher Name] (replace in 000-project-overview.mdc)

## Development Workflow
1. `/specify [feature-name]` - Create user-focused specification
2. `/plan [spec-name]` - Create technical architecture plan
3. `/tasks [plan-name] [phase]` - Break plan into code tasks
4. `/implement [task-file] [task-id|next]` - Implement code sequentially
5. `/review [file-or-folder-path]` - ESC compliance check
6. `/update_doc [init|update]` - Maintain .agent/ documentation

## Critical ESC Standards
**ALWAYS enforce these rules:**
- ✅ Use ABC prefix consistently (customer-specific, replace ABC with actual prefix)
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
├── .cursor/rules/               # Cursor AI rules (MDC format, always applied)
│   ├── 000-project-overview.mdc # Project config, PREFIX, standards
│   ├── 001-naming-conventions.mdc
│   ├── 002-development-patterns.mdc
│   ├── 003-document-extensions.mdc
│   ├── 004-performance.mdc
│   ├── 005-bc26-symbols.mdc
│   ├── 006-tools-review.mdc
│   └── 007-deployment-security.mdc
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
```

## ESC Standards Reference
**Load these rules from `.cursor/rules/` for details:**
- **001-naming-conventions.mdc** - Object naming, FBakkensen pattern, file organization
- **002-development-patterns.mdc** - Early exit, TryFunction, ConfirmManagement
- **003-document-extensions.mdc** - Complete Sales/Purchase document checklist
- **004-performance.mdc** - Thresholds, background jobs, SetLoadFields rules
- **005-bc26-symbols.mdc** - Local BC26 symbol references
- **006-tools-review.mdc** - Development extensions, Object Ninja, review process
- **007-deployment-security.mdc** - Security, integration, upgrade patterns

## Local Resources
- **BC26 Base Symbols:** C:\Temp\BC26Objects\BaseApp (Microsoft 26.3.36158.37931)
- **Additional Modules:** ALAppExtensions, BCIntrastatCore, Continia modules
- **No MCP Dependencies:** Fully offline capable
- **Access via:** Read(//mnt/c/Temp/BC26Objects/**) or Read(//c/Temp/BC26Objects/**)

## Object Naming Patterns
**Tables:**
- `ABC <Object Name>` (e.g., `ABC Customer Credit`)
- Extension: `ABC <Base Object Name>` (e.g., `ABC Customer`)

**Pages:**
- Card: `ABC <Entity> Card`
- List: `ABC <Entity> List`
- Document: `ABC <Doc Type> <Doc Name>` (e.g., `ABC Sales Invoice`)

**Codeunits:**
- Business Logic: `ABC <Feature> Mgt.`
- Event Subscribers: `ABC <Feature> Subscribers`
- Install/Upgrade: `ABC Install`, `ABC Upgrade`

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
1. Replace `ABC` with actual 3-letter customer prefix in 000-project-overview.mdc
2. Update `[Your Publisher Name]` in 000-project-overview.mdc
3. Configure app.json with correct ID ranges
4. Verify BC26 symbols path accessibility
5. Review and adjust .claude/settings.json permissions
6. Test workflow with simple feature (/specify → /implement)

## Support and Documentation
- **Cursor Rules:** https://cursor.com/docs/context/rules
- **Claude Code Commands:** https://code.claude.com/docs/en/slash-commands
- **Claude Code Hooks:** https://code.claude.com/docs/en/hooks
- **BC26 Documentation:** Microsoft Learn - Business Central
- **ESC Standards:** See .cursor/rules/ files

---

**Version:** 2.0.0
**BC Version:** 26 (SaaS)
**Last Updated:** 2025-11-07
**Template Purpose:** AI-assisted BC26 development with ESC standards compliance
