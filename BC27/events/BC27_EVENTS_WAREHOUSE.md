# BC27 Advanced Warehouse Events - WMS Integration Points

Event reference for Advanced Warehouse module in Business Central 27. Extend warehouse picks, put-aways, bin management, and directed operations.

**Module**: Advanced Warehouse Management
**Version**: 1.0
**BC Version**: 27
**Last Updated**: 2025-11-08

---

## Warehouse Pick Events

### OnBeforeCreatePick
- **Publisher**: Codeunit 7312 "Whse.-Create Pick"
- **When**: Before creating warehouse pick
- **Cancellable**: Yes
- **Parameters**: `var WarehouseShipmentLine: Record "Warehouse Shipment Line"`, `var Handled: Boolean`
- **Uses**: Apply pick strategies (FIFO, FEFO, zone-based), validate availability, check pick capacity, optimize pick routes
- **Source**: [WhseCreatePick.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Warehouse/Activity/WhseCreatePick.Codeunit.al)

**Example**:
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Pick", 'OnBeforeCreatePick', '', false, false)]
local procedure ApplyFEFOStrategy(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; var Handled: Boolean)
begin
    if WarehouseShipmentLine."ABC Use FEFO" then begin
        ABCPickStrategy.CreateFEFOPick(WarehouseShipmentLine);
        Handled := true;
    end;
end;
```

### OnAfterCreatePick
- **Publisher**: Codeunit 7312 "Whse.-Create Pick"
- **When**: After pick created
- **Parameters**: `var WarehouseActivityLine: Record "Warehouse Activity Line"`, `WarehouseShipmentLine: Record "Warehouse Shipment Line"`
- **Uses**: Assign to picker, optimize pick wave, send pick notification, update warehouse dashboard

### OnBeforeRegisterPick
- **Publisher**: Codeunit 7307 "Whse.-Activity-Register"
- **When**: Before registering completed pick
- **Cancellable**: Yes
- **Parameters**: `var WarehouseActivityLine: Record "Warehouse Activity Line"`, `var Handled: Boolean`
- **Uses**: Validate quantities picked, verify lot/serial numbers, check bin locations, apply quality control

### OnAfterRegisterPick
- **Publisher**: Codeunit 7307 "Whse.-Activity-Register"
- **When**: After pick registered
- **Parameters**: `var WarehouseActivityLine: Record "Warehouse Activity Line"`
- **Uses**: Update bin contents, trigger shipment posting, calculate picker performance, update inventory real-time

---

## Warehouse Put-Away Events

### OnBeforeCreatePutAway
- **Publisher**: Codeunit 7314 "Whse.-Create Put-away"
- **When**: Before creating warehouse put-away
- **Cancellable**: Yes
- **Parameters**: `var WarehouseReceiptLine: Record "Warehouse Receipt Line"`, `var Handled: Boolean`
- **Uses**: Apply directed put-away logic, determine optimal bins, check bin capacity, apply ABC classification
- **Source**: [WhseCreatePutaway.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Warehouse/Activity/WhseCreatePutaway.Codeunit.al)

### OnAfterCreatePutAway
- **Publisher**: Codeunit 7314 "Whse.-Create Put-away"
- **When**: After put-away created
- **Parameters**: `var WarehouseActivityLine: Record "Warehouse Activity Line"`, `WarehouseReceiptLine: Record "Warehouse Receipt Line"`
- **Uses**: Assign to warehouse worker, optimize put-away routes, send put-away instructions, update receiving dashboard

### OnBeforeRegisterPutAway
- **Publisher**: Codeunit 7307 "Whse.-Activity-Register"
- **When**: Before registering completed put-away
- **Cancellable**: Yes
- **Parameters**: `var WarehouseActivityLine: Record "Warehouse Activity Line"`, `var Handled: Boolean`
- **Uses**: Validate bin location, verify quantities, check expiration dates, apply receiving inspection

### OnAfterRegisterPutAway
- **Publisher**: Codeunit 7307 "Whse.-Activity-Register"
- **When**: After put-away registered
- **Parameters**: `var WarehouseActivityLine: Record "Warehouse Activity Line"`
- **Uses**: Update bin contents, post item receipt, calculate worker productivity, trigger replenishment

---

## Bin Management Events

### OnBeforeCreateBinContent
- **Publisher**: Codeunit 7302 "Create Bin Content"
- **When**: Before creating bin content record
- **Cancellable**: Yes
- **Parameters**: `var BinContent: Record "Bin Content"`, `var Handled: Boolean`
- **Uses**: Validate bin type compatibility, check bin capacity, apply bin ranking, enforce storage policies

### OnAfterUpdateBinContent
- **Publisher**: Table 7302 "Bin Content"
- **When**: After bin content quantity updated
- **Parameters**: `var Rec: Record "Bin Content"`, `var xRec: Record "Bin Content"`
- **Uses**: Trigger replenishment when low, update bin utilization, check max quantity limits, optimize bin allocation

### OnBeforeCalculateBinReplenishment
- **Publisher**: Codeunit 7315 "Whse. Create Pick"
- **When**: Before calculating bin replenishment needs
- **Cancellable**: Yes
- **Parameters**: `var Bin: Record Bin`, `ItemNo: Code[20]`, `var Handled: Boolean`
- **Uses**: Apply custom replenishment rules, calculate min/max levels, consider demand forecast, optimize refill timing

### OnAfterCalculateBinReplenishment
- **Publisher**: Codeunit 7315 "Whse. Create Pick"
- **When**: After replenishment calculated
- **Parameters**: `var Bin: Record Bin`, `ReplenishmentQty: Decimal`
- **Uses**: Create replenishment movements, prioritize bins, schedule replenishment timing

---

## Directed Put-Away & Pick Events

### OnBeforeFindBinForPutAway
- **Publisher**: Codeunit 7314 "Whse.-Create Put-away"
- **When**: Before finding optimal bin for put-away
- **Cancellable**: Yes
- **Parameters**: `ItemNo: Code[20]`, `UnitOfMeasure: Code[10]`, `var BinCode: Code[20]`, `var Handled: Boolean`
- **Uses**: Apply ABC analysis, consider bin proximity, check bin capacity, apply storage policies (bulk, pallet, shelf)

**Example**:
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Put-away", 'OnBeforeFindBinForPutAway', '', false, false)]
local procedure CustomBinSelection(ItemNo: Code[20]; UnitOfMeasure: Code[10]; var BinCode: Code[20]; var Handled: Boolean)
var
    Item: Record Item;
begin
    Item.Get(ItemNo);
    if Item."ABC High Value" then begin
        BinCode := ABCBinMgmt.FindSecureBin(ItemNo);
        Handled := true;
    end;
end;
```

