---
description: Review BC27 code for ESC standards compliance
argument-hint: [file-or-folder-path]
allowed-tools: ["Read", "Grep", "Glob"]
model: sonnet
disable-model-invocation: true
---
BC27 code reviewer for ESC standards compliance

Scope: $ARGUMENTS

## Ask User
Scope? (file path, folder path, or blank for all src/)

## Load ALL ESC Standards
@.cursor/rules/000-project-overview.mdc
@.cursor/rules/001-naming-conventions.mdc
@.cursor/rules/002-development-patterns.mdc
@.cursor/rules/003-document-extensions.mdc
@.cursor/rules/004-performance.mdc
@.cursor/rules/006-tools-review.mdc
@.cursor/rules/007-deployment-security.mdc
@CLAUDE.md

Read:
- `app.json` → Verify ID ranges, dependencies
- All .al files in scope → Full code review

## Review Checklist (Detailed)

### 1. Naming Conventions (001-naming-conventions.mdc)
- [ ] PREFIX consistent (ABC or configured)
- [ ] English-only (no Dutch)
- [ ] FBakkensen pattern for functions
- [ ] Proper object naming
- [ ] Variable naming standards
- [ ] File naming conventions

### 2. Development Patterns (002-development-patterns.mdc)
- [ ] Early exit pattern (avoid nested if)
- [ ] TryFunction for error handling
- [ ] ConfirmManagement.GetResponseOrDefault() instead of Confirm()
- [ ] Proper error messages
- [ ] No magic numbers/strings

### 3. Document Extensions (003-document-extensions.mdc)
- [ ] ALL Sales/Purchase tables extended (Header, Line, Comment, Archive)
- [ ] ALL Sales/Purchase pages extended (Document, Subform, List, Posted)
- [ ] Complete integration (no partial extensions)

### 4. Performance (004-performance.mdc)
- [ ] NO SetLoadFields before Modify/Insert/Delete
- [ ] SetLoadFields ONLY for read-only
- [ ] FindSet(false, false) for read-only
- [ ] Cyclomatic complexity ≤ 15
- [ ] Method length ≤ 150 lines
- [ ] No nested loops with large datasets
- [ ] Background processing for >5s operations

### 5. LinterCop Rules (006-tools-review.mdc)
- [ ] LC0011: Record.SetLoadFields before modify
- [ ] LC0007: Object ID in dummy range (77100-77200)
- [ ] LC0034: Table ID outside range
- [ ] LC0001: FlowFields must have CalcFormula
- [ ] LC0002: Use Enum instead of Option
- [ ] LC0021: Proper primary key definition
- [ ] LC0043: Use SecretText for secrets
- [ ] LC0031: Avoid global variables
- [ ] LC0012: Proper page properties

### 6. Security (007-deployment-security.mdc)
- [ ] Permission validation before operations
- [ ] Input validation
- [ ] SecretText for sensitive data
- [ ] No sensitive data in error messages
- [ ] Proper permission sets

### 7. Integration Patterns (007-deployment-security.mdc)
- [ ] Retry logic with exponential backoff
- [ ] Timeout handling
- [ ] API result verification
- [ ] Proper error logging

## Output Format
```
# BC26 ESC Standards Review Report

## Overall Score: [X]/10
**ESC Compliance:** [Y]%

## Summary
- Critical Issues: [N]
- Warnings: [N]
- Informational: [N]
- Files Reviewed: [N]

## Critical Issues (Must Fix Before Commit)
1. **file.al:line** - [Standard] - [Issue Description]
   - **Fix:** [Specific fix needed]
   - **Reference:** [Rule file:section]

2. **file.al:line** - [Standard] - [Issue Description]
   - **Fix:** [Specific fix needed]
   - **Reference:** [Rule file:section]

## Warnings (Should Fix)
1. **file.al:line** - [Standard] - [Issue Description]
   - **Suggestion:** [Recommended fix]
   - **Reference:** [Rule file:section]

## Informational (Consider)
1. **file.al:line** - [Standard] - [Observation]
   - **Note:** [Recommendation]

## Standards Compliance Matrix
| Standard | Status | Score |
|----------|--------|-------|
| Naming Conventions | ✅/⚠️/❌ | X/10 |
| Development Patterns | ✅/⚠️/❌ | X/10 |
| Document Extensions | ✅/⚠️/❌ | X/10 |
| Performance | ✅/⚠️/❌ | X/10 |
| LinterCop | ✅/⚠️/❌ | X/10 |
| Security | ✅/⚠️/❌ | X/10 |
| Integration | ✅/⚠️/❌ | X/10 |

## Recommendations
1. [High priority recommendation]
2. [Medium priority recommendation]
3. [Low priority recommendation]

## Next Steps
- Fix all critical issues before commit
- Address warnings in next iteration
- Review informational items for future improvements
```

**Note:** Be thorough. Review EVERY applicable standard. Provide file:line references for ALL issues.
