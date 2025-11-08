# BC27 Manufacturing Events - Production & BOM Integration Points

Comprehensive event reference for Manufacturing module in Business Central 27. Use this catalog to extend production order processing, BOM management, routing, and capacity planning.

**Module**: Manufacturing
**Version**: 1.0
**BC Version**: 27
**Last Updated**: 2025-11-08

---

## Table of Contents

1. [Production Order Events](#production-order-events)
2. [BOM & Routing Events](#bom--routing-events)
3. [Capacity & Work Center Events](#capacity--work-center-events)
4. [Production Journal Events](#production-journal-events)
5. [MRP & Planning Events](#mrp--planning-events)
6. [Manufacturing Setup Events](#manufacturing-setup-events)

---

## Production Order Events

### OnBeforeRefreshProdOrder
- **Publisher**: Codeunit 99000773 "Prod. Order Status Mgmt."
- **Type**: IntegrationEvent
- **When**: Before production order refresh (recalculation)
- **Cancellable**: Yes (via `Handled` parameter)
- **Parameters**:
  - `var ProductionOrder: Record "Production Order"`
  - `Direction: Option Forward,Backward`
  - `var Handled: Boolean`
- **Common Uses**:
  - Prevent refresh under certain conditions
  - Modify production order before recalculation
  - Add custom validation before refresh
  - Log refresh operations
- **Source**: [ProdOrderStatusMgmt.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Document/ProdOrderStatusMgmt.Codeunit.al)

### OnAfterRefreshProdOrder
- **Publisher**: Codeunit 99000773 "Prod. Order Status Mgmt."
- **Type**: IntegrationEvent
- **When**: After production order refresh completed
- **Cancellable**: No
- **Parameters**:
  - `var ProductionOrder: Record "Production Order"`
  - `Direction: Option Forward,Backward`
- **Common Uses**:
  - Update custom fields after recalculation
  - Trigger capacity planning updates
  - Send notifications to shop floor
  - Update external MES systems
- **Source**: [ProdOrderStatusMgmt.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Document/ProdOrderStatusMgmt.Codeunit.al)

### OnBeforeChangeProdOrderStatus
- **Publisher**: Codeunit 99000773 "Prod. Order Status Mgmt."
- **Type**: IntegrationEvent
- **When**: Before production order status change (Simulated → Planned → Released → Finished)
- **Cancellable**: Yes
- **Parameters**:
  - `var ProductionOrder: Record "Production Order"`
  - `NewStatus: Enum "Production Order Status"`
  - `var Handled: Boolean`
- **Common Uses**:
  - Validate required fields before status change
  - Enforce workflow rules
  - Check material availability
  - Verify capacity constraints
- **Source**: [ProdOrderStatusMgmt.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Document/ProdOrderStatusMgmt.Codeunit.al)

**Example**:
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Mgmt.", 'OnBeforeChangeProdOrderStatus', '', false, false)]
local procedure ValidateBeforeStatusChange(var ProductionOrder: Record "Production Order"; NewStatus: Enum "Production Order Status"; var Handled: Boolean)
begin
    if (NewStatus = NewStatus::Released) and (ProductionOrder."ABC Shop Floor Approved" = false) then begin
        Error('Production Order %1 must be approved by shop floor before release', ProductionOrder."No.");
        Handled := true;
    end;
end;
```

### OnAfterChangeProdOrderStatus
- **Publisher**: Codeunit 99000773 "Prod. Order Status Mgmt."
- **Type**: IntegrationEvent
- **When**: After successful production order status change
- **Cancellable**: No
- **Parameters**:
  - `var ProductionOrder: Record "Production Order"`
  - `OldStatus: Enum "Production Order Status"`
  - `NewStatus: Enum "Production Order Status"`
- **Common Uses**:
  - Update capacity planning
  - Trigger material requirements
  - Send shop floor notifications
  - Update production schedules
  - Integrate with MES systems
- **Source**: [ProdOrderStatusMgmt.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Document/ProdOrderStatusMgmt.Codeunit.al)

### OnBeforeFinishProdOrder
- **Publisher**: Codeunit 99000773 "Prod. Order Status Mgmt."
- **Type**: IntegrationEvent
- **When**: Before production order is finished
- **Cancellable**: Yes
- **Parameters**:
  - `var ProductionOrder: Record "Production Order"`
  - `var Handled: Boolean`
- **Common Uses**:
  - Validate all operations are complete
  - Check for outstanding material consumption
  - Verify quality checks completed
  - Calculate final costs
- **Source**: [ProdOrderStatusMgmt.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Document/ProdOrderStatusMgmt.Codeunit.al)

### OnAfterFinishProdOrder
- **Publisher**: Codeunit 99000773 "Prod. Order Status Mgmt."
- **Type**: IntegrationEvent
- **When**: After production order finished
- **Cancellable**: No
- **Parameters**:
  - `var ProductionOrder: Record "Production Order"`
- **Common Uses**:
  - Update finished goods inventory
  - Generate completion reports
  - Archive production data
  - Update production KPIs
- **Source**: [ProdOrderStatusMgmt.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Document/ProdOrderStatusMgmt.Codeunit.al)

### OnBeforeCreateProdOrderLine
- **Publisher**: Codeunit 99000787 "Create Prod. Order Lines"
- **Type**: IntegrationEvent
- **When**: Before creating production order line from BOM
- **Cancellable**: Yes
- **Parameters**:
  - `var ProdOrderLine: Record "Prod. Order Line"`
  - `ProductionBOMLine: Record "Production BOM Line"`
  - `var Handled: Boolean`
- **Common Uses**:
  - Modify line data before creation
  - Add custom line attributes
  - Apply custom routing logic
  - Skip certain BOM lines conditionally
- **Source**: [CreateProdOrderLines.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Document/CreateProdOrderLines.Codeunit.al)

### OnAfterCreateProdOrderLine
- **Publisher**: Codeunit 99000787 "Create Prod. Order Lines"
- **Type**: IntegrationEvent
- **When**: After production order line created
- **Cancellable**: No
- **Parameters**:
  - `var ProdOrderLine: Record "Prod. Order Line"`
  - `ProductionBOMLine: Record "Production BOM Line"`
- **Common Uses**:
  - Create related records
  - Update custom fields
  - Trigger material reservations
  - Generate routing entries
- **Source**: [CreateProdOrderLines.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Document/CreateProdOrderLines.Codeunit.al)

---

## BOM & Routing Events

### OnBeforeExplodeBOM
- **Publisher**: Codeunit 99000770 "BOM Explode BOM"
- **Type**: IntegrationEvent
- **When**: Before BOM explosion (expanding BOM components)
- **Cancellable**: Yes
- **Parameters**:
  - `var ProductionBOMHeader: Record "Production BOM Header"`
  - `var Handled: Boolean`
- **Common Uses**:
  - Custom BOM explosion logic
  - Filter BOM lines
  - Apply configuration rules
  - Validate BOM before explosion
- **Source**: [BOMExplodeBOM.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/ProductionBOM/BOMExplodeBOM.Codeunit.al)

### OnAfterExplodeBOM
- **Publisher**: Codeunit 99000770 "BOM Explode BOM"
- **Type**: IntegrationEvent
- **When**: After BOM explosion completed
- **Cancellable**: No
- **Parameters**:
  - `var ProductionBOMHeader: Record "Production BOM Header"`
  - `var TempProdBOMLine: Record "Production BOM Line" temporary`
- **Common Uses**:
  - Modify exploded BOM lines
  - Add additional components
  - Calculate material requirements
  - Update cost estimates
- **Source**: [BOMExplodeBOM.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/ProductionBOM/BOMExplodeBOM.Codeunit.al)

### OnBeforeValidateProdBOM
- **Publisher**: Table 99000771 "Production BOM Header"
- **Type**: IntegrationEvent
- **When**: Before production BOM validation
- **Cancellable**: No (validation trigger)
- **Parameters**:
  - `var Rec: Record "Production BOM Header"`
  - `var xRec: Record "Production BOM Header"`
- **Common Uses**:
  - Add custom BOM validation rules
  - Check for circular references
  - Validate version numbers
  - Enforce BOM standards
- **Source**: [ProductionBOMHeader.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/ProductionBOM/ProductionBOMHeader.Table.al)

### OnBeforeCertifyProdBOM
- **Publisher**: Codeunit 99000752 "Production BOM-Check"
- **Type**: IntegrationEvent
- **When**: Before certifying production BOM
- **Cancellable**: Yes
- **Parameters**:
  - `var ProductionBOMHeader: Record "Production BOM Header"`
  - `var Handled: Boolean`
- **Common Uses**:
  - Custom certification rules
  - Engineering approval workflow
  - Validate BOM completeness
  - Check cost estimates
- **Source**: [ProductionBOMCheck.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/ProductionBOM/ProductionBOMCheck.Codeunit.al)

### OnBeforeCalculateRouting
- **Publisher**: Codeunit 99000774 "Calculate Routing Line"
- **Type**: IntegrationEvent
- **When**: Before routing calculation
- **Cancellable**: Yes
- **Parameters**:
  - `var ProdOrderRoutingLine: Record "Prod. Order Routing Line"`
  - `Direction: Option Forward,Backward`
  - `var Handled: Boolean`
- **Common Uses**:
  - Custom routing calculation logic
  - Apply efficiency factors
  - Modify setup/run times
  - Adjust work center selection
- **Source**: [CalculateRoutingLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Routing/CalculateRoutingLine.Codeunit.al)

### OnAfterCalculateRouting
- **Publisher**: Codeunit 99000774 "Calculate Routing Line"
- **Type**: IntegrationEvent
- **When**: After routing calculation completed
- **Cancellable**: No
- **Parameters**:
  - `var ProdOrderRoutingLine: Record "Prod. Order Routing Line"`
  - `Direction: Option Forward,Backward`
- **Common Uses**:
  - Update custom timing fields
  - Calculate capacity requirements
  - Update production schedule
  - Trigger resource allocation
- **Source**: [CalculateRoutingLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Routing/CalculateRoutingLine.Codeunit.al)

---

## Capacity & Work Center Events

### OnBeforePostCapacity
- **Publisher**: Codeunit 5510 "Capacity Jnl.-Post Line"
- **Type**: IntegrationEvent
- **When**: Before capacity journal line posting
- **Cancellable**: Yes
- **Parameters**:
  - `var ItemJournalLine: Record "Item Journal Line"`
  - `var Handled: Boolean`
- **Common Uses**:
  - Validate operator assignments
  - Check work center availability
  - Apply labor costing rules
  - Verify time clock data
- **Source**: [CapacityJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Capacity/CapacityJnlPostLine.Codeunit.al)

**Example**:
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Capacity Jnl.-Post Line", 'OnBeforePostCapacity', '', false, false)]
local procedure ValidateCapacityPosting(var ItemJournalLine: Record "Item Journal Line"; var Handled: Boolean)
begin
    if ItemJournalLine."ABC Operator Code" = '' then begin
        Error('Operator Code must be specified for capacity posting on work center %1', ItemJournalLine."Work Center No.");
        Handled := true;
    end;
end;
```

### OnAfterPostCapacity
- **Publisher**: Codeunit 5510 "Capacity Jnl.-Post Line"
- **Type**: IntegrationEvent
- **When**: After capacity ledger entry created
- **Cancellable**: No
- **Parameters**:
  - `var ItemJournalLine: Record "Item Journal Line"`
  - `CapacityLedgerEntry: Record "Capacity Ledger Entry"`
- **Common Uses**:
  - Update labor tracking systems
  - Calculate efficiency metrics
  - Trigger payroll integration
  - Update production dashboards
- **Source**: [CapacityJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Capacity/CapacityJnlPostLine.Codeunit.al)

### OnBeforeValidateWorkCenterNo
- **Publisher**: Table 5405 "Prod. Order Routing Line"
- **Type**: IntegrationEvent
- **When**: Before work center number validation
- **Cancellable**: No (validation trigger)
- **Parameters**:
  - `var Rec: Record "Prod. Order Routing Line"`
  - `var xRec: Record "Prod. Order Routing Line"`
  - `CurrFieldNo: Integer`
- **Common Uses**:
  - Apply work center selection logic
  - Check work center capacity
  - Validate certifications
  - Apply routing preferences
- **Source**: [ProdOrderRoutingLine.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Document/ProdOrderRoutingLine.Table.al)

### OnAfterCalcAvailableCapacity
- **Publisher**: Codeunit 99000755 "Check Availability"
- **Type**: IntegrationEvent
- **When**: After available capacity calculation
- **Cancellable**: No
- **Parameters**:
  - `WorkCenter: Record "Work Center"`
  - `var AvailableCapacity: Decimal`
  - `StartDate: Date`
  - `EndDate: Date`
- **Common Uses**:
  - Apply custom capacity adjustments
  - Account for maintenance downtime
  - Include overtime capacity
  - Adjust for seasonal variations
- **Source**: [CheckAvailability.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Capacity/CheckAvailability.Codeunit.al)

---

## Production Journal Events

### OnBeforePostOutputJournal
- **Publisher**: Codeunit 22 "Item Jnl.-Post Line" (manufacturing context)
- **Type**: IntegrationEvent
- **When**: Before output journal posting
- **Cancellable**: Yes
- **Parameters**:
  - `var ItemJournalLine: Record "Item Journal Line"`
  - `var Handled: Boolean`
- **Common Uses**:
  - Validate output quantities
  - Check scrap reporting
  - Verify operation completion
  - Apply quality control rules
- **Source**: [ItemJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Inventory/Posting/ItemJnlPostLine.Codeunit.al)

### OnAfterPostOutputJournal
- **Publisher**: Codeunit 22 "Item Jnl.-Post Line"
- **Type**: IntegrationEvent
- **When**: After output journal posted
- **Cancellable**: No
- **Parameters**:
  - `var ItemJournalLine: Record "Item Journal Line"`
  - `ItemLedgerEntry: Record "Item Ledger Entry"`
- **Common Uses**:
  - Update production progress
  - Trigger next operation
  - Update WIP accounting
  - Send shop floor notifications
- **Source**: [ItemJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Inventory/Posting/ItemJnlPostLine.Codeunit.al)

### OnBeforePostConsumptionJournal
- **Publisher**: Codeunit 22 "Item Jnl.-Post Line"
- **Type**: IntegrationEvent
- **When**: Before consumption journal posting
- **Cancellable**: Yes
- **Parameters**:
  - `var ItemJournalLine: Record "Item Journal Line"`
  - `var Handled: Boolean`
- **Common Uses**:
  - Validate material availability
  - Check lot/serial numbers
  - Apply flushing method rules
  - Verify pick documentation
- **Source**: [ItemJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Inventory/Posting/ItemJnlPostLine.Codeunit.al)

### OnAfterPostConsumptionJournal
- **Publisher**: Codeunit 22 "Item Jnl.-Post Line"
- **Type**: IntegrationEvent
- **When**: After consumption journal posted
- **Cancellable**: No
- **Parameters**:
  - `var ItemJournalLine: Record "Item Journal Line"`
  - `ItemLedgerEntry: Record "Item Ledger Entry"`
- **Common Uses**:
  - Update material tracking
  - Trigger replenishment
  - Update cost accounting
  - Generate material usage reports
- **Source**: [ItemJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Inventory/Posting/ItemJnlPostLine.Codeunit.al)

---

## MRP & Planning Events

### OnBeforeRunMRP
- **Publisher**: Codeunit 99001020 "Calculate Plan - Plan. Wksh."
- **Type**: IntegrationEvent
- **When**: Before MRP calculation starts
- **Cancellable**: Yes
- **Parameters**:
  - `var Item: Record Item`
  - `var Handled: Boolean`
- **Common Uses**:
  - Filter items for MRP
  - Apply custom planning parameters
  - Set safety stock levels
  - Adjust lead times
- **Source**: [CalculatePlanPlanWksh.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Planning/CalculatePlanPlanWksh.Codeunit.al)

### OnAfterCalcPlanningLine
- **Publisher**: Codeunit 99001020 "Calculate Plan - Plan. Wksh."
- **Type**: IntegrationEvent
- **When**: After planning line calculated by MRP
- **Cancellable**: No
- **Parameters**:
  - `var RequisitionLine: Record "Requisition Line"`
  - `Item: Record Item`
- **Common Uses**:
  - Modify planned quantities
  - Adjust planning dates
  - Apply custom lot sizing
  - Set preferred vendor
- **Source**: [CalculatePlanPlanWksh.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Planning/CalculatePlanPlanWksh.Codeunit.al)

### OnBeforeCarryOutAction
- **Publisher**: Codeunit 99000813 "Carry Out Action"
- **Type**: IntegrationEvent
- **When**: Before carrying out planning action (create order)
- **Cancellable**: Yes
- **Parameters**:
  - `var RequisitionLine: Record "Requisition Line"`
  - `var Handled: Boolean`
- **Common Uses**:
  - Validate before order creation
  - Apply approval workflow
  - Check budget availability
  - Set custom order parameters
- **Source**: [CarryOutAction.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Planning/CarryOutAction.Codeunit.al)

### OnAfterCarryOutAction
- **Publisher**: Codeunit 99000813 "Carry Out Action"
- **Type**: IntegrationEvent
- **When**: After planning action carried out
- **Cancellable**: No
- **Parameters**:
  - `var RequisitionLine: Record "Requisition Line"`
  - `OrderNo: Code[20]`
- **Common Uses**:
  - Send order notifications
  - Update planning dashboard
  - Archive planning decisions
  - Integrate with ERP systems
- **Source**: [CarryOutAction.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Planning/CarryOutAction.Codeunit.al)

---

## Manufacturing Setup Events

### OnBeforeValidateManufacturingSetup
- **Publisher**: Table 99000765 "Manufacturing Setup"
- **Type**: IntegrationEvent
- **When**: Before manufacturing setup validation
- **Cancellable**: No (validation trigger)
- **Parameters**:
  - `var Rec: Record "Manufacturing Setup"`
  - `var xRec: Record "Manufacturing Setup"`
  - `CurrFieldNo: Integer`
- **Common Uses**:
  - Add custom setup validation
  - Enforce configuration rules
  - Validate number series
  - Check work center setup
- **Source**: [ManufacturingSetup.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Setup/ManufacturingSetup.Table.al)

---

## Event Subscriber Template

```al
codeunit 77102 "ABC Manufacturing Subscribers"
{
    // Production Order Status Change
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Mgmt.", 'OnAfterChangeProdOrderStatus', '', false, false)]
    local procedure NotifyStatusChange(var ProductionOrder: Record "Production Order"; OldStatus: Enum "Production Order Status"; NewStatus: Enum "Production Order Status")
    var
        ABCNotification: Codeunit "ABC Notification Mgmt";
    begin
        if NewStatus = NewStatus::Released then
            ABCNotification.SendProdOrderReleased(ProductionOrder);
    end;

    // Capacity Posting Validation
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Capacity Jnl.-Post Line", 'OnBeforePostCapacity', '', false, false)]
    local procedure ValidateOperator(var ItemJournalLine: Record "Item Journal Line"; var Handled: Boolean)
    begin
        if ItemJournalLine."ABC Operator Code" = '' then begin
            Error('Operator Code required for capacity posting');
            Handled := true;
        end;
    end;

    // BOM Explosion
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"BOM Explode BOM", 'OnAfterExplodeBOM', '', false, false)]
    local procedure AddCustomComponents(var ProductionBOMHeader: Record "Production BOM Header"; var TempProdBOMLine: Record "Production BOM Line" temporary)
    var
        ABCBOMEnhancement: Codeunit "ABC BOM Enhancement";
    begin
        ABCBOMEnhancement.AddCustomComponents(TempProdBOMLine, ProductionBOMHeader);
    end;
}
```

---

## Best Practices

### 1. **Production Order Lifecycle**
- Subscribe to status change events for workflow integration
- Use OnBefore events for validation
- Use OnAfter events for notifications and integrations

### 2. **Capacity Management**
- Keep capacity posting subscribers fast (< 50ms)
- Use OnAfter events for heavy calculations
- Defer external system integration to job queue

### 3. **BOM & Routing**
- Validate BOM changes before certification
- Use explosion events for configuration management
- Cache routing calculations when possible

### 4. **Performance**
- MRP events can fire thousands of times - keep lightweight
- Use temporary tables for bulk operations
- Batch notifications instead of per-line processing

---

## Additional Resources

- **Main Event Catalog**: [BC27_EVENT_CATALOG.md](../BC27_EVENT_CATALOG.md)
- **Event Index**: [BC27_EVENT_INDEX.md](../BC27_EVENT_INDEX.md)
- **Extension Points**: [BC27_EXTENSION_POINTS.md](../BC27_EXTENSION_POINTS.md)
- **Manufacturing Module**: [BC27_MODULES_OVERVIEW.md](../BC27_MODULES_OVERVIEW.md#manufacturing)
- **Source Repository**: [BC27 GitHub](https://github.com/StefanMaron/MSDyn365BC.Code.History/tree/be-27)

---

**Coverage**: 30+ manufacturing events from Production Order Management, BOM, Routing, Capacity, and Planning modules
**Version**: 1.0
**Last Updated**: 2025-11-08
