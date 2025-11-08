---
description: Load complete performance optimization context (patterns, thresholds, ESC rules)
category: context-loader
tags: [performance, optimization, setloadfields, batch, caching, queries]
---

# Performance Optimization Context Loader

**Purpose:** Instantly load all relevant context for performance optimization and ESC compliance.

**Use when working on:**
- Performance troubleshooting
- Large data set processing
- Query optimization
- Batch operations
- Caching implementations
- ESC compliance reviews

## Auto-Loaded Context

### 1. BC27 Documentation
```
@BC27/BC27_LLM_QUICKREF.md
@BC27/BC27_ARCHITECTURE.md (Performance best practices section)
```

### 2. ESC Standards
```
@.cursor/rules/000-project-overview.mdc
@.cursor/rules/001-naming-conventions.mdc
@.cursor/rules/002-development-patterns.mdc
@.cursor/rules/004-performance.mdc (COMPLETE performance patterns)
```

### 3. Security & Deployment
```
@.cursor/rules/007-deployment-security.mdc
```

## ESC Performance Rules Summary

### SetLoadFields (CRITICAL)

**Rule:** Use SetLoadFields for read-only operations only.

**❌ WRONG:**
```al
Customer.SetLoadFields(Name, Address);
Customer.Get('10000');
Customer."Phone No." := '123456';  // ERROR: Field not loaded
Customer.Modify();
```

**✅ CORRECT:**
```al
// Read-only: Use SetLoadFields
Customer.SetLoadFields(Name, Address);
Customer.Get('10000');
Message('%1 %2', Customer.Name, Customer.Address);

// Modify: Load ALL fields
Customer.Get('10000');
Customer."Phone No." := '123456';
Customer.Modify();
```

### SetAutoCalcFields

**Rule:** Use SetAutoCalcFields for FlowFields in read-only scenarios.

**✅ CORRECT:**
```al
Customer.SetLoadFields(Name);
Customer.SetAutoCalcFields(Balance);  // FlowField
Customer.Get('10000');
Message('Balance: %1', Customer.Balance);
```

### Batch Processing Thresholds

**Rule:** Commit every 100-1000 records in batch operations.

**✅ CORRECT:**
```al
procedure ProcessLargeDataset(var TempBuffer: Record "ABC Buffer" temporary)
var
    Counter: Integer;
begin
    if not TempBuffer.FindSet() then
        exit;

    repeat
        ProcessSingleRecord(TempBuffer);
        Counter += 1;

        // Commit every 100 records
        if Counter mod 100 = 0 then
            Commit();
    until TempBuffer.Next() = 0;
end;
```

### FindSet vs. Find('-')

**Rule:** Always use FindSet() for forward-only loops, never Find('-').

**❌ WRONG:**
```al
if Item.Find('-') then
    repeat
        // Process
    until Item.Next() = 0;
```

**✅ CORRECT:**
```al
if Item.FindSet() then
    repeat
        // Process
    until Item.Next() = 0;
```

### Filtering Before Calculations

**Rule:** Always set filters before CalcFields or CalcSums.

**❌ WRONG:**
```al
Customer.CalcFields(Balance);  // Calculates for all companies/filters
Customer.SetRange("Customer Posting Group", 'DOMESTIC');
```

**✅ CORRECT:**
```al
Customer.SetRange("Customer Posting Group", 'DOMESTIC');
Customer.SetRange("Date Filter", StartDate, EndDate);
Customer.CalcFields(Balance);  // Only calculates for filtered data
```

### Query Performance

**Thresholds:**
- Simple SELECT: < 100ms
- Complex JOIN: < 500ms
- Aggregation: < 1s
- Large dataset (>10k records): < 3s

**Pattern:**
```al
procedure OptimizedQuery(CustomerNo: Code[20]): Decimal
var
    SalesLine: Record "Sales Line";
    TotalAmount: Decimal;
begin
    // Early exit
    if CustomerNo = '' then
        exit(0);

    // Use SetLoadFields
    SalesLine.SetLoadFields(Amount);
    SalesLine.SetRange("Sell-to Customer No.", CustomerNo);
    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);

    // Use CalcSums instead of loop
    SalesLine.CalcSums(Amount);
    exit(SalesLine.Amount);
end;
```

### Temporary Tables

**Rule:** Use temporary tables for intermediate calculations.

**✅ CORRECT:**
```al
procedure CalculateComplexData(var TempResult: Record "ABC Result" temporary)
var
    SourceData: Record "ABC Source";
begin
    TempResult.DeleteAll();

    if SourceData.FindSet() then
        repeat
            // Complex calculation
            TempResult.Init();
            TempResult."Entry No." := SourceData."Entry No.";
            TempResult.Amount := CalculateAmount(SourceData);
            TempResult.Insert();
        until SourceData.Next() = 0;
end;
```

### Caching Pattern

**When to cache:**
- Data rarely changes
- Accessed frequently (>10 times per transaction)
- Lookup tables (currencies, countries, setup)

**✅ CORRECT:**
```al
codeunit 77100 "ABC Cache Manager"
{
    var
        CompanyInfo: Record "Company Information";
        CompanyInfoRead: Boolean;

    procedure GetCompanyInfo(var CompanyInformation: Record "Company Information")
    begin
        if not CompanyInfoRead then begin
            CompanyInfo.Get();
            CompanyInfoRead := true;
        end;

        CompanyInformation := CompanyInfo;
    end;

    procedure ClearCache()
    begin
        CompanyInfoRead := false;
        Clear(CompanyInfo);
    end;
}
```

### Index Usage

**Rule:** Filter on indexed fields first.

