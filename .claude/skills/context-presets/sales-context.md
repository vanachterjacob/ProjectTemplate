---
description: Load complete sales & customer context (docs, events, patterns)
category: context-loader
tags: [sales, orders, customers, invoicing, shipping]
---

# Sales & Customer Context Loader

**Purpose:** Instantly load all relevant context for sales document development.

**Use when working on:**
- Sales Orders, Quotes, Invoices, Credit Memos
- Customer extensions
- Pricing, discounts, payment terms
- Order processing workflows
- Shipping and delivery

## Auto-Loaded Context

### 1. BC27 Documentation
```
@BC27/BC27_LLM_QUICKREF.md
@BC27/BC27_EVENT_CATALOG.md (Sales Order Posting, Invoice Posting, Customer events)
@BC27/BC27_EXTENSION_POINTS.md (Customer, Sales Header, Sales Line tables)
```

### 2. ESC Standards
```
@.cursor/rules/000-project-overview.mdc
@.cursor/rules/001-naming-conventions.mdc
@.cursor/rules/002-development-patterns.mdc
@.cursor/rules/003-document-extensions.mdc
```

### 3. Performance Rules
```
@.cursor/rules/004-performance.mdc (focus: table reads, SetLoadFields)
```

## Key Events Available

**Sales Order Processing:**
- OnBeforePostSalesDoc
- OnAfterPostSalesDoc
- OnAfterSalesLineInsert
- OnBeforeSalesLineValidate
- OnAfterReleaseSalesDoc

**Customer Events:**
- OnBeforeCustomerInsert
- OnAfterCustomerModify
- OnBeforeCustomerCreditLimitCheck

**Pricing & Discounts:**
- OnAfterCalcSalesPrice
- OnAfterCalcSalesLineDiscount
- OnBeforeFindSalesLinePrice

## Common Extension Points

**Tables to extend:**
- Customer (18)
- Sales Header (36)
- Sales Line (37)
- Sales Invoice Header (112)
- Sales Invoice Line (113)

**Pages to extend:**
- Customer Card (21)
- Customer List (22)
- Sales Order (42)
- Sales Order List (9305)
- Sales Invoice (43)

## ESC Patterns for Sales

**Complete Document Extension:**
```al
tableextension 77100 "ABC Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(77100; "ABC Custom Field"; Text[100])
        {
            Caption = 'Custom Field';
            DataClassification = CustomerContent;
        }
    }
}

// ALWAYS extend ALL related tables:
// - Sales Header + Sales Line
// - Sales Invoice Header + Sales Invoice Line
// - Sales Cr.Memo Header + Sales Cr.Memo Line
// - Posted Sales Shipment Header + Line
```

**Sales Validation with Early Exit:**
```al
[EventSubscriber(ObjectType::Table, Table::"Sales Line", 'OnBeforeValidateQuantity', '', true, true)]
local procedure OnBeforeValidateQuantity(var SalesLine: Record "Sales Line")
begin
    if SalesLine.Type <> SalesLine.Type::Item then
        exit; // Early exit

    if not ValidateCustomBusinessRule(SalesLine) then
        Error('Validation failed');
end;
```

## Context Loaded ✓

You now have all necessary context for sales development. Ask your question or describe the feature to implement.

**Examples:**
- "Add custom approval workflow for sales orders over €10,000"
- "Extend customer card with credit rating field"
- "Subscribe to sales posting to update custom ledger"
- "Add validation to prevent negative discounts"
