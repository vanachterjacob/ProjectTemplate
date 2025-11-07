# BC26 Source Code Context

This directory contains AL source code for Business Central 26 extensions.

## General Development Guidelines

When working with AL code in this directory:

1. **Prefix Usage**
   - ALWAYS use the ABC prefix (replace with actual 3-letter customer code)
   - Check `.cursor/rules/000-project-overview.mdc` for the current project prefix
   - Example: `table 77100 "ABC Customer Credit"`

2. **Object ID Range**
   - Development range: 77100-77200 (dummy range)
   - NEVER manually assign production IDs
   - Object Ninja will assign final IDs from customer range

3. **ESC Standards**
   - Early exit pattern (no nested if statements)
   - TryFunction for error-prone operations
   - ConfirmManagement.GetResponseOrDefault() instead of Confirm()
   - NEVER use SetLoadFields before Modify/Insert/Delete

4. **Language**
   - English ONLY in all code, comments, and identifiers
   - Dutch translations via XLIFF Sync tool only

5. **BC26 Base Objects**
   - Reference symbols at: C:\Temp\BC26Objects\BaseApp
   - Use Read tool: Read(//mnt/c/Temp/BC26Objects/BaseApp/Customer.Table.al)
   - For extension patterns, check Microsoft base objects first

## Code Review Checklist

Before committing AL code:

- [ ] ABC prefix used consistently
- [ ] Object ID in dummy range (77100-77200)
- [ ] English-only code and comments
- [ ] Early exit pattern applied
- [ ] No SetLoadFields before Modify/Insert/Delete
- [ ] ConfirmManagement used instead of Confirm()
- [ ] TryFunction for error-prone operations
- [ ] LinterCop compliant (no warnings)
- [ ] Performance tested with production-scale data
- [ ] Complete document extensions (if applicable)

## Module Organization

Organize code by functional area:

```
src/
├── CustomerCredit/         # Customer credit limit management
├── DocumentExtensions/     # Sales/Purchase document extensions
├── Integration/            # External system integrations
├── Setup/                  # Configuration tables and pages
└── _Permissions/          # Permission sets
```

## Quick Reference Commands

```bash
# Find Microsoft base object
Read(//mnt/c/Temp/BC26Objects/BaseApp/Customer.Table.al)

# Search for event pattern
Grep("OnAfterValidateEvent", path="//mnt/c/Temp/BC26Objects/BaseApp")

# Review code for ESC compliance
Use /review command with file path
```

## Getting Help

- **ESC Standards:** See `.cursor/rules/*.mdc` files
- **Naming Conventions:** @.cursor/rules/001-naming-conventions.mdc
- **Development Patterns:** @.cursor/rules/002-development-patterns.mdc
- **Performance Rules:** @.cursor/rules/004-performance.mdc
- **BC26 Symbols:** @.cursor/rules/005-bc26-symbols.mdc

## Common Patterns

### Extending a Document

When extending Sales/Purchase documents, ALWAYS extend:
- Header table + Line table
- Header page + Line subform
- Comment Line table
- Archive tables (Header + Line)
- Posted document versions
- Related reports

See: @.cursor/rules/003-document-extensions.mdc for complete checklist

### Adding a Setup Table

```al
table 77100 "ABC Setup"
{
    DataClassification = CustomerContent;
    Caption = 'ABC Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        // Add your fields here
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
```

### Event Subscriber Pattern

```al
codeunit 77110 "ABC Sales Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Document Type', false, false)]
    local procedure OnAfterValidateSalesHeaderDocType(var Rec: Record "Sales Header")
    begin
        // Your code here
    end;
}
```

---

**Note:** This AGENTS.md file is automatically loaded when you reference any file in the src/ directory. It provides context without needing MDC files or manual @-mentions.
