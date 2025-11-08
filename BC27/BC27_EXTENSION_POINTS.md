# BC27 Extension Points - Tables & Pages

Complete guide for extending Business Central 27 base tables and pages. This catalog helps you identify the best places to add custom fields, modify UI, and extend business logic.

**Version**: 1.0
**BC Version**: 27
**Last Updated**: 2025-11-08

---

## Table of Contents

1. [Extension Principles](#extension-principles)
2. [Sales & Customer Extensions](#sales--customer-extensions)
3. [Purchase & Vendor Extensions](#purchase--vendor-extensions)
4. [Inventory & Item Extensions](#inventory--item-extensions)
5. [Finance & G/L Extensions](#finance--gl-extensions)
6. [Master Data Extensions](#master-data-extensions)
7. [Page Extension Patterns](#page-extension-patterns)
8. [Field Placement Guidelines](#field-placement-guidelines)

---

## Extension Principles

### Core Rules

1. **Never modify base tables directly** - Always use table extensions
2. **Prefix custom fields** - Use your 3-letter prefix (e.g., `ABC Custom Field`)
3. **Use field IDs from your range** - Typically 50000-99999 for customer extensions
4. **Extend related pages** - When adding table fields, extend corresponding pages
5. **Follow BC naming conventions** - See [001-naming-conventions.mdc](../.cursor/rules/001-naming-conventions.mdc)

### Table Extension Template

```al
tableextension 77100 "ABC Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(77100; "ABC External Order No."; Code[20])
        {
            Caption = 'External Order No.';
            DataClassification = CustomerContent;
        }

        field(77101; "ABC Priority Level"; Option)
        {
            Caption = 'Priority Level';
            OptionMembers = Normal,High,Urgent;
            OptionCaption = 'Normal,High,Urgent';
            DataClassification = CustomerContent;
        }
    }

    // Optional: Add custom procedures
    procedure ABCValidateExternalOrder()
    begin
        // Custom logic here
    end;
}
```

### Page Extension Template

```al
pageextension 77100 "ABC Sales Order Ext" extends "Sales Order"
{
    layout
    {
        addafter("External Document No.")
        {
            field("ABC External Order No."; Rec."ABC External Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the external order number from the customer system';
            }
        }

        addfirst(General)
        {
            field("ABC Priority Level"; Rec."ABC Priority Level")
            {
                ApplicationArea = All;
                Importance = Promoted;
            }
        }
    }

    actions
    {
        addafter(Post)
        {
            action(ABCSendToExternalSystem)
            {
                ApplicationArea = All;
                Caption = 'Send to External System';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ABCIntegration: Codeunit "ABC Integration Mgmt";
                begin
                    ABCIntegration.SendSalesOrder(Rec);
                end;
            }
        }
    }
}
```

---

## Sales & Customer Extensions

### Sales Header (Table 36)

**Common Extension Scenarios**:
- External system references (order IDs, tracking numbers)
- Custom approval workflows (approval status, approver ID)
- Business-specific flags (priority, project codes)
- Integration timestamps (last sync, sync status)

**Recommended Field Locations**:

| Field Type | Insert Location | Page Location |
|------------|----------------|---------------|
| External References | After "External Document No." | General FastTab, after External Document No. |
| Status/Flags | After "Status" | General FastTab (promoted) |
| Dates | In "Dates" field group | Shipping and Billing FastTab |
| Amounts | After "Amount Including VAT" | General FastTab |

**Key Pages to Extend**:
- Page 42 "Sales Order" - Primary document entry
- Page 43 "Sales Invoice" - Invoice processing
- Page 9300 "Sales Order List" - Add fields to list view
- Page 9305 "Sales Invoice List" - Invoice list customization

**Example Extensions**:

```al
tableextension 77100 "ABC Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(77100; "ABC Project Code"; Code[20])
        {
            Caption = 'Project Code';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }

        field(77101; "ABC Approval Status"; Enum "ABC Approval Status")
        {
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(77102; "ABC Last Sync DateTime"; DateTime)
        {
            Caption = 'Last Sync Date/Time';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
}
```

**Source**: [SalesHeader.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Sales/Document/SalesHeader.Table.al)

### Sales Line (Table 37)

**Common Extension Scenarios**:
- Line-level attributes (custom dimensions, tags)
- Alternative measurements (secondary UOM, conversion factors)
- Extended pricing/discounts (tier pricing, promotional codes)
- Item attributes (color, size, custom specs)

**Recommended Field Locations**:

| Field Type | Insert Location | Page Location |
|------------|----------------|---------------|
| Item Attributes | After "Description 2" | Lines subfolder, visible on drill-down |
| Pricing | After "Line Discount %" | Lines subfolder |
| Quantities | After "Quantity" | Lines subfolder |
| Dimensions | Use Dimension Set ID | Not directly on lines |

**Key Pages to Extend**:
- Page 46 "Sales Order Subform" - Line entry (subpage)
- Page 47 "Sales Invoice Subform" - Invoice lines (subpage)

**Example Extensions**:

```al
tableextension 77101 "ABC Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(77100; "ABC Manufacturer Part No."; Code[30])
        {
            Caption = 'Manufacturer Part No.';
            DataClassification = CustomerContent;
        }

        field(77101; "ABC Requested Ship Date"; Date)
        {
            Caption = 'Requested Ship Date';
            DataClassification = CustomerContent;
        }

        field(77102; "ABC Commission %"; Decimal)
        {
            Caption = 'Commission %';
            DecimalPlaces = 0:5;
            MinValue = 0;
            MaxValue = 100;
            DataClassification = CustomerContent;
        }
    }
}
```

**Source**: [SalesLine.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Sales/Document/SalesLine.Table.al)

### Customer (Table 18)

**Common Extension Scenarios**:
- CRM integration fields (CRM ID, territory, account manager)
- Credit management (custom credit rules, risk scores)
- Customer classifications (VIP status, customer segments)
- External system mappings (legacy customer numbers)

**Recommended Field Locations**:

| Field Type | Insert Location | Page Location |
|------------|----------------|---------------|
| Contact Info | After "E-Mail" | General FastTab |
| Business Info | After "Customer Posting Group" | Invoicing FastTab |
| Classifications | Create custom field group | New FastTab (addafter) |
| Integration | Create custom field group | New FastTab (addlast) |

**Key Pages to Extend**:
- Page 21 "Customer Card" - Master data entry
- Page 22 "Customer List" - List view (add columns)
- Page 9301 "Customer Lookup" - Quick lookup fields

**Example Extensions**:

```al
tableextension 77102 "ABC Customer Ext" extends Customer
{
    fields
    {
        field(77100; "ABC CRM Account ID"; Code[20])
        {
            Caption = 'CRM Account ID';
            DataClassification = CustomerContent;
        }

        field(77101; "ABC VIP Customer"; Boolean)
        {
            Caption = 'VIP Customer';
            DataClassification = CustomerContent;
        }

        field(77102; "ABC Account Manager"; Code[20])
        {
            Caption = 'Account Manager';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = CustomerContent;
        }
    }
}

pageextension 77102 "ABC Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addafter(General)
        {
            group("ABC Custom Info")
            {
                Caption = 'Custom Information';

                field("ABC VIP Customer"; Rec."ABC VIP Customer")
                {
                    ApplicationArea = All;
                }
                field("ABC Account Manager"; Rec."ABC Account Manager")
                {
                    ApplicationArea = All;
                }
                field("ABC CRM Account ID"; Rec."ABC CRM Account ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
```

**Source**: [Customer.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Sales/Customer/Customer.Table.al)

---

## Purchase & Vendor Extensions

### Purchase Header (Table 38)

**Common Extension Scenarios**:
- Vendor order references (vendor PO number, quote reference)
- Approval workflows (approval levels, approver history)
- Budget tracking (budget code, budget remaining)
- Receiving instructions (dock door, contact person)

**Recommended Field Locations**:

| Field Type | Insert Location | Page Location |
|------------|----------------|---------------|
| Vendor References | After "Vendor Order No." | General FastTab |
| Approval Info | Create custom field group | New FastTab |
| Receiving | After "Ship-to" fields | Shipping and Payment FastTab |

**Key Pages to Extend**:
- Page 50 "Purchase Order" - Primary document
- Page 51 "Purchase Invoice" - Invoice entry
- Page 9307 "Purchase Order List" - List view

**Example Extensions**:

```al
tableextension 77103 "ABC Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        field(77100; "ABC Requisition No."; Code[20])
        {
            Caption = 'Requisition No.';
            DataClassification = CustomerContent;
        }

        field(77101; "ABC Budget Code"; Code[20])
        {
            Caption = 'Budget Code';
            TableRelation = "ABC Budget";
            DataClassification = CustomerContent;
        }

        field(77102; "ABC Receiving Contact"; Text[100])
        {
            Caption = 'Receiving Contact';
            DataClassification = CustomerContent;
        }
    }
}
```

**Source**: [PurchaseHeader.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Purchases/Document/PurchaseHeader.Table.al)

### Vendor (Table 23)

**Common Extension Scenarios**:
- Vendor performance metrics (on-time %, quality score)
- Procurement rules (preferred vendor, blocked reasons)
- Payment preferences (ACH details, payment portal)
- Certifications (ISO, minority-owned, sustainability)

**Key Pages to Extend**:
- Page 26 "Vendor Card" - Master data
- Page 27 "Vendor List" - List view

**Example Extensions**:

```al
tableextension 77104 "ABC Vendor Ext" extends Vendor
{
    fields
    {
        field(77100; "ABC Preferred Vendor"; Boolean)
        {
            Caption = 'Preferred Vendor';
            DataClassification = CustomerContent;
        }

        field(77101; "ABC On-Time Delivery %"; Decimal)
        {
            Caption = 'On-Time Delivery %';
            DecimalPlaces = 0:2;
            MinValue = 0;
            MaxValue = 100;
            DataClassification = CustomerContent;
            Editable = false; // Calculate via codeunit
        }

        field(77102; "ABC ISO Certified"; Boolean)
        {
            Caption = 'ISO Certified';
            DataClassification = CustomerContent;
        }
    }
}
```

**Source**: [Vendor.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Purchases/Vendor/Vendor.Table.al)

---

## Inventory & Item Extensions

### Item (Table 27)

**Common Extension Scenarios**:
- Extended item attributes (dimensions, weight, material)
- Supplier information (preferred vendor, lead times)
- Quality control (inspection required, shelf life)
- E-commerce data (web description, SEO keywords, images)

**Recommended Field Locations**:

| Field Type | Insert Location | Page Location |
|------------|----------------|---------------|
| Physical Attributes | After "Base Unit of Measure" | Item FastTab |
| Supplier Info | Create custom field group | Replenishment FastTab |
| Quality | Create custom field group | New FastTab |
| E-Commerce | Create custom field group | New FastTab |

**Key Pages to Extend**:
- Page 30 "Item Card" - Master data
- Page 31 "Item List" - List view
- Page 5701 "Item Card (Warehouse)" - Warehouse-specific view

**Example Extensions**:

```al
tableextension 77105 "ABC Item Ext" extends Item
{
    fields
    {
        field(77100; "ABC Manufacturer"; Text[100])
        {
            Caption = 'Manufacturer';
            DataClassification = CustomerContent;
        }

        field(77101; "ABC Hazardous Material"; Boolean)
        {
            Caption = 'Hazardous Material';
            DataClassification = CustomerContent;
        }

        field(77102; "ABC Shelf Life Days"; Integer)
        {
            Caption = 'Shelf Life (Days)';
            MinValue = 0;
            DataClassification = CustomerContent;
        }

        field(77103; "ABC Web Description"; Text[250])
        {
            Caption = 'Web Description';
            DataClassification = CustomerContent;
        }
    }
}

pageextension 77105 "ABC Item Card Ext" extends "Item Card"
{
    layout
    {
        addafter(Item)
        {
            group("ABC Extended Info")
            {
                Caption = 'Extended Information';

                field("ABC Manufacturer"; Rec."ABC Manufacturer")
                {
                    ApplicationArea = All;
                }
                field("ABC Hazardous Material"; Rec."ABC Hazardous Material")
                {
                    ApplicationArea = All;
                }
                field("ABC Shelf Life Days"; Rec."ABC Shelf Life Days")
                {
                    ApplicationArea = All;
                }
            }
        }

        addafter(Invoicing)
        {
            group("ABC E-Commerce")
            {
                Caption = 'E-Commerce';

                field("ABC Web Description"; Rec."ABC Web Description")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
        }
    }
}
```

**Source**: [Item.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Inventory/Item/Item.Table.al)

### Location (Table 14)

**Common Extension Scenarios**:
- Warehouse-specific rules (inspection required, cross-dock)
- Geographic data (GPS coordinates, time zone)
- Capacity information (storage capacity, throughput limits)
- External system mappings (WMS location code)

**Key Pages to Extend**:
- Page 5715 "Location Card" - Location setup

**Example Extensions**:

```al
tableextension 77106 "ABC Location Ext" extends Location
{
    fields
    {
        field(77100; "ABC WMS Location Code"; Code[20])
        {
            Caption = 'WMS Location Code';
            DataClassification = CustomerContent;
        }

        field(77101; "ABC GPS Coordinates"; Text[50])
        {
            Caption = 'GPS Coordinates';
            DataClassification = CustomerContent;
        }

        field(77102; "ABC Inspection Required"; Boolean)
        {
            Caption = 'Inspection Required';
            DataClassification = CustomerContent;
        }
    }
}
```

**Source**: [Location.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Inventory/Location/Location.Table.al)

---

## Finance & G/L Extensions

### G/L Account (Table 15)

**Common Extension Scenarios**:
- Budget tracking (budget owner, department)
- Account classifications (custom reporting categories)
- Consolidation mappings (parent account, consolidation code)
- Approval requirements (requires approval, threshold amount)

**Key Pages to Extend**:
- Page 17 "G/L Account Card" - Account setup
- Page 18 "G/L Account List" - Account list

**Example Extensions**:

```al
tableextension 77107 "ABC G/L Account Ext" extends "G/L Account"
{
    fields
    {
        field(77100; "ABC Department Code"; Code[20])
        {
            Caption = 'Department Code';
            TableRelation = "ABC Department";
            DataClassification = CustomerContent;
        }

        field(77101; "ABC Budget Owner"; Code[50])
        {
            Caption = 'Budget Owner';
            DataClassification = CustomerContent;
        }

        field(77102; "ABC Custom Category"; Option)
        {
            Caption = 'Custom Category';
            OptionMembers = " ",Operating,COGS,Overhead,Capital;
            OptionCaption = ' ,Operating,COGS,Overhead,Capital';
            DataClassification = CustomerContent;
        }
    }
}
```

**Source**: [GLAccount.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Finance/GeneralLedger/Account/GLAccount.Table.al)

### General Journal Line (Table 81)

**Common Extension Scenarios**:
- Approval tracking (approval status, approver)
- External references (transaction ID, batch reference)
- Multi-dimensional analysis (project, cost center)
- Import tracking (import batch, import timestamp)

**Key Pages to Extend**:
- Page 39 "General Journal" - Journal entry
- Page 251 "General Journal Batches" - Batch setup

**Example Extensions**:

```al
tableextension 77108 "ABC Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(77100; "ABC External Ref. No."; Code[30])
        {
            Caption = 'External Reference No.';
            DataClassification = CustomerContent;
        }

        field(77101; "ABC Approval Required"; Boolean)
        {
            Caption = 'Approval Required';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(77102; "ABC Import Batch ID"; Guid)
        {
            Caption = 'Import Batch ID';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
}
```

**Source**: [GenJournalLine.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Finance/GeneralLedger/Journal/GenJournalLine.Table.al)

---

## Master Data Extensions

### Company Information (Table 79)

**Common Extension Scenarios**:
- Additional contact methods (mobile, social media)
- Certifications (tax IDs for multiple jurisdictions)
- Integration endpoints (API URLs, webhook URLs)
- Company-wide defaults (custom policies, preferences)

**Key Pages to Extend**:
- Page 1 "Company Information" - Company setup

**Example Extensions**:

```al
tableextension 77109 "ABC Company Information Ext" extends "Company Information"
{
    fields
    {
        field(77100; "ABC API Endpoint URL"; Text[250])
        {
            Caption = 'API Endpoint URL';
            DataClassification = OrganizationIdentifiableInformation;
        }

        field(77101; "ABC Customer Portal URL"; Text[250])
        {
            Caption = 'Customer Portal URL';
            DataClassification = OrganizationIdentifiableInformation;
        }

        field(77102; "ABC Secondary Tax ID"; Text[30])
        {
            Caption = 'Secondary Tax ID';
            DataClassification = OrganizationIdentifiableInformation;
        }
    }
}
```

**Source**: [CompanyInformation.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Foundation/Company/CompanyInformation.Table.al)

---

## Page Extension Patterns

### Layout Placement Options

| Placement Method | Use Case | Example |
|------------------|----------|---------|
| `addfirst(FastTab)` | Critical fields, top priority | Status flags, priority indicators |
| `addlast(FastTab)` | Supplementary information | External references, notes |
| `addafter(FieldName)` | Logically related fields | Custom field after standard field |
| `addbefore(FieldName)` | Priority over standard field | Override field order |

### Action Placement Options

| Placement Method | Use Case | Example |
|------------------|----------|---------|
| `addafter(ActionName)` | Related to existing action | Send to System after Post |
| `addfirst(ActionGroup)` | High priority action | Custom validation |
| `addlast(ActionGroup)` | Supplementary action | Export, reports |
| `Promoted = true` | Ribbon visibility | Key user actions |

### Field Importance Levels

```al
field("ABC Critical Field"; Rec."ABC Critical Field")
{
    ApplicationArea = All;
    Importance = Promoted; // Always visible, even in collapsed view
}

field("ABC Standard Field"; Rec."ABC Standard Field")
{
    ApplicationArea = All;
    Importance = Standard; // Default visibility
}

field("ABC Detail Field"; Rec."ABC Detail Field")
{
    ApplicationArea = All;
    Importance = Additional; // Hidden in collapsed view
}
```

### Conditional Visibility

```al
field("ABC Approval Status"; Rec."ABC Approval Status")
{
    ApplicationArea = All;
    Visible = ABCApprovalMgtVisible; // Controlled by variable
}

var
    ABCApprovalMgtVisible: Boolean;

trigger OnOpenPage()
begin
    ABCApprovalMgtVisible := ABCSetup."Enable Approval Workflow";
end;
```

---

## Field Placement Guidelines

### FastTab Organization

**Standard BC FastTab Structure** (Sales Order example):

1. **General** - Key identifiers, status, customer
2. **Lines** - Document lines (subpage)
3. **Invoice Details** - Billing information
4. **Shipping and Billing** - Addresses, shipping
5. **Foreign Trade** - Import/export
6. **Prepayment** - Prepayment settings

**Custom FastTab Recommendations**:

```al
pageextension 77110 "ABC Sales Order Ext" extends "Sales Order"
{
    layout
    {
        // Add to existing FastTab
        addafter(General)
        {
            group("ABC Integration")
            {
                Caption = 'Integration';

                field("ABC External Order No."; Rec."ABC External Order No.")
                {
                    ApplicationArea = All;
                }
                field("ABC Last Sync"; Rec."ABC Last Sync DateTime")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
```

### Field Grouping Best Practices

✅ **DO**:
- Group related fields together
- Use clear, descriptive captions
- Follow BC naming conventions
- Place most important fields first

❌ **DON'T**:
- Mix unrelated fields in one group
- Create too many custom FastTabs (max 2-3)
- Use technical field names for captions
- Hide critical fields by default

---

## Data Classification Guidelines

| Classification | Use Case | Examples |
|----------------|----------|----------|
| **CustomerContent** | Business data created by customer | Order numbers, descriptions, amounts |
| **EndUserIdentifiableInformation** | Data that identifies end users | Contact names, email addresses |
| **OrganizationIdentifiableInformation** | Data that identifies organization | Company name, tax IDs |
| **SystemMetadata** | System-generated data | Sync timestamps, GUIDs |

```al
field(77100; "ABC Customer Email"; Text[80])
{
    Caption = 'Customer Email';
    DataClassification = EndUserIdentifiableInformation; // Contains PII
    ExtendedDatatype = EMail;
}

field(77101; "ABC Last Import DateTime"; DateTime)
{
    Caption = 'Last Import Date/Time';
    DataClassification = SystemMetadata; // System-generated
    Editable = false;
}
```

---

## Performance Considerations

### FlowFields and FlowFilters

Use FlowFields for calculated values to avoid performance issues:

```al
field(77100; "ABC Open Orders"; Integer)
{
    Caption = 'Open Orders';
    FieldClass = FlowField;
    CalcFormula = count("Sales Header" where("Sell-to Customer No." = field("No."),
                                              "Document Type" = const(Order),
                                              Status = const(Open)));
    Editable = false;
}
```

### Keys and SumIndexFields

When extending tables with custom fields used in lookups or filtering:

```al
tableextension 77111 "ABC Item Ext" extends Item
{
    fields
    {
        field(77100; "ABC Product Category"; Code[20])
        {
            Caption = 'Product Category';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(ABCCategory; "ABC Product Category")
        {
            // Custom key for filtering/sorting by category
        }
    }
}
```

---

## Additional Resources

- **Event Catalog**: [BC27_EVENT_CATALOG.md](./BC27_EVENT_CATALOG.md) - Find events to subscribe to
- **Architecture Guide**: [BC27_ARCHITECTURE.md](./BC27_ARCHITECTURE.md) - Understand BC27 structure
- **Naming Conventions**: [001-naming-conventions.mdc](../.cursor/rules/001-naming-conventions.mdc) - ESC naming standards
- **Source Repository**: [BC27 Code History](https://github.com/StefanMaron/MSDyn365BC.Code.History/tree/be-27)

---

**Version Notes**:
- **v1.0**: Initial extension point guide covering Sales, Purchase, Inventory, Finance, and Master Data
- **Coverage**: Most commonly extended tables in BC27 BaseApp
- **Future**: Will expand with service management, manufacturing, and specialized module extensions
