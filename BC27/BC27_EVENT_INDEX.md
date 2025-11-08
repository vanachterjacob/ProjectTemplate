# BC27 Event Index - Keyword Search Across All Events

Master index for searching BC27 events by keyword, operation, or use case. Use this index to quickly find events across all catalogs.

**Version**: 1.0
**BC Version**: 27
**Coverage**: 140+ events across all modules
**Last Updated**: 2025-11-08

---

## How to Use This Index

1. **Search by keyword** (Ctrl+F): posting, validate, calculate, sync, etc.
2. **Search by operation**: "sales posting", "BOM explosion", "API authentication"
3. **Search by publisher**: "Codeunit 80", "Sales-Post", "Service-Post"
4. **Check catalog column**: Navigate to detailed event documentation

---

## Event Index by Keyword

### Posting Events

| Event Name | When | Publisher | Module | Catalog |
|------------|------|-----------|--------|---------|
| **OnBeforePostSalesDoc** | Before sales posting | Codeunit 80 "Sales-Post" | Sales | [Main](./BC27_EVENT_CATALOG.md#onbeforepostsalesdoc) |
| **OnAfterPostSalesDoc** | After sales posting | Codeunit 80 "Sales-Post" | Sales | [Main](./BC27_EVENT_CATALOG.md#onafterpostsalesdoc) |
| **OnBeforePostPurchaseDoc** | Before purchase posting | Codeunit 90 "Purch.-Post" | Purchase | [Main](./BC27_EVENT_CATALOG.md#onbeforepostpurchasedoc) |
| **OnAfterPostPurchaseDoc** | After purchase posting | Codeunit 90 "Purch.-Post" | Purchase | [Main](./BC27_EVENT_CATALOG.md#onafterpostpurchasedoc) |
| **OnBeforePostGenJnlLine** | Before G/L posting | Codeunit 12 "Gen. Jnl.-Post Line" | Finance | [Main](./BC27_EVENT_CATALOG.md#onbeforepostgenjnlline) |
| **OnAfterPostGenJnlLine** | After G/L posting | Codeunit 12 "Gen. Jnl.-Post Line" | Finance | [Main](./BC27_EVENT_CATALOG.md#onafterpostgenjnlline) |
| **OnBeforePostItemJnlLine** | Before item posting | Codeunit 22 "Item Jnl.-Post Line" | Inventory | [Main](./BC27_EVENT_CATALOG.md#onbeforepostitemjnlline) |
| **OnAfterPostItemJnlLine** | After item posting | Codeunit 22 "Item Jnl.-Post Line" | Inventory | [Main](./BC27_EVENT_CATALOG.md#onafterpostitemjnlline) |
| **OnBeforePostServiceDoc** | Before service posting | Codeunit 5980 "Service-Post" | Service | [Service](./events/BC27_EVENTS_SERVICE.md#onbeforepostservicedoc) |
| **OnAfterPostServiceDoc** | After service posting | Codeunit 5980 "Service-Post" | Service | [Service](./events/BC27_EVENTS_SERVICE.md#onafterpostservicedoc) |
| **OnBeforePostJobJnlLine** | Before job posting | Codeunit 1000 "Job Jnl.-Post Line" | Jobs | [Jobs](./events/BC27_EVENTS_JOBS.md#onbeforepostjobjnlline) |
| **OnAfterPostJobJnlLine** | After job posting | Codeunit 1000 "Job Jnl.-Post Line" | Jobs | [Jobs](./events/BC27_EVENTS_JOBS.md#onafterpostjobjnlline) |
| **OnBeforePostCapacity** | Before capacity posting | Codeunit 5510 "Capacity Jnl.-Post Line" | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md#onbeforepostcapacity) |
| **OnAfterPostCapacity** | After capacity posting | Codeunit 5510 "Capacity Jnl.-Post Line" | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md#onafterpostcapacity) |

### Validation Events

| Event Name | When | Publisher | Module | Catalog |
|------------|------|-----------|--------|---------|
| **OnBeforeCheckSalesDoc** | Before document validation | Codeunit 80 "Sales-Post" | Sales | [Main](./BC27_EVENT_CATALOG.md#onbeforechecksalesdoc) |
| **OnAfterValidateEvent (Quantity)** | After quantity validation | Table 37 "Sales Line" | Sales | [Main](./BC27_EVENT_CATALOG.md#onaftervalidateevent-quantity) |
| **OnAfterValidateEvent (Unit Price)** | After price validation | Table 37 "Sales Line" | Sales | [Main](./BC27_EVENT_CATALOG.md#onaftervalidateevent-unit-price) |
| **OnBeforeValidateProdBOM** | Before BOM validation | Table 99000771 "Production BOM Header" | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md#onbeforevalidateprodbom) |
| **OnBeforeValidateManufacturingSetup** | Before setup validation | Table 99000765 "Manufacturing Setup" | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md#onbeforevalidatemanufacturingsetup) |
| **OnBeforeAPIValidation** | Before API validation | API controllers | API | [API](./events/BC27_EVENTS_API.md#onbeforeapivalidation) |

### Production & Manufacturing Events

| Event Name | When | Publisher | Module | Catalog |
|------------|------|-----------|--------|---------|
| **OnBeforeRefreshProdOrder** | Before prod order refresh | Codeunit 99000773 | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md#onbeforerefreshprodorder) |
| **OnAfterRefreshProdOrder** | After prod order refresh | Codeunit 99000773 | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md#onafterrefreshprodorder) |
| **OnBeforeChangeProdOrderStatus** | Before status change | Codeunit 99000773 | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md#onbeforechangeprodorderstatus) |
| **OnAfterChangeProdOrderStatus** | After status change | Codeunit 99000773 | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md#onafterchangeprodorderstatus) |
| **OnBeforeFinishProdOrder** | Before finishing order | Codeunit 99000773 | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md#onbeforefinishprodorder) |
| **OnAfterFinishProdOrder** | After order finished | Codeunit 99000773 | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md#onafterfinishprodorder) |
| **OnBeforeExplodeBOM** | Before BOM explosion | Codeunit 99000770 | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md#onbeforeexplodebom) |
| **OnAfterExplodeBOM** | After BOM explosion | Codeunit 99000770 | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md#onafterexplodebom) |
| **OnBeforeCalculateRouting** | Before routing calculation | Codeunit 99000774 | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md#onbeforecalculaterouting) |
| **OnAfterCalculateRouting** | After routing calculation | Codeunit 99000774 | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md#onaftercalculaterouting) |

### Service Management Events

| Event Name | When | Publisher | Module | Catalog |
|------------|------|-----------|--------|---------|
| **OnBeforeSignServContract** | Before contract signing | Codeunit 5940 | Service | [Service](./events/BC27_EVENTS_SERVICE.md#onbeforesignservcontract) |
| **OnAfterSignServContract** | After contract signed | Codeunit 5940 | Service | [Service](./events/BC27_EVENTS_SERVICE.md#onaftersignservcontract) |
| **OnBeforeCreateContractInvoice** | Before contract invoice | Codeunit 5940 | Service | [Service](./events/BC27_EVENTS_SERVICE.md#onbeforecreatecontractinvoice) |
| **OnAfterCreateContractInvoice** | After invoice created | Codeunit 5940 | Service | [Service](./events/BC27_EVENTS_SERVICE.md#onaftercreatecontractinvoice) |
| **OnBeforeRenewContract** | Before contract renewal | Codeunit 5940 | Service | [Service](./events/BC27_EVENTS_SERVICE.md#onbeforerenewcontract) |
| **OnAfterRenewContract** | After contract renewed | Codeunit 5940 | Service | [Service](./events/BC27_EVENTS_SERVICE.md#onafterrenewcontract) |
| **OnBeforeFinishServiceOrder** | Before finishing service | Codeunit 5980 | Service | [Service](./events/BC27_EVENTS_SERVICE.md#onbeforefinishserviceorder) |
| **OnAfterFinishServiceOrder** | After service finished | Codeunit 5980 | Service | [Service](./events/BC27_EVENTS_SERVICE.md#onafterfinishserviceorder) |

### Jobs & Projects Events

| Event Name | When | Publisher | Module | Catalog |
|------------|------|-----------|--------|---------|
| **OnBeforeCreateJobPlanningLine** | Before planning line create | Codeunit 1000 | Jobs | [Jobs](./events/BC27_EVENTS_JOBS.md#onbeforecreatejobplanningline) |
| **OnAfterCreateJobPlanningLine** | After planning line created | Codeunit 1000 | Jobs | [Jobs](./events/BC27_EVENTS_JOBS.md#onaftercreatejobplanningline) |
| **OnBeforeCalculateWIP** | Before WIP calculation | Codeunit 1000 | Jobs | [Jobs](./events/BC27_EVENTS_JOBS.md#onbeforecalculatewip) |
| **OnAfterCalculateWIP** | After WIP calculated | Codeunit 1000 | Jobs | [Jobs](./events/BC27_EVENTS_JOBS.md#onaftercalculatewip) |
| **OnBeforeRecognizeRevenue** | Before revenue recognition | Codeunit 1000 | Jobs | [Jobs](./events/BC27_EVENTS_JOBS.md#onbeforerecognizerevenue) |
| **OnBeforeCompleteJob** | Before job completion | Codeunit 1000 | Jobs | [Jobs](./events/BC27_EVENTS_JOBS.md#onbeforecompletejob) |
| **OnAfterCompleteJob** | After job completed | Codeunit 1000 | Jobs | [Jobs](./events/BC27_EVENTS_JOBS.md#onaftercompletejob) |

### API & Integration Events

| Event Name | When | Publisher | Module | Catalog |
|------------|------|-----------|--------|---------|
| **OnAfterAPIRecordInsert** | After API record create | API pages | API | [API](./events/BC27_EVENTS_API.md#onafterapirecordinsert) |
| **OnAfterAPIRecordModify** | After API record modify | API pages | API | [API](./events/BC27_EVENTS_API.md#onafterapirecordmodify) |
| **OnAfterAPIRecordDelete** | After API record delete | API pages | API | [API](./events/BC27_EVENTS_API.md#onafterapirecorddelete) |
| **OnBeforeRegisterWebhook** | Before webhook registration | Codeunit 6155 | API | [API](./events/BC27_EVENTS_API.md#onbeforeregisterwebhook) |
| **OnAfterSendWebhookNotification** | After webhook sent | Codeunit 6155 | API | [API](./events/BC27_EVENTS_API.md#onaftersendwebhooknotification) |
| **OnBeforeSyncToExternal** | Before external sync | Sync codeunits | API | [API](./events/BC27_EVENTS_API.md#onbeforesynctoexternal) |
| **OnAfterSyncFromExternal** | After external sync | Sync codeunits | API | [API](./events/BC27_EVENTS_API.md#onaftersyncfromexternal) |
| **OnBeforeAPIAuthentication** | Before API authentication | API auth handlers | API | [API](./events/BC27_EVENTS_API.md#onbeforeapiauth) |
| **OnBeforeImportDataExchange** | Before data import | Codeunit 1220 | API | [API](./events/BC27_EVENTS_API.md#onbeforeimportdataexchange) |

---

## Search by Common Use Case

### "I want to..."

| Use Case | Recommended Event | Catalog |
|----------|-------------------|---------|
| Validate before posting sales | `OnBeforePostSalesDoc` | [Main](./BC27_EVENT_CATALOG.md) |
| Sync to external system after posting | `OnAfterPost[Document]Doc` | [Main](./BC27_EVENT_CATALOG.md) |
| Modify price when quantity changes | `OnAfterValidateEvent (Quantity)` | [Main](./BC27_EVENT_CATALOG.md) |
| Add custom validation to BOM | `OnBeforeValidateProdBOM` | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md) |
| Track production order status | `OnAfterChangeProdOrderStatus` | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md) |
| Send service completion notification | `OnAfterPostServiceDoc` | [Service](./events/BC27_EVENTS_SERVICE.md) |
| Validate contract terms | `OnBeforeSignServContract` | [Service](./events/BC27_EVENTS_SERVICE.md) |
| Calculate WIP for projects | `OnBeforeCalculateWIP` | [Jobs](./events/BC27_EVENTS_JOBS.md) |
| Sync API operations | `OnAfterAPIRecordInsert` | [API](./events/BC27_EVENTS_API.md) |
| Validate webhook endpoints | `OnBeforeRegisterWebhook` | [API](./events/BC27_EVENTS_API.md) |

---

## Search by Publisher Object

### Codeunit Index

| Codeunit | Events | Module | Catalog |
|----------|--------|--------|---------|
| 12 "Gen. Jnl.-Post Line" | 10+ posting events | Finance | [Main](./BC27_EVENT_CATALOG.md) |
| 22 "Item Jnl.-Post Line" | 8+ inventory events | Inventory | [Main](./BC27_EVENT_CATALOG.md) |
| 80 "Sales-Post" | 15+ sales posting events | Sales | [Main](./BC27_EVENT_CATALOG.md) |
| 90 "Purch.-Post" | 12+ purchase events | Purchase | [Main](./BC27_EVENT_CATALOG.md) |
| 1000 "Job Jnl.-Post Line" | 15+ job events | Jobs | [Jobs](./events/BC27_EVENTS_JOBS.md) |
| 5510 "Capacity Jnl.-Post Line" | 5+ capacity events | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md) |
| 5940 "ServContractManagement" | 12+ contract events | Service | [Service](./events/BC27_EVENTS_SERVICE.md) |
| 5980 "Service-Post" | 10+ service events | Service | [Service](./events/BC27_EVENTS_SERVICE.md) |
| 6155 "Webhook Management" | 6+ webhook events | API | [API](./events/BC27_EVENTS_API.md) |
| 99000773 "Prod. Order Status Mgmt." | 15+ production events | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md) |
| 99000770 "BOM Explode BOM" | 4+ BOM events | Manufacturing | [Manufacturing](./events/BC27_EVENTS_MANUFACTURING.md) |

---

## Event Pattern Quick Reference

| Pattern | When Fires | Typical Parameters | Cancellable? |
|---------|------------|-------------------|--------------|
| `OnBefore[Action]` | Before operation | `var Record`, `var Handled` | Usually Yes |
| `OnAfter[Action]` | After operation | `Record` (readonly) | No |
| `OnValidate[Field]` | Field validation | `var Rec`, `var xRec`, `FieldNo` | No (validation) |
| `OnInsert/Modify/DeleteEvent` | Table triggers | `var Rec`, `RunTrigger` | No (triggers) |
| `OnAfterCalculate[X]` | After calculation | `var Result` | No |

---

## Coverage Summary

| Module | Events Documented | Catalog File |
|--------|-------------------|--------------|
| **Sales & Purchase** | 50+ | [BC27_EVENT_CATALOG.md](./BC27_EVENT_CATALOG.md) |
| **Inventory & Warehouse** | ~15 | [BC27_EVENT_CATALOG.md](./BC27_EVENT_CATALOG.md) |
| **Finance & G/L** | ~20 | [BC27_EVENT_CATALOG.md](./BC27_EVENT_CATALOG.md) |
| **Manufacturing** | 30+ | [events/BC27_EVENTS_MANUFACTURING.md](./events/BC27_EVENTS_MANUFACTURING.md) |
| **Service Management** | 20+ | [events/BC27_EVENTS_SERVICE.md](./events/BC27_EVENTS_SERVICE.md) |
| **Jobs & Projects** | 15+ | [events/BC27_EVENTS_JOBS.md](./events/BC27_EVENTS_JOBS.md) |
| **API & Integration** | 25+ | [events/BC27_EVENTS_API.md](./events/BC27_EVENTS_API.md) |
| **TOTAL** | **~175 events** | - |

---

## Additional Resources

- **Event Catalogs**:
  - [BC27_EVENT_CATALOG.md](./BC27_EVENT_CATALOG.md) - Core posting & document events
  - [BC27_EVENTS_MANUFACTURING.md](./events/BC27_EVENTS_MANUFACTURING.md) - Production & BOM events
  - [BC27_EVENTS_SERVICE.md](./events/BC27_EVENTS_SERVICE.md) - Service & contract events
  - [BC27_EVENTS_JOBS.md](./events/BC27_EVENTS_JOBS.md) - Job & project events
  - [BC27_EVENTS_API.md](./events/BC27_EVENTS_API.md) - API & integration events

- **Extension Points**: [BC27_EXTENSION_POINTS.md](./BC27_EXTENSION_POINTS.md)
- **Cursor Rule**: `.cursor/rules/010-event-discovery.mdc`
- **Source Repository**: [BC27 GitHub](https://github.com/StefanMaron/MSDyn365BC.Code.History/tree/be-27)

---

**Version**: 1.0
**Last Updated**: 2025-11-08
**Total Events Indexed**: ~175 across all modules
