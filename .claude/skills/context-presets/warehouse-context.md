---
description: Load complete warehouse & inventory context (WMS, bins, picks, put-aways)
category: context-loader
tags: [warehouse, inventory, wms, bins, picks, put-aways, shipment]
---

# Warehouse & Inventory Context Loader

**Purpose:** Instantly load all relevant context for warehouse management and inventory development.

**Use when working on:**
- Warehouse picks and put-aways
- Bin management
- Inventory posting
- Item tracking (serial/lot numbers)
- Warehouse shipments and receipts
- Stock transfers

## Auto-Loaded Context

### 1. BC27 Documentation
```
@BC27/BC27_LLM_QUICKREF.md
@BC27/events/BC27_EVENTS_WAREHOUSE.md (18+ picks, put-aways, bins, movements)
@BC27/BC27_EXTENSION_POINTS.md (Item, Warehouse tables)
@BC27/BC27_MODULES_OVERVIEW.md (Warehouse Management module)
```

### 2. ESC Standards
```
@.cursor/rules/000-project-overview.mdc
@.cursor/rules/001-naming-conventions.mdc
@.cursor/rules/002-development-patterns.mdc
```

### 3. Performance Rules
```
@.cursor/rules/004-performance.mdc (focus: inventory calculations, bin content queries)
```

## Key Events Available

**Warehouse Activity Events:**
- OnBeforeCreatePickDoc
- OnAfterCreatePickDoc
- OnBeforeCreatePutAwayDoc
- OnAfterCreatePutAwayDoc
- OnBeforeRegisterWhseActivity
- OnAfterRegisterWhseActivity

**Inventory Posting:**
- OnBeforePostItemJnlLine
- OnAfterPostItemJnlLine
- OnBeforeInsertItemLedgerEntry
- OnAfterInsertItemLedgerEntry
- OnBeforeApplyItemLedgEntry

**Bin Management:**
- OnBeforeFindBinContent
- OnAfterCalcBinAvailability
- OnBeforeUpdateBinContent
- OnAfterCreateBinContent

**Item Tracking:**
- OnBeforeItemTrackingLinesCreate
- OnAfterItemTrackingLinesInsert
- OnBeforeLotNoValidation
- OnAfterSerialNoValidation

**Warehouse Shipment:**
- OnBeforeCreateWhseShipment
- OnAfterCreateWhseShipment
- OnBeforePostWhseShipment
- OnAfterPostWhseShipment

## Common Extension Points

**Tables to extend:**
- Item (27)
- Item Ledger Entry (32)
- Warehouse Activity Line (5767)
- Warehouse Shipment Header (7320)
- Warehouse Receipt Header (7316)
- Bin (7354)
- Bin Content (7302)
- Warehouse Entry (7312)

**Pages to extend:**
- Item Card (30)
- Item List (31)
- Warehouse Pick (5785)
- Warehouse Put-away (5786)
- Warehouse Shipment (7335)
- Warehouse Receipt (7332)
- Bin Contents (7305)

## ESC Patterns for Warehouse

**Item Extension with Inventory Fields:**
```al
tableextension 77100 "ABC Item Ext" extends Item
{
    fields
    {
        field(77100; "ABC Warehouse Code"; Code[10])
        {
            Caption = 'ABC Warehouse Code';
            DataClassification = CustomerContent;
            TableRelation = Location where("Use As In-Transit" = const(false));
        }

        field(77101; "ABC Default Bin Code"; Code[20])
        {
            Caption = 'ABC Default Bin Code';
            DataClassification = CustomerContent;
            TableRelation = Bin.Code where("Location Code" = field("ABC Warehouse Code"));
        }

        field(77102; "ABC Min. Stock Level"; Decimal)
        {
            Caption = 'ABC Minimum Stock Level';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
    }
}
```

**Warehouse Pick Event Subscriber:**
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnBeforePostedWhseActivityLineInsert', '', true, true)]
local procedure OnBeforePostedWhseActivityLineInsert(
    var PostedWhseActivityLine: Record "Posted Whse. Activity Line";
    WhseActivityLine: Record "Warehouse Activity Line")
var
    Item: Record Item;
begin
    // Early exit if not pick
    if WhseActivityLine."Activity Type" <> WhseActivityLine."Activity Type"::Pick then
        exit;

    // Add custom fields
    if Item.Get(WhseActivityLine."Item No.") then begin
        PostedWhseActivityLine."ABC Custom Field" := Item."ABC Custom Field";
    end;
end;
```

**Bin Content Validation (Early Exit + TryFunction):**
```al
procedure TryValidateBinContent(LocationCode: Code[10]; BinCode: Code[20]; ItemNo: Code[20]; Quantity: Decimal): Boolean
var
    BinContent: Record "Bin Content";
    AvailableQty: Decimal;
