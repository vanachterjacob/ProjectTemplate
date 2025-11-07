# BC27 - System Architecture & Design

Complete architectural reference for Business Central version 27, including layering, design patterns, extension model, and development considerations.

---

## System Layering

BC27 follows a **clean layered architecture** with minimal core and extensive extension-based functionality:

```
┌─────────────────────────────────────────────────────────────┐
│                    69 BUSINESS EXTENSIONS                   │
│  (Finance, Manufacturing, Sales, Services, AI/ML, APIs)     │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────┐
│            BUSINESS FOUNDATION & UTILITIES                  │
│  (Shared business logic, common patterns, helpers)          │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────┐
│                    BASE APP (Core ERP)                      │
│     (Customer, Vendor, Item, G/L, Sales, Purchase,          │
│      Inventory, Manufacturing basics, Reports)              │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────┐
│  APPLICATION (Metadata, Localization, Translations)         │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────┐
│      SYSTEM APPLICATION (Infrastructure & Utilities)        │
│  (Permissions, Events, Error Handling, Telemetry)           │
└─────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

#### System Application (Foundation)
- **Role**: System-level infrastructure
- **Provides**: Permission framework, event pub/sub, telemetry, error handling
- **Dependencies**: None
- **Scope**: Never modified for customization
- **Stability**: Highest - core system stability

#### Application (Localization)
- **Role**: Application-level settings and translations
- **Provides**: Multi-language support, cultural settings
- **Dependencies**: System Application, BaseApp
- **Components**: Translations folder (30+ languages)
- **Localization**: Supports 30+ countries/languages

#### BaseApp (Core ERP)
- **Role**: Foundation business functionality
- **Provides**: Master data, core transactions, basic workflows
- **Key Tables**:
  - Customer, Vendor, Item, G/L Account
  - Sales Header/Line, Purchase Header/Line
  - Bank Account, Inventory, Warehouse
  - Dimensions, Cost Accounting
- **Dependencies**: System Application, Application
- **Scope**: Limited to essential ERP functionality
- **Stability**: High - core ERP data model

#### BusinessFoundation (Shared Logic)
- **Role**: Common business logic patterns
- **Provides**: Shared codeunits, common utilities, calculation routines
- **Purpose**: Reduce code duplication across extensions
- **Dependencies**: BaseApp
- **Users**: Financial, Sales, Manufacturing extensions
- **Examples**:
  - Discount calculation routines
  - Tax calculation patterns
  - Common posting logic
  - Standard conversions

#### Business Extensions (69 modules)
- **Role**: Specialized functionality
- **Provides**: Feature-specific tables, pages, logic
- **Independence**: Can be installed/uninstalled
- **Dependencies**: BaseApp minimum, may depend on other extensions
- **Examples**: Manufacturing, Service Management, Subscriptions, APIs, Integrations
- **Key Principle**: Don't modify core tables, extend via extension points

---

## Architectural Principles

### 1. Extension-Based Architecture
All business functionality beyond core ERP is built as extensions:
- **Advantage**: Clean separation of concerns
- **Advantage**: Extensions can be independently updated
- **Advantage**: Easy to remove unused features
- **Pattern**: Extensions extend tables, pages, and logic via hooks and events

### 2. Event-Driven Architecture
- **Pattern**: Publish/Subscribe model throughout
- **Framework**: System Application provides event infrastructure
- **Usage**: Extensions subscribe to core events without modifying core code
- **Examples**: OnBeforeInsert, OnAfterPost, OnBeforeCalculate
- **Benefit**: Decoupling between modules

### 3. Hook-Based Extensibility
- **Mechanism**: Events, table extensions, page extensions
- **Pattern**: Core raises events at key points
- **Extensions**: Hook into these events without modifying core
- **No Core Modifications**: Pure extension-based approach

### 4. Minimal Core Philosophy
- **BaseApp**: ~700 tables, only essential tables
- **All Specialized**: Manufacturing, Service, Subscriptions, etc. are extensions
- **Customization**: Extend don't modify
- **Upgradability**: Easier upgrades with minimal core modifications

### 5. Modular Independence
- **Goal**: Modules should be independently functional
- **Pattern**: Clear dependency arrows (downward only)
- **Isolation**: Minimize cross-extension dependencies
- **Testability**: Each module independently testable

---

## Core Dependency Model

### Strict Dependency Rules

```
System Application
        ↓
        ├─→ Application
        │   ├─→ BaseApp
        │       ├─→ BusinessFoundation
        │           ├─→ Manufacturing
        │           ├─→ Service Management
        │           ├─→ Subscription Billing
        │           ├─→ Financial modules
        │           └─→ All 69 extensions...
