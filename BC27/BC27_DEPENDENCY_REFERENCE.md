# BC27 - Module Dependency Reference

Complete dependency mapping between all 73 BC27 modules. Use this guide to understand which modules depend on which, and plan feature combinations.

---

## Dependency Legend

- **→** Direct dependency (required)
- **⤳** Optional dependency (enhanced functionality)
- **≈** Loosely coupled (via events)

---

## Core Foundation Dependencies

```
System Application
    (Foundation layer - no dependencies)

Application
    → System Application
    → BaseApp

BaseApp
    → System Application
    → Application

BusinessFoundation
    → BaseApp
```

**Key Point**: Everything depends on BaseApp. System Application is the absolute foundation.

---

## Module Dependency Tree

### Level 1: Must Have (Foundation)
```
System Application (no dependencies)
```

### Level 2: Always Installed
```
BaseApp
    ← depends on: System Application

Application
    ← depends on: System Application, BaseApp

BusinessFoundation
    ← depends on: BaseApp
```

### Level 3: Core Extensions (2 Major Domain Modules)
```
Manufacturing
    ← depends on: BaseApp, BusinessFoundation

ServiceManagement
    ← depends on: BaseApp, BusinessFoundation
```

### Level 4: Functional Extensions (58 Modules)
All functional extensions depend on one or more of:
- System Application
- BaseApp
- BusinessFoundation
- Sometimes on each other

---

## Dependency Groups

### Group A: Pure BaseApp Dependencies
These modules ONLY depend on BaseApp (simplest):

1. **Simple Financial**: ReviewGLEntries, APIReportsFinance
2. **Simple Banking**: SimplifiedBankStatementImport, BankDeposits, PayPalPaymentsStandard
3. **Simple Data**: DataSearch
4. **Simple Reporting**: ExcelReports, ReportLayouts
5. **Simple Admin**: RecommendedApps

**Total**: ~13 modules
**Complexity**: Low
**Stability**: High (few dependencies to break things)

---

### Group B: BaseApp + One Extension
These modules depend on BaseApp and one other module:

1. **StatisticalAccounts + Dependencies**:
   - StatisticalAccounts → BaseApp
   - ESGStatisticalAccountsDemoTool → BaseApp, StatisticalAccounts
   - Sustainability → BaseApp, StatisticalAccounts

2. **Intrastat + Localization**:
   - Intrastat → BaseApp
   - IntrastatBE → Intrastat
   - (EU3PartyTradePurchase → BaseApp, similar pattern)

3. **E-Documents + Connectors**:
   - EDocument Core → BaseApp
   - EDocumentConnectors → EDocument Core
   - EnforcedDigitalVouchers → BaseApp, EDocument Core

4. **Subscription + Features**:
   - SubscriptionBilling → BaseApp
   - PaymentPractices → BaseApp (standalone)

**Pattern**: Base extension → Localization/Enhancement

---

### Group C: Multiple Dependencies
These modules depend on several other modules:

1. **Sustainability Ecosystem**:
   ```
   Sustainability
       ← BaseApp
       ← StatisticalAccounts
       ← BusinessFoundation

   SustainabilityCopilotSuggestion
       ← Sustainability

   SustainabilityContosoCoffeeDemoDataset
       ← Sustainability
       ← ContosoCoffeeDemoDataset
   ```

2. **Banking Ecosystem**:
   ```
   AMCBanking365Fundamentals
       ← BaseApp

   BankAccRecWithAI
       ← BaseApp
       ← AMCBanking365Fundamentals (optional)
   ```

3. **Manufacturing Ecosystem**:
   ```
   Manufacturing
       ← BaseApp
       ← BusinessFoundation

   SalesAndInventoryForecast
       ← BaseApp
       ← (optionally Manufacturing for MRP)
   ```

4. **API Ecosystem**:
   ```
   APIV1
       ← BaseApp

   APIV2
       ← BaseApp
       ← APIV1 (evolution)
   ```

5. **Email Ecosystem**:
   ```
   Email - Microsoft 365 Connector
       ← BaseApp

   EmailLogging
       ← BaseApp
       ← Email - Microsoft 365 Connector (optional)

   Send To Email Printer
       ← BaseApp
   ```

---

## Feature Combination Dependencies

