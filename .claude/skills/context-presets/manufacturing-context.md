---
description: Load complete manufacturing context (production, BOMs, routing, capacity)
category: context-loader
tags: [manufacturing, production, bom, routing, capacity, work-center]
---

# Manufacturing & Production Context Loader

**Purpose:** Instantly load all relevant context for manufacturing and production development.

**Use when working on:**
- Production orders
- Bills of Materials (BOMs)
- Routing and work centers
- Capacity planning
- Manufacturing output posting
- Shop floor control

## Auto-Loaded Context

### 1. BC27 Documentation
```
@BC27/BC27_LLM_QUICKREF.md
@BC27/events/BC27_EVENTS_MANUFACTURING.md (30+ production, BOM, routing events)
@BC27/BC27_EXTENSION_POINTS.md (Production Order, BOM tables)
@BC27/BC27_MODULES_OVERVIEW.md (Manufacturing module)
```

### 2. ESC Standards
```
@.cursor/rules/000-project-overview.mdc
@.cursor/rules/001-naming-conventions.mdc
@.cursor/rules/002-development-patterns.mdc
```

### 3. Performance Rules
```
@.cursor/rules/004-performance.mdc (focus: BOM explosions, capacity calculations)
```

## Key Events Available

**Production Order Events:**
- OnBeforeCreateProdOrder
- OnAfterCreateProdOrder
- OnBeforeRefreshProdOrder
- OnAfterRefreshProdOrder
- OnBeforeChangeProdOrderStatus
- OnAfterChangeProdOrderStatus
- OnBeforeFinishProdOrder
- OnAfterFinishProdOrder

**BOM Events:**
- OnBeforeInsertBOMComponent
- OnAfterInsertBOMComponent
- OnBeforeCalcBOMQuantity
- OnAfterCalcBOMQuantity
- OnBeforeExplodeBOM
- OnAfterExplodeBOM

**Routing Events:**
- OnBeforeInsertRoutingLine
- OnAfterInsertRoutingLine
- OnBeforeCalcRoutingTime
- OnAfterCalcRoutingTime
- OnBeforeUpdateRoutingStatus

**Output Posting:**
- OnBeforePostOutput
- OnAfterPostOutput
- OnBeforeOutputJnlPostLine
- OnAfterOutputJnlPostLine
- OnBeforePostConsumption
- OnAfterPostConsumption

**Capacity Events:**
- OnBeforeCalcCapacity
- OnAfterCalcCapacity
- OnBeforeUpdateWorkCenterCalendar
- OnAfterUpdateMachCtrCalendar

## Common Extension Points

**Tables to extend:**
- Production Order (5405)
- Prod. Order Line (5406)
- Prod. Order Component (5407)
- Prod. Order Routing Line (5409)
- Production BOM Header (99000771)
- Production BOM Line (99000772)
- Routing Header (99000763)
- Routing Line (99000764)
- Work Center (99000754)
- Machine Center (99000758)

**Pages to extend:**
- Production Order (99000831)
- Released Production Order (9326)
- Production BOM (99000786)
- Routing (99000765)
- Work Centers (99000754)
- Machine Centers (99000761)

## ESC Patterns for Manufacturing

**Production Order Extension:**
```al
tableextension 77100 "ABC Prod. Order Ext" extends "Production Order"
{
    fields
    {
        field(77100; "ABC Production Line"; Code[20])
        {
            Caption = 'ABC Production Line';
            DataClassification = CustomerContent;
            TableRelation = "ABC Production Line";
        }

        field(77101; "ABC Priority Level"; Option)
        {
            Caption = 'ABC Priority Level';
            DataClassification = CustomerContent;
            OptionMembers = Normal,High,Urgent;
            OptionCaption = 'Normal,High,Urgent';
        }

        field(77102; "ABC Planned Start DateTime"; DateTime)
        {
            Caption = 'ABC Planned Start Date Time';
            DataClassification = CustomerContent;
        }
    }
}
```