begin
    // Early exit checks
    if (LocationCode = '') or (BinCode = '') or (ItemNo = '') then
        exit(false);

    if Quantity <= 0 then
        exit(false);

    // Find bin content
    BinContent.SetLoadFields("Location Code", "Bin Code", "Item No.", Quantity);
    BinContent.SetRange("Location Code", LocationCode);
    BinContent.SetRange("Bin Code", BinCode);
    BinContent.SetRange("Item No.", ItemNo);

    if not BinContent.FindFirst() then
        exit(false);

    // Calculate available quantity
    BinContent.CalcFields(Quantity, "Qty. on Pick", "Qty. on Put-away");
    AvailableQty := BinContent.Quantity - BinContent."Qty. on Pick" - BinContent."Qty. on Put-away";

    exit(AvailableQty >= Quantity);
end;
```

**Custom Warehouse Document:**
```al
table 77100 "ABC Warehouse Document"
{
    Caption = 'ABC Warehouse Document';
    DataClassification = CustomerContent;
    LookupPageId = "ABC Warehouse Documents";
    DrillDownPageId = "ABC Warehouse Documents";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;

            trigger OnValidate()
            begin
                if "Location Code" <> xRec."Location Code" then
                    ValidateLocationChange();
            end;
        }
        field(3; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                // Early exit
                if Quantity = xRec.Quantity then
                    exit;

                ValidateQuantity();
            end;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Location; "Location Code", "Document Date")
        {
        }
    }

    local procedure ValidateQuantity()
    begin
        if Quantity < 0 then
            Error('Quantity cannot be negative');
    end;
}
```

**Inventory Calculation (Performance Optimized):**
```al
procedure CalculateAvailableInventory(ItemNo: Code[20]; LocationCode: Code[10]): Decimal
var
    Item: Record Item;
begin
    // Early exit
    if ItemNo = '' then
        exit(0);

    // Use SetLoadFields for performance
    Item.SetLoadFields(Inventory, "Qty. on Purch. Order", "Qty. on Sales Order");
    if not Item.Get(ItemNo) then
        exit(0);

    // Set filters for location if specified
    if LocationCode <> '' then
        Item.SetRange("Location Filter", LocationCode);

    // Calculate fields
    Item.CalcFields(Inventory, "Qty. on Purch. Order", "Qty. on Sales Order");

    exit(Item.Inventory + Item."Qty. on Purch. Order" - Item."Qty. on Sales Order");
end;
```

**Item Tracking Validation:**
```al
[EventSubscriber(ObjectType::Table, Table::"Reservation Entry", 'OnBeforeValidateSerialNo', '', true, true)]
local procedure OnBeforeValidateSerialNo(var ReservationEntry: Record "Reservation Entry"; var IsHandled: Boolean)
begin
    // Early exit if already handled
    if IsHandled then
        exit;

    // Custom serial number validation
    if not ValidateSerialNumberFormat(ReservationEntry."Serial No.") then begin
        IsHandled := true;
        Error('Invalid serial number format');
    end;
end;

local procedure ValidateSerialNumberFormat(SerialNo: Code[50]): Boolean
begin
    // Early exit if empty
    if SerialNo = '' then
        exit(true);

    // Custom validation logic
    exit(StrLen(SerialNo) >= 6);
end;
```

## Performance Best Practices

**Inventory Queries:**
- ✅ Always use SetLoadFields when reading Item
- ✅ Filter by Location before CalcFields
- ✅ Use SumIndexFields for bin content totals
- ✅ Cache frequently accessed inventory values
- ✅ Avoid repeated CalcFields in loops

**Example:**
```al
procedure GetInventoryForMultipleItems(var TempItem: Record Item temporary)
var
    Item: Record Item;
begin
    Item.SetLoadFields(Inventory);
    Item.SetAutoCalcFields(Inventory);

    if TempItem.FindSet() then
        repeat
            if Item.Get(TempItem."No.") then begin
                TempItem.Inventory := Item.Inventory;
                TempItem.Modify();
            end;
        until TempItem.Next() = 0;
end;
```

## Security Considerations

**Permissions:**
```al
permissionset 77100 "ABC Warehouse Ops"
{
    Assignable = true;
    Caption = 'ABC Warehouse Operations';

    Permissions =
        tabledata Item = R,
        tabledata "Item Ledger Entry" = R,
        tabledata "Bin Content" = RIMD,
        tabledata "Warehouse Entry" = R,
        table "ABC Warehouse Document" = X,
        page "ABC Warehouse Documents" = X;
}
```

## Context Loaded ✓

You now have all necessary context for warehouse and inventory development.

**Examples:**
- "Create custom bin selection logic based on item category"
- "Add validation to prevent picking from restricted bins"
- "Extend warehouse shipment with delivery route field"
- "Subscribe to inventory posting to update custom stock table"
- "Implement automatic bin replenishment logic"
