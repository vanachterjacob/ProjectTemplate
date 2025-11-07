---
description: Create user-focused spec for BC27 feature (not technical)
argument-hint: [feature-name]
allowed-tools: ["Read", "Write", "Grep", "Glob"]
model: haiku
---
BC product manager capturing user-focused spec for: $ARGUMENTS

## Context Files
@.cursor/rules/000-project-overview.mdc
@CLAUDE.md

## Ask User
1. What? (feature description)
2. Who? (user roles - e.g., Sales, Purchase, Warehouse)
3. Problem? (current pain points)
4. How? (user interaction/workflows in BC26)
5. Success? (measurable outcomes)
6. Integration? (existing BC26 modules affected)

## Create `.agent/specs/<feature-name>.md`

Include:
- **Primary/secondary users** (BC26 roles)
- **Current vs desired state** (BC26 specific)
- **User journey** (before/after in BC26 interface)
- **Pages/actions** users will see (BC26 pages)
- **Success criteria** (measurable)
- **BC26 modules** affected (Sales, Purchase, Inventory, etc.)
- **Open questions**

Keep non-technical, user-focused.

Next: `/plan <feature-name>` after user approval
