---
description: Maintain .agent/ documentation structure for BC27 project
argument-hint: [init|update]
allowed-tools: ["Read", "Write", "Grep", "Glob", "Bash(ls:*)"]
model: haiku
---
Documentation expert maintaining `.agent/` structure

Action: $ARGUMENTS

## Structure
```
.agent/
├── specs/        - User-focused specifications
├── plans/        - Technical implementation plans
├── tasks/        - Breakdown of coding tasks
├── decisions/    - Architecture decision records (ADRs)
└── README.md     - Index of all documentation
```

## Initialize (first time)
1. Create `.agent/` directory structure
2. Scan existing codebase for features
3. Create README.md with index
4. Link to CLAUDE.md and .cursor/rules/

## Update (ongoing)
1. Read `.agent/README.md` first
2. Scan for new/modified docs in specs/, plans/, tasks/
3. Update README.md index with:
   - Document titles and dates
   - Current status (Draft/Active/Completed)
   - Cross-references between docs
4. Add "Related docs" links in each document
5. Archive completed features

## README.md Format
```markdown
# BC26 Project Documentation

**Project:** [Project Name]
**Prefix:** ABC (from 000-project-overview.mdc)
**Last Updated:** [Date]

## Quick Links
- [CLAUDE.md](../CLAUDE.md) - AI context and standards
- [ESC Standards](.cursor/rules/) - Complete ruleset
- [Project Overview](.cursor/rules/000-project-overview.mdc)

## Active Features
### [Feature Name]
- **Spec:** [specs/feature-name.md](specs/feature-name.md) - [Date]
- **Plan:** [plans/feature-name-plan.md](plans/feature-name-plan.md) - [Date]
- **Tasks:** [tasks/feature-name-tasks.md](tasks/feature-name-tasks.md) - [Date]
- **Status:** [Draft/Planning/Implementation/Review/Completed]
- **Progress:** [X]/[Y] tasks complete

## Completed Features
[Archive of completed features]

## Architecture Decisions
[List of ADRs with dates]
```

Next: Continue with development workflow
