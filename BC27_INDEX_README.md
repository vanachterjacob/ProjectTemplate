# BC 27 Base Code - Comprehensive Index

Welcome to the comprehensive index of Microsoft Dynamics 365 Business Central version 27 base code. This documentation set provides complete reference information for all 73 modules in the BC27 platform.

## 📚 Documentation Structure

This index consists of multiple markdown files organized by topic for easy navigation:

### Core Documentation
- **[BC27_MODULES_OVERVIEW.md](./BC27_MODULES_OVERVIEW.md)** - Complete inventory of all 73 modules with detailed descriptions
- **[BC27_ARCHITECTURE.md](./BC27_ARCHITECTURE.md)** - System architecture, layering, and design patterns
- **[BC27_MODULES_BY_CATEGORY.md](./BC27_MODULES_BY_CATEGORY.md)** - Modules grouped by functional category
- **[BC27_DEPENDENCY_REFERENCE.md](./BC27_DEPENDENCY_REFERENCE.md)** - Module dependencies and relationships
- **[BC27_FEATURES_INDEX.md](./BC27_FEATURES_INDEX.md)** - Complete feature index and capabilities
- **[BC27_INTEGRATION_GUIDE.md](./BC27_INTEGRATION_GUIDE.md)** - External integrations and cloud services

## 🎯 Quick Navigation

### By Use Case
- **Manufacturing** → See [Manufacturing Module](./BC27_MODULES_OVERVIEW.md#manufacturing-module-1)
- **Financial Services** → See [Financial & Accounting](./BC27_MODULES_BY_CATEGORY.md#financial--accounting-modules-5)
- **E-Commerce** → See [Shopify Integration](./BC27_MODULES_OVERVIEW.md#shopify) & [Sales & Inventory](./BC27_MODULES_BY_CATEGORY.md#sales--inventory-modules-2)
- **Sustainability** → See [Sustainability Modules](./BC27_MODULES_BY_CATEGORY.md#sustainability-modules-3)
- **Multi-Company/Global** → See [Localization & Regulatory](./BC27_MODULES_BY_CATEGORY.md#localization--regulatory-modules-4)

### By Technology
- **AI/Copilot Features** → See [Advanced AI/ML Features](./BC27_MODULES_BY_CATEGORY.md#advancedaiml-features-4)
- **Cloud Integrations** → See [Integration Guide](./BC27_INTEGRATION_GUIDE.md)
- **APIs** → See [API & Integration Modules](./BC27_MODULES_BY_CATEGORY.md#api--integration-modules-4)
- **Email** → See [Email & Communications](./BC27_MODULES_BY_CATEGORY.md#email--communications-modules-7)

### By Role
- **Extension Developer** → Start with [Architecture](./BC27_ARCHITECTURE.md) then [Dependency Reference](./BC27_DEPENDENCY_REFERENCE.md)
- **Architect** → Review [Architecture](./BC27_ARCHITECTURE.md) and [Integration Guide](./BC27_INTEGRATION_GUIDE.md)
- **Consultant** → Browse [Features Index](./BC27_FEATURES_INDEX.md) and [Modules by Category](./BC27_MODULES_BY_CATEGORY.md)
- **System Admin** → See [Integration Guide](./BC27_INTEGRATION_GUIDE.md) and [Admin Configuration](./BC27_MODULES_BY_CATEGORY.md#admin--configuration-modules-6)

## 📊 Quick Stats

| Metric | Count |
|--------|-------|
| **Total Modules** | 73 |
| **Core Platform** | 4 |
| **Business Extensions** | 69 |
| **AI/ML Features** | 7 |
| **Integration Points** | 15+ |
| **Localization Variants** | 8+ |
| **Regulatory Modules** | 8+ |

## 🔍 Key Features in BC27

### New/Enhanced Capabilities
- ✨ **AI-Powered Features**: Bank Reconciliation AI, Sales Forecasting, Product Content Generation
- 🌱 **Sustainability**: ESG accounting, CSRD compliance, Carbon tracking
- 📦 **E-Document Framework**: Core infrastructure for e-invoicing and digital documents
- 🤖 **Copilot Integration**: Multiple Copilot-assisted features
- ☁️ **Cloud Native**: Deep Azure and Microsoft 365 integration

### Core Capabilities
- 💰 **Financial Management**: G/L, AR/AP, FA, Tax, VAT
- 📊 **Manufacturing**: Production orders, BOMs, Routing, Capacity
- 🛍️ **Sales & Inventory**: Orders, SOPs, Warehouse, Forecasting
- 📞 **Service Management**: Service orders, Contracts, Resource planning
- 🔄 **Recurring Billing**: Subscription contracts, Recurring revenue

## 🏗️ Architecture Overview

BC27 follows a **modular extension architecture**:

```
System Application (Core Infrastructure)
        ↓
    BaseApp (Core ERP)
        ↓
BusinessFoundation (Shared Logic)
        ↓
    69 First-Party Extensions
  (Financial, Sales, Manufacturing,
   Integrations, AI/ML, Compliance, etc.)
```

**Key Principle**: All business functionality is built as extensions on top of a minimal core, enabling clean separation and easier customization.

## 📖 How to Use This Index

### Step 1: Understand the Big Picture
Start with [BC27_ARCHITECTURE.md](./BC27_ARCHITECTURE.md) to understand how BC27 is organized.

### Step 2: Find Relevant Modules
Use [BC27_MODULES_BY_CATEGORY.md](./BC27_MODULES_BY_CATEGORY.md) to find modules related to your needs.

### Step 3: Get Detailed Information
Go to [BC27_MODULES_OVERVIEW.md](./BC27_MODULES_OVERVIEW.md) for detailed descriptions of specific modules.

### Step 4: Understand Dependencies
Consult [BC27_DEPENDENCY_REFERENCE.md](./BC27_DEPENDENCY_REFERENCE.md) to see how modules relate to each other.

### Step 5: Plan Integrations
Review [BC27_INTEGRATION_GUIDE.md](./BC27_INTEGRATION_GUIDE.md) for external system connections.

## 🔗 Important Links

- **Source Repository**: [MSDyn365BC.Code.History](https://github.com/StefanMaron/MSDyn365BC.Code.History/tree/be-27)
- **Branch**: `be-27` (Belgium localization, BC v27)
- **Update Schedule**: Daily updates at midnight UTC
- **Status**: Read-only reference repository (Microsoft-owned)

## 📝 Document Versions

| Document | Purpose | Scope |
|----------|---------|-------|
| **BC27_MODULES_OVERVIEW.md** | Complete module listing with details | All 73 modules |
| **BC27_ARCHITECTURE.md** | System design and layering | Core architecture |
| **BC27_MODULES_BY_CATEGORY.md** | Functional organization | 22 categories |
| **BC27_DEPENDENCY_REFERENCE.md** | Module relationships | Dependency chains |
| **BC27_FEATURES_INDEX.md** | Capability reference | All features |
| **BC27_INTEGRATION_GUIDE.md** | External integrations | 15+ services |

---

**Index Version**: 1.0
**BC Version**: 27
**Analysis Branch**: be-27 (Belgium)
**Last Updated**: 2025-11-07
**Source**: Stefan Maron's Code History Repository

---

## Navigation Tips

- 🔍 Use your editor's search function (Ctrl+F) to find specific modules
- 🔗 Click table of contents links to jump between documents
- 📌 Bookmark frequently used documents
- 💾 Save this index locally for offline reference
- 🔄 Check the source repository regularly for updates

## Support & Contributing

This index is generated from the BC27 source code repository. For questions about specific modules or features, refer to the original Microsoft Business Central documentation or the source repository.