**Production Order Status Change Subscriber:**
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnBeforeChangeProdOrderStatus', '', true, true)]
local procedure OnBeforeChangeProdOrderStatus(
    var ProdOrder: Record "Production Order";
    NewStatus: Enum "Production Order Status";
    var IsHandled: Boolean)
begin
    // Early exit if already handled
    if IsHandled then
        exit;

    // Early exit if not relevant status change
    if NewStatus <> NewStatus::Released then
        exit;

    // Custom validation before releasing
    if not ValidateProductionLineCapacity(ProdOrder) then begin
        IsHandled := true;
        Error('Production line has insufficient capacity');
    end;
end;

local procedure ValidateProductionLineCapacity(ProdOrder: Record "Production Order"): Boolean
var
    ProdOrderLine: Record "Prod. Order Line";
    TotalQuantity: Decimal;
begin
    // Early exit
    if ProdOrder."ABC Production Line" = '' then
        exit(true);

    // Calculate total quantity
    ProdOrderLine.SetLoadFields(Quantity);
    ProdOrderLine.SetRange(Status, ProdOrder.Status);
    ProdOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");

    if ProdOrderLine.FindSet() then
        repeat
            TotalQuantity += ProdOrderLine.Quantity;
        until ProdOrderLine.Next() = 0;

    exit(CheckLineCapacity(ProdOrder."ABC Production Line", TotalQuantity));
end;
```

**BOM Component Validation (TryFunction):**
```al
procedure TryValidateBOMComponent(ItemNo: Code[20]; ComponentNo: Code[20]; QuantityPer: Decimal): Boolean
var
    Item: Record Item;
    Component: Record Item;
begin
    // Early exit checks
    if (ItemNo = '') or (ComponentNo = '') then
        exit(false);

    if QuantityPer <= 0 then
        exit(false);

    // Validate parent item
    Item.SetLoadFields("No.", Type, "Replenishment System");
    if not Item.Get(ItemNo) then
        exit(false);

    if Item."Replenishment System" <> Item."Replenishment System"::"Prod. Order" then
        exit(false);

    // Validate component
    Component.SetLoadFields("No.", Type);
    if not Component.Get(ComponentNo) then
        exit(false);

    // Prevent circular references
    if ComponentNo = ItemNo then
        exit(false);

    exit(true);
end;
```

**Output Posting with Early Exit:**
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforePostOutputLine', '', true, true)]
local procedure OnBeforePostOutputLine(
    var ItemJournalLine: Record "Item Journal Line";
    var IsHandled: Boolean)
var
    ProdOrder: Record "Production Order";
begin
    // Early exit if not output
    if ItemJournalLine."Entry Type" <> ItemJournalLine."Entry Type"::Output then
        exit;

    // Early exit if no production order
    if ItemJournalLine."Order No." = '' then
        exit;

    // Validate production order status
    if not ProdOrder.Get(ProdOrder.Status::Released, ItemJournalLine."Order No.") then begin
        IsHandled := true;
        Error('Production order must be released');
    end;

    // Custom validations
    ValidateOutputQuantity(ItemJournalLine);
end;

local procedure ValidateOutputQuantity(var ItemJournalLine: Record "Item Journal Line")
var
    ProdOrderLine: Record "Prod. Order Line";
    RemainingQuantity: Decimal;
begin
    // Find related production order line
    ProdOrderLine.SetLoadFields("Remaining Quantity");
    ProdOrderLine.SetRange(Status, ProdOrderLine.Status::Released);
    ProdOrderLine.SetRange("Prod. Order No.", ItemJournalLine."Order No.");
    ProdOrderLine.SetRange("Line No.", ItemJournalLine."Prod. Order Line No.");

    if not ProdOrderLine.FindFirst() then
        exit;

    ProdOrderLine.CalcFields("Remaining Quantity");
    RemainingQuantity := ProdOrderLine."Remaining Quantity";

    if ItemJournalLine."Output Quantity" > RemainingQuantity then
        Error('Output quantity cannot exceed remaining quantity %1', RemainingQuantity);
end;
```