```

### Dependency Constraints

**Valid Dependencies** (allowed):
- ✅ Extension → BaseApp
- ✅ Extension → System Application
- ✅ Extension → BusinessFoundation
- ✅ Extension → Another specific extension (if documented)

**Invalid Dependencies** (prohibited):
- ❌ BaseApp → Extension (core doesn't depend on extensions)
- ❌ System Application → Any other module
- ❌ Circular dependencies between extensions
- ❌ Undocumented cross-extension dependencies

### Purpose of Constraints

1. **Upgradeability**: Core can be upgraded without breaking extensions
2. **Independence**: Extensions don't block core updates
3. **Clarity**: Clear ownership and responsibility
4. **Testability**: Can test modules independently

---

## Module Categories & Typical Dependencies

### Category 1: Core (No Optional Dependencies)
```
System Application
        ↓
    BaseApp
        ↓
BusinessFoundation
```

### Category 2: Functional Extensions (BaseApp → Extension)
```
BaseApp
  ├─→ Manufacturing (depends on Item, BOM, Routing)
  ├─→ Service Management (depends on Resource, Item, Customer)
  ├─→ Subscription Billing (depends on Sales Order)
  └─→ Financial modules (depend on G/L, AR/AP)
```

### Category 3: Integration Extensions (BaseApp → Integration)
```
BaseApp
  ├─→ Shopify (depends on Item, Customer, Sales Order)
  ├─→ Field Service Integration (depends on Service modules)
  ├─→ Email connectors (depend on mail infrastructure)
  └─→ Payment gateways (depend on Sales/Purchase)
```

### Category 4: API Extensions (BaseApp → API)
```
BaseApp
  ├─→ APIV1
  └─→ APIV2 (may depend on APIV1)
```

### Category 5: Compliance Extensions (BaseApp → Compliance)
```
BaseApp
  ├─→ Intrastat
  │   └─→ IntrastatBE (depends on Intrastat)
  ├─→ VAT Group Management
  ├─→ EDocument Core
  │   └─→ EDocumentConnectors (depends on EDocument Core)
  └─→ Audit File Export
```

---

## Design Patterns

### Pattern 1: Extension Table Pattern
```AL
// BaseApp defines base table
table 18 Customer
{
    // Core fields only
}

// Extension adds fields without modifying base
tableextension 77100 "ABC Customer" extends Customer
{
    fields
    {
        field(77100; "ABC Credit Limit"; Decimal) { }
        field(77101; "ABC Risk Category"; Code[10]) { }
    }
}
```

**Purpose**: Extend master tables with custom fields
**Benefit**: Separate layer of customization, clear ownership
**Pattern Used**: Throughout all extensions

### Pattern 2: Page Extension Pattern
```AL
// BaseApp provides base page
page 21 "Customer Card"
{
    // Core fields and actions
}

