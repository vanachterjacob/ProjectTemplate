# Development Session Checkpoints

**Purpose:** Save and resume long-running development sessions with full context

---

## What Are Session Checkpoints?

When working on complex features that span multiple days or sessions, checkpoints allow you to:

1. **Save your progress** - Document what's done, in-progress, and pending
2. **Resume later** - Pick up exactly where you left off with full context
3. **Switch between features** - Work on multiple things without losing context
4. **Share with team** - Others can see your progress and continue your work

---

## Usage

### Save Current Session
```bash
/checkpoint commission-feature
```

Creates: `.claude/sessions/2025-11-09-commission-feature.checkpoint.md`

### Resume Previous Session
```bash
/resume commission-feature
```

Loads the most recent checkpoint matching that name.

---

## Checkpoint Files

### File Naming Convention
```
YYYY-MM-DD-{session-name}.checkpoint.md
```

Examples:
- `2025-11-09-commission-feature.checkpoint.md`
- `2025-11-08-api-refactor.checkpoint.md`
- `2025-11-07-warehouse-optimization.checkpoint.md`

### File Structure

Each checkpoint contains:

1. **Metadata** - Date, project, status, git branch
2. **Session Summary** - High-level overview
3. **Completed Tasks** - What's done with file references
4. **In Progress** - Current work with status percentage
5. **Pending Tasks** - What still needs doing with estimates
6. **Key Decisions** - Architectural choices made
7. **Current Context** - What you were working on
8. **Files Modified** - List from git
9. **Technical Notes** - Performance, security, integration details
10. **Blockers** - What's preventing progress
11. **Resume Instructions** - How to pick up later

---

## When to Use Checkpoints

### ✅ Good Use Cases

**Long-running features (2+ days)**
```bash
# Day 1: Start feature
... work for 4 hours ...
/checkpoint commission-tracking

# Day 2: Resume
/resume commission-tracking
... work continues ...
```

**End of work day**
```bash
# Save progress before going home
/checkpoint api-integration
```

**Context switching**
```bash
# Working on Feature A
/checkpoint feature-a

# Switch to urgent bugfix
... fix bug ...

# Back to Feature A
/resume feature-a
```

**Before long interruption**
```bash
# Before vacation/weekend/customer meeting
/checkpoint warehouse-redesign
```

**Handoff to team member**
```bash
# You start, colleague finishes
/checkpoint customer-portal
# Colleague later: /resume customer-portal
```

---

### ❌ When NOT to Use

**Simple tasks (<1 hour)**
- No need to checkpoint quick fixes

**Already using /tasks workflow**
- The `/implement` command tracks task progress
- Use checkpoints for work OUTSIDE the structured workflow

**Completed features**
- Just commit and close
- No need to checkpoint finished work

---

## Best Practices

### 1. Checkpoint Regularly
```bash
# Every 2-4 hours of work
/checkpoint feature-name

# Before context switches
/checkpoint current-work

# End of day
/checkpoint todays-work
```

### 2. Use Descriptive Names
```bash
# ✅ Good
/checkpoint commission-calculator-logic
/checkpoint api-authentication-refactor

# ❌ Bad
/checkpoint stuff
/checkpoint work
```

### 3. Include Blockers
If waiting for something, document it:
- Customer decisions
- External dependencies
- Technical questions

### 4. Estimate Remaining Work
Helps with planning and prioritization:
- Percentage complete
- Hours remaining per task
- Dependencies

### 5. Reference Related Artifacts
Link to:
- ADR files (architectural decisions)
- Pattern files (reused solutions)
- Git commits
- External documents

---

## Checkpoint Lifecycle

```
1. START SESSION
   ↓
2. WORK (2-4 hours)
   ↓
3. /checkpoint session-name
   ↓
4. INTERRUPT (end of day, context switch, etc.)
   ↓
5. LATER: /resume session-name
   ↓
6. CONTINUE WORK
   ↓
7. REPEAT steps 2-6 until done
   ↓
8. FEATURE COMPLETE
   ↓
9. Commit & push
   ↓
10. DELETE or ARCHIVE checkpoint
```

---

## Managing Checkpoints

### List All Checkpoints
```bash
ls -lt .claude/sessions/
```

### Find Specific Checkpoint
```bash
ls .claude/sessions/*commission*
```

### Delete Old Checkpoints
```bash
# After feature is complete and merged
rm .claude/sessions/2025-11-09-commission-feature.checkpoint.md
```

### Archive Completed Checkpoints
```bash
# Keep for reference, but move to archive
mkdir -p .claude/sessions/archive
mv .claude/sessions/2025-11-09-*.checkpoint.md .claude/sessions/archive/
```

---

## Integration with Other Features

### With ADRs
```markdown
# In checkpoint:
## Key Decisions Made
- Use custom ledger for commission → See ADR-0001
- Event subscriber over table trigger → See ADR-0002
```

### With Pattern Library
```markdown
# In checkpoint:
## Technical Notes
- Using "Custom Ledger Posting" pattern (see .claude/patterns/learned/)
- Applied "Batch Processing with Progress" pattern
```

### With Project Context
```markdown
# In checkpoint:
**Project:** ABC Logistics
**Customer-specific notes:**
- Remember: ABC wants confirm dialogs default to Yes
- High volume: 5000+ transactions/day, performance critical
```

### With /tasks Workflow
```markdown
# Checkpoint can reference task files
**Related task file:** .agent/tasks/commission-feature-tasks.md
**Current task:** #3 - Implement calculation engine (70% done)
```

---

## Example Checkpoint

See `example-checkpoint.md` in this directory for a complete example.

---

## Troubleshooting

**Problem:** Can't find my checkpoint
```bash
# List all checkpoints
ls -lt .claude/sessions/

# Search by name
find .claude/sessions -name "*commission*"
```

**Problem:** Multiple checkpoints with same name
- Resume loads most recent automatically
- Or specify date: `/resume commission-feature 2025-11-08`

**Problem:** Checkpoint is outdated (many git changes)
```bash
# Check what changed
git log --since="2025-11-08"

# Update checkpoint
/checkpoint commission-feature  # Overwrites old one
```

**Problem:** Lost track of what I was doing
```bash
# List recent checkpoints
ls -lt .claude/sessions/ | head -5

# Resume most recent
/resume {most-recent-name}
```

---

## Version History

**v1.0.0** (2025-11-09)
- Initial implementation
- /checkpoint and /resume commands
- Checkpoint template
- README documentation

---

**Maintained By:** Project team
**Last Updated:** 2025-11-09