### OnBeforeFindBinForPick
- **Publisher**: Codeunit 7312 "Whse.-Create Pick"
- **When**: Before finding bin for picking
- **Cancellable**: Yes
- **Parameters**: `ItemNo: Code[20]`, `var BinCode: Code[20]`, `var Handled: Boolean`
- **Uses**: Apply FIFO/FEFO/LIFO logic, optimize pick distance, check bin accessibility, consider pick zone

### OnAfterFindBinForPick
- **Publisher**: Codeunit 7312 "Whse.-Create Pick"
- **When**: After bin determined for pick
- **Parameters**: `ItemNo: Code[20]`, `BinCode: Code[20]`
- **Uses**: Log bin selection decision, update bin ranking, calculate pick efficiency, optimize future picks

---

## Movement & Transfer Events

### OnBeforeCreateMovement
- **Publisher**: Codeunit 7322 "Create Movement"
- **When**: Before creating warehouse movement
- **Cancellable**: Yes
- **Parameters**: `var WhseWorksheetLine: Record "Whse. Worksheet Line"`, `var Handled: Boolean`
- **Uses**: Validate movement authorization, optimize movement sequence, check bin availability, apply zone restrictions

### OnAfterCreateMovement
- **Publisher**: Codeunit 7322 "Create Movement"
- **When**: After movement created
- **Parameters**: `var WarehouseActivityLine: Record "Warehouse Activity Line"`, `WhseWorksheetLine: Record "Whse. Worksheet Line"`
- **Uses**: Assign to warehouse worker, prioritize movements, update movement dashboard

### OnBeforeRegisterMovement
- **Publisher**: Codeunit 7307 "Whse.-Activity-Register"
- **When**: Before registering warehouse movement
- **Cancellable**: Yes
- **Parameters**: `var WarehouseActivityLine: Record "Warehouse Activity Line"`, `var Handled: Boolean`
- **Uses**: Validate bin locations, verify quantities, check movement authorization

### OnAfterRegisterMovement
- **Publisher**: Codeunit 7307 "Whse.-Activity-Register"
- **When**: After movement registered
- **Parameters**: `var WarehouseActivityLine: Record "Warehouse Activity Line"`
- **Uses**: Update bin contents in both source and destination, track movement productivity, optimize bin layout

---

## Internal Pick & Put-Away Events

### OnBeforeCreateInternalPick
- **Publisher**: Codeunit 7313 "Create Internal Pick"
- **When**: Before creating internal pick (for production/assembly)
- **Cancellable**: Yes
- **Parameters**: `var WhseInternalPickLine: Record "Whse. Internal Pick Line"`, `var Handled: Boolean`
- **Uses**: Validate component availability, apply picking strategy, check production schedule alignment

### OnAfterCreateInternalPick
- **Publisher**: Codeunit 7313 "Create Internal Pick"
- **When**: After internal pick created
- **Parameters**: `var WarehouseActivityLine: Record "Warehouse Activity Line"`
- **Uses**: Link to production order, prioritize by due date, update production material status

