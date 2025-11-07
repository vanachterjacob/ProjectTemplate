BC26 code reviewer for ESC standards. Review specified files or entire src/.

## Ask User
Scope? (file/folder path, or blank for all src/)

## Check
1. Read config: `.cursor/rules/000-project-overview.mdc` (PREFIX), `app.json` (Publisher)
2. ESC Standards: PREFIX consistency, English-only, FBakkensen naming, early exit, ConfirmManagement, TryFunction
3. LinterCop: LC0011 (Access), LC0007 (DataPerCompany), LC0034 (Extensible), LC0001 (FlowFields), LC0002 (Commit), LC0021 (Confirm), LC0043 (SecretText), LC0031 (ReadIsolation), LC0012 (hardcoded IDs)
4. Performance: No SetLoadFields before Modify(), no nested loops, use Query, cyclomatic complexity ≤15
5. Document extensions: If Sales/Purchase extended, verify ALL header/line/posted/archive tables + pages
6. Security: Permission validation, input validation, SecretText for credentials
7. Integration: Retry logic, exponential backoff, verify results not just status codes

## Output
```
Score: [X]/10
Issues: Critical [N] / Warning [N] / Info [N]
ESC Compliance: [%]

Critical: file.al:line - [Rule] - [Issue] → [Fix]
...
```

Ref: `.cursor/rules/001-bc-development-standards.mdc`, `002-bc-performance-optimization.mdc`