// Extension adds fields/actions
pageextension 77100 "ABC Customer Card" extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field("ABC Risk Category"; Rec."ABC Risk Category") { }
        }
    }
}
```

**Purpose**: Extend UI without modifying core pages
**Benefit**: Non-breaking changes to page structure
**Pattern Used**: Standard for all UI extensions

### Pattern 3: Event Hook Pattern
```AL
// BaseApp raises event
codeunit 80 "Sales-Post"
{
    [IntegrationEvent(false, false)]
    local procedure OnBeforePostSalesDoc(...)
    begin
    end;
}

// Extension subscribes to event
codeunit 77101 "ABC Sales Subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post",
                     'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforeSalesPost(...)
    begin
        // Custom logic here
    end;
}
```

**Purpose**: Hook into core logic without modifying core
**Benefit**: Clean separation, multiple subscribers possible
**Pattern Used**: Event-driven architecture throughout

### Pattern 4: Localization Extension Pattern
```
Intrastat (W1 - Worldwide)
    └─→ IntrastatBE (BE - Belgium specific)
    └─→ IntrastatDE (DE - Germany specific)
    └─→ IntrastatFR (FR - France specific)
```

**Purpose**: Country-specific compliance built on base functionality
**Benefit**: Shared core logic, country-specific rules
**Pattern Used**: Compliance and localization modules

### Pattern 5: Integration Connector Pattern
```AL
// Connector provides base interface
codeunit 77200 "ABC Email Connector"
{
    procedure SendEmail(...): Boolean
    begin
        // Connector-specific implementation
    end;
}

// External system calls connector
codeunit 77100 "ABC Integration"
{
    procedure NotifyPartner(...)
    begin
        ABCEmailConnector.SendEmail(...);
    end;
}
```

**Purpose**: Isolate external system integration
**Benefit**: Easy to swap connectors, clear responsibility
**Pattern Used**: Payment, email, cloud integrations

---

## Table Ownership Model

### BaseApp Core Tables (Never Extended)
```
Customer (18)
Vendor (23)
Item (27)
General Ledger Entry (17)
Customer Ledger Entry (21)
Vendor Ledger Entry (25)
Item Ledger Entry (32)
```

**Rule**: These tables are extended, not modified
**Pattern**: All customization via table extensions
**Reason**: Core data integrity, upgrade stability

### Extension-Owned Tables
```
Manufacturing tables (owned by Manufacturing extension)
Service Order (owned by Service Management)
Subscription tables (owned by Subscription Billing)
```

**Rule**: Extensions create new tables for feature-specific data
**Pattern**: Clear ownership, one extension per domain
**Benefit**: Feature isolation, independent lifecycle

### Shared Tables
```
Statistical Accounts (multiple extensions use)
External Events (integration base)
```

**Rule**: Well-defined contract, clear usage documentation
**Pattern**: Shared infrastructure, read/write rules documented
**Benefit**: Reuse across multiple extensions

---

## Data Model Characteristics

### Master Data Hierarchy
```
Company
  ├─→ Dimensions
  ├─→ Chart of Accounts
  ├─→ Customers
  │   └─→ Customer Ledger Entries
  ├─→ Vendors
  │   └─→ Vendor Ledger Entries
  ├─→ Items
  │   ├─→ Item Ledger Entries
  │   ├─→ SKU (Stock Keeping Unit)
  │   └─→ Bill of Materials (Manufacturing)
  ├─→ Resources (Service/Manufacturing)
  └─→ Locations (Warehouse)
```

### Transaction Hierarchy
```
Order Header
  ├─→ Order Line (detail)
  ├─→ Shipment Header (fulfillment)
  ├─→ Shipment Line (fulfillment detail)
  └─→ Posted Document (archive)

Posted Document
  ├─→ G/L Entry (financial impact)
  ├─→ Customer/Vendor Ledger Entry (AR/AP impact)
  ├─→ Item Ledger Entry (inventory impact)
  └─→ Value Entry (costing impact)
```

### Posting Logic Pattern
```
Input Document (Sales Order)
    ↓
Validation (Check permissions, balances, etc.)
    ↓
Calculation (Amounts, taxes, discounts)
    ↓
