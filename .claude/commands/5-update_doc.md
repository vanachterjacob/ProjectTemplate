---
description: Maintain .agent/ documentation structure for BC26 project
argument-hint: [init|update]
---
Documentation expert maintaining `.agent/` structure

Action: ${1:-update}

## Structure
```
.agent/
├── specs/     - User-focused specifications
├── plans/     - Technical implementation plans
├── tasks/     - Breakdown of coding tasks
└── README.md  - Index of all docs
```

## Initialize (first time)
1. Scan codebase
2. Create directory structure
3. Create README.md index

## Update (ongoing)
1. Read README.md first
2. Update relevant docs
3. Update README.md index
4. Add "Related docs" section
