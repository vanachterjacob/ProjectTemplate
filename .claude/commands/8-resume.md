---
description: Resume previous development session from checkpoint
model: sonnet
---

# Resume Development Session

**Purpose:** Load saved session state and continue where you left off

**Usage:** `/resume [session-name]`

**Example:** `/resume commission-feature`

---

## Your Task

You are resuming a previously saved development session with full context restoration.

### Step 1: Find Checkpoint File

Search for checkpoint file:

```bash
# List all checkpoints matching session name
ls -lt .claude/sessions/*{session-name}*.checkpoint.md

# If multiple found, use most recent
# If none found, report error to user
```

---

### Step 2: Load Checkpoint

Read the checkpoint file and extract:

1. **Session metadata** - Date, project, branch, status
2. **Completed tasks** - What was already done
3. **In-progress tasks** - What was being worked on
4. **Pending tasks** - What still needs doing
5. **Current context** - Last file/task worked on
6. **Decisions made** - Architectural choices
7. **Blockers** - What's preventing progress
8. **Resume instructions** - First action when resuming

---

### Step 3: Verify Current State

Check if anything changed since checkpoint:

```bash
# Check git status
git status

# Compare current branch to checkpoint
git branch --show-current

# Check for commits since checkpoint
git log --since="{checkpoint-date}" --oneline
```

If different:
- Report changes to user
- Ask if they want to continue or update checkpoint

---

### Step 4: Load Project Context

Based on checkpoint project info:

1. **Load project context** (if multi-project setup exists)
   - Check `.claude/projects/{project-name}.project.md`
   - Load prefix, conventions, customer-specific patterns

2. **Load relevant context presets**
   - From checkpoint "Resume Instructions" section
   - Or infer from feature being worked on
   - Example: Sales feature → load @sales-context

3. **Load related ADRs** (if referenced in checkpoint)

---

### Step 5: Restore Working Context

Present session context to user:

```markdown
🔄 **Resuming Session: {Feature Name}**

**Original Date:** {checkpoint date}
**Time Since Checkpoint:** {X hours/days ago}
**Project:** {Project name}
**Status:** {X}% complete

---

## What Was Completed ✅
{List completed tasks from checkpoint}

---

## What Was In Progress 🔄
{Last thing being worked on}
- File: {current file}
- Task: {current task}
- Status: {X}% done
- Approach: {technical approach}

---

## What's Pending ⏳
{List pending tasks with estimates}

---

## Changes Since Checkpoint
{If any commits/changes detected}
- New commits: {list}
- Modified files: {list}

OR

No changes since checkpoint. Ready to continue.

---

## Blockers / Questions
{If any were noted}

---

## Next Action 🎯
{From "Resume Instructions" in checkpoint}

**Suggested first step:** {Immediate action}

---

Ready to continue? I have the full context loaded.
```

---

### Step 6: Interactive Resume

Ask user:

```
How would you like to proceed?

A) Continue with suggested next step: {next action}
B) Review what was done so far (show file diffs)
C) Change direction (what do you want to do instead?)
D) Update checkpoint (if situation changed)
```

Wait for user choice before proceeding.

---

### Step 7: Begin Work

Based on user choice:

**If A (Continue):**
- Start working on the suggested next step
- Load necessary files
- Apply patterns/context from checkpoint

**If B (Review):**
- Show git diff for modified files
- Summarize implementation details
- Then offer to continue

**If C (Change direction):**
- Ask what they want to do
- Update mental model
- Optionally save new checkpoint

**If D (Update):**
- Run `/checkpoint {session-name}` to update

---

## Important Notes

1. **Verify checkpoint freshness** - Warn if >7 days old
2. **Check for conflicts** - If git state differs, highlight changes
3. **Load context economically** - Don't load full BC27 docs unless needed
4. **Respect blockers** - If checkpoint mentions waiting for customer, ask if resolved
5. **Update TODO list** - Restore pending tasks to active TODO tracking

---

## Error Handling

**If checkpoint not found:**
```
❌ No checkpoint found for "{session-name}"

Available checkpoints:
{list .claude/sessions/*.checkpoint.md files}

Or create new checkpoint: /checkpoint {session-name}
```

**If multiple checkpoints found:**
```
⚠️ Multiple checkpoints found for "{session-name}":

1. 2025-11-09-commission-feature.checkpoint.md (most recent)
2. 2025-11-08-commission-feature.checkpoint.md
3. 2025-11-01-commission-feature.checkpoint.md

Using most recent. To use different checkpoint, specify date:
/resume commission-feature 2025-11-08
```

**If checkpoint is very old:**
```
⚠️ Checkpoint is {X} days old (from {date})

Codebase may have changed significantly. Proceed with caution.

Continue anyway? (yes/no)
```

---

## Integration with Other Features

- **With ADRs:** Load referenced ADR files automatically
- **With Pattern Library:** Load mentioned patterns
- **With Project Switching:** Auto-load correct project context
- **With Impact Analysis:** Re-run if resuming after long time

---

## Example Output

```
🔄 **Resuming Session: Commission Tracking Feature**

**Original Date:** 2025-11-09 14:30
**Time Since Checkpoint:** 1 day ago
**Project:** ABC Logistics
**Status:** 60% complete

---

## What Was Completed ✅
- Created table 77105 "ABC Commission Ledger Entry"
- Created codeunit 77106 "ABC Commission Post"
- Event subscriber on Sales-Post working
- Permission sets created

---

## What Was In Progress 🔄
Working on: Codeunit 77107 "ABC Commission Calculator"
- Status: 70% done
- Issue: Handling split commissions (multiple salespeople per order)
- Approach: Using temporary table for calculation, then batch post

---

## What's Pending ⏳
- Page 77105 "Commission Entries" (list + card) - 2h
- Report 77105 "Commission Statement" - 3h
- API endpoint for external reporting - 4h
- Data migration from G/L fields - 2h
- Testing & ESC review - 3h

---

## Changes Since Checkpoint
No changes detected. Ready to continue.

---

## Blockers / Questions
⚠️ Customer hasn't decided: Commission on invoiced or shipped amount?
   Status: Waiting since 2025-11-09

---

## Next Action 🎯
**Suggested:** Finish split commission logic in Calculator codeunit

**Context loaded:**
- @sales-context
- ADR-0001 (Custom Ledger decision)
- ABC Logistics project context

Ready to continue?

A) Continue with Calculator codeunit
B) Review what was done so far
C) Work on something else
D) Update checkpoint
```

---

**Version:** 1.0
**Created:** 2025-11-09
