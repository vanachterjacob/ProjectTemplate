# ESC Strict Compliance Mode

Apply **maximum ESC standard compliance** to all code in this project.

## Enforcement Level
- **STRICT** - Zero tolerance for ESC violations
- Review ALL code before committing
- Performance testing required for loops
- Security validation on all external inputs

## Mandatory Patterns

### 1. Early Exit (ALWAYS)
```al
// ✅ REQUIRED
procedure OnBeforeSalesPost(var SalesHeader: Record "Sales Header")
begin
    if SalesHeader."No." = '' then
        exit;
    // Your logic
end;
```

### 2. SetLoadFields (ALWAYS on loops)
```al
// ✅ REQUIRED
Customer.SetLoadFields("No.", Name, "E-Mail");
if Customer.FindSet() then
    repeat
        // Process
    until Customer.Next() = 0;
```

### 3. TryFunction (for validation)
```al
// ✅ REQUIRED for validation
procedure TryValidateEmail(Email: Text): Boolean
begin
    // Validation logic
    exit(true);
end;
```

### 4. Confirm Pattern
```al
// ✅ REQUIRED for destructive actions
if not Confirm(ConfirmDeleteQst) then
    Error('');
```

## Performance Thresholds

NEVER exceed these limits:
- **FindSet loops**: Max 1000 iterations without batch
- **StrSubstNo calls in loops**: FORBIDDEN
- **Nested loops**: Max 2 levels deep
- **Recursive calls**: Max depth 10
- **CalcFields in loops**: FORBIDDEN

## Review Checklist

Before ANY commit:
- ✅ Early exit in ALL procedures
- ✅ SetLoadFields on ALL loops
- ✅ TryFunction for validation
- ✅ Confirm for destructive actions
- ✅ No StrSubstNo in loops
- ✅ No CalcFields in loops
- ✅ Performance tested
- ✅ Security validated

## Auto-Review Command

After coding, ALWAYS run:
```
/review [file-or-folder]
```

## Zero Tolerance

These patterns will be **REJECTED** in code review:
- ❌ Missing early exit
- ❌ Loops without SetLoadFields
- ❌ Validation without TryFunction
- ❌ StrSubstNo in loops
- ❌ CalcFields in loops
- ❌ Nested loops > 2 levels
- ❌ Missing error handling

## Remember
ESC compliance is NOT optional. It ensures:
- Performance at scale (millions of records)
- Security against attacks
- Maintainability for team
- Microsoft AppSource certification
