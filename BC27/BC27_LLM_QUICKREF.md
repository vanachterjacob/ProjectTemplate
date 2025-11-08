# BC27 Quick Reference for LLMs
<!-- LLM Context: High-priority, token-optimized BC27 reference -->
<!-- Priority: CRITICAL | Token Budget: <500 lines | Auto-load: On BC27 queries -->

**Purpose:** Ultra-condensed BC27 reference for efficient LLM consumption
**Token Strategy:** Summary first, links to details
**Update:** Regenerate when BC27 index changes

## 🎯 When to Use Full Documentation

**Use this file for:** Quick lookups, validation, initial context
**Use detailed docs for:**
- Event integration → [BC27_EVENT_CATALOG.md](./BC27_EVENT_CATALOG.md)
- Architecture decisions → [BC27_ARCHITECTURE.md](./BC27_ARCHITECTURE.md)
- Module selection → [BC27_MODULES_BY_CATEGORY.md](./BC27_MODULES_BY_CATEGORY.md)

---

## 📊 BC27 Platform Overview

| Aspect | Details |
|--------|---------|
| **Total Modules** | 73 (4 core + 69 extensions) |
| **Architecture** | System App → Base App → Business Foundation → Extensions |
| **Key Events** | ~210 events indexed (50 core, 160+ module-specific) |
| **Integration Points** | 15+ (Shopify, Power BI, Teams, OneDrive, etc.) |
| **Localization** | 8+ countries with regulatory modules |

---

## 🔧 Extension Development Quick Guide

### 1. Finding Events (Most Common Task)

**Step 1:** Check event type
- **Posting/Validation** → [BC27_EVENT_CATALOG.md](./BC27_EVENT_CATALOG.md) (core events)
- **Manufacturing** → [events/BC27_EVENTS_MANUFACTURING.md](./events/BC27_EVENTS_MANUFACTURING.md)
- **Service** → [events/BC27_EVENTS_SERVICE.md](./events/BC27_EVENTS_SERVICE.md)
- **Jobs** → [events/BC27_EVENTS_JOBS.md](./events/BC27_EVENTS_JOBS.md)
- **API** → [events/BC27_EVENTS_API.md](./events/BC27_EVENTS_API.md)
- **Fixed Assets** → [events/BC27_EVENTS_FIXEDASSETS.md](./events/BC27_EVENTS_FIXEDASSETS.md)
- **Warehouse** → [events/BC27_EVENTS_WAREHOUSE.md](./events/BC27_EVENTS_WAREHOUSE.md)
- **Assembly** → [events/BC27_EVENTS_ASSEMBLY.md](./events/BC27_EVENTS_ASSEMBLY.md)
- **Keyword Search** → [BC27_EVENT_INDEX.md](./BC27_EVENT_INDEX.md) (all events)

**Step 2:** Event naming patterns
```al
OnBefore[Action]        // Block/modify before action
OnAfter[Action]         // Add logic after action
OnValidate[Field]       // Field validation
On[DocType]Post         // Document posting
```

### 2. Table/Page Extensions

**Read:** [BC27_EXTENSION_POINTS.md](./BC27_EXTENSION_POINTS.md)

**Key Patterns:**
- Sales Header/Line → ID 10000-19999 (reserved for extensions)
- Purchase Header/Line → ID 10000-19999
- Item, Customer, Vendor → ID 10000-19999
- G/L Entry, Bank Ledger → Avoid extending (performance)

### 3. Module Dependencies

**Before using a module:** Check [BC27_DEPENDENCY_REFERENCE.md](./BC27_DEPENDENCY_REFERENCE.md)

**Example chains:**
- Service Management → Jobs → Resource Planning → Time Sheet
- Manufacturing → Inventory → Item Tracking → Warehouse
- Fixed Assets → G/L → VAT → Audit

---

## 📦 Top 20 Most-Used Modules (by Extension Frequency)

