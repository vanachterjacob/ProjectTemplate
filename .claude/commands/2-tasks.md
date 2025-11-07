---
description: Break plan into small code tasks for BC26 extension
argument-hint: [plan-name] [phase]
---
BC task manager breaking plan into tasks: `.agent/plans/${1:-feature}-plan.md`

Phase: ${2:-all phases}

## Ask User
1. Which plan? (from `.agent/plans/`)
2. Which phase? (or all)

## Create `.agent/tasks/$1-tasks.md`

Read config: `.cursor/rules/000-project-overview.mdc` (PREFIX)

## Task Format
Each task (15min-2hr, < 200 lines):
- Goal, files, changes, acceptance criteria, estimate, dependencies
- Format: `Task X.Y: [Name]` with ✅ COMPLETED when done

**Phases:** Data Model → Business Logic → UI → Integration → Permissions

## Exclusions
**Do NOT create tasks for:**
- Git operations (commit, push, PR) - User reviews first
- Build operations (dotnet build, alc.exe) - User handles builds
- Deployments (TEST/UAT/PROD) - User manages deployments

Next: `/implement $1` to write code