**Keys:**
```al
keys
{
    key(PK; "Entry No.")
    {
        Clustered = true;
    }
    key(PostingDate; "Posting Date", "Document No.")  // Fast filtering
    {
        SumIndexFields = Amount;
    }
    key(Customer; "Customer No.", "Posting Date")  // Customer queries
    {
    }
}
```

**Query:**
```al
// ✅ CORRECT: Filters on indexed field first
Entry.SetRange("Customer No.", CustomerNo);  // Indexed
Entry.SetRange("Posting Date", StartDate, EndDate);  // Part of same index
Entry.SetRange(Open, true);  // Additional filter
```

### Avoiding N+1 Queries

**❌ WRONG:**
```al
if SalesHeader.FindSet() then
    repeat
        Customer.Get(SalesHeader."Sell-to Customer No.");  // N queries!
        ProcessCustomer(Customer);
    until SalesHeader.Next() = 0;
```

**✅ CORRECT:**
```al
// Option 1: Join with SetLoadFields
if SalesHeader.FindSet() then
    repeat
        if Customer."No." <> SalesHeader."Sell-to Customer No." then begin
            Customer.SetLoadFields(Name, "Payment Terms Code");
            Customer.Get(SalesHeader."Sell-to Customer No.");
        end;
        ProcessCustomer(Customer);
    until SalesHeader.Next() = 0;

// Option 2: Use Query object for complex joins
```

### Record Locking

**Rule:** Minimize lock duration using LockTable sparingly.

**✅ CORRECT:**
```al
procedure GetNextNo(var NoSeriesLine: Record "No. Series Line"): Code[20]
var
    NewNo: Code[20];
begin
    NoSeriesLine.LockTable();  // Lock only when necessary
    NoSeriesLine.Get(NoSeriesLine."Series Code", NoSeriesLine."Line No.");

    NewNo := IncrementNo(NoSeriesLine."Last No. Used");
    NoSeriesLine."Last No. Used" := NewNo;
    NoSeriesLine.Modify();

    exit(NewNo);
end;
```

### CalcFields vs. CalcSums

**CalcFields:** Use for FlowFields (single record).
**CalcSums:** Use for aggregating multiple records.

**✅ CORRECT:**
```al
// CalcFields: Single customer balance
Customer.SetRange("Date Filter", StartDate, EndDate);
Customer.CalcFields(Balance);

// CalcSums: Total for multiple customers
Customer.SetRange("Customer Posting Group", 'DOMESTIC');
Customer.SetRange("Date Filter", StartDate, EndDate);
Customer.CalcSums(Balance);  // Sums across all filtered records
```

### Memory Management

**Rule:** Clear large variables after use.

**✅ CORRECT:**
```al
procedure ProcessLargeReport()
var
    TempBuffer: Record "ABC Buffer" temporary;
    BigText: BigText;
begin
    // Process data
    LoadDataIntoBuffer(TempBuffer);
    ProcessBuffer(TempBuffer);

    // Clear memory
    TempBuffer.DeleteAll();
    Clear(BigText);
end;
```

## Performance Testing Checklist

**Before deployment:**
- ✅ Test with production-size datasets (>10k records)
- ✅ Verify all queries < threshold times
- ✅ Check SetLoadFields used for read operations
- ✅ Validate batch operations commit regularly
- ✅ Review key usage and filtering order
- ✅ Test concurrent user scenarios
- ✅ Profile with Session Event Recorder
- ✅ Check database query plan

## Common Performance Anti-Patterns

**1. Missing Early Exit:**
```al
// ❌ WRONG
procedure ProcessOrder(OrderNo: Code[20])
begin
    SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo);
    // ... complex processing even if already processed
end;

// ✅ CORRECT
procedure ProcessOrder(OrderNo: Code[20])
begin
    if OrderNo = '' then
        exit;  // Early exit

    if not SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo) then
        exit;  // Early exit

    if SalesHeader."ABC Processed" then
        exit;  // Already processed

    // ... complex processing
end;
```

**2. Repeated Get() in Loop:**
```al
// ❌ WRONG
if SalesLine.FindSet() then
    repeat
        Item.Get(SalesLine."No.");  // Repeated Get for same item
    until SalesLine.Next() = 0;

// ✅ CORRECT
LastItemNo := '';
if SalesLine.FindSet() then
    repeat
        if SalesLine."No." <> LastItemNo then begin
            Item.SetLoadFields(Description, "Base Unit of Measure");
            Item.Get(SalesLine."No.");
            LastItemNo := SalesLine."No.";
        end;
    until SalesLine.Next() = 0;
```

**3. Unnecessary Modify():**
```al
// ❌ WRONG
if SalesHeader.Get(DocType, DocNo) then begin
    SalesHeader.Modify();  // No changes made!
end;

// ✅ CORRECT
if SalesHeader.Get(DocType, DocNo) then begin
    SalesHeader."ABC Field" := NewValue;
    if SalesHeader.Modify() then;  // Only if field changed
end;
```

## Context Loaded ✓

You now have all necessary context for performance optimization.

**Examples:**
- "Review my code for ESC performance compliance"
- "Optimize this batch processing routine"
- "Why is this query slow?"
- "How should I cache this frequently accessed data?"
- "Convert this loop to use SetLoadFields correctly"

## Quick Reference Card

| Operation | Use | Don't Use |
|-----------|-----|-----------|
| Forward loop | FindSet() | Find('-') |
| Read-only | SetLoadFields | Full record load |
| FlowField read | SetAutoCalcFields | Manual calculation |
| Aggregate | CalcSums | Loop + counter |
| Batch commit | Every 100-1000 | Never or every record |
| Exit early | First line checks | Nested if statements |
| Filter before | All SetRange first | CalcFields then filter |
| Temporary data | Temporary tables | Regular tables |
| Caching | Setup/lookup data | Transaction data |
| Locking | Minimal duration | LockTable at start |
