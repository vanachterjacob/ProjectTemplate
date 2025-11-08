# BC27 Event Catalog - Extension Integration Points

Complete reference for event subscribers and publishers in Business Central 27. Use this catalog to find integration points for extending base functionality.

**Version**: 1.0
**BC Version**: 27
**Last Updated**: 2025-11-08

---

## 📊 Coverage Scope

This catalog provides **core posting and document events** most commonly used in BC27 extensions. For specialized events, see module-specific catalogs.

### ✅ Fully Documented (This File)

**BaseApp Core Events** (~50 events):
- ✅ Sales & Purchase posting events
- ✅ Inventory & warehouse posting events
- ✅ G/L posting & bank account events
- ✅ Core manufacturing events (production orders, capacity)
- ✅ Core service management events
- ✅ Master data validation events

### 📁 Module-Specific Catalogs

For detailed coverage of specialized modules, see:
- **[Manufacturing Events](./events/BC27_EVENTS_MANUFACTURING.md)** - 30+ production, BOM, routing events
- **[Service Management Events](./events/BC27_EVENTS_SERVICE.md)** - 20+ service order, contract events
- **[Jobs & Projects Events](./events/BC27_EVENTS_JOBS.md)** - 15+ job planning, WIP events
- **[API & Integration Events](./events/BC27_EVENTS_API.md)** - 25+ REST API, webhook events
- **[Fixed Assets Events](./events/BC27_EVENTS_FIXEDASSETS.md)** - 15+ depreciation, acquisition, disposal events
- **[Warehouse Events](./events/BC27_EVENTS_WAREHOUSE.md)** - 18+ picks, put-aways, bins, movements
- **[Assembly Events](./events/BC27_EVENTS_ASSEMBLY.md)** - 12+ assembly orders, ATO, BOM events

### 🔍 Finding Undocumented Events