| Rank | Module | Use Cases | Events |
|------|--------|-----------|--------|
| 1 | **Sales** | Orders, quotes, invoices | 20+ |
| 2 | **Purchase** | POs, receipts, vendor mgmt | 18+ |
| 3 | **Inventory** | Stock, warehousing, items | 15+ |
| 4 | **G/L** | Financial posting, accounts | 12+ |
| 5 | **Manufacturing** | Production, BOMs, routing | 30+ |
| 6 | **Service** | Service orders, contracts | 20+ |
| 7 | **Jobs** | Project management, WIP | 15+ |
| 8 | **Fixed Assets** | Asset tracking, depreciation | 15+ |
| 9 | **CRM** | Contact management, campaigns | 8+ |
| 10 | **Warehouse** | Advanced warehouse mgmt | 18+ |
| 11 | **Assembly** | Kit assembly, ATO | 12+ |
| 12 | **Item Tracking** | Serial/lot numbers | 10+ |
| 13 | **Bank Reconciliation** | Bank feeds, matching | 5+ |
| 14 | **VAT** | Tax calculation, reporting | 8+ |
| 15 | **Resource Planning** | Resource allocation | 6+ |
| 16 | **Intercompany** | Multi-company transactions | 5+ |
| 17 | **Shopify** | E-commerce integration | 25+ |
| 18 | **Power BI** | Reporting, analytics | N/A |
| 19 | **API** | REST APIs, webhooks | 25+ |
| 20 | **E-Document** | E-invoicing, digital docs | 8+ |

---

## 🔍 Event Lookup by Business Process

### Financial Processes
| Process | Primary Events File | Key Events |
|---------|-------------------|-----------|
| G/L Posting | BC27_EVENT_CATALOG.md | OnBeforePostGenJnlLine, OnAfterPostGenJnlLine |
| Sales Posting | BC27_EVENT_CATALOG.md | OnBeforeSalesPost, OnAfterSalesPost |
| Purchase Posting | BC27_EVENT_CATALOG.md | OnBeforePurchPost, OnAfterPurchPost |
| Payment Processing | BC27_EVENT_CATALOG.md | OnBeforePostPayment, OnAfterPostPayment |

### Inventory & Manufacturing
| Process | Primary Events File | Key Events |
|---------|-------------------|-----------|
| Item Posting | BC27_EVENT_CATALOG.md | OnBeforePostItemJnlLine, OnAfterPostItemJnlLine |
| Production Orders | BC27_EVENTS_MANUFACTURING.md | OnBeforePostProductionOrder, OnAfterPostOutput |
| BOM Management | BC27_EVENTS_MANUFACTURING.md | OnBeforeCalculateBOM, OnAfterExplodeBOM |
| Warehouse Operations | BC27_EVENTS_WAREHOUSE.md | OnBeforeCreatePick, OnAfterRegisterWhseJnlLine |

### Service & Projects
| Process | Primary Events File | Key Events |
|---------|-------------------|-----------|
| Service Orders | BC27_EVENTS_SERVICE.md | OnBeforePostServiceOrder, OnAfterPostServiceInvoice |
| Job Posting | BC27_EVENTS_JOBS.md | OnBeforePostJobJnlLine, OnAfterJobPost |
| Time Tracking | BC27_EVENTS_JOBS.md | OnValidateTimeSheetLine, OnPostTimeSheet |

### Integration & API
| Process | Primary Events File | Key Events |
|---------|-------------------|-----------|
| REST API Calls | BC27_EVENTS_API.md | OnBeforeAPIRequest, OnAfterAPIResponse |
| Webhook Handling | BC27_EVENTS_API.md | OnReceiveWebhook, OnProcessWebhookQueue |
| Shopify Sync | BC27_EVENTS_API.md | OnSyncShopifyProducts, OnSyncShopifyOrders |

---

## 🏗️ BC27 Architecture Layers (Simplified)

```
Layer 5: Industry Extensions (Shopify, Manufacturing, Service, etc.)
         ↓ depends on
Layer 4: Business Foundation (shared business logic)
         ↓ depends on
Layer 3: Base App (core ERP - Sales, Purchase, G/L, Inventory)
         ↓ depends on
Layer 2: System Application (infrastructure - auth, telemetry, etc.)
         ↓ depends on
Layer 1: Platform (AL runtime, SQL, Azure services)
```

**Extension Rule:** Extensions can depend on lower layers, never higher
**Example:** Your extension can use Base App (Sales) but not Shopify extension

---

## 🎨 Common Extension Patterns

### Pattern 1: Validate Before Posting
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post",
    'OnBeforePostSalesDoc', '', false, false)]