### Financial Suite
```
Required:
  - BaseApp
  - BusinessFoundation

Recommended:
  - ReviewGLEntries
  - API Reports - Finance

Optional:
  - DataCorrectionFA (if FA issues)
  - StatisticalAccounts (for metrics)
  - AuditFileExport (for compliance)
  - VATGroupManagement (if multi-company)
```

### Manufacturing Suite
```
Required:
  - Manufacturing

Recommended:
  - SalesAndInventoryForecast

Optional:
  - Shopify (if B2C)
  - Subscription Billing (service contracts)
```

### Service Management Suite
```
Required:
  - ServiceManagement

Recommended:
  - FieldServiceIntegration
  - Subscription Billing

Optional:
  - Email connectors (for notifications)
```

### E-Commerce Suite
```
Recommended:
  - Shopify
  - SalesLinesSuggestions
  - SalesAndInventoryForecast

Optional:
  - PayPalPaymentsStandard
  - WorldPayPaymentsStandard
```

### Cloud Integration Suite
```
Choose Email Connector:
  - Email - Microsoft 365 Connector (M365) OR
  - Email - SMTP Connector (Traditional)

Choose File Storage:
  - Azure Blob/Files (Azure) OR
  - SharePoint Connector (M365) OR
  - None (embedded storage only)

Optional:
  - FieldServiceIntegration
  - ExternalEvents
  - Shopify
```

### Sustainability Suite
```
Required:
  - Sustainability

Recommended:
  - SustainabilityCopilotSuggestion
  - StatisticalAccounts

Optional:
  - SustainabilityContosoCoffeeDemoDataset (training)
```

### Compliance & Regulatory Suite
```
Choose based on operating regions:
  - Intrastat (EU companies)
  - IntrastatBE (Belgium)
  - EU3PartyTradePurchase (3-party trades)
  - ServiceDeclaration (Service trades)
  - AuditFileExport (Tax audits)
  - EnforcedDigitalVouchers (FR/DE)
  - VATGroupManagement (Group VAT)
```

### Analytics Suite
```
Choose Analytics:
  - PowerBIReports (Power BI) AND/OR
  - ExcelReports (Excel)

Recommended:
  - ReportLayouts (custom layouts)
  - DataArchive (performance)
```

### API Integration Suite
```
Required:
  - APIV1 OR APIV2 (choose one or both)

Recommended:
  - ExternalEvents (webhooks)

Optional by Integration:
  - FieldServiceIntegration
  - Shopify
  - Email connectors
```

---

## Circular Dependency Check

✅ **Good News**: BC27 has NO circular dependencies

This means:
- All modules can be independently uninstalled
- No deadlock scenarios
- Upgrade path is always possible
- Clear dependency hierarchy maintained

---

## Dependency Matrix