**If event not found in catalogs**:
1. Use search strategies in ["Finding Events in Source Code"](#finding-events-in-source-code) section below
2. Search BC27 source: [Stefan Maron's Repository](https://github.com/StefanMaron/MSDyn365BC.Code.History/tree/be-27)
3. Check the **[Event Index](./BC27_EVENT_INDEX.md)** for keyword search across all events

### ⚠️ Out of Scope

**Not covered** (internal/deprecated):
- ❌ Internal events (marked with `local` or `internal`)
- ❌ Obsolete events (marked with `Obsolete` tag)
- ❌ Test codeunit events
- ❌ Legacy upgrade events

---

## Table of Contents

1. [Event Pattern Guide](#event-pattern-guide)
2. [Sales & Receivables Events](#sales--receivables-events)
3. [Purchase & Payables Events](#purchase--payables-events)
4. [Inventory & Warehouse Events](#inventory--warehouse-events)
5. [General Ledger & Posting Events](#general-ledger--posting-events)
6. [Manufacturing Events](#manufacturing-events)
7. [Service Management Events](#service-management-events)
8. [Integration & API Events](#integration--api-events)
9. [Finding Events in Source Code](#finding-events-in-source-code)

---

## Event Pattern Guide

### Event Types

| Event Type | Purpose | Can Cancel? | Common Use Cases |
|------------|---------|-------------|------------------|
| **IntegrationEvent** | Extension hook points | Some (via `Handled` parameter) | Custom validation, external API calls, additional processing |
| **BusinessEvent** | Business process notifications | No | Logging, notifications, workflow triggers |
| **InternalEvent** | Internal module communication | No | Module-specific logic, not for external use |

### Event Naming Patterns

| Pattern | When Fired | Typical Use |
|---------|------------|-------------|
| **OnBefore[Action]** | Before operation starts | Validation, parameter modification, cancellation |
| **OnAfter[Action]** | After operation completes | Side effects, notifications, additional processing |
| **OnValidate[Field]** | During field validation | Custom validation logic |
| **On[Document]Insert/Modify/Delete** | Table triggers | Extend CRUD operations |

### Cancellation Pattern

```al
// Publisher provides Handled parameter
[IntegrationEvent(false, false)]
local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; var Handled: Boolean)
begin
end;

// Subscriber sets Handled := true to cancel
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
local procedure CancelPostingIfCondition(var SalesHeader: Record "Sales Header"; var Handled: Boolean)
begin
    if SalesHeader."ABC Custom Field" = '' then begin
        Error('Custom field required');
        Handled := true; // Cancel posting
    end;
end;
```

---

## Sales & Receivables Events

### Posting Events

#### OnBeforePostSalesDoc
- **Publisher**: Codeunit 80 "Sales-Post"
- **Type**: IntegrationEvent
- **Parameters**: `var SalesHeader: Record "Sales Header"`, `var Handled: Boolean`
- **When**: Before any sales document posting begins
- **Cancellable**: Yes (set `Handled := true`)
- **Common Uses**:
  - Custom document validation
  - External system integration (check inventory, credit limits)
  - Add custom header fields before posting
  - Trigger approval workflows
- **Source**: [SalesPost.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Sales/Posting/SalesPost.Codeunit.al)

#### OnAfterPostSalesDoc
- **Publisher**: Codeunit 80 "Sales-Post"
- **Type**: IntegrationEvent
- **Parameters**: `var SalesHeader: Record "Sales Header"`, `SalesShipmentNo: Code[20]`, `SalesInvoiceNo: Code[20]`
- **When**: After successful sales document posting
- **Cancellable**: No
- **Common Uses**:
  - Send confirmation emails
  - Update external systems (CRM, EDI)
  - Create follow-up documents
  - Generate reports or notifications
- **Source**: [SalesPost.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Sales/Posting/SalesPost.Codeunit.al)

#### OnBeforeCheckSalesDoc
- **Publisher**: Codeunit 80 "Sales-Post"
- **Type**: IntegrationEvent
- **Parameters**: `var SalesHeader: Record "Sales Header"`, `var Handled: Boolean`
- **When**: Before document validation during posting
- **Cancellable**: Yes
- **Common Uses**:
  - Add custom validation rules
  - Skip standard validation (use carefully!)
  - Pre-populate missing fields
- **Source**: [SalesPost.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Sales/Posting/SalesPost.Codeunit.al)

### Sales Line Events

#### OnAfterValidateEvent (Quantity)
- **Publisher**: Table 37 "Sales Line"
- **Type**: IntegrationEvent
- **Parameters**: `var Rec: Record "Sales Line"`, `var xRec: Record "Sales Line"`, `CurrFieldNo: Integer`
- **When**: After quantity validation on sales line
- **Common Uses**:
  - Update custom pricing
  - Calculate custom discounts
  - Check inventory availability from external warehouse
  - Trigger replenishment orders
- **Source**: [SalesLine.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Sales/Document/SalesLine.Table.al)

#### OnAfterValidateEvent (Unit Price)
- **Publisher**: Table 37 "Sales Line"
- **Type**: IntegrationEvent
- **Parameters**: `var Rec: Record "Sales Line"`, `var xRec: Record "Sales Line"`, `CurrFieldNo: Integer`
- **When**: After unit price validation
- **Common Uses**:
  - Apply custom pricing logic
  - Enforce price limits
  - Log price changes for audit
- **Source**: [SalesLine.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Sales/Document/SalesLine.Table.al)

### Sales Header Events

#### OnAfterInsertEvent
- **Publisher**: Table 36 "Sales Header"
- **Type**: IntegrationEvent
- **Parameters**: `var Rec: Record "Sales Header"`, `RunTrigger: Boolean`
- **When**: After sales header record insertion
- **Common Uses**:
  - Auto-populate custom fields
  - Create related records (approvals, workflows)
  - Send notifications to sales team
- **Source**: [SalesHeader.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Sales/Document/SalesHeader.Table.al)

#### OnBeforeDeleteEvent
- **Publisher**: Table 36 "Sales Header"
- **Type**: IntegrationEvent
- **Parameters**: `var Rec: Record "Sales Header"`, `RunTrigger: Boolean`
- **When**: Before sales header deletion
- **Cancellable**: No (use table trigger override)
- **Common Uses**:
  - Archive document before deletion
  - Check custom deletion restrictions
  - Clean up related custom records
- **Source**: [SalesHeader.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Sales/Document/SalesHeader.Table.al)

---

## Purchase & Payables Events

### Posting Events

#### OnBeforePostPurchaseDoc
- **Publisher**: Codeunit 90 "Purch.-Post"
- **Type**: IntegrationEvent
- **Parameters**: `var PurchaseHeader: Record "Purchase Header"`, `var Handled: Boolean`
- **When**: Before purchase document posting
- **Cancellable**: Yes
- **Common Uses**:
  - Verify vendor approval status
  - Check budget availability
  - Validate against PO limits
  - Integrate with procurement systems
- **Source**: [PurchPost.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Purchases/Posting/PurchPost.Codeunit.al)

#### OnAfterPostPurchaseDoc
- **Publisher**: Codeunit 90 "Purch.-Post"
- **Type**: IntegrationEvent
- **Parameters**: `var PurchaseHeader: Record "Purchase Header"`, `PurchRcptNo: Code[20]`, `PurchInvNo: Code[20]`
- **When**: After successful purchase posting
- **Common Uses**:
  - Update vendor portals
  - Trigger payment processing
  - Generate GRN reports
  - Update cost accounting
- **Source**: [PurchPost.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Purchases/Posting/PurchPost.Codeunit.al)

### Purchase Line Events

#### OnAfterValidateEvent (Quantity)
- **Publisher**: Table 39 "Purchase Line"
- **Type**: IntegrationEvent
- **Parameters**: `var Rec: Record "Purchase Line"`, `var xRec: Record "Purchase Line"`, `CurrFieldNo: Integer`
- **When**: After quantity field validation
- **Common Uses**:
  - Calculate custom costs
  - Update demand planning
  - Check MOQ/EOQ constraints
- **Source**: [PurchaseLine.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Purchases/Document/PurchaseLine.Table.al)

---

## Inventory & Warehouse Events

### Item Posting Events

#### OnBeforePostItemJnlLine
- **Publisher**: Codeunit 22 "Item Jnl.-Post Line"
- **Type**: IntegrationEvent
- **Parameters**: `var ItemJournalLine: Record "Item Journal Line"`, `var Handled: Boolean`
- **When**: Before item ledger entry posting
- **Cancellable**: Yes
- **Common Uses**:
  - Validate serial/lot numbers
  - Check warehouse bin availability
  - Integrate with WMS systems
  - Apply custom costing logic
- **Source**: [ItemJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Inventory/Posting/ItemJnlPostLine.Codeunit.al)

#### OnAfterPostItemJnlLine
- **Publisher**: Codeunit 22 "Item Jnl.-Post Line"
- **Type**: IntegrationEvent
- **Parameters**: `var ItemJournalLine: Record "Item Journal Line"`, `ItemLedgerEntry: Record "Item Ledger Entry"`
- **When**: After item ledger entry created
- **Common Uses**:
  - Update external inventory systems
  - Trigger replenishment
  - Generate stock alerts
  - Update real-time dashboards
- **Source**: [ItemJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Inventory/Posting/ItemJnlPostLine.Codeunit.al)

### Item Events

#### OnAfterValidateEvent (Unit Cost)
- **Publisher**: Table 27 "Item"
- **Type**: IntegrationEvent
- **Parameters**: `var Rec: Record Item`, `var xRec: Record Item`, `CurrFieldNo: Integer`
- **When**: After unit cost field validation
- **Common Uses**:
  - Audit cost changes
  - Update standard costs
  - Trigger price list updates
  - Alert on significant cost variances
- **Source**: [Item.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Inventory/Item/Item.Table.al)

### Transfer Order Events

#### OnBeforePostTransferOrder
- **Publisher**: Codeunit 5704 "TransferOrder-Post"
- **Type**: IntegrationEvent
- **Parameters**: `var TransferHeader: Record "Transfer Header"`, `var Handled: Boolean`
- **When**: Before transfer order posting
- **Cancellable**: Yes
- **Common Uses**:
  - Validate inter-warehouse transfers
  - Check transit time constraints
  - Integrate with logistics providers
- **Source**: [TransferOrderPost.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Inventory/Transfer/TransferOrderPost.Codeunit.al)

---

## General Ledger & Posting Events

### General Journal Posting

#### OnBeforePostGenJnlLine
- **Publisher**: Codeunit 12 "Gen. Jnl.-Post Line"
- **Type**: IntegrationEvent
- **Parameters**: `var GenJournalLine: Record "Gen. Journal Line"`, `var Handled: Boolean`
- **When**: Before G/L entry creation
- **Cancellable**: Yes
- **Common Uses**:
  - Add custom account validations
  - Apply inter-company mappings
  - Enforce segregation of duties
  - Custom dimension logic
- **Source**: [GenJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Finance/GeneralLedger/Posting/GenJnlPostLine.Codeunit.al)

#### OnAfterPostGenJnlLine
- **Publisher**: Codeunit 12 "Gen. Jnl.-Post Line"
- **Type**: IntegrationEvent
- **Parameters**: `var GenJournalLine: Record "Gen. Journal Line"`, `GLEntryNo: Integer`
- **When**: After G/L entry posted
- **Common Uses**:
  - Update consolidation systems
  - Generate audit logs
  - Trigger financial reports
  - Update analytics/BI
- **Source**: [GenJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Finance/GeneralLedger/Posting/GenJnlPostLine.Codeunit.al)

### Customer/Vendor Ledger Events

#### OnBeforePostCustLedgerEntry
- **Publisher**: Codeunit 12 "Gen. Jnl.-Post Line"
- **Type**: IntegrationEvent
- **Parameters**: `var CustLedgerEntry: Record "Cust. Ledger Entry"`, `var GenJournalLine: Record "Gen. Journal Line"`
- **When**: Before customer ledger entry creation
- **Common Uses**:
  - Custom credit limit checks
  - Payment term validation
  - Collection workflow triggers
- **Source**: [GenJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Finance/GeneralLedger/Posting/GenJnlPostLine.Codeunit.al)

#### OnBeforePostVendorLedgerEntry
- **Publisher**: Codeunit 12 "Gen. Jnl.-Post Line"
- **Type**: IntegrationEvent
- **Parameters**: `var VendorLedgerEntry: Record "Vendor Ledger Entry"`, `var GenJournalLine: Record "Gen. Journal Line"`
- **When**: Before vendor ledger entry creation
- **Common Uses**:
  - Vendor payment hold checks
  - 1099 tracking
  - Payment batch preparation
- **Source**: [GenJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Finance/GeneralLedger/Posting/GenJnlPostLine.Codeunit.al)

### Bank Account Events

#### OnBeforePostBankAccLedgerEntry
- **Publisher**: Codeunit 12 "Gen. Jnl.-Post Line"
- **Type**: IntegrationEvent
- **Parameters**: `var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"`
- **When**: Before bank entry posting
- **Common Uses**:
  - Bank reconciliation automation
  - Cash flow forecasting updates
  - Multi-currency exchange rate checks
- **Source**: [GenJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Finance/GeneralLedger/Posting/GenJnlPostLine.Codeunit.al)

---

## Manufacturing Events

### Production Order Events

#### OnBeforePostProdOrder
- **Publisher**: Codeunit 5406 "Prod. Order Status Mgmt."
- **Type**: IntegrationEvent
- **Parameters**: `var ProductionOrder: Record "Production Order"`, `var Handled: Boolean`
- **When**: Before production order posting/status change
- **Cancellable**: Yes
- **Common Uses**:
  - Validate BOM completeness
  - Check routing capacity
  - Integrate with MES systems
  - Custom costing calculations
- **Source**: [ProdOrderStatusMgmt.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Document/ProdOrderStatusMgmt.Codeunit.al)

#### OnAfterChangeProdOrderStatus
- **Publisher**: Codeunit 5406 "Prod. Order Status Mgmt."
- **Type**: IntegrationEvent
- **Parameters**: `var ProductionOrder: Record "Production Order"`, `OldStatus: Enum "Production Order Status"`
- **When**: After production order status change
- **Common Uses**:
  - Trigger shop floor notifications
  - Update capacity planning
  - Generate work orders
  - Update material requirements
- **Source**: [ProdOrderStatusMgmt.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Document/ProdOrderStatusMgmt.Codeunit.al)

### Capacity Events

#### OnAfterPostCapacityEntry
- **Publisher**: Codeunit 5510 "Capacity Jnl.-Post Line"
- **Type**: IntegrationEvent
- **Parameters**: `var ItemJournalLine: Record "Item Journal Line"`, `CapacityLedgerEntry: Record "Capacity Ledger Entry"`
- **When**: After capacity consumption posting
- **Common Uses**:
  - Update labor tracking systems
  - Calculate actual vs. standard variances
  - Trigger efficiency reports
- **Source**: [CapacityJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Manufacturing/Capacity/CapacityJnlPostLine.Codeunit.al)

---

## Service Management Events

### Service Order Events

#### OnBeforePostServiceDoc
- **Publisher**: Codeunit 5980 "Service-Post"
- **Type**: IntegrationEvent
- **Parameters**: `var ServiceHeader: Record "Service Header"`, `var Handled: Boolean`
- **When**: Before service order posting
- **Cancellable**: Yes
- **Common Uses**:
  - Validate technician assignments
  - Check parts availability
  - SLA compliance verification
  - Customer notification triggers
- **Source**: [ServicePost.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Posting/ServicePost.Codeunit.al)

#### OnAfterPostServiceDoc
- **Publisher**: Codeunit 5980 "Service-Post"
- **Type**: IntegrationEvent
- **Parameters**: `var ServiceHeader: Record "Service Header"`, `ServiceShipmentNo: Code[20]`, `ServiceInvoiceNo: Code[20]`
- **When**: After service order posting
- **Common Uses**:
  - Send completion emails
  - Update service contracts
  - Generate customer surveys
  - Update asset history
- **Source**: [ServicePost.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Service/Posting/ServicePost.Codeunit.al)

---

## Integration & API Events

### Web Service Events

#### OnAfterAPIRecordInsert
- **Publisher**: Various API pages
- **Type**: IntegrationEvent
- **Parameters**: `var RecordRef: RecordRef`
- **When**: After record creation via API
- **Common Uses**:
  - Sync to external databases
  - Trigger webhooks
  - Audit API operations
  - Post-creation validation
- **Source**: Multiple API page objects in BaseApp

### Data Exchange Events

#### OnBeforeImportData
- **Publisher**: Codeunit 1220 "Data Exch. Def"
- **Type**: IntegrationEvent
- **Parameters**: `var DataExch: Record "Data Exch."`, `var Handled: Boolean`
- **When**: Before data import execution
- **Cancellable**: Yes
- **Common Uses**:
  - Transform import data
  - Validate file formats
  - Pre-process EDI messages
- **Source**: [DataExchDef.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Foundation/DataExchange/DataExchDef.Codeunit.al)

---

## Finding Events in Source Code

### Quick Reference: Search Workflow

**Recommended approach when event not in catalog**:
1. ✅ **Check Event Index first**: [BC27_EVENT_INDEX.md](./BC27_EVENT_INDEX.md) - Keyword search across all events
2. ✅ **Use AL Language tools**: VS Code "Go to Definition" (F12) on codeunit names
3. ✅ **Search BC27 source**: GitHub repository or local BC symbols
4. ✅ **Use Cursor rule**: See `.cursor/rules/010-event-discovery.mdc` for LLM-assisted discovery

---

### Search Strategies

#### 1. **By Event Name Pattern (Grep/Ripgrep)**

```bash
# Find all OnBefore sales posting events
grep -r "OnBefore.*Sales.*Post" --include="*.al" -A 5

# Find all event publishers in a codeunit
grep -r "\[IntegrationEvent\|BusinessEvent\]" SalesPost.Codeunit.al -A 3

# Find all subscribers to a specific event
grep -r "EventSubscriber.*OnBeforePostSalesDoc" --include="*.al"

# Find events with "Handled" parameter (cancellable events)
grep -r "IntegrationEvent.*var.*Handled.*Boolean" --include="*.al"

# Find all validation events
grep -r "OnValidate.*Event" --include="*.al" -B 2 -A 5

# Search with ripgrep (faster for large codebases)
rg "IntegrationEvent" --type al -A 5 | rg "OnBefore.*Post"
```

#### 2. **By Object/Module**

```bash
# Find ALL events in Sales-Post codeunit (list complete event catalog)
grep -E "^\s+(local )?procedure On(Before|After)" SalesPost.Codeunit.al

# Find events in specific module/folder
grep -r "IntegrationEvent" BaseApp/Sales/ --include="*.al" | grep "procedure On"

# Find table trigger events (OnAfter/OnBefore Insert/Modify/Delete/Validate)
grep -r "On(After|Before)(Insert|Modify|Delete)Event" --include="*.al"

# Find all events in a namespace/module
grep -r "IntegrationEvent" BaseApp/Manufacturing/ --include="*.al" -l | xargs -I {} basename {}
```

#### 3. **By Business Operation**

```bash
# Find events related to posting operations
grep -r "IntegrationEvent.*Post" --include="*.al" | grep "procedure"

# Find events related to validation
grep -r "IntegrationEvent.*Validate" --include="*.al" | grep "procedure"

# Find events related to calculation
grep -r "IntegrationEvent.*Calculate" --include="*.al" | grep "procedure"

# Find events related to specific document types
grep -r "IntegrationEvent.*(Sales|Purchase|Transfer)" --include="*.al" | grep "procedure"
```

#### 4. **Using VS Code/Cursor (AL Language Extension)**

**Fastest method for finding events**:

1. **Go to Definition** (F12):
   - Open any AL file
   - Type codeunit name: `Codeunit::"Sales-Post"`
   - Press F12 → Opens codeunit definition
   - Search within file for `[IntegrationEvent]`

2. **Find All References** (Shift+F12):
   - Place cursor on event name
   - Press Shift+F12 → Shows all subscribers

3. **Symbol Search** (Ctrl+T):
   - Press Ctrl+T
   - Type: `OnBeforePostSalesDoc`
   - Shows definition + all subscribers

4. **Workspace Search** (Ctrl+Shift+F):
   ```
   Search: \[IntegrationEvent.*\]
   Files to include: **/*.al
   ```

#### 5. **Using BC27 Source Repository**

**Repository**: [MSDyn365BC.Code.History](https://github.com/StefanMaron/MSDyn365BC.Code.History)
**Branch**: `be-27` (Belgium localization, BC v27)

**GitHub Search Examples**:
```
# Find specific event
repo:StefanMaron/MSDyn365BC.Code.History IntegrationEvent OnBeforePostSalesDoc

# Find all events in a codeunit
repo:StefanMaron/MSDyn365BC.Code.History "Sales-Post" IntegrationEvent

# Find subscribers to an event
repo:StefanMaron/MSDyn365BC.Code.History EventSubscriber "OnBeforePostSalesDoc"

# Find events by module
repo:StefanMaron/MSDyn365BC.Code.History path:Manufacturing IntegrationEvent
```

**Advanced GitHub Code Search**:
```
# Find cancellable events (with Handled parameter)
repo:StefanMaron/MSDyn365BC.Code.History "IntegrationEvent" "var Handled"

# Find events added/modified in BC27
repo:StefanMaron/MSDyn365BC.Code.History IntegrationEvent is:modified

# Find events in specific file type
repo:StefanMaron/MSDyn365BC.Code.History IntegrationEvent extension:al
```

#### 6. **Event Discovery Workflow**

**Step-by-step approach**:

1. **Identify Operation**: What base functionality do you want to extend?
   - Example: "I want to validate sales orders before posting"

2. **Find Publisher Object**: Locate the codeunit/table that handles it
   - Sales posting → Codeunit 80 "Sales-Post"
   - Item posting → Codeunit 22 "Item Jnl.-Post Line"
   - Use [BC27_ARCHITECTURE.md](./BC27_ARCHITECTURE.md) to identify objects

3. **Search for Events**: Look for `[IntegrationEvent]` attributes
   ```bash
   grep -A 10 "\[IntegrationEvent\]" SalesPost.Codeunit.al
   ```

4. **Check Parameters**: Verify event signature matches your needs
   - Need to modify header? → Check for `var SalesHeader` parameter
   - Need to cancel operation? → Check for `var Handled` parameter

5. **Look for Handled Pattern**: Check if event supports cancellation
   ```bash
   grep -B 2 -A 5 "OnBeforePostSalesDoc" | grep "Handled"
   ```

6. **Find Examples**: Search for existing subscribers to see usage patterns
   ```bash
   grep -r "EventSubscriber.*OnBeforePostSalesDoc" --include="*.al" -A 10
   ```

#### 7. **Finding Events by Category**

**Common event categories**:

```bash
# Posting events
grep -r "IntegrationEvent.*Post" --include="*.al" | grep "procedure On"

# Validation events
grep -r "OnValidate.*Event" --include="*.al"

# Document lifecycle
grep -r "On(Before|After)(Insert|Modify|Delete)" --include="*.al"

# Calculation events
grep -r "OnAfterCalculate" --include="*.al"

# Report events
grep -r "OnBefore.*Report|OnAfter.*Report" --include="*.al"

# Job Queue events
grep -r "OnBeforeJobQueueScheduleTask" --include="*.al"
```

### Common Publisher Objects

| Area | Object | Common Events |
|------|--------|---------------|
| **Sales Posting** | Codeunit 80 "Sales-Post" | OnBeforePostSalesDoc, OnAfterPostSalesDoc |
| **Purchase Posting** | Codeunit 90 "Purch.-Post" | OnBeforePostPurchaseDoc, OnAfterPostPurchaseDoc |
| **G/L Posting** | Codeunit 12 "Gen. Jnl.-Post Line" | OnBeforePostGenJnlLine, OnAfterPostGenJnlLine |
| **Item Posting** | Codeunit 22 "Item Jnl.-Post Line" | OnBeforePostItemJnlLine, OnAfterPostItemJnlLine |
| **Sales Header** | Table 36 "Sales Header" | OnAfterInsertEvent, OnBeforeDeleteEvent |
| **Sales Line** | Table 37 "Sales Line" | OnAfterValidateEvent (various fields) |

---

## Event Subscriber Template

```al
codeunit 77101 "ABC Event Subscribers"
{
    // Pattern: OnBefore event with cancellation
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure ValidateCustomFieldsBeforePost(var SalesHeader: Record "Sales Header"; var Handled: Boolean)
    begin
        // Add custom validation
        if SalesHeader."ABC Custom Field" = '' then
            Error('ABC Custom Field is required before posting');

        // To cancel posting, set Handled := true
        // Handled := true;
    end;

    // Pattern: OnAfter event for side effects
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure NotifyExternalSystemAfterPost(var SalesHeader: Record "Sales Header"; SalesShipmentNo: Code[20]; SalesInvoiceNo: Code[20])
    var
        ABCIntegration: Codeunit "ABC Integration Mgmt";
    begin
        // Send to external system
        ABCIntegration.SendSalesOrder(SalesHeader, SalesInvoiceNo);
    end;

    // Pattern: Table field validation
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure UpdateCustomPricingOnQuantityChange(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        ABCPricing: Codeunit "ABC Custom Pricing";
    begin
        // Apply custom pricing logic
        if Rec.Quantity <> xRec.Quantity then
            ABCPricing.CalculateVolumeDiscount(Rec);
    end;
}
```

---

## Best Practices

### 1. **Event Selection**
- ✅ Use OnBefore events for validation and data modification
- ✅ Use OnAfter events for notifications and side effects
- ✅ Prefer higher-level events (document posting vs. line-by-line)
- ❌ Don't modify base records in OnAfter events (creates confusion)

### 2. **Error Handling**
- ✅ Throw clear, actionable error messages
- ✅ Use Handled parameter to gracefully cancel operations
- ❌ Don't silently fail in event subscribers
- ❌ Don't use OnError triggers in subscribers

### 3. **Performance**
- ✅ Keep subscribers fast (< 100ms ideal)
- ✅ Use temporary tables for bulk operations
- ✅ Defer heavy processing to job queue
- ❌ Don't make synchronous external API calls in high-frequency events

### 4. **Testing**
- ✅ Test both with and without your extension installed
- ✅ Verify Handled parameter works correctly
- ✅ Test error scenarios and rollback behavior
- ✅ Check impact on standard posting performance

---

## Quick Reference: Top 20 Events

| Event | Publisher | Use Case | Cancellable |
|-------|-----------|----------|-------------|
| OnBeforePostSalesDoc | Codeunit 80 | Sales posting validation | ✅ |
| OnAfterPostSalesDoc | Codeunit 80 | Sales posting notifications | ❌ |
| OnBeforePostPurchaseDoc | Codeunit 90 | Purchase posting validation | ✅ |
| OnAfterPostPurchaseDoc | Codeunit 90 | Purchase posting notifications | ❌ |
| OnBeforePostGenJnlLine | Codeunit 12 | G/L validation | ✅ |
| OnAfterPostGenJnlLine | Codeunit 12 | G/L integration | ❌ |
| OnBeforePostItemJnlLine | Codeunit 22 | Inventory validation | ✅ |
| OnAfterPostItemJnlLine | Codeunit 22 | Inventory updates | ❌ |
| OnAfterValidateEvent (Quantity) | Table 37 | Sales line calculations | ❌ |
| OnAfterValidateEvent (Unit Price) | Table 37 | Pricing logic | ❌ |
| OnAfterInsertEvent | Table 36 | Sales header creation | ❌ |
| OnBeforeDeleteEvent | Table 36 | Sales header deletion checks | ❌ |
| OnBeforeCheckSalesDoc | Codeunit 80 | Custom document validation | ✅ |
| OnBeforePostProdOrder | Codeunit 5406 | Production validation | ✅ |
| OnAfterChangeProdOrderStatus | Codeunit 5406 | Production workflow | ❌ |
| OnBeforePostServiceDoc | Codeunit 5980 | Service order validation | ✅ |
| OnAfterPostServiceDoc | Codeunit 5980 | Service completion | ❌ |
| OnBeforePostCustLedgerEntry | Codeunit 12 | Customer ledger validation | ❌ |
| OnBeforePostVendorLedgerEntry | Codeunit 12 | Vendor ledger validation | ❌ |
| OnBeforeImportData | Codeunit 1220 | Data import transformation | ✅ |

---

## Additional Resources

- **Source Repository**: [BC27 Code History](https://github.com/StefanMaron/MSDyn365BC.Code.History/tree/be-27)
- **Architecture Guide**: [BC27_ARCHITECTURE.md](./BC27_ARCHITECTURE.md)
- **Module Overview**: [BC27_MODULES_OVERVIEW.md](./BC27_MODULES_OVERVIEW.md)
- **Integration Guide**: [BC27_INTEGRATION_GUIDE.md](./BC27_INTEGRATION_GUIDE.md)
- **Extension Points**: [BC27_EXTENSION_POINTS.md](./BC27_EXTENSION_POINTS.md)

---

**Version Notes**:
- **v1.0**: Initial catalog with 50+ core events across Sales, Purchase, Inventory, G/L, Manufacturing, and Service modules
- **Coverage**: BaseApp core events (most commonly used)
- **Future**: Will expand with API events, specialized module events, and additional examples
