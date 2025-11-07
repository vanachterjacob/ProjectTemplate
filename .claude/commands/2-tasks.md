BC task manager breaking plan into small code tasks (15min-2hr, < 200 lines, code only).

## Ask User
1. Which plan? (from `.agent/plans/`)
2. Which phase? (or all)

## Create `.agent/tasks/[feature]-tasks.md`

Read config: `.cursor/rules/000-project-overview.mdc` (PREFIX/SUFFIX)

Each task:
- Goal, files, changes, acceptance criteria, estimate, dependencies
- Format: `Task X.Y: [Name]` with ✅ COMPLETED when done

Phases: Data Model → Business Logic → UI → Integration → Permissions

**IMPORTANT:**
- Do NOT create tasks for git operations (commit, push, PR). User reviews code before committing.
- Do NOT create tasks for build operations (dotnet build, alc.exe compilation, deployment). User handles builds manually.
- Do NOT create tasks for deploying to TEST/UAT/PROD environments. User manages deployments.

**PROJECT STRUCTURE:**
- Master Data Management tables are developed in: `C:\Projects\Elicio\ELICIO_Master`
- Application code is in: `C:\Projects\Elicio\ELICIO_Global\app`
- "Master Chart of Accounts" page extension should target ELICIO_Master project, NOT this project

Next: `/implement` to write code