| Module | Depends On | Category | Complexity |
|--------|-----------|----------|-----------|
| System Application | - | Foundation | Low |
| BaseApp | System App | Foundation | Low |
| Application | System App, BaseApp | Foundation | Low |
| BusinessFoundation | BaseApp | Foundation | Low |
| Manufacturing | BaseApp, Business Found | Core Domain | High |
| ServiceManagement | BaseApp, Business Found | Core Domain | Medium |
| ReviewGLEntries | BaseApp | Financial | Low |
| APIReportsFinance | BaseApp | API | Low |
| DataCorrectionFA | BaseApp | Finance | Medium |
| StatisticalAccounts | BaseApp | Finance | Medium |
| ESGStatAcctsDemoTool | BaseApp, StatAccts | Demo | Low |
| AMCBanking365 | BaseApp | Banking | High |
| BankAccRecWithAI | BaseApp | Banking | Medium |
| BankDeposits | BaseApp | Banking | Low |
| SimplifiedBankImport | BaseApp | Banking | Low |
| PayPalPayments | BaseApp | Payments | Low |
| WorldPayPayments | BaseApp | Payments | Low |
| SalesLinesSuggestions | BaseApp | Sales AI | Medium |
| SalesInventoryFcast | BaseApp | Sales AI | High |
| SalesLinesSuggestions | BaseApp | Sales | Medium |
| DataArchive | BaseApp | Data Mgmt | Medium |
| DataSearch | BaseApp | Data Mgmt | Low |
| MasterDataManagement | BaseApp | Data Mgmt | High |
| EmailLogging | BaseApp | Email | Low |
| EmailM365Connector | BaseApp | Email | Low |
| EmailOutlookREST | BaseApp | Email | Low |
| EmailSMTPConnector | BaseApp | Email | Low |
| EmailSMTPAPI | BaseApp | Email | Low |
| EmailCurrentUser | BaseApp | Email | Low |
| SendToEmailPrinter | BaseApp | Email | Low |
| EDocumentCore | BaseApp | Documents | Medium |
| EDocumentConnectors | EDocument Core | Documents | High |
| EnforcedDigitalVouchers | BaseApp, E-Docs | Compliance | Low |
| AuditFileExport | BaseApp | Compliance | Medium |
| Intrastat | BaseApp | Compliance | Medium |
| IntrastatBE | Intrastat | Compliance | Low |
| EU3PartyTradePurchase | BaseApp | Compliance | High |
| ServiceDeclaration | BaseApp | Compliance | Low |
| AzureBlobConnector | BaseApp | Cloud | Low |
| AzureFileConnector | BaseApp | Cloud | Low |
| SharePointConnector | BaseApp | Cloud | Low |
| UniversalPrint | BaseApp | Cloud | Low |
| SubscriptionBilling | BaseApp | Billing | Medium |
| PaymentPractices | BaseApp | Compliance | Low |
| PowerBIReports | BaseApp | Analytics | Medium |
| ExcelReports | BaseApp | Analytics | Low |
| ReportLayouts | BaseApp | Analytics | Low |
| ContosoCoffeeDemoDataset | BaseApp | Demo | Low |
| ContosoCoffeeDemoDatasetBE | Contoso Coffee | Demo | Low |
| SustainabilityCoffeDemo | Contoso Coffee, Sustain | Demo | Low |
| PlanConfiguration | System App | Admin | Low |
| RecommendedApps | BaseApp | Admin | Low |
| CompanyHub | BaseApp | Admin | Low |
| ClientAddIns | BaseApp | Admin | Low |
| OnpremPermissions | System App | Admin | Low |
| Sustainability | BaseApp, StatAccts | Domain | High |
| SustainabilityCopilot | Sustainability | AI | Medium |
| Shopify | BaseApp | Integration | High |
| LatePaymentPredictor | BaseApp | AI | Medium |
| ErrorMessagesRecmn | System App | AI | Low |
| EssentialBusinessHeadlines | BaseApp | AI | Medium |
| CreateProductCopilot | BaseApp | AI | Medium |
| VATGroupManagement | BaseApp | Compliance | High |
| testframework | - | Infrastructure | Low |
| scripts | - | Infrastructure | Low |
| .github/workflows | - | Infrastructure | Low |

---

## Conditional Dependencies

Some modules have **optional** dependencies that enhance functionality:

### BankAccRecWithAI
- **Requires**: BaseApp
- **Enhanced By**: AMCBanking365 (optional, for advanced bank formats)

### SalesAndInventoryForecast
- **Requires**: BaseApp
- **Enhanced By**: Manufacturing (optional, for MRP integration)

### FieldServiceIntegration
- **Requires**: BaseApp
- **Enhanced By**: ServiceManagement (optional, for service integration)

### Sustainability
- **Requires**: BaseApp, StatisticalAccounts
- **Enhanced By**: SustainabilityCopilotSuggestion, Manufacturing

### EmailLogging
- **Requires**: BaseApp
- **Enhanced By**: Any Email Connector

---

## Safe Combination Scenarios

### Scenario 1: Small Business (no manufacturing)
```
Core:
  - BaseApp, System Application, Application, BusinessFoundation

Financial:
  - ReviewGLEntries

Banking:
  - SimplifiedBankStatementImport OR BankAccRecWithAI

Email:
  - Email - Microsoft 365 Connector OR Email - SMTP Connector

Reporting:
  - ExcelReports

Total Dependencies: Minimal, all clear, safe to upgrade
```

### Scenario 2: Manufacturing Company
```
Core:
  - BaseApp, System Application, Application, BusinessFoundation

Manufacturing:
  - Manufacturing (depends on BaseApp, BusinessFoundation)
  - SalesAndInventoryForecast

Reporting:
  - PowerBIReports
  - ReportLayouts

Analytics:
  - DataArchive (for performance)

Banking:
  - BankAccRecWithAI

Email:
  - Email - M365 Connector

Cloud:
  - SharePoint Connector

Total Dependencies: Clear hierarchy, Manufacturing → BaseApp only
```

### Scenario 3: Enterprise (all features)
```
All Core + BusinessFoundation (required)

All Domains:
  - Manufacturing
  - ServiceManagement

All Extensions (69 modules)

Total Dependencies: Complex but well-defined
Upgrade Path: Still clear (no circular dependencies)
```