### OnBeforeCreateInternalPutAway
- **Publisher**: Codeunit 7316 "Create Internal Put-away"
- **When**: Before creating internal put-away (from production output)
- **Cancellable**: Yes
- **Parameters**: `var WhseInternalPutAwayLine: Record "Whse. Internal Put-Away Line"`, `var Handled: Boolean`
- **Uses**: Determine finished goods bin, apply quality inspection rules, check bin capacity

---

## Warehouse Shipment Events

### OnBeforePostWarehouseShipment
- **Publisher**: Codeunit 5760 "Whse.-Post Shipment"
- **When**: Before posting warehouse shipment
- **Cancellable**: Yes
- **Parameters**: `var WarehouseShipmentHeader: Record "Warehouse Shipment Header"`, `var Handled: Boolean`
- **Uses**: Validate all picks registered, verify shipping documents, check carrier availability, apply shipping rules

### OnAfterPostWarehouseShipment
- **Publisher**: Codeunit 5760 "Whse.-Post Shipment"
- **When**: After shipment posted
- **Parameters**: `var WarehouseShipmentHeader: Record "Warehouse Shipment Header"`, `ShipmentNo: Code[20]`
- **Uses**: Send shipping notification, update carrier system, generate shipping labels, archive shipment data

---

## Warehouse Receipt Events

### OnBeforePostWarehouseReceipt
- **Publisher**: Codeunit 5760 "Whse.-Post Receipt"
- **When**: Before posting warehouse receipt
- **Cancellable**: Yes
- **Parameters**: `var WarehouseReceiptHeader: Record "Warehouse Receipt Header"`, `var Handled: Boolean`
- **Uses**: Validate receiving documents, verify vendor PO, check quality inspection requirements, apply receiving policies

### OnAfterPostWarehouseReceipt
- **Publisher**: Codeunit 5760 "Whse.-Post Receipt"
- **When**: After receipt posted
- **Parameters**: `var WarehouseReceiptHeader: Record "Warehouse Receipt Header"`, `ReceiptNo: Code[20]`
- **Uses**: Trigger put-away creation, send receipt notification, update receiving KPIs, synchronize with ERP

---

## Event Subscriber Template

```al
codeunit 77106 "ABC Warehouse Subscribers"
{
    // FEFO Pick Strategy
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Pick", 'OnBeforeCreatePick', '', false, false)]
    local procedure ApplyFEFO(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; var Handled: Boolean)
    begin
        if WarehouseShipmentLine."ABC Expiration Critical" then begin
            ABCPickStrategy.CreateFEFOPick(WarehouseShipmentLine);
            Handled := true;
        end;
    end;

    // Directed Put-Away
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Put-away", 'OnBeforeFindBinForPutAway', '', false, false)]
    local procedure DirectedPutAway(ItemNo: Code[20]; UnitOfMeasure: Code[10]; var BinCode: Code[20]; var Handled: Boolean)
    begin
        BinCode := ABCBinOptimization.FindOptimalBin(ItemNo, UnitOfMeasure);
        Handled := true;
    end;

    // Bin Replenishment
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Create Pick", 'OnAfterCalculateBinReplenishment', '', false, false)]
    local procedure TriggerReplenishment(var Bin: Record Bin; ReplenishmentQty: Decimal)
    begin
        if ReplenishmentQty > 0 then
            ABCReplenishment.CreateMovement(Bin, ReplenishmentQty);
    end;
}
```

---

## Best Practices

### 1. **Pick Optimization**
- Use directed picking for high-volume operations
- Apply FEFO for perishable items
- Optimize pick routes to minimize travel distance
- Batch picks when possible

### 2. **Put-Away Strategy**
- Use ABC classification for bin assignment
- Consider bin capacity and accessibility
- Apply directed put-away for efficiency
- Reserve fast-moving items in accessible bins

### 3. **Bin Management**
- Monitor bin utilization regularly
- Implement automatic replenishment
- Optimize bin layout based on velocity
- Maintain bin content accuracy (cycle counting)

### 4. **Performance**
- Keep pick/put-away subscribers fast
- Batch warehouse activities when possible
- Use temporary tables for complex calculations
- Optimize bin content queries

---

## Additional Resources

- **Main Event Catalog**: [BC27_EVENT_CATALOG.md](../BC27_EVENT_CATALOG.md)
- **Event Index**: [BC27_EVENT_INDEX.md](../BC27_EVENT_INDEX.md)
- **Warehouse Module**: [BC27_MODULES_OVERVIEW.md](../BC27_MODULES_OVERVIEW.md#warehouse)
- **Source Repository**: [BC27 GitHub](https://github.com/StefanMaron/MSDyn365BC.Code.History/tree/be-27)

---

**Coverage**: 18+ advanced warehouse events from Picks, Put-Aways, Bins, Movements, Directed Operations, Shipments, and Receipts
**Version**: 1.0
**Last Updated**: 2025-11-08
