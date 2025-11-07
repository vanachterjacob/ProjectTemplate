---
description: Break plan into small code tasks for BC27 extension
argument-hint: [plan-name] [phase]
allowed-tools: ["Read", "Write", "Grep", "Glob"]
model: sonnet
---
BC27 task manager breaking plan into tasks: `.agent/plans/$ARGUMENTS-plan.md`

## Ask User
1. Which plan? (from `.agent/plans/`)
2. Which phase? (Data Model / Business Logic / UI / Integration / Permissions / all)
3. Task size preference? (small=15-30min, medium=30-90min, large=90-120min)

## Load Context
@.cursor/rules/000-project-overview.mdc
@CLAUDE.md

Read:
- `.agent/plans/<plan-name>-plan.md` → Technical plan
- `app.json` → Available ID ranges

## Create `.agent/tasks/<plan-name>-tasks.md`

## Task Format
Each task (15min-2hr, < 200 lines code):

```markdown
### Task X.Y: [Descriptive Name]
**Phase:** [Data Model/Business Logic/UI/Integration/Permissions]
**Goal:** [What this task achieves]
**Files:** [List of files to create/modify]
**Changes:**
- Specific changes to make
**Acceptance Criteria:**
- [ ] Criteria 1
- [ ] Criteria 2
**Estimate:** [15m/30m/1h/2h]
**Dependencies:** [Task IDs this depends on]
**ESC Standards:** [Relevant standards to apply]

Status: ⏳ PENDING
```

**Phases (in order):**
1. Data Model (tables, table extensions, enums)
2. Business Logic (codeunits, subscribers, functions)
3. UI (pages, page extensions, actions)
4. Integration (APIs, events, external systems)
5. Permissions (permission sets, field/object permissions)

## Exclusions
**Do NOT create tasks for:**
- Git operations (commit, push, PR) - User reviews first
- Build operations (dotnet build, alc.exe) - User handles builds
- Deployments (TEST/UAT/PROD) - User manages deployments
- Object Ninja ID assignment - Done at end by user

## Status Tracking
- ⏳ PENDING - Not started
- 🔄 IN PROGRESS - Currently implementing
- ✅ COMPLETED [YYYY-MM-DD] - Done and verified

Next: `/implement <plan-name> next` to start coding