---

## Dependency Chain Examples

### Chain 1: E-Document to Tax Authority
```
User creates Sales Invoice
  → triggers posting
  → creates G/L Entry (BaseApp)
  → EDocument Core hooks into event
  → generates E-Document record
  → EDocumentConnectors submits to provider
  → tax authority receives e-invoice
```

**Dependencies**: BaseApp → EDocument Core → EDocumentConnectors
**Chain Length**: 3 levels
**Stability**: High (linear chain, no branching)

### Chain 2: Inventory to Forecasting to Manufacturing
```
Item Posted to Inventory
  → triggers event (BaseApp)
  → SalesAndInventoryForecast updates forecast
  → Manufacturing module reads forecast
  → creates MRP suggestions
  → suggests Production Orders
```

**Dependencies**: BaseApp → SalesAndInventoryForecast → Manufacturing
**Chain Length**: 3 levels
**Stability**: High (linear through events)

### Chain 3: Sustainability Reporting
```
Purchase of Electricity
  → Sustainability journals entry
  → Copilot suggests emission factor
  → calculates CO2 emissions
  → updates Statistical Accounts
  → ESG Report generated
```

**Dependencies**: BaseApp → Sustainability → SustainabilityCopilot → StatAccounts
**Chain Length**: 4 levels
**Stability**: High (functional chain)

---

## Avoiding Dependency Issues

### ✅ Best Practices

1. **Understand the core**: BaseApp must be stable
2. **Follow the hierarchy**: Extend don't replace
3. **Use events**: Don't hard-code module references
4. **Document dependencies**: When adding custom code
5. **Test combinations**: Before deploying multi-module changes

### ❌ Common Mistakes

1. **Circular references**: Don't create feedback loops
2. **Modifying core**: Don't change BaseApp tables directly
3. **Hard-coded dependencies**: Use events instead
4. **Undocumented links**: Always document between modules
5. **Skipping foundation**: Never skip required dependencies

---

## Upgrade Impact Analysis

### Low Impact Upgrades (most modules)
```
When upgrading a module:
  - Only affects modules depending on it
  - Example: Intrastat → IntrastatBE still works
  - Modules can be independently tested
```

### High Impact Upgrades (core changes)
```
When upgrading BaseApp:
  - Affects ALL modules
  - Requires comprehensive testing
  - May need dependent module updates
```

### Safe Upgrade Order
1. System Application
2. BaseApp + Application
3. BusinessFoundation
4. Manufacturing/ServiceManagement (if used)
5. All other extensions (order independent)

---

## Dependency Statistics

| Metric | Count |
|--------|-------|
| Modules depending only on BaseApp | ~13 |
| Modules with 1-2 dependencies | ~45 |
| Modules with 3+ dependencies | ~8 |
| Modules with 0 dependencies | 1 (System App) |
| **Circular dependencies** | **0 (✓ None)** |
| Max dependency chain length | 4 levels |

---

## Quick Dependency Lookup

### Looking for all modules dependent on BaseApp?
**Answer**: All 69 extension modules eventually depend on BaseApp (directly or indirectly)

### Looking for modules that depend on Manufacturing?
**Answer**:
- SalesAndInventoryForecast (optional)
- Custom extensions if created

### Looking for modules that depend on Sustainability?
**Answer**:
- SustainabilityCopilotSuggestion
- SustainabilityContosoCoffeeDemoDataset
- Custom extensions if created

### Looking for modules independent of each other?
**Answer**: Most modules can be independently installed/uninstalled because:
- No circular dependencies
- Events decouple modules
- Clear layering prevents tight coupling

---

## Summary

**Key Principle**: BC27 follows a **strict hierarchical dependency model**:

```
System Application (base)
  ↓
BaseApp (core)
  ↓
BusinessFoundation (shared logic)
  ↓
69 Extensions (specialized features)
```

**Benefits**:
- ✅ Clean upgrade path
- ✅ No circular dependencies
- ✅ Independent module testing
- ✅ Easy to add/remove features
- ✅ Stable core, extensible platform

**Managing Dependencies**:
- Always understand what depends on your changes
- Use events instead of hard references
- Test dependency chains before deployment
- Document custom dependencies clearly

---

**Document Version**: 1.0
**BC Version**: 27
**Last Updated**: 2025-11-07