Event: OnBeforePost (Extensions hook here)
    ↓
Create Posted Records (Posted Sales Invoice)
    ↓
Create Ledger Entries (G/L, Customer, Item, Value)
    ↓
Event: OnAfterPost (Extensions hook here)
    ↓
Archive or Delete Original
```

---

## Extensibility Points

### Table Extensibility
- **Table Extensions**: Add fields and keys
- **Range**: Each extension has own 77000-77100 range (example ABC)
- **Keys**: Can add secondary keys for performance
- **Example**: `tableextension 77100 "ABC Customer"`

### Page Extensibility
- **Page Extensions**: Add fields, actions, groups
- **addafter/addbefore**: Insert into existing layout
- **modify**: Change existing element properties
- **actions**: Add new actions and groups
- **Example**: `pageextension 77100 "ABC Customer Card"`

### Event Extensibility
- **Integration Events**: Raised by core at key points
- **Subscriber Model**: Multiple extensions can subscribe
- **No Modification**: Core code not modified
- **Examples**: OnBeforeInsert, OnAfterPost, OnBeforeValidate

### Code Extensibility
- **Codeunits**: Can define new codeunits
- **Table Trigger Subscribers**: Subscribe to insert/modify/delete
- **Page Events**: Form load, record change, action click
- **Posting Events**: Pre/post posting hooks

### Business Logic Extensibility
- **Calculation Events**: Before/after calculations
- **Validation Events**: Custom validation rules
- **Workflow Events**: State transition hooks
- **Approval Events**: Custom approval workflows

---

## Cross-Module Communication

### Event-Based Communication
**Pattern**: Module A raises event → Module B subscribes

```
Module A (Core):
  [IntegrationEvent(false, false)]
  OnBeforeCalculateTax(...)

Module B (Extension):
  [EventSubscriber(...)]
  local procedure UpdateTaxInABC(...)
```

**Benefit**: Loose coupling, no direct dependency
**Frequency**: Most common communication pattern

### Direct Dependency Communication
**Pattern**: Module B explicitly depends on Module A

```
Module B code:
  TaxCalculationMgt.CalculateTax(...)
```

**When Used**: When strong contract needed
**Documented**: Clear dependency documented
**Example**: Sustainability module depends on Statistical Accounts

### API Communication
**Pattern**: External system calls BC API

```
External System → API v2.0 → BC data
```

**Used By**: Shopify, Field Service, Third-party systems
**Exposed**: REST API with OData protocol

---

## Performance Architectural Patterns

### Query Optimization
```
Pattern: Use SetLoadFields for read-only operations
  Rec.SetLoadFields(Name, Address);  // Load only needed fields
  Rec.FindSet(false, false);         // Read-only iteration

Pattern: Avoid full-table scans
  Rec.SetRange(Blocked, false);  // Filter first
  Rec.FindSet();                 // Then iterate

Pattern: Use temporary records
  TempRec.DeleteAll();           // Use temp table for processing
  TempRec.Insert();              // Avoid posting to real table
```

### Data Archive Pattern
```
Production Year 2020
  ├─→ Keep in DataArchive
  ├─→ Remove from G/L Entry (transactional)
  └─→ Reports still show via archive tables
```

**Benefit**: Database performance improvement
**Trade-off**: Archived data read-only

### Batch Processing Pattern
```
Process 10,000 records
  ├─→ Loop in batches of 100
  ├─→ Commit each batch
  └─→ Allow user cancellation between batches
```

**Benefit**: Memory efficiency, user control
**Implementation**: JobQueue or Recurring Jobs

---

## Testing Architecture

### Test Framework Organization
```
Each module has dedicated test directory
Module/
  ├─→ Source/ (production code)
  └─→ Test/
      ├─→ Module Tests/ (unit tests)
      └─→ Library/ (test libraries)
