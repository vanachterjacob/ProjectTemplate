---
description: Save current development session state for later resumption
model: sonnet
---

# Checkpoint Current Session

**Purpose:** Save conversation state and progress to resume later

**Usage:** `/checkpoint [session-name]`

**Example:** `/checkpoint commission-feature`

---

## Your Task

You are saving the current development session state so it can be resumed later with full context.

### Step 1: Analyze Current Session

Review the conversation history and extract:

1. **Session Metadata**
   - Session name (from user input)
   - Current date/time
   - Current project (check `.claude/CLAUDE.md` or project context)
   - Current git branch

2. **Completed Work**
   - Files created/modified (check git status, git log)
   - Features implemented
   - Decisions made
   - Commits created

3. **In-Progress Work**
   - What's currently being worked on
   - Files partially completed
   - Percentage complete (estimate based on discussion)

4. **Pending Tasks**
   - What still needs to be done
   - User-mentioned TODOs
   - Next steps discussed

5. **Key Decisions & Context**
   - Architectural choices made
   - Patterns chosen
   - Customer requirements
   - Blockers or waiting-for items

6. **Current State**
   - What file/task you were last working on
   - Current approach being taken
   - Any temporary workarounds

---

### Step 2: Check Git Status

```bash
# Get current state
git status
git log --oneline -5
git branch --show-current

# List modified files
git diff --name-only
```

---

### Step 3: Generate Checkpoint File

Create checkpoint file at: `.claude/sessions/YYYY-MM-DD-{session-name}.checkpoint.md`

Use this template:

```markdown
# Session Checkpoint: {Feature Name}
**Date:** {YYYY-MM-DD HH:MM}
**Project:** {Project Name from context}
**Git Branch:** {Current branch}
**Status:** {In Progress | Blocked | Completed}% complete

## Session Summary
{1-2 sentence overview of what this session is about}

## Completed Tasks
{List with checkmarks}
- ✅ Task 1 (with file references)
- ✅ Task 2
- ✅ Task 3

## In Progress
{List with status}
- 🔄 Task in progress (X% done)
  - Sub-detail of current state
  - What's working
  - What's left

## Pending Tasks
{List with estimates}
- ⏳ Task 1 (estimated: X hours)
- ⏳ Task 2 (estimated: Y hours)
- ⏳ Task 3

## Key Decisions Made
{List of architectural/technical decisions}
- Decision 1: Rationale
- Decision 2: Rationale
- (Reference ADRs if created)

## Current Context
**Working on:** {Current file/task}
**Approach:** {Technical approach being taken}
**Issue/Challenge:** {If any}
**Next Step:** {Immediate next action}

## Files Modified
{List from git status}
- src/Path/File1.al (created/modified)
- src/Path/File2.al (modified)
- src/Path/File3.al (in progress)

## Technical Notes
{Important technical details}
- Performance considerations
- Security notes
- Integration points
- Dependencies

## Questions / Blockers
{Things waiting for resolution}
- Customer decision needed: {Question}
- Waiting for: {External dependency}
- Technical question: {Issue}

## Resume Instructions
{For /resume command}
**First action:** {What to do when resuming}
**Context files to load:** {Which context presets/docs needed}
**Last commit:** {git commit hash}
```

---

### Step 4: Save Checkpoint

Write the generated checkpoint to `.claude/sessions/YYYY-MM-DD-{session-name}.checkpoint.md`

---

### Step 5: Confirm to User

Report to user:
```
✅ Session checkpoint saved: .claude/sessions/{date}-{session-name}.checkpoint.md

Summary:
- Completed: {N} tasks
- In Progress: {N} tasks
- Pending: {N} tasks
- Status: {X}% complete

To resume later: /resume {session-name}
```

---

## Important Notes

1. **Be thorough but concise** - Capture essential context, not entire conversation
2. **Include file references** - Specific paths and line numbers when relevant
3. **Estimate completion** - Give realistic percentage based on work done vs remaining
4. **Note blockers** - Highlight anything preventing progress
5. **Git context** - Include commit hashes so we can verify state when resuming
6. **Next action** - Make it easy to pick up where you left off

---

## Example Checkpoint

See `.claude/sessions/example-checkpoint.md` for reference format.

---

## Integration with Other Features

- If ADRs were created, reference them in "Key Decisions"
- If patterns were used, note them in "Technical Notes"
- Include relevant project context (which customer, which module)

---

**Version:** 1.0
**Created:** 2025-11-09
