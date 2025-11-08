# BC27 Development Template - AI Context

**Purpose:** Complete context for AI assistants (Cursor AI, Claude Code) working on Business Central 27 extensions.
**Audience:** LLMs only (humans: see README.md)
**Version:** 3.0.0

## Project Overview

### Focus & Compatibility
- **Primary:** Business Central 27 (SaaS)
- **Compatibility:** BC26+ (all patterns apply)
- **Development:** AL Language extensions with ESC standards
- **Prefix:** ABC (replace with customer 3-letter code per project)
- **Publisher:** [Your Publisher Name] (configured in 000-project-overview.mdc)

### Object ID Management
- **Development Range:** 77100-77200 (dummy IDs)
- **Production Assignment:** Object Ninja tool assigns from customer range
- **Never:** Manually assign production IDs during development

## File Structure & Purpose

### Cursor Rules (`.cursor/rules/`)
Auto-loaded AI context based on file patterns:

| File | When Loaded | Purpose | Lines |
|------|-------------|---------|-------|
| `000-project-overview.mdc` | Always | Project configuration | 42 |
| `001-naming-conventions.mdc` | `*.al` | Object/variable naming | 108 |
| `002-development-patterns.mdc` | `*.al` | Early exit, TryFunction, Confirm | 126 |
| `003-document-extensions.mdc` | `*Sales*`, `*Purchase*` | Complete document extensions | 57 |
| `004-performance.mdc` | `*.al` | Performance patterns, thresholds | 96 |
| `005-bc26-symbols.mdc` | @-mention | Local BC symbols reference | 61 |
| `006-tools-review.mdc` | @-mention | LinterCop, Object Ninja, extensions | 76 |
| `007-deployment-security.mdc` | `*Install*`, `*Upgrade*`, `*Permission*` | Security, upgrades | 113 |
| `008-bc27-quick-reference.mdc` | `*.al`, `app.json` | BC27 modules quick ref | 107 |
| `009-bc27-architecture.mdc` | @-mention | BC27 architecture details | 201 |
| `010-event-discovery.mdc` | Event queries | Find BC27 events workflow | 348 |
| `011-llm-optimization.mdc` | Always | Token efficiency, context loading | 100 |

**Total:** ~1,335 lines of AI context rules

###Claude Commands (`.claude/commands/`)
Workflow automation via slash commands:

| Command | Purpose | Model |
|---------|---------|-------|
| `/specify` | Create user specification | sonnet |
| `/plan` | Create technical plan | sonnet |
| `/tasks` | Break into implementation tasks | sonnet |
| `/implement` | Write code from tasks | sonnet |
| `/review` | ESC standards compliance | sonnet |
| `/update_doc` | Maintain documentation | sonnet |
| `/auto-install-rules` | Install template to project | haiku |

### Context Presets (`.claude/skills/context-presets/`)
⚡ **Quick context loading** - Load complete domain context with a single skill invocation:

| Preset | Purpose | Time Saved |
|--------|---------|------------|
| `sales-context` | Sales & customer context (docs, events, patterns) | 10-15 min |
| `posting-context` | G/L posting & ledger context | 10-15 min |
| `api-context` | API & integration context | 10-15 min |
| `warehouse-context` | Warehouse & inventory context | 10-15 min |
| `manufacturing-context` | Production & BOM context | 10-15 min |
| `performance-context` | Performance optimization & ESC rules | 10-15 min |

**Usage:**
- **Cursor AI:** `@sales-context` then ask your question
- **Claude Code:** Use the skill, then describe your task

**Benefits:**
- ✅ Complete domain context loaded instantly
- ✅ No manual file searching (2-5 min saved)
- ✅ Never forget required ESC rules
- ✅ Pattern examples included automatically

**See:** `.claude/skills/context-presets/README.md` for details

### MCP Servers (`.claude/MCP_CONFIGURATION.md`)
🔌 **Extend Claude capabilities** - MCP (Model Context Protocol) servers add powerful integrations:

**Recommended for BC27:**
- **GitHub MCP** ⭐ Auto-create PRs with ESC checklist after `/implement`
- **Filesystem MCP** ⭐ Real-time ESC compliance validation on file save
- **Brave Search MCP** - Verify latest BC27 event signatures
- **Database MCP** - Validate table extensions and test queries

**Quick Setup:**
```bash
# Create .claude/mcp_settings.json (see MCP_CONFIGURATION.md)
# Set GITHUB_TOKEN environment variable
# Reload VS Code/Cursor
```

**Benefits:**
- ✅ PR automation (40-50% faster workflow)
- ✅ Proactive ESC warnings (catch violations early)
- ✅ Always current BC27 docs (auto-fetch from Microsoft Learn)
- ✅ Schema validation before deployment

**See:** `.claude/MCP_CONFIGURATION.md` for full guide and `.claude/RECOMMENDED_MCP_SERVERS.md` for quick reference

### BC27 Base Code Index (`/BC27/`)
Complete reference documentation (360 KB, 18 files):