```

### Test Patterns
```
Test Codeunit: Tests for specific functionality
  - SetUp(): Initialize test data
  - Test[Feature](): Test specific scenario
  - Verify(): Check results

Test Library: Reusable test utilities
  - CreateTestCustomer(): Helper to create test data
  - AssertEquals(): Custom assertion
  - MockExternalSystem(): Test double
```

### Test Coverage
- **Unit Tests**: Feature-level testing
- **Integration Tests**: Cross-module testing
- **Data Tests**: Data integrity validation
- **Upgrade Tests**: Post-upgrade validation

---

## Version Management

### Module Versioning
- **App.json**: Each extension defines version
- **Version Format**: Major.Minor.Patch (e.g., 27.0.0)
- **BC Version Alignment**: Extensions match BC version
- **Backward Compatibility**: Patch versions maintain compatibility

### Breaking Changes
- **Major Version**: Allowed breaking changes
- **Minor Version**: New features, no breaking changes
- **Patch Version**: Bug fixes only

### Upgrade Path
```
BC 26 Extensions
    ↓ (Compile & Publish)
BC 27 Extensions
    ↓ (Data migration if needed)
Running System
```

---

## Security Architecture

### Permission Model
- **Permission Sets**: Role-based access
- **Plan-Based**: SaaS uses licensing plans
- **Table Permissions**: Read, Insert, Modify, Delete per table
- **Field Permissions**: Field-level security for sensitive data
- **Page Permissions**: Page-level access control

### Authentication
- **SaaS**: Azure AD authentication
- **On-Prem**: Windows or Azure AD
- **API**: OAuth 2.0 for external integrations

### Data Protection
- **Field-Level Security**: Sensitive data masked
- **Encryption**: Data at rest and in transit
- **SecretText**: Sensitive values never logged
- **Audit Trail**: All changes logged and auditable

---

## Deployment Architecture

### SaaS Deployment
```
Microsoft Cloud
  ├─→ Tenant 1 (Company A)
  │   ├─→ Company A-1
  │   └─→ Company A-2
  ├─→ Tenant 2 (Company B)
  │   └─→ Company B-1
  └─→ Shared Infrastructure
      ├─→ System Application
      ├─→ BaseApp
      └─→ All Extensions
```

### Multi-Company
```
Single Tenant
  ├─→ Company 1
  │   ├─→ Master data (separate)
  │   └─→ Transactions (separate)
  └─→ Company 2
      ├─→ Master data (separate)
      └─→ Transactions (separate)
```

**Shared**: Configuration, users, extensions
**Separate**: Data per company

---

## Scalability Considerations

### Horizontal Scalability
- **Stateless Sessions**: Users can switch servers
- **Load Balancing**: Multiple application servers
- **Database Scale-Out**: Multiple database replicas for read

### Vertical Scalability
- **Archive Strategy**: Remove old data to reduce database size
- **Compression**: Transaction compression options
- **Indexing**: Strategic indexes on high-volume tables

### Performance Targets
- **Page Load**: <2 seconds typical
- **Posting**: <10 seconds for complex documents
- **Reports**: <30 seconds for large datasets
- **API**: <1 second typical response

---

## Summary: Design Principles

| Principle | Implementation | Benefit |
|-----------|----------------|---------|
| **Minimal Core** | BaseApp only essential | Upgrade stability |
| **Extension-Based** | 69 modules as extensions | Feature independence |
| **Event-Driven** | Pub/Sub throughout | Loose coupling |
| **Modular** | Clear dependencies | Easy customization |
| **Testable** | Each module independently tested | Quality assurance |
| **Upgradeable** | No core modifications | Smooth version updates |
| **Secure** | Permission model + encryption | Data protection |
| **Performant** | Query optimization patterns | Scalability |
| **Multi-Tenant** | SaaS-native architecture | Cloud deployment |

---

**Document Version**: 1.0
**BC Version**: 27
**Last Updated**: 2025-11-07