**Custom Manufacturing Table:**
```al
table 77100 "ABC Production Line"
{
    Caption = 'ABC Production Line';
    DataClassification = CustomerContent;
    LookupPageId = "ABC Production Lines";
    DrillDownPageId = "ABC Production Lines";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(10; "Work Center No."; Code[20])
        {
            Caption = 'Work Center No.';
            TableRelation = "Work Center";
        }
        field(11; "Daily Capacity"; Decimal)
        {
            Caption = 'Daily Capacity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(12; "Efficiency %"; Decimal)
        {
            Caption = 'Efficiency %';
            DecimalPlaces = 0 : 2;
            MinValue = 0;
            MaxValue = 100;
        }
        field(20; "Current Load %"; Decimal)
        {
            Caption = 'Current Load %';
            DecimalPlaces = 0 : 2;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Prod. Order Line".Quantity where("ABC Production Line" = field(Code),
                                                                  Status = const(Released)));
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
        key(WorkCenter; "Work Center No.")
        {
        }
    }

    trigger OnDelete()
    var
        ProdOrder: Record "Production Order";
    begin
        // Prevent deletion if in use
        ProdOrder.SetRange("ABC Production Line", Code);
        if not ProdOrder.IsEmpty then
            Error('Cannot delete production line that is in use');
    end;
}
```

**Routing Time Calculation:**
```al
procedure CalculateRoutingTime(RoutingNo: Code[20]; var SetupTime: Decimal; var RunTime: Decimal): Boolean
var
    RoutingLine: Record "Routing Line";
begin
    // Early exit
    if RoutingNo = '' then
        exit(false);

    SetupTime := 0;
    RunTime := 0;

    // Use SetLoadFields for performance
    RoutingLine.SetLoadFields("Setup Time", "Run Time");
    RoutingLine.SetRange("Routing No.", RoutingNo);

    if not RoutingLine.FindSet() then
        exit(false);

    repeat
        SetupTime += RoutingLine."Setup Time";
        RunTime += RoutingLine."Run Time";
    until RoutingLine.Next() = 0;

    exit(true);
end;
```

## Performance Best Practices

**BOM Explosions:**
- ✅ Use SetLoadFields when reading BOM components
- ✅ Cache BOM structures for repeated calculations
- ✅ Filter by version code early
- ✅ Avoid recursive BOM explosions without depth limit

**Capacity Calculations:**
- ✅ Use CalcFields for aggregated capacity
- ✅ Filter by date range before calculations
- ✅ Cache work center calendar data
- ✅ Use SumIndexFields for production order quantities

**Example:**
```al
procedure CalculateWorkCenterLoad(WorkCenterNo: Code[20]; StartDate: Date; EndDate: Date): Decimal
var
    CalendarEntry: Record "Calendar Entry";
    TotalCapacity: Decimal;
begin
    // Early exit
    if WorkCenterNo = '' then
        exit(0);

    CalendarEntry.SetLoadFields(Capacity);
    CalendarEntry.SetRange("Work Center No.", WorkCenterNo);
    CalendarEntry.SetRange(Date, StartDate, EndDate);

    if CalendarEntry.FindSet() then
        repeat
            TotalCapacity += CalendarEntry.Capacity;
        until CalendarEntry.Next() = 0;

    exit(TotalCapacity);
end;
```

## Security Considerations

**Permissions:**
```al
permissionset 77100 "ABC Manufacturing"
{
    Assignable = true;
    Caption = 'ABC Manufacturing';

    Permissions =
        tabledata "Production Order" = RIMD,
        tabledata "Prod. Order Line" = RIMD,
        tabledata "Prod. Order Component" = RIMD,
        tabledata "Production BOM Header" = R,
        table "ABC Production Line" = X,
        page "ABC Production Lines" = X;
}
```

## Context Loaded ✓

You now have all necessary context for manufacturing and production development.

**Examples:**
- "Add custom production line field to production orders"
- "Validate BOM components before production order release"
- "Subscribe to output posting to update custom tracking table"
- "Create custom routing calculation for parallel operations"
- "Implement automatic work center selection based on capacity"