**⚡ START HERE (Token-Optimized):**
0. **BC27_LLM_QUICKREF.md** - ⭐ Quick reference for LLMs (450 lines vs. 11k+ full docs)

**Core Documentation**:
1. **BC27_INDEX_README.md** - Navigation guide
2. **BC27_ARCHITECTURE.md** - System design, layering, patterns
3. **BC27_MODULES_OVERVIEW.md** - All 73 modules detailed
4. **BC27_MODULES_BY_CATEGORY.md** - 22 functional categories
5. **BC27_DEPENDENCY_REFERENCE.md** - Module relationships
6. **BC27_FEATURES_INDEX.md** - 200+ features matrix
7. **BC27_INTEGRATION_GUIDE.md** - 15+ external integrations

**Source Code Integration**:
8. **BC27_EVENT_CATALOG.md** - Core posting & document events (~50 events)
9. **BC27_EVENT_INDEX.md** - Keyword search across ALL events (~210 events)
10. **BC27_EXTENSION_POINTS.md** - Table/page extension patterns and guidelines

**Module Event Catalogs** (`/BC27/events/`):
11. **BC27_EVENTS_MANUFACTURING.md** - 30+ production, BOM, routing events
12. **BC27_EVENTS_SERVICE.md** - 20+ service order, contract events
13. **BC27_EVENTS_JOBS.md** - 15+ job planning, WIP events
14. **BC27_EVENTS_API.md** - 25+ REST API, webhook events
15. **BC27_EVENTS_FIXEDASSETS.md** - 15+ depreciation, acquisition, disposal events
16. **BC27_EVENTS_WAREHOUSE.md** - 18+ picks, put-aways, bins, movements
17. **BC27_EVENTS_ASSEMBLY.md** - 12+ assembly orders, ATO, BOM events

**💡 LLM Usage Tip:** Always start with BC27_LLM_QUICKREF.md for 80-90% token savings on BC27 queries. Load detailed docs only when quick ref is insufficient.

## Development Workflow

### Standard Process (Sequential)

\`\`\`
1. /specify [feature-name]
   → Creates: .agent/specs/[feature-name]-spec.md
   → Focus: User needs, NOT technical details
   → Output: User stories, business value, acceptance criteria

2. /plan [spec-name]
   → Input: .agent/specs/[spec-name]-spec.md
   → Creates: .agent/plans/[spec-name]-plan.md
   → Focus: Architecture, technical design
   → Output: Object structure, dependencies, data model

3. /tasks [plan-name] [phase]
   → Input: .agent/plans/[plan-name]-plan.md
   → Creates: .agent/tasks/[plan-name]-tasks.md
   → Phases: Data Model → Business Logic → UI → Integration → Permissions
   → Output: Small tasks (15min-2hr each, <200 lines code)

4. /implement [task-file] [task-id|next]
   → Input: .agent/tasks/[task-file]-tasks.md
   → Creates: AL files in src/
   → Focus: ESC-compliant code only (no git/build)
   → Updates: Task status (⏳ PENDING → 🔄 IN PROGRESS → ✅ COMPLETED)

5. /review [file-or-folder]
   → Input: AL files in scope
   → Output: ESC compliance report with file:line references
   → Check: ALL standards (naming, patterns, performance, security)
\`\`\`

---

## LLM Optimization (Token Efficiency)

### Context Loading Strategy

**Always loaded:**
- This file (CLAUDE.md) - Project overview
- `000-project-overview.mdc` - Configuration
- `011-llm-optimization.mdc` - Loading strategies

**Load on demand:**
- BC27 queries → Start with `BC27_LLM_QUICKREF.md` (450 lines) NOT full docs (11k+ lines)
- Event discovery → Use `010-event-discovery.mdc` workflow + specific event catalog
- Coding tasks → Load `001-naming-conventions.mdc` + `002-development-patterns.mdc`
- **Domain tasks → Use context presets** (`@sales-context`, `@api-context`, etc.) **⭐ NEW**

### Token Savings

| Approach | Token Usage | Savings |
|----------|-------------|---------|
| Old: Load all BC27 docs | ~50k tokens | 0% |
| New: Use BC27_LLM_QUICKREF.md first | ~2k tokens | 96% ⭐ |
| Old: Load all event catalogs | ~20k tokens | 0% |
| New: Load specific catalog only | ~6k tokens | 70% ⭐ |
| Old: Manually load domain files (5-8 files) | ~8k tokens | 0% |
| New: Use context preset (1 skill) | ~3k tokens | 62% ⭐ |

### Exclusion Files

- **`.claudeignore`** - Claude Code context exclusions (build artifacts, symbols, logs)
- **`.cursorignore`** - Cursor AI context exclusions (same as .claudeignore)

**Excluded:** Build artifacts, symbols, generated files, translations, logs, sensitive data (~40-60% token reduction)

### Full Optimization Guide

**See:** `LLM_OPTIMIZATION_GUIDE.md` for complete recommendations, patterns, and best practices.

---

**Remember:** This file is AI context only. Humans should read README.md for installation and usage instructions.
