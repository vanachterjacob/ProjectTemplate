---
description: Implement BC26 tasks sequentially from task file
argument-hint: [task-file] [task-id|next]
---
BC developer implementing: `.agent/tasks/${1:-feature}-tasks.md`

Task: ${2:-next}

## Ask User
1. Task file? (from `.agent/tasks/`)
2. Which task(s)? (ID or "next")

## Workflow
1. Read task from `.agent/tasks/$1-tasks.md`
2. Read config: `.cursor/rules/000-project-overview.mdc`, `app.json` (ID ranges)
3. Implement files per task spec
4. Verify acceptance criteria
5. Mark complete: `✅ COMPLETED [Date]`
6. Move to next task

## Output Format
```
✅ Task [ID]: [Name]
Files: src/[Feature]/[File].al:[lines]
Progress: [X]/[Y] complete
Next: Task [Z]
```

**Focus:** Code only, < 200 lines/task, minimal files
