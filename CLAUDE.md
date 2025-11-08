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

**Total:** ~887 lines of AI context rules

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

### BC27 Base Code Index (`/BC27/`)
Complete reference documentation (306 KB, 14 files):

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
9. **BC27_EVENT_INDEX.md** - Keyword search across ALL events (~175 events)
10. **BC27_EXTENSION_POINTS.md** - Table/page extension patterns and guidelines

**Module Event Catalogs** (`/BC27/events/`):
11. **BC27_EVENTS_MANUFACTURING.md** - 30+ production, BOM, routing events
12. **BC27_EVENTS_SERVICE.md** - 20+ service order, contract events
13. **BC27_EVENTS_JOBS.md** - 15+ job planning, WIP events
14. **BC27_EVENTS_API.md** - 25+ REST API, webhook events

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

**Remember:** This file is AI context only. Humans should read README.md for installation and usage instructions.
