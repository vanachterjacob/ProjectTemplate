# BC27 Service Management Events - Service Order & Contract Integration Points

Comprehensive event reference for Service Management module in Business Central 27. Use this catalog to extend service order processing, service contracts, resource allocation, and service item tracking.

**Module**: Service Management
**Version**: 1.0
**BC Version**: 27
**Last Updated**: 2025-11-08

---

## Table of Contents

1. [Service Order Events](#service-order-events)
2. [Service Contract Events](#service-contract-events)
3. [Service Item Events](#service-item-events)
4. [Resource Planning Events](#resource-planning-events)
5. [Service Pricing Events](#service-pricing-events)

---

## Service Order Events

### OnBeforePostServiceDoc
- **Publisher**: Codeunit 5980 "Service-Post"
- **Type**: IntegrationEvent
- **When**: Before service document posting
- **Cancellable**: Yes (via `Handled` parameter)
- **Parameters**: `var ServiceHeader: Record "Service Header"`, `var Handled: Boolean`
- **Common Uses**: Service order validation, technician assignment verification, parts availability check, SLA compliance validation
- **Source**: [ServicePost.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Posting/ServicePost.Codeunit.al)

**Example**:
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Service-Post", 'OnBeforePostServiceDoc', '', false, false)]
local procedure ValidateSLABeforePost(var ServiceHeader: Record "Service Header"; var Handled: Boolean)
begin
    if ServiceHeader."ABC SLA Status" <> ServiceHeader."ABC SLA Status"::Met then begin
        if not Confirm('SLA not met. Continue posting?') then begin
            Handled := true;
            exit;
        end;
    end;
end;
```

### OnAfterPostServiceDoc
- **Publisher**: Codeunit 5980 "Service-Post"
- **Type**: IntegrationEvent
- **When**: After successful service document posting
- **Cancellable**: No
- **Parameters**: `var ServiceHeader: Record "Service Header"`, `ServiceShipmentNo: Code[20]`, `ServiceInvoiceNo: Code[20]`
- **Common Uses**: Customer notification, warranty tracking updates, service history archiving, external FSM integration
- **Source**: [ServicePost.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Posting/ServicePost.Codeunit.al)

### OnBeforeCreateServiceLine
- **Publisher**: Codeunit 5950 "ServHeader-Manage"
- **Type**: IntegrationEvent
- **When**: Before creating service line from service item
- **Cancellable**: Yes
- **Parameters**: `var ServiceLine: Record "Service Line"`, `ServiceItem: Record "Service Item"`, `var Handled: Boolean`
- **Common Uses**: Auto-populate service tasks, apply contract pricing, add standard service components, calculate estimated time
- **Source**: [ServHeaderManage.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Document/ServHeaderManage.Codeunit.al)

### OnAfterCreateServiceLine
- **Publisher**: Codeunit 5950 "ServHeader-Manage"
- **Type**: IntegrationEvent
- **When**: After service line created
- **Cancellable**: No
- **Parameters**: `var ServiceLine: Record "Service Line"`, `ServiceItem: Record "Service Item"`
- **Common Uses**: Create default resource allocations, reserve spare parts, update service scheduling, trigger work order generation
- **Source**: [ServHeaderManage.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Document/ServHeaderManage.Codeunit.al)

### OnBeforeFinishServiceOrder
- **Publisher**: Codeunit 5980 "Service-Post"
- **Type**: IntegrationEvent
- **When**: Before marking service order as finished
- **Cancellable**: Yes
- **Parameters**: `var ServiceHeader: Record "Service Header"`, `var Handled: Boolean`
- **Common Uses**: Verify all service tasks completed, validate customer sign-off, check quality control, ensure invoicing complete
- **Source**: [ServicePost.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Posting/ServicePost.Codeunit.al)

### OnAfterFinishServiceOrder
- **Publisher**: Codeunit 5980 "Service-Post"
- **Type**: IntegrationEvent
- **When**: After service order finished
- **Cancellable**: No
- **Parameters**: `var ServiceHeader: Record "Service Header"`
- **Common Uses**: Generate completion reports, update service item history, trigger customer survey, calculate technician performance metrics
- **Source**: [ServicePost.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Posting/ServicePost.Codeunit.al)

### OnBeforeAllocateResource
- **Publisher**: Codeunit 5950 "ServHeader-Manage"
- **Type**: IntegrationEvent
- **When**: Before resource allocation to service order
- **Cancellable**: Yes
- **Parameters**: `var ServiceHeader: Record "Service Header"`, `ResourceNo: Code[20]`, `var Handled: Boolean`
- **Common Uses**: Check resource availability, verify certifications, validate skill match, apply allocation rules
- **Source**: [ServHeaderManage.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Document/ServHeaderManage.Codeunit.al)

---

## Service Contract Events

### OnBeforeSignServContract
- **Publisher**: Codeunit 5940 "ServContractManagement"
- **Type**: IntegrationEvent
- **When**: Before service contract signing/activation
- **Cancellable**: Yes
- **Parameters**: `var ServiceContractHeader: Record "Service Contract Header"`, `var Handled: Boolean`
- **Common Uses**: Validate contract terms, verify approval workflow, check creditworthiness, calculate contract pricing
- **Source**: [ServContractManagement.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Contract/ServContractManagement.Codeunit.al)

**Example**:
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::ServContractManagement, 'OnBeforeSignServContract', '', false, false)]
local procedure ValidateContractTerms(var ServiceContractHeader: Record "Service Contract Header"; var Handled: Boolean)
var
    ABCContractValidation: Codeunit "ABC Contract Validation";
begin
    if not ABCContractValidation.ValidateMinimumTerms(ServiceContractHeader) then begin
        Error('Contract %1 does not meet minimum term requirements', ServiceContractHeader."Contract No.");
        Handled := true;
    end;
end;
```

### OnAfterSignServContract
- **Publisher**: Codeunit 5940 "ServContractManagement"
- **Type**: IntegrationEvent
- **When**: After service contract signed/activated
- **Cancellable**: No
- **Parameters**: `var ServiceContractHeader: Record "Service Contract Header"`
- **Common Uses**: Generate welcome package, schedule preventive maintenance, create invoice schedule, update customer portal
- **Source**: [ServContractManagement.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Contract/ServContractManagement.Codeunit.al)

### OnBeforeCreateContractInvoice
- **Publisher**: Codeunit 5940 "ServContractManagement"
- **Type**: IntegrationEvent
- **When**: Before creating invoice from service contract
- **Cancellable**: Yes
- **Parameters**: `var ServiceContractHeader: Record "Service Contract Header"`, `var Handled: Boolean`
- **Common Uses**: Apply contract pricing adjustments, validate billing period, check payment status, add contract-specific charges
- **Source**: [ServContractManagement.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Contract/ServContractManagement.Codeunit.al)

### OnAfterCreateContractInvoice
- **Publisher**: Codeunit 5940 "ServContractManagement"
- **Type**: IntegrationEvent
- **When**: After contract invoice created
- **Cancellable**: No
- **Parameters**: `var ServiceContractHeader: Record "Service Contract Header"`, `InvoiceNo: Code[20]`
- **Common Uses**: Send invoice notification, update revenue recognition, trigger payment collection, update contract billing history
- **Source**: [ServContractManagement.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Contract/ServContractManagement.Codeunit.al)

### OnBeforeRenewContract
- **Publisher**: Codeunit 5940 "ServContractManagement"
- **Type**: IntegrationEvent
- **When**: Before service contract renewal
- **Cancellable**: Yes
- **Parameters**: `var ServiceContractHeader: Record "Service Contract Header"`, `var Handled: Boolean`
- **Common Uses**: Calculate renewal pricing, apply escalation clauses, verify customer status, check service history
- **Source**: [ServContractManagement.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Contract/ServContractManagement.Codeunit.al)

### OnAfterRenewContract
- **Publisher**: Codeunit 5940 "ServContractManagement"
- **Type**: IntegrationEvent
- **When**: After contract renewed
- **Cancellable**: No
- **Parameters**: `var ServiceContractHeader: Record "Service Contract Header"`, `NewContractNo: Code[20]`
- **Common Uses**: Send renewal confirmation, update contract reporting, archive old contract, reset service counters
- **Source**: [ServContractManagement.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Contract/ServContractManagement.Codeunit.al)

---

## Service Item Events

### OnBeforeCreateServiceItem
- **Publisher**: Codeunit 5940 "ServContractManagement"
- **Type**: IntegrationEvent
- **When**: Before service item creation
- **Cancellable**: Yes
- **Parameters**: `var ServiceItem: Record "Service Item"`, `Item: Record Item`, `var Handled: Boolean`
- **Common Uses**: Auto-populate service item attributes, assign default warranty, create maintenance schedule, set SLA parameters
- **Source**: [ServContractManagement.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Contract/ServContractManagement.Codeunit.al)

### OnAfterCreateServiceItem
- **Publisher**: Codeunit 5940 "ServContractManagement"
- **Type**: IntegrationEvent
- **When**: After service item created
- **Cancellable**: No
- **Parameters**: `var ServiceItem: Record "Service Item"`, `Item: Record Item`
- **Common Uses**: Create service item components, register serial numbers, initialize service history, update asset register
- **Source**: [ServContractManagement.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Contract/ServContractManagement.Codeunit.al)

### OnAfterUpdateServiceItemInfo
- **Publisher**: Table 5940 "Service Item"
- **Type**: IntegrationEvent
- **When**: After service item information updated
- **Cancellable**: No
- **Parameters**: `var Rec: Record "Service Item"`, `var xRec: Record "Service Item"`
- **Common Uses**: Track service item changes, update IoT device registry, sync with asset management, trigger condition-based maintenance
- **Source**: [ServiceItem.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Item/ServiceItem.Table.al)

### OnBeforeTransferServiceItem
- **Publisher**: Codeunit 5950 "ServHeader-Manage"
- **Type**: IntegrationEvent
- **When**: Before service item transfer to different customer/location
- **Cancellable**: Yes
- **Parameters**: `var ServiceItem: Record "Service Item"`, `NewCustomerNo: Code[20]`, `var Handled: Boolean`
- **Common Uses**: Validate transfer authorization, close existing contracts, calculate transfer costs, update warranty ownership
- **Source**: [ServHeaderManage.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Document/ServHeaderManage.Codeunit.al)

---

## Resource Planning Events

### OnBeforeAllocateResourceToTask
- **Publisher**: Codeunit 5900 "Resource-Find"
- **Type**: IntegrationEvent
- **When**: Before resource allocation to service task
- **Cancellable**: Yes
- **Parameters**: `var ServiceLine: Record "Service Line"`, `ResourceNo: Code[20]`, `var Handled: Boolean`
- **Common Uses**: Check resource skill match, verify availability, validate travel distance, apply allocation preferences
- **Source**: [ResourceFind.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Resources/ResourceFind.Codeunit.al)

### OnAfterCalculateResourceCapacity
- **Publisher**: Codeunit 5900 "Resource-Find"
- **Type**: IntegrationEvent
- **When**: After resource capacity calculation
- **Cancellable**: No
- **Parameters**: `Resource: Record Resource`, `var AvailableCapacity: Decimal`, `StartDateTime: DateTime`, `EndDateTime: DateTime`
- **Common Uses**: Adjust for overtime, account for travel time, include on-call availability, apply seasonal adjustments
- **Source**: [ResourceFind.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Resources/ResourceFind.Codeunit.al)

### OnBeforeScheduleServiceTask
- **Publisher**: Codeunit 5950 "ServHeader-Manage"
- **Type**: IntegrationEvent
- **When**: Before scheduling service task
- **Cancellable**: Yes
- **Parameters**: `var ServiceLine: Record "Service Line"`, `ScheduledDate: Date`, `var Handled: Boolean`
- **Common Uses**: Apply scheduling rules, validate customer availability, check parts availability, optimize route planning
- **Source**: [ServHeaderManage.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Document/ServHeaderManage.Codeunit.al)

---

## Service Pricing Events

### OnBeforeCalculateServicePrice
- **Publisher**: Codeunit 5940 "ServContractManagement"
- **Type**: IntegrationEvent
- **When**: Before service price calculation
- **Cancellable**: Yes
- **Parameters**: `var ServiceLine: Record "Service Line"`, `var Handled: Boolean`
- **Common Uses**: Apply contract pricing, calculate emergency service premium, apply volume discounts, include travel charges
- **Source**: [ServContractManagement.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Contract/ServContractManagement.Codeunit.al)

**Example**:
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::ServContractManagement, 'OnBeforeCalculateServicePrice', '', false, false)]
local procedure ApplyEmergencyPricing(var ServiceLine: Record "Service Line"; var Handled: Boolean)
begin
    if ServiceLine."ABC Emergency Service" then begin
        ServiceLine."Unit Price" := ServiceLine."Unit Price" * 1.5; // 50% premium
        Handled := true;
    end;
end;
```

### OnAfterCalculateServicePrice
- **Publisher**: Codeunit 5940 "ServContractManagement"
- **Type**: IntegrationEvent
- **When**: After service price calculated
- **Cancellable**: No
- **Parameters**: `var ServiceLine: Record "Service Line"`
- **Common Uses**: Apply additional charges, round pricing, log pricing decisions, update pricing history
- **Source**: [ServContractManagement.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Contract/ServContractManagement.Codeunit.al)

### OnBeforeApplyContractDiscount
- **Publisher**: Codeunit 5940 "ServContractManagement"
- **Type**: IntegrationEvent
- **When**: Before applying contract discount
- **Cancellable**: Yes
- **Parameters**: `var ServiceLine: Record "Service Line"`, `ServiceContractHeader: Record "Service Contract Header"`, `var Handled: Boolean`
- **Common Uses**: Calculate tiered contract discounts, apply promotional pricing, validate discount eligibility, enforce discount limits
- **Source**: [ServContractManagement.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Contract/ServContractManagement.Codeunit.al)

---

## Event Subscriber Template

```al
codeunit 77103 "ABC Service Subscribers"
{
    // Service Order Posting
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Service-Post", 'OnAfterPostServiceDoc', '', false, false)]
    local procedure SendCompletionNotification(var ServiceHeader: Record "Service Header"; ServiceShipmentNo: Code[20]; ServiceInvoiceNo: Code[20])
    var
        ABCNotification: Codeunit "ABC Notification Mgmt";
    begin
        if ServiceShipmentNo <> '' then
            ABCNotification.SendServiceCompletion(ServiceHeader, ServiceShipmentNo);
    end;

    // Contract Pricing
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ServContractManagement, 'OnBeforeCalculateServicePrice', '', false, false)]
    local procedure ApplyCustomPricing(var ServiceLine: Record "Service Line"; var Handled: Boolean)
    var
        ABCPricing: Codeunit "ABC Service Pricing";
    begin
        if ABCPricing.HasCustomContract(ServiceLine."Customer No.") then begin
            ABCPricing.ApplyContractPrice(ServiceLine);
            Handled := true;
        end;
    end;

    // Resource Allocation
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Resource-Find", 'OnBeforeAllocateResourceToTask', '', false, false)]
    local procedure ValidateResourceSkills(var ServiceLine: Record "Service Line"; ResourceNo: Code[20]; var Handled: Boolean)
    var
        ABCResourceMgmt: Codeunit "ABC Resource Management";
    begin
        if not ABCResourceMgmt.HasRequiredSkills(ResourceNo, ServiceLine."Service Item No.") then begin
            Error('Resource %1 does not have required skills for this service item', ResourceNo);
            Handled := true;
        end;
    end;
}
```

---

## Best Practices

### 1. **Service Order Lifecycle**
- Validate technician assignment before posting
- Track SLA compliance throughout order lifecycle
- Use OnAfter events for customer notifications

### 2. **Contract Management**
- Enforce contract terms during renewal
- Automate invoice generation
- Track contract profitability

### 3. **Resource Planning**
- Check skills and certifications
- Optimize travel routes
- Balance workload across resources

### 4. **Service Item Tracking**
- Maintain complete service history
- Link to warranty information
- Track parts replacement

---

## Additional Resources

- **Main Event Catalog**: [BC27_EVENT_CATALOG.md](../BC27_EVENT_CATALOG.md)
- **Event Index**: [BC27_EVENT_INDEX.md](../BC27_EVENT_INDEX.md)
- **Extension Points**: [BC27_EXTENSION_POINTS.md](../BC27_EXTENSION_POINTS.md)
- **Service Module**: [BC27_MODULES_OVERVIEW.md](../BC27_MODULES_OVERVIEW.md#service-management)
- **Source Repository**: [BC27 GitHub](https://github.com/StefanMaron/MSDyn365BC.Code.History/tree/be-27)

---

**Coverage**: 20+ service management events from Service Orders, Contracts, Items, Resources, and Pricing
**Version**: 1.0
**Last Updated**: 2025-11-08
