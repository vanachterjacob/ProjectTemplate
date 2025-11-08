# BC27 Assembly Events - Assemble-to-Order Integration Points

Event reference for Assembly module in Business Central 27. Extend assembly order processing, BOM explosion, component picking, and assemble-to-order scenarios.

**Module**: Assembly Management
**Version**: 1.0
**BC Version**: 27
**Last Updated**: 2025-11-08

---

## Assembly Order Events

### OnBeforePostAssemblyOrder
- **Publisher**: Codeunit 900 "Assembly-Post"
- **When**: Before assembly order posting
- **Cancellable**: Yes
- **Parameters**: `var AssemblyHeader: Record "Assembly Header"`, `var Handled: Boolean`
- **Uses**: Validate component availability, check resource capacity, verify assembly BOM, apply quality control rules
- **Source**: [AssemblyPost.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Assembly/Posting/AssemblyPost.Codeunit.al)

**Example**:
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", 'OnBeforePostAssemblyOrder', '', false, false)]
local procedure ValidateComponents(var AssemblyHeader: Record "Assembly Header"; var Handled: Boolean)
var
    AssemblyLine: Record "Assembly Line";
begin
    AssemblyLine.SetRange("Document Type", AssemblyHeader."Document Type");
    AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
    AssemblyLine.SetFilter("Remaining Quantity", '>0');
    if not AssemblyLine.IsEmpty then begin
        Error('Assembly order %1 has components with remaining quantity', AssemblyHeader."No.");
        Handled := true;
    end;
end;
```

### OnAfterPostAssemblyOrder
- **Publisher**: Codeunit 900 "Assembly-Post"
- **When**: After assembly order posted
- **Parameters**: `var AssemblyHeader: Record "Assembly Header"`, `PostedAssemblyHeaderNo: Code[20]`
- **Uses**: Update inventory, trigger shipment, send completion notification, calculate assembly cost variance

### OnBeforeCreateAssemblyOrder
- **Publisher**: Codeunit 905 "Assembly Header Management"
- **When**: Before creating new assembly order
- **Cancellable**: Yes
- **Parameters**: `var AssemblyHeader: Record "Assembly Header"`, `Item: Record Item`, `var Handled: Boolean`
- **Uses**: Auto-populate assembly BOM, set default location, assign resources, apply lead time

### OnAfterCreateAssemblyOrder
- **Publisher**: Codeunit 905 "Assembly Header Management"
- **When**: After assembly order created
- **Parameters**: `var AssemblyHeader: Record "Assembly Header"`, `Item: Record Item`
- **Uses**: Reserve components, schedule assembly, create pick documents, send work order to shop floor

---

## Assembly BOM Events

### OnBeforeExplodeAssemblyBOM
- **Publisher**: Codeunit 905 "Assembly Header Management"
- **When**: Before exploding assembly BOM into lines
- **Cancellable**: Yes
- **Parameters**: `var AssemblyHeader: Record "Assembly Header"`, `var Handled: Boolean`
- **Uses**: Filter BOM components, apply variant substitution, validate BOM structure, check component availability

### OnAfterExplodeAssemblyBOM
- **Publisher**: Codeunit 905 "Assembly Header Management"
- **When**: After BOM exploded into assembly lines
- **Parameters**: `var AssemblyHeader: Record "Assembly Header"`, `var AssemblyLine: Record "Assembly Line"`
- **Uses**: Adjust component quantities, add supplemental components, apply assembly instructions, calculate estimated cost

### OnBeforeValidateAssemblyBOM
- **Publisher**: Table 904 "Assembly Header"
- **When**: Before validating assembly BOM
- **Parameters**: `var Rec: Record "Assembly Header"`, `var xRec: Record "Assembly Header"`
- **Uses**: Check for circular BOM references, validate component types, verify resource requirements, ensure BOM completeness

---

## Component Management Events

### OnBeforeReserveComponent
- **Publisher**: Codeunit 925 "Assembly Line-Reserve"
- **When**: Before reserving assembly component
- **Cancellable**: Yes
- **Parameters**: `var AssemblyLine: Record "Assembly Line"`, `var Handled: Boolean`
- **Uses**: Apply reservation priority, check reservation policy, validate lot/serial tracking, optimize component allocation

### OnAfterReserveComponent
- **Publisher**: Codeunit 925 "Assembly Line-Reserve"
- **When**: After component reserved
- **Parameters**: `var AssemblyLine: Record "Assembly Line"`, `ReservationEntry: Record "Reservation Entry"`
- **Uses**: Trigger component picking, update component availability, send reservation notification

### OnBeforeConsumeComponent
- **Publisher**: Codeunit 900 "Assembly-Post"
- **When**: Before consuming assembly component
- **Cancellable**: Yes
- **Parameters**: `var AssemblyLine: Record "Assembly Line"`, `var Handled: Boolean`
- **Uses**: Validate lot/serial numbers, check component location, verify component quantity, apply backflushing rules

### OnAfterConsumeComponent
- **Publisher**: Codeunit 900 "Assembly-Post"
- **When**: After component consumed
- **Parameters**: `var AssemblyLine: Record "Assembly Line"`, `ItemLedgerEntryNo: Integer`
- **Uses**: Update component tracking, calculate actual cost, trigger replenishment, update BOM cost history

---

## Assemble-to-Order Events

### OnBeforeCreateATO
- **Publisher**: Codeunit 905 "Assembly Header Management"
- **When**: Before creating assemble-to-order from sales
- **Cancellable**: Yes
- **Parameters**: `var SalesLine: Record "Sales Line"`, `var Handled: Boolean`
- **Uses**: Validate ATO item configuration, check assembly capacity, verify customer lead time, apply ATO rules

**Example**:
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly Header Management", 'OnBeforeCreateATO', '', false, false)]
local procedure ValidateATOCapacity(var SalesLine: Record "Sales Line"; var Handled: Boolean)
begin
    if not ABCCapacityMgmt.HasATOCapacity(SalesLine."No.", SalesLine.Quantity, SalesLine."Shipment Date") then begin
        Error('Insufficient assembly capacity for ATO item %1 on %2', SalesLine."No.", SalesLine."Shipment Date");
        Handled := true;
    end;
end;
```

