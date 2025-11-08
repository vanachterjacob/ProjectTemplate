---
description: Load complete posting & ledger context (G/L, ledgers, financial events)
category: context-loader
tags: [posting, ledger, general-ledger, financial, journal]
---

# Posting & Ledger Context Loader

**Purpose:** Instantly load all relevant context for posting routine and ledger development.

**Use when working on:**
- General Ledger posting
- Custom ledger entries
- Journal posting modifications
- Financial posting workflows
- Ledger entry extensions

## Auto-Loaded Context

### 1. BC27 Documentation
```
@BC27/BC27_LLM_QUICKREF.md
@BC27/BC27_EVENT_CATALOG.md (G/L Posting, Journal Posting events)
@BC27/BC27_EXTENSION_POINTS.md (G/L Entry, Journal Line tables)
@BC27/BC27_ARCHITECTURE.md (Posting Layer section)
```

### 2. ESC Standards
```
@.cursor/rules/000-project-overview.mdc
@.cursor/rules/001-naming-conventions.mdc
@.cursor/rules/002-development-patterns.mdc
```

### 3. Performance & Security
```
@.cursor/rules/004-performance.mdc (focus: batch processing, commits)
@.cursor/rules/007-deployment-security.mdc (focus: permissions)
```

## Key Events Available

**General Ledger Posting:**
- OnBeforePostGLEntry
- OnAfterPostGLEntry
- OnBeforeGLFinishPosting
- OnAfterGLFinishPosting
- OnBeforeInsertGlobalGLEntry

**Journal Posting:**
- OnBeforePostJournalLine
- OnAfterPostJournalLine
- OnBeforeCheckJnlLineBalance
- OnBeforeRunCheck

**Sales/Purchase Posting:**
- OnBeforePostSalesDoc
- OnAfterPostSalesDoc
- OnBeforePostPurchaseDoc
- OnAfterPostPurchaseDoc
- OnBeforeRunGenJnlPostLine

**Ledger Entry Events:**
- OnBeforeCustLedgerEntryInsert
- OnBeforeVendLedgerEntryInsert
- OnBeforeItemLedgerEntryInsert
- OnAfterCustLedgerEntryModify

## Common Extension Points

**Tables to extend:**
- G/L Entry (17)
- Gen. Journal Line (81)
- Cust. Ledger Entry (21)
- Vendor Ledger Entry (25)
- Item Ledger Entry (32)
- Value Entry (5802)

**Pages to extend:**
- General Ledger Entries (20)
- General Journal (39)
- Customer Ledger Entries (25)
- Vendor Ledger Entries (29)

## ESC Patterns for Posting

**Custom Ledger Entry Table:**
```al
table 77100 "ABC Custom Ledger Entry"
{
    Caption = 'ABC Custom Ledger Entry';
    DataClassification = CustomerContent;
    LookupPageId = "ABC Custom Ledger Entries";
    DrillDownPageId = "ABC Custom Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(10; "Amount"; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 1;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(PostingDate; "Posting Date", "Document No.")
        {
            SumIndexFields = Amount;
        }
    }
}
```

**Posting Event Subscriber (Early Exit + Error Handling):**
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostGLEntry', '', true, true)]
local procedure OnBeforePostGLEntry(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
var
    CustomLedgerMgt: Codeunit "ABC Custom Ledger Mgt";
begin
    // Early exit if not relevant
    if GenJournalLine."Source Code" <> 'CUSTOM' then
        exit;

    if not CustomLedgerMgt.TryCreateCustomEntry(GenJournalLine) then
        Error('Failed to create custom ledger entry');
end;
```

**Batch Posting with Commit Control:**
```al
procedure PostBatchEntries(var TempBuffer: Record "ABC Buffer" temporary)
var
    Counter: Integer;
begin
    if not TempBuffer.FindSet() then
        exit;

    repeat
        PostSingleEntry(TempBuffer);
        Counter += 1;

        // Commit every 100 records (ESC performance pattern)
        if Counter mod 100 = 0 then
            Commit();
    until TempBuffer.Next() = 0;
end;
```

## Security Considerations

**Always:**
- ✅ Check permissions before posting
- ✅ Use TryFunction for posting operations
- ✅ Log posting errors
- ✅ Validate amounts and dates
- ✅ Maintain audit trail

**Permissions needed:**
```al
permissionset 77100 "ABC Posting"
{
    Assignable = true;
    Caption = 'ABC Custom Posting';

    Permissions =
        tabledata "ABC Custom Ledger Entry" = RIMD,
        table "ABC Custom Ledger Entry" = X;
}
```

## Context Loaded ✓

You now have all necessary context for posting and ledger development.

**Examples:**
- "Create custom ledger for tracking commission payments"
- "Subscribe to sales posting to update custom financial table"
- "Add validation to prevent posting on closed periods"
- "Extend G/L Entry with custom dimensions"
