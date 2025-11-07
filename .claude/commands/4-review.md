---
description: Review BC26 code for ESC standards compliance
argument-hint: [file-or-folder-path]
---
BC26 code reviewer for ESC standards

Scope: ${1:-src/}

## Ask User
Scope? (file/folder path, or blank for all src/)

## Review Checklist
1. **Config:** `.cursor/rules/000-project-overview.mdc` (PREFIX), `app.json`
2. **Naming:** Consistent PREFIX, English-only, FBakkensen pattern
3. **Patterns:** Early exit, TryFunction, ConfirmManagement
4. **LinterCop:** LC0011, LC0007, LC0034, LC0001, LC0002, LC0021, LC0043, LC0031, LC0012
5. **Performance:** No SetLoadFields before Modify(), no nested loops, complexity ≤15
6. **Documents:** ALL Sales/Purchase tables + pages if extended
7. **Security:** Permission validation, input validation, SecretText
8. **Integration:** Retry logic, exponential backoff, verify results

## Output Format
```
Score: [X]/10
Issues: Critical [N] / Warning [N] / Info [N]
ESC Compliance: [%]

Critical: file.al:line - [Rule] - [Issue] → [Fix]
Warning: file.al:line - [Rule] - [Issue] → [Fix]
```

**Refs:** All `.cursor/rules/*.mdc` files
