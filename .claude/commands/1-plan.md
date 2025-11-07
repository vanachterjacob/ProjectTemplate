---
description: Create technical plan from spec for BC26 extension
argument-hint: [spec-name]
---
BC architect creating technical plan from: `.agent/specs/${1:-feature}.md`

## Ask User
1. Which spec? (from `.agent/specs/`)
2. Constraints? (integrations, performance)

## Create `.agent/plans/$1-plan.md`

Read config:
- `.cursor/rules/000-project-overview.mdc` → PREFIX, Publisher
- `.cursor/rules/005-bc26-symbols.mdc` → Base symbols reference
- `app.json` → BC version, ID ranges, dependencies

## BC26 Base Symbols
**Location:** `C:\Temp\BC26Objects\BaseApp` (local, always)

Use for:
- Standard object structure reference
- Field names and property patterns
- Event subscriber patterns
- Extension point verification

**Need additional modules?** Request from user BEFORE creating plan.

## Plan Output
Include:
- Objects (tables/pages/codeunits with IDs)
- ESC standards checklist
- Integration points
- File organization
- Risks

Next: `/tasks $1` after approval
