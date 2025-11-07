# BC27 - Modules Organized by Functional Category

Complete listing of all BC27 modules organized by functional category and business domain.

**Quick Navigation**: [Core (4)](#core-foundation-modules) | [Finance (5)](#financial--accounting-modules) | [Banking (6)](#banking--payments-modules) | [Sales (2)](#sales--inventory-modules) | [Mfg (1)](#manufacturing-module) | [APIs (4)](#api--integration-modules) | [Data (3)](#data-management-modules) | [Email (7)](#email--communications-modules) | [Documents (4)](#document-management-modules) | [Regulatory (4)](#localization--regulatory-modules) | [Storage (4)](#external-storage--cloud-modules) | [Service (1)](#service-management-module) | [Subscriptions (2)](#subscription--recurring-billing-modules) | [Analytics (3)](#analytics--reporting-modules) | [Demo (3)](#demo--sample-data-modules) | [Admin (6)](#admin--configuration-modules) | [Sustainability (3)](#sustainability-modules) | [E-Commerce (1)](#e-commerce-integration) | [AI/ML (4)](#advanced-aiml-features) | [VAT (1)](#vat-management) | [Infrastructure (3)](#infrastructure--testing)

---

## CORE FOUNDATION MODULES
**Count**: 4 | **Criticality**: Essential for all deployments

These modules form the foundation of Business Central. All other modules depend on this core.

### System Application
- **Category**: Core Infrastructure
- **Purpose**: System-level utilities and infrastructure
- **Must-Have**: Yes - required
- **Key Role**: Foundation for all other modules
- **Contains**: Permission framework, events, telemetry
- **Users**: Every other module depends on this

### BaseApp
- **Category**: Core ERP
- **Purpose**: Foundation business functionality
- **Must-Have**: Yes - required
- **Key Tables**: Customer, Vendor, Item, G/L, Sales, Purchase, Inventory
- **Scope**: Essential ERP functionality
- **Customization Base**: All extensions extend this

### Application
- **Category**: Core Configuration
- **Purpose**: Application metadata and localization
- **Must-Have**: Yes - required
- **Languages**: Supports 30+ languages
- **Translations**: Multi-language resources
- **Configuration**: Application-level settings

### BusinessFoundation
- **Category**: Shared Logic
- **Purpose**: Common business logic patterns
- **Must-Have**: Yes - recommended
- **Used By**: Financial, Sales, Manufacturing modules
- **Reduces**: Code duplication across modules
- **Pattern Support**: Standard calculation routines

---

## FINANCIAL & ACCOUNTING MODULES
**Count**: 5 | **Typical Install**: 3-5 depending on needs

Modules for financial management, G/L analysis, and fixed asset management.

### ReviewGLEntries
- **Priority**: Medium
- **Use When**: Need to review/analyze G/L entries
- **Common Use**: Month-end close, period analysis
- **Features**: Entry review pages, analysis tools
- **Size**: Small extension
- **Complexity**: Low

### API Reports - Finance
- **Priority**: High (if using external reporting)
- **Use When**: Integrating with BI tools, external reporting
- **Features**: Financial data APIs
- **Size**: Small extension
- **API**: Exposes G/L, AR/AP, FA via REST

### DataCorrectionFA
- **Priority**: Low (troubleshooting only)
- **Use When**: Need to fix FA posting errors
- **Caution**: Use carefully - modifies ledger entries
- **Features**: FA correction utilities
- **Size**: Small extension
- **When Needed**: Post-implementation corrections

### StatisticalAccounts
- **Priority**: Medium (sustainability/KPI tracking)
- **Use When**: Need non-monetary metrics (units, headcount, etc.)
- **Features**: Statistical journals, ledger
- **Integration**: Works with Sustainability module
- **Size**: Medium extension
- **Use Case**: ESG metrics, KPI tracking

### ESG Statistical Accounts Demo Tool
- **Priority**: Low (demo only)
- **Use When**: Demonstrating ESG features
- **Content**: Sample ESG data and setup
- **Purpose**: Training and POC
- **Size**: Small demo extension

---

## BANKING & PAYMENTS MODULES
**Count**: 6 | **Typical Install**: 3-5 for financial services

Modules for bank account management, reconciliation, and payment processing.

### BankAccRecWithAI
- **Priority**: High (modern banking)
- **Use When**: Need automated bank reconciliation
- **Key Feature**: AI-powered transaction matching
- **Benefit**: Reduces manual reconciliation by 80%+
- **Size**: Medium extension
- **Complexity**: Medium (AI/ML components)

### SimplifiedBankStatementImport
- **Priority**: High (most companies)
- **Use When**: Need simple bank statement import
- **Simpler Than**: AMCBanking365
- **Size**: Small extension
- **Setup Time**: Quick setup, limited options

### AMCBanking365Fundamentals
- **Priority**: Medium (complex banking)
- **Use When**: Need international payment processing
- **Features**: SEPA, ISO 20022 support
- **Partner**: AMC Banking Solutions
- **Size**: Medium extension
- **Complexity**: High (multiple bank formats)

### BankDeposits
- **Priority**: Medium (US/regional)
- **Use When**: Operating in North America
- **Features**: Deposit documents, slip printing
- **Size**: Small extension
- **Complexity**: Low
- **Regional**: Primarily US market

### PayPalPaymentsStandard
- **Priority**: High (e-commerce)
- **Use When**: Accepting PayPal payments
- **Features**: PayPal API integration
- **Size**: Small extension
- **Use Case**: Online payment capture

### WorldPayPaymentsStandard
- **Priority**: High (enterprise payments)
- **Use When**: Accepting credit cards, complex payments
- **Features**: WorldPay gateway
- **Size**: Small extension
- **Partner**: FIS WorldPay

---

## SALES & INVENTORY MODULES
**Count**: 2 | **Typical Install**: 1-2 (optional enhancements)

Modules for advanced sales and inventory management with AI capabilities.

### SalesLinesSuggestions
- **Priority**: Medium (Copilot-driven)
- **Use When**: Want AI-powered sales suggestions
- **Feature**: Copilot-powered line suggestions
- **Benefit**: Increased cross-sell/up-sell
- **Size**: Small extension
- **Technology**: Azure ML + Copilot

### SalesAndInventoryForecast
- **Priority**: Medium (planning-focused)
- **Use When**: Need demand planning
- **Feature**: Predictive analytics
- **Benefit**: Reduce stockouts and overstock
- **Size**: Medium extension
- **Technology**: Azure ML forecasting

---

## MANUFACTURING MODULE
**Count**: 1 | **Size**: Large | **Typical Install**: High for manufacturers

Complete manufacturing module for production management.

### Manufacturing
- **Category**: Core Business Domain
- **Priority**: High (if manufacturing)
- **Scope**: Complete manufacturing management
- **Key Objects**: Production Orders, BOMs, Routing, Work Centers
- **Complexity**: High (large module)
- **Size**: Very Large (hundreds of objects)
- **Required For**: Any manufacturing operation
- **Key Features**:
  - Production Orders (Make-to-Order, Make-to-Stock)
  - Bill of Materials with multi-level
  - Routing with operations
  - Capacity Planning
  - Shop Floor Control
  - Scrap and Byproducts
- **Typical Flow**: Sales Order → Demand Forecast → MRP → Production Order → Shop Floor → Posted

---

## API & INTEGRATION MODULES
**Count**: 4 | **Typical Install**: 2-4 depending on integrations

Modules for REST API access and external system integration.

### APIV1
- **Priority**: Medium (legacy support)
- **Use When**: Supporting legacy integrations
- **Version**: v1.0
- **Status**: Supported but V2 recommended
- **Size**: Small-Medium
- **Entities**: Customers, Vendors, Items, Sales, Purchase, G/L

### APIV2
- **Priority**: High (modern integrations)
- **Use When**: Building new integrations
- **Version**: v2.0
- **Improvement Over V1**: Better performance, more filtering
- **Size**: Small-Medium
- **Recommendation**: Use for new integrations

### FieldServiceIntegration
- **Priority**: High (if using Field Service)
- **Use When**: Managing field service operations
- **Partner**: Microsoft Dynamics 365 Field Service
- **Integration Type**: Bidirectional sync
- **Size**: Medium
- **Complexity**: High (complex sync scenarios)

### ExternalEvents
- **Priority**: Medium (event-driven architecture)
- **Use When**: Need webhook/event notifications
- **Pattern**: Pub/Sub for external systems
- **Size**: Small
- **Use Case**: Real-time event notifications

---

## DATA MANAGEMENT MODULES
**Count**: 3 | **Typical Install**: 1-3 for large organizations

Modules for data governance, archival, and search capabilities.

### DataArchive
- **Priority**: Medium (performance optimization)
- **Use When**: Database performance concerns
- **Key Benefit**: Move old data to archive
- **Size**: Medium
- **Effect**: Significant performance improvement
- **Typical Use**: Archive data older than 3 years

### DataSearch
- **Priority**: Low (utility enhancement)
- **Use When**: Users need global search
- **Features**: Cross-module search
- **Size**: Small
- **Benefit**: Better user navigation

### MasterDataManagement
- **Priority**: Medium (multi-company only)
- **Use When**: Managing multiple companies
- **Key Feature**: Centralized master data governance
- **Size**: Medium
- **Typical User**: Large multi-company organizations

---

## EMAIL & COMMUNICATIONS MODULES
**Count**: 7 | **Typical Install**: 1-2 (choose based on email provider)

Modules for email integration and communications.

### Email - Microsoft 365 Connector (RECOMMENDED for M365 users)
- **Priority**: High (M365 organizations)
- **Use When**: Using Microsoft 365
- **Technology**: OAuth via Azure AD
- **Size**: Small
- **Benefit**: Native M365 integration
- **Recommended For**: Most enterprises

### Email - Outlook REST API
- **Priority**: High (Microsoft ecosystem)
- **Use When**: Need rich Outlook integration
- **Features**: Email, Calendar, Contacts
- **Size**: Small
- **Technology**: Microsoft Graph API

### Email - SMTP Connector (RECOMMENDED for traditional setup)
- **Priority**: High (universal solution)
- **Use When**: Using traditional SMTP
- **Features**: Universal email sending
- **Size**: Small
- **Recommended For**: Non-Microsoft email

### EmailLogging
- **Priority**: Medium (audit trail)
- **Use When**: Need email logging to contacts
- **Features**: Automatic email logging
- **Technology**: Microsoft Graph API
- **Size**: Small

### Email - Current User Connector
- **Priority**: Low (personal email)
- **Use When**: Users send from personal mailbox
- **Features**: SMTP-based user email
- **Size**: Small

### Email - SMTP API
- **Priority**: Medium (flexible SMTP)
- **Use When**: Need SMTP flexibility
- **Features**: SMTP API for custom solutions
- **Size**: Small

### Send To Email Printer
- **Priority**: Low (specific use case)
- **Use When**: Emailing reports to users
- **Features**: Print-to-email
- **Size**: Small

---

## DOCUMENT MANAGEMENT MODULES
**Count**: 4 | **Typical Install**: 1-3 depending on e-invoicing needs

Modules for electronic documents, e-invoicing, and audit compliance.

### EDocument Core
- **Priority**: High (future requirement)
- **Use When**: Planning e-invoicing
- **Key Role**: Foundation for e-invoicing
- **Size**: Medium
- **Importance**: Future compliance requirement
- **Regulatory**: EU e-invoicing directive

### EDocumentConnectors
- **Priority**: Medium (compliance-driven)
- **Use When**: Using specific e-invoice provider
- **Features**: Connector framework for providers
- **Size**: Depends on provider
- **Integration**: Peppol, country-specific providers

### AuditFileExport
- **Priority**: High (large organizations)
- **Use When**: Tax authority audits
- **Features**: SAF-T file export
- **Size**: Medium
- **Regulatory**: International tax compliance

### EnforcedDigitalVouchers
- **Priority**: Medium (country-specific)
- **Use When**: Operating in France/Germany
- **Features**: Digital voucher enforcement
- **Size**: Small
- **Regulatory**: FR/DE digital requirements

---

## LOCALIZATION & REGULATORY MODULES
**Count**: 4 | **Typical Install**: 1-4 depending on operating regions

Modules for localization, compliance, and regulatory requirements.

### Intrastat
- **Priority**: High (EU companies)
- **Use When**: EU intra-community trade
- **Regulatory**: EU Intrastat regulation
- **Frequency**: Monthly/Quarterly
- **Size**: Small-Medium
- **Scope**: EU-wide requirement

### IntrastatBE
- **Priority**: High (Belgium companies)
- **Use When**: Operating in Belgium
- **Localization**: Belgium-specific formats
- **Size**: Small
- **Depends On**: Intrastat (core)

### EU3PartyTradePurchase
- **Priority**: Medium (triangular trade)
- **Use When**: Doing triangular trade
- **Features**: Special VAT rules for 3-party trades
- **Size**: Small
- **Complexity**: Medium (specialized VAT)

### ServiceDeclaration
- **Priority**: Medium (EU service companies)
- **Use When**: Providing cross-border services
- **Regulatory**: EU service statistics
- **Size**: Small
- **Frequency**: Annual reporting

---

## EXTERNAL STORAGE & CLOUD MODULES
**Count**: 4 | **Typical Install**: 1-3 (choose based on cloud provider)

Modules for cloud storage and external file integration.

### External File Storage - Azure Blob Service Connector
- **Priority**: High (Azure users)
- **Use When**: Using Azure cloud
- **Features**: Blob storage integration
- **Size**: Small
- **Scalability**: Unlimited cloud storage
- **Recommended For**: Large document storage

### External File Storage - Azure File Service Connector
- **Priority**: High (Azure users)
- **Use When**: Need SMB-compatible storage
- **Features**: Azure Files (SMB protocol)
- **Size**: Small
- **Advantage**: Can map as Windows drive

### External File Storage - SharePoint Connector
- **Priority**: High (M365/SharePoint users)
- **Use When**: Using Microsoft SharePoint
- **Features**: SharePoint document integration
- **Size**: Small
- **Common Use**: Collaborative document management

### Universal Print Integration
- **Priority**: Medium (cloud printing)
- **Use When**: Need cloud-based printing
- **Features**: Microsoft Universal Print
- **Size**: Small
- **Benefit**: No print server needed

---

## SERVICE MANAGEMENT MODULE
**Count**: 1 | **Size**: Medium | **Typical Install**: High for service companies

Complete service management module.

### ServiceManagement
- **Category**: Core Business Domain
- **Priority**: High (if service-based)
- **Scope**: Service orders, contracts, resources
- **Key Objects**: Service Orders, Contracts, Service Items
- **Complexity**: Medium-High
- **Size**: Large module
- **Required For**: Service companies, field service
- **Key Features**:
  - Service Order management
  - Service Contracts with renewal
  - Resource allocation
  - Service tasks
  - Service ledger
- **Typical Users**: Field service, maintenance, support

---

## SUBSCRIPTION & RECURRING BILLING MODULES
**Count**: 2 | **Typical Install**: 1-2 (optional for SaaS/subscription models)

Modules for subscription and recurring revenue management.

### SubscriptionBilling
- **Priority**: Medium-High (subscription models)
- **Use When**: Operating subscription business
- **Key Features**: Recurring invoicing, MRR tracking
- **Size**: Medium
- **Complexity**: Medium
- **Business Model**: SaaS, subscriptions, recurring services
- **Benefit**: Automates recurring billing

### PaymentPractices
- **Priority**: Medium (EU compliance)
- **Use When**: EU companies need transparency
- **Features**: Payment statistics reporting
- **Size**: Small
- **Regulatory**: EU Payment Practices Directive

---

## ANALYTICS & REPORTING MODULES
**Count**: 3 | **Typical Install**: 1-3 (optional enhancements)

Modules for advanced reporting and analytics.

### PowerBIReports
- **Priority**: Medium (if using Power BI)
- **Use When**: Need embedded Power BI dashboards
- **Features**: Embedded Power BI in BC
- **Size**: Small
- **Requirement**: Power BI license
- **Benefit**: Rich analytics in BC UI

### ExcelReports
- **Priority**: Low-Medium (finance teams)
- **Use When**: Exporting data to Excel
- **Features**: Excel export utilities
- **Size**: Small
- **Common Use**: Finance team reporting

### ReportLayouts
- **Priority**: Medium (reporting customization)
- **Use When**: Need custom report layouts
- **Features**: RDLC and Word layouts
- **Size**: Small
- **Benefit**: Business users can customize layouts

---

## DEMO & SAMPLE DATA MODULES
**Count**: 3 | **Typical Install**: 0-1 (training/POC only)

Modules providing sample data for demonstration and training.

### ContosoCoffeeDemoDataset
- **Purpose**: Standard demo data
- **Use When**: Training, POCs, feature exploration
- **Contents**: Master data, sample transactions
- **Size**: Medium (complete scenario)
- **Remove After**: POC/training complete

### Contoso Coffee Demo Dataset (BE)
- **Purpose**: Belgium-localized demo data
- **Use When**: Training in Belgium
- **Localization**: BE-specific setup
- **Size**: Small
- **Depends On**: ContosoCoffeeDemoDataset

### Sustainability Contoso Coffee Demo Dataset
- **Purpose**: ESG feature demonstration
- **Use When**: Demonstrating sustainability
- **Contents**: ESG demo data
- **Size**: Small
- **Use Case**: Sustainability feature POC

---

## ADMIN & CONFIGURATION MODULES
**Count**: 6 | **Typical Install**: 2-4 depending on deployment

Modules for administration, configuration, and management.

### PlanConfiguration
- **Priority**: High (SaaS deployments)
- **Use When**: Managing user plans/licenses
- **Features**: Plan management, permissions
- **Size**: Small
- **SaaS Only**: Used in SaaS deployments

### RecommendedApps
- **Priority**: Low (navigation aid)
- **Use When**: Want app recommendations
- **Features**: Contextual app suggestions
- **Size**: Small

### Company Hub
- **Priority**: High (multi-company)
- **Use When**: Managing multiple companies
- **Features**: Cross-company dashboard
- **Size**: Small
- **Benefit**: Unified multi-company view

### ClientAddIns
- **Priority**: Medium (rich UI)
- **Use When**: Need client-side functionality
- **Features**: Maps, barcode scanning, camera
- **Size**: Small
- **Example Uses**: Location picking, photo capture

### Onprem Permissions
- **Priority**: Low (on-prem only)
- **Use When**: On-premises deployment
- **Features**: Legacy permission sets
- **Size**: Small
- **Note**: SaaS doesn't use this

---

## SUSTAINABILITY MODULES
**Count**: 3 | **Typical Install**: 1-2 (ESG/sustainability-focused companies)

Modules for environmental, social, and governance (ESG) management.

### Sustainability
- **Category**: Core Business Domain
- **Priority**: Medium-High (future requirement)
- **Key Feature**: ESG accounting and reporting
- **Size**: Large module
- **Regulatory**: EU CSRD compliance
- **Required For**: Organizations with ESG reporting needs
- **Key Components**: Carbon accounting, emission tracking, ESG reporting
- **Typical Users**: Large organizations, public companies, sustainability-focused

### SustainabilityCopilotSuggestion
- **Priority**: Medium (Copilot-enhanced)
- **Use When**: Want AI assistance for ESG data
- **Features**: Copilot-powered suggestions
- **Size**: Small
- **Technology**: AI/Copilot integration

### Sustainability Contoso Coffee Demo Dataset
- **Purpose**: ESG demo data
- **Use When**: Demonstrating sustainability features
- **Size**: Small

---

## E-COMMERCE INTEGRATION
**Count**: 1 | **Typical Install**: 1-2 (optional for e-commerce)

Module for e-commerce platform integration.

### Shopify
- **Category**: Cloud Integration
- **Priority**: High (if using Shopify)
- **Partner**: Shopify
- **Features**: Product, order, inventory, customer sync
- **Size**: Medium
- **Bidirectional**: Sync in both directions
- **Typical Users**: E-commerce companies, retailers

---

## ADVANCED AI/ML FEATURES
**Count**: 4 | **Typical Install**: 1-3 (optional AI enhancements)

Modules for artificial intelligence and machine learning capabilities.

### LatePaymentPredictor
- **Priority**: Medium (credit management)
- **Use When**: Want payment predictability
- **Feature**: ML-based payment prediction
- **Size**: Small-Medium
- **Technology**: Azure ML
- **Benefit**: Better credit decisions

### SalesLinesSuggestions
- **Priority**: Medium (Copilot)
- **Use When**: Want AI sales recommendations
- **Feature**: Copilot-powered suggestions
- **Size**: Small
- **Technology**: Azure ML + Copilot

### ErrorMessagesWithRecommendations
- **Priority**: Medium (user experience)
- **Use When**: Want intelligent error handling
- **Feature**: AI-powered error suggestions
- **Size**: Small
- **Benefit**: Reduced support burden

### Create Product Information With Copilot
- **Priority**: Medium (e-commerce)
- **Use When**: Need AI-generated product content
- **Feature**: GPT-powered descriptions
- **Size**: Small
- **Technology**: Azure OpenAI

---

## VAT MANAGEMENT
**Count**: 1 | **Typical Install**: 1 (multi-company groups)

Module for VAT group consolidation and management.

### VATGroupManagement
- **Priority**: Medium-High (group companies)
- **Use When**: Multi-company with group VAT
- **Features**: Consolidated VAT returns
- **Size**: Small-Medium
- **Regulatory**: EU VAT group provisions
- **Typical Users**: Corporate groups

---

## INFRASTRUCTURE & TESTING
**Count**: 3 | **Typical Install**: All projects

System infrastructure and testing frameworks.

### testframework
- **Purpose**: Test automation framework
- **Size**: Small-Medium
- **Used By**: All modules for testing
- **Components**: Test libraries, runners, utilities

### scripts
- **Purpose**: Maintenance scripts
- **Size**: Small
- **Used For**: Repository updates

### .github/workflows
- **Purpose**: CI/CD pipelines
- **Size**: Small
- **Used For**: Automated builds and tests

---

## Installation Recommendations by Company Type

### Small Business (10-50 users)
**Core Modules**: BaseApp, System Application, Application
**Typical Extensions**: SimplifiedBankStatementImport, Email connector, Basic reporting
**Optional**: Manufacturing (if applicable), Shopify (if e-commerce)

### Mid-Market (50-500 users)
**Core Modules**: All core + BusinessFoundation
**Typical Extensions**: Bank Reconciliation AI, Financial modules, Sales extensions
**Optional**: Manufacturing, Service Management, Subscription Billing
**Recommended**: PowerBI Reports, Data Archive

### Enterprise (500+ users)
**All Core Modules**: Complete
**All Business Extensions**: Selective based on needs
**Required**: Manufacturing, Service Management, Multi-company modules
**Recommended**: All AI/ML, Analytics, Integration modules
**Essential**: Master Data Management, Data Archive, Audit exports

### Specialty: Manufacturing
**Core + Manufacturing**: Required
**Recommended**: SalesAndInventoryForecast, Subscription Billing (for service contracts)
**Optional**: Manufacturing analytics, Advanced reporting

### Specialty: Service Company
**Core + Service Management**: Required
**Recommended**: Subscription Billing, Field Service Integration
**Optional**: Resource scheduling, AI suggestions

### Specialty: E-Commerce
**Core**: Required
**Recommended**: Shopify, SalesLinesSuggestions, SalesAndInventoryForecast
**Optional**: Payment gateways (PayPal, WorldPay)

---

## Summary: Typical Installation Sizes

| Company Size | Core | Common | Optional | Total |
|--------------|------|--------|----------|-------|
| **Small** | 4 | 2-3 | 1-2 | 7-9 |
| **Mid-Market** | 4 | 5-8 | 3-5 | 12-17 |
| **Enterprise** | 4 | 10-15 | 5-10 | 19-29 |
| **Manufacturing** | 4 | Manufacturing (1) | 3-5 | 8-10 |
| **Service** | 4 | Service Mgmt (1) | 2-4 | 7-9 |
| **E-Commerce** | 4 | Shopify (1) | 2-4 | 7-9 |

**Note**: These are guidelines. Actual installations vary based on specific business needs.

---

**Document Version**: 1.0
**BC Version**: 27
**Last Updated**: 2025-11-07