### OnAfterCreateATO
- **Publisher**: Codeunit 905 "Assembly Header Management"
- **When**: After ATO assembly order created from sales
- **Parameters**: `var AssemblyHeader: Record "Assembly Header"`, `SalesLine: Record "Sales Line"`
- **Uses**: Link assembly to sales order, schedule assembly by ship date, reserve ATO components, send assembly work order

### OnBeforeUpdateATOLink
- **Publisher**: Codeunit 905 "Assembly Header Management"
- **When**: Before updating assembly-to-order link
- **Cancellable**: Yes
- **Parameters**: `var AssembleToOrderLink: Record "Assemble-to-Order Link"`, `var Handled: Boolean`
- **Uses**: Validate link integrity, check for quantity changes, verify shipment date alignment, apply ATO policies

### OnAfterUpdateATOLink
- **Publisher**: Codeunit 905 "Assembly Header Management"
- **When**: After ATO link updated
- **Parameters**: `var AssembleToOrderLink: Record "Assemble-to-Order Link"`
- **Uses**: Adjust assembly quantity, reschedule assembly, update component reservations, notify production planning

---

## Resource & Capacity Events

### OnBeforeAssignResource
- **Publisher**: Codeunit 905 "Assembly Header Management"
- **When**: Before assigning resource to assembly order
- **Cancellable**: Yes
- **Parameters**: `var AssemblyHeader: Record "Assembly Header"`, `ResourceNo: Code[20]`, `var Handled: Boolean`
- **Uses**: Validate resource skills, check resource availability, apply resource optimization, consider resource cost

