---
description: Create technical plan from spec for BC27 extension
argument-hint: [spec-name]
allowed-tools: ["Read", "Write", "Grep", "Glob"]
model: sonnet
---
BC26 architect creating technical plan from: `.agent/specs/$ARGUMENTS.md`

## Ask User
1. Which spec? (from `.agent/specs/`)
2. Constraints? (integrations, performance, security)
3. Existing extensions? (conflicts to avoid)

## Load Context
@.cursor/rules/000-project-overview.mdc
@.cursor/rules/005-bc26-symbols.mdc
@CLAUDE.md

Read:
- `.agent/specs/<spec-name>.md` → User requirements
- `app.json` → BC version, ID ranges, dependencies
- Existing `src/` → Current codebase structure

## BC26 Base Symbols
**Location:** `C:\Temp\BC26Objects\BaseApp`

Use Read(//mnt/c/Temp/BC26Objects/**) or Read(//c/Temp/BC26Objects/**) for:
- Standard object structure reference
- Field names and property patterns
- Event subscriber patterns
- Extension point verification

**Need additional modules?** Request from user BEFORE creating plan.

## Create `.agent/plans/<spec-name>-plan.md`

Include:
- **Objects** (tables/pages/codeunits with dummy IDs from 77100-77200 range)
- **ESC standards checklist** (all applicable standards)
- **Integration points** (BC26 base objects extended/subscribed)
- **File organization** (src/ structure)
- **Performance considerations** (SetLoadFields, background processing)
- **Security** (permissions, validation)
- **Risks** and mitigation
- **Dependencies** (app.json updates needed)

Next: `/tasks <spec-name>` after user approval