local procedure ValidateCustomFields(var SalesHeader: Record "Sales Header")
begin
    // Add custom validation
    SalesHeader.TestField("Your Custom Field");
end;
```

### Pattern 2: Enrich Data After Posting
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post",
    'OnAfterPostSalesDoc', '', false, false)]
local procedure UpdateExternalSystem(var SalesHeader: Record "Sales Header")
begin
    // Send to external API, update custom tables, etc.
end;
```

### Pattern 3: Modify Calculation
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Line - Price Calc.",
    'OnAfterCalcLineAmount', '', false, false)]
local procedure AddCustomDiscount(var SalesLine: Record "Sales Line"; var LineAmount: Decimal)
begin
    // Apply custom pricing logic
    LineAmount := LineAmount * (1 - GetCustomDiscount(SalesLine));
end;
```

---

## 🚀 Performance-Critical Modules (Avoid Heavy Extensions)

| Module | Why Critical | Alternative Approach |
|--------|-------------|---------------------|
| G/L Entry | Millions of records | Use summary tables, batch processing |
| Item Ledger Entry | High-volume transactions | Index carefully, use filtered views |
| Value Entry | Accounting reconciliation | Read-only access preferred |
| Bank Account Ledger | Real-time bank feeds | Use staging tables |

**Rule:** If a table has "Entry" or "Ledger" in the name, optimize aggressively

---

## 📚 Documentation Navigation Matrix

| I need to... | Start here | Then check |
|-------------|-----------|-----------|
| Find an event for [process] | BC27_EVENT_INDEX.md (keyword search) | Specific event catalog |
| Understand module relationships | BC27_DEPENDENCY_REFERENCE.md | BC27_ARCHITECTURE.md |
| Choose modules for a feature | BC27_MODULES_BY_CATEGORY.md | BC27_MODULES_OVERVIEW.md |
| Extend a table/page | BC27_EXTENSION_POINTS.md | BC27_ARCHITECTURE.md |
| Integrate with external system | BC27_INTEGRATION_GUIDE.md | BC27_EVENTS_API.md |
| Learn BC27 architecture | BC27_ARCHITECTURE.md | BC27_MODULES_OVERVIEW.md |
| Get full feature list | BC27_FEATURES_INDEX.md | BC27_MODULES_BY_CATEGORY.md |

---

## 🔗 External Integration Summary

| Integration | Module | Auth Method | Use Case |
|-------------|--------|-------------|----------|
| Shopify | Shopify | OAuth 2.0 | E-commerce sync |
| Microsoft 365 | Email, OneDrive | Azure AD | Document mgmt, email |
| Power BI | Power BI | Service principal | Reporting, dashboards |
| Azure AI | Bank Rec AI, Copilot | Managed identity | ML features |
| Universal Print | Print Management | Azure AD | Cloud printing |
| Dataverse | CRM Integration | OAuth 2.0 | Dynamics 365 sync |

**Details:** See [BC27_INTEGRATION_GUIDE.md](./BC27_INTEGRATION_GUIDE.md)

---

## 💡 LLM Usage Tips

### Token Optimization
1. **Start here** for quick answers (500 lines vs. 11,000+ in full docs)
2. **Load specific files** only when needed (see navigation matrix)
3. **Use keyword search** in BC27_EVENT_INDEX.md before reading full catalogs
4. **Cache frequently used** files (EVENT_CATALOG, ARCHITECTURE)

### Context Loading Strategy
```
Query Type                → Load These Files
────────────────────────────────────────────────────
"Find event for X"       → BC27_LLM_QUICKREF.md + BC27_EVENT_INDEX.md
"Extend table X"         → BC27_LLM_QUICKREF.md + BC27_EXTENSION_POINTS.md
"Architecture question"  → BC27_LLM_QUICKREF.md + BC27_ARCHITECTURE.md
"Which modules for X?"   → BC27_LLM_QUICKREF.md + BC27_MODULES_BY_CATEGORY.md
```

### Update Triggers
Regenerate this file when:
- New BC27 version released
- Event catalogs updated
- Module structure changes
- New integration points added

---

**Version:** 1.0
**BC Version:** 27
**Token Count:** ~450 lines (optimized for <2000 tokens)
**Last Updated:** 2025-11-08
**Maintenance:** Sync with BC27_INDEX_README.md changes