### OnAfterAssignResource
- **Publisher**: Codeunit 905 "Assembly Header Management"
- **When**: After resource assigned
- **Parameters**: `var AssemblyHeader: Record "Assembly Header"`, `ResourceNo: Code[20]`
- **Uses**: Update resource schedule, calculate estimated cost, send resource notification, track resource utilization

### OnBeforeCalculateAssemblyCost
- **Publisher**: Codeunit 900 "Assembly-Post"
- **When**: Before calculating assembly cost
- **Cancellable**: Yes
- **Parameters**: `var AssemblyHeader: Record "Assembly Header"`, `var Cost: Decimal`, `var Handled: Boolean`
- **Uses**: Apply custom costing method, include overhead, calculate resource costs, consider scrap/waste

### OnAfterCalculateAssemblyCost
- **Publisher**: Codeunit 900 "Assembly-Post"
- **When**: After assembly cost calculated
- **Parameters**: `var AssemblyHeader: Record "Assembly Header"`, `Cost: Decimal`
- **Uses**: Compare to standard cost, calculate variance, update cost history, apply cost adjustments

---

## Event Subscriber Template

```al
codeunit 77107 "ABC Assembly Subscribers"
{
    // Component Validation
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", 'OnBeforePostAssemblyOrder', '', false, false)]
    local procedure ValidateBeforePost(var AssemblyHeader: Record "Assembly Header"; var Handled: Boolean)
    begin
        ABCAssemblyValidation.CheckComponentAvailability(AssemblyHeader);
        ABCAssemblyValidation.CheckResourceCapacity(AssemblyHeader);
    end;

    // ATO Capacity Check
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly Header Management", 'OnBeforeCreateATO', '', false, false)]
    local procedure ValidateATOCapacity(var SalesLine: Record "Sales Line"; var Handled: Boolean)
    begin
        if not ABCCapacityMgmt.CanAssembleByDate(SalesLine."No.", SalesLine.Quantity, SalesLine."Shipment Date") then begin
            Error('Cannot assemble %1 units by %2', SalesLine.Quantity, SalesLine."Shipment Date");
            Handled := true;
        end;
    end;

    // Cost Calculation
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", 'OnAfterCalculateAssemblyCost', '', false, false)]
    local procedure ApplyOverhead(var AssemblyHeader: Record "Assembly Header"; Cost: Decimal)
    var
        OverheadCost: Decimal;
    begin
        OverheadCost := ABCCosting.CalculateAssemblyOverhead(AssemblyHeader);
        AssemblyHeader."ABC Total Cost" := Cost + OverheadCost;
        AssemblyHeader.Modify();
    end;
}
```

---

## Best Practices

### 1. **Assembly Order Management**
- Validate component availability before creation
- Check resource capacity for scheduling
- Link ATO orders to sales for shipment synchronization
- Monitor assembly order status in real-time

### 2. **BOM Management**
- Verify BOM completeness before explosion
- Handle variant substitution gracefully
- Apply component scrap factors
- Maintain BOM version control

### 3. **Assemble-to-Order**
- Validate ship date against assembly lead time
- Reserve components immediately
- Monitor ATO fulfillment metrics
- Coordinate assembly with shipping

### 4. **Costing**
- Track actual vs. standard assembly costs
- Include resource and overhead costs
- Calculate cost variances
- Update standard costs regularly

---

## Additional Resources

- **Main Event Catalog**: [BC27_EVENT_CATALOG.md](../BC27_EVENT_CATALOG.md)
- **Event Index**: [BC27_EVENT_INDEX.md](../BC27_EVENT_INDEX.md)
- **Assembly Module**: [BC27_MODULES_OVERVIEW.md](../BC27_MODULES_OVERVIEW.md#assembly)
- **Source Repository**: [BC27 GitHub](https://github.com/StefanMaron/MSDyn365BC.Code.History/tree/be-27)

---

**Coverage**: 12+ assembly events from Assembly Orders, BOM Explosion, Components, Assemble-to-Order, Resources, and Costing
**Version**: 1.0
**Last Updated**: 2025-11-08
