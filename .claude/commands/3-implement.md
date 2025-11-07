---
description: Implement BC26 tasks sequentially from task file
argument-hint: [task-file] [task-id|next]
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob"]
model: sonnet
---
BC26 developer implementing: `.agent/tasks/$ARGUMENTS-tasks.md`

## Ask User
1. Task file? (from `.agent/tasks/`)
2. Which task(s)? (Task ID like "1.1" or "next" for first pending task)

## Load Context
@.cursor/rules/000-project-overview.mdc
@.cursor/rules/001-naming-conventions.mdc
@.cursor/rules/002-development-patterns.mdc
@CLAUDE.md

Read:
- `.agent/tasks/<task-file>-tasks.md` → All tasks
- `app.json` → ID ranges, dependencies
- Relevant files from task dependencies

## Workflow
1. **Find task** → Read from `.agent/tasks/<task-file>-tasks.md`
2. **Check dependencies** → Verify prerequisite tasks completed
3. **Load ESC standards** → From .cursor/rules/ per task requirements
4. **Implement code** → Follow task spec exactly
5. **Verify acceptance criteria** → Check each criterion
6. **Update task status** → Mark `✅ COMPLETED [YYYY-MM-DD]` in tasks file
7. **Report** → Summary with file:line references
8. **Next task?** → Ask if user wants to continue

## ESC Standards (ALWAYS enforce)
- ✅ Prefix consistency (ABC or configured prefix)
- ✅ English-only code
- ✅ Early exit pattern
- ✅ TryFunction for errors
- ✅ ConfirmManagement instead of Confirm()
- ✅ SetLoadFields ONLY for read-only
- ✅ Complete document extensions
- ✅ Performance patterns from 004-performance.mdc

## Output Format
```
✅ Task X.Y: [Task Name]

Files Created/Modified:
- src/[Feature]/Tab[ID].[Object].al (lines 1-45)
- src/[Feature]/Pag[ID].[Object].al (lines 1-87)

ESC Standards Applied:
✅ Prefix: ABC used throughout
✅ English-only
✅ Early exit: [example location]
✅ TryFunction: [example location]

Acceptance Criteria Verification:
✅ Criterion 1 - Verified
✅ Criterion 2 - Verified

Progress: [X]/[Y] tasks complete
Next: Task [Z] or "complete" if finished
```

**Focus:**
- Code only (no git/build operations)
- < 200 lines per task
- Minimal files per task
- ESC compliant code

Next: Continue with next task or `/review src/` when phase complete
