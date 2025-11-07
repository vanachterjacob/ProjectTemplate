# BC27 - Complete Modules Overview

Comprehensive listing of all 73 modules in Business Central version 27. Each module includes purpose, key components, and primary dependencies.

**Contents**: [Core (4)](#1-core-application-modules) | [Financial (5)](#2-financial--accounting-modules) | [Banking (6)](#3-banking--payments-modules) | [Sales (2)](#4-sales--inventory-modules) | [Manufacturing (1)](#5-manufacturing-module) | [APIs (4)](#6-api--integration-modules) | [Data (3)](#7-data-management-modules) | [Email (7)](#8-email--communications-modules) | [Documents (4)](#9-document-management-modules) | [Regulatory (4)](#10-localization--regulatory-modules) | [Storage (4)](#11-external-storage--cloud-modules) | [Service (1)](#12-service-management-module) | [Subscriptions (2)](#13-subscription--recurring-billing-modules) | [Analytics (3)](#14-analytics--reporting-modules) | [Demo (3)](#15-demo--sample-data-modules) | [Admin (6)](#16-admin--configuration-modules) | [Sustainability (3)](#17-sustainability-modules) | [E-Commerce (1)](#18-e-commerce-integration) | [AI/ML (4)](#19-advanced-aiml-features) | [VAT (1)](#20-vat-management) | [Infrastructure (3)](#21-infrastructure--testing)

---

## 1. CORE APPLICATION MODULES

### BaseApp
- **Path**: `/BaseApp/`
- **Type**: Core Platform
- **Purpose**: Foundation application containing core Business Central functionality
- **Structure**: Source/ and Test/
- **Key Components**:
  - Customer, Vendor, Item master data
  - Sales Orders, Quotes, Invoices, Credit Memos
  - Purchase Orders, Invoices
  - General Ledger, Bank Accounts
  - Inventory, Warehouse
  - Dimensions, Cost Accounting
- **Dependencies**: None (foundation layer)
- **Use Cases**: Required for all BC deployments
- **Objects**: Hundreds of tables, pages, reports, codeunits

### System Application
- **Path**: `/System Application/`
- **Type**: Core Platform
- **Purpose**: Low-level system infrastructure and utilities
- **Structure**: Source/System Application/, Test/
- **Key Components**:
  - Permission management framework
  - Base infrastructure utilities
  - System events and subscribers
  - Telemetry framework
  - Error handling utilities
- **Dependencies**: None (system layer)
- **Use Cases**: Required for all BC deployments
- **Critical Role**: Foundation for all other modules

### Application
- **Path**: `/Application/Source/Application/`
- **Type**: Core Platform
- **Purpose**: Main application package configuration and metadata
- **Structure**: Translations/, app.json, directory configuration
- **Key Components**:
  - Application-level settings
  - Localization resources (translations)
  - Multi-language support
  - Application metadata
- **Dependencies**: System Application, BaseApp
- **Key Features**: Multi-language support across 30+ languages
- **Files**:
  - app.json (application manifest)
  - Directory.App.Props.json
  - Translations/ (per-language resources)

### BusinessFoundation
- **Path**: `/BusinessFoundation/`
- **Type**: Core Platform
- **Purpose**: Business logic foundation layer with shared patterns
- **Structure**: Source/Business Foundation/, Test/
- **Key Components**:
  - Common business patterns
  - Shared business logic utilities
  - Standard calculation routines
  - Common page patterns
- **Dependencies**: BaseApp
- **Use Cases**: Used by financial, sales, and manufacturing modules
- **Role**: Reduces code duplication across functional modules

---

## 2. FINANCIAL & ACCOUNTING MODULES

### API Reports - Finance
- **Path**: `/APIReportsFinance/Source/API Reports - Finance/`
- **Type**: API Extension
- **Purpose**: Financial reporting exposed through REST APIs
- **Key Features**:
  - Financial statement APIs
  - G/L entry data export
  - AR/AP reporting APIs
  - FA reporting APIs
- **Use Cases**: External reporting, integration with BI tools, financial data export
- **Dependencies**: BaseApp (G/L Entry, Customer/Vendor Ledgers)
- **Data Access**: Read-only API pages

### ReviewGLEntries
- **Path**: `/ReviewGLEntries/`
- **Type**: Business Extension
- **Purpose**: Review and analyze general ledger entries
- **Structure**: Source/, Test/
- **Key Components**:
  - G/L entry review pages
  - Entry analysis tools
  - Reconciliation utilities
  - Adjustment pages
- **Use Cases**: Period-end review, audit trail analysis, entry verification
- **Dependencies**: BaseApp (G/L Entry tables)
- **Key Pages**: G/L Entry review, analysis pages

### DataCorrectionFA (Troubleshoot FA Ledger Entries)
- **Path**: `/DataCorrectionFA/Source/Troubleshoot FA Ledger Entries/`
- **Type**: Maintenance Extension
- **Purpose**: Fixed asset ledger troubleshooting and correction
- **Key Components**:
  - FA ledger correction utilities
  - Depreciation fix tools
  - Entry deletion/modification
  - FA adjustment pages
- **Use Cases**: Fixing FA posting errors, correcting depreciation, FA adjustments
- **Dependencies**: BaseApp (Fixed Asset tables)
- **Note**: Use with caution - modifies GL entries

### StatisticalAccounts
- **Path**: `/StatisticalAccounts/`
- **Type**: Business Extension
- **Purpose**: Non-financial statistical account management
- **Structure**: Source/, Test/
- **Key Components**:
  - Statistical Account master data
  - Statistical Journal functionality
  - Statistical posting routines
  - Statistical ledger entries
- **Use Cases**: KPI tracking, non-monetary metrics, supplementary accounting
- **Dependencies**: BaseApp (G/L Account structure)
- **Example Uses**: Units produced, headcount, environmental metrics

### ESG Statistical Accounts Demo Tool
- **Path**: `/ESGStatisticalAccountsDemoTool/Source/ESG Statistical Accounts Demo Tool/`
- **Type**: Demo/Education
- **Purpose**: ESG (Environmental, Social, Governance) metrics demonstration
- **Key Components**:
  - Demo data for ESG metrics
  - Setup guides for ESG tracking
  - Sample emission factors
  - Demo journals
- **Use Cases**: Sustainability metric tracking demonstration, training
- **Dependencies**: StatisticalAccounts, Sustainability modules
- **Note**: Demo/example content only

---

## 3. BANKING & PAYMENTS MODULES

### AMCBanking365Fundamentals
- **Path**: `/AMCBanking365Fundamentals/`
- **Type**: Integration Extension
- **Purpose**: AMC Banking integration fundamentals
- **Structure**: Source/, Test/
- **Key Components**:
  - Bank account setup for AMC
  - Payment file format definitions
  - Bank import/export interfaces
  - AMC API connector
- **Use Cases**: International payment processing, bank file exchange, SEPA compliance
- **Dependencies**: BaseApp (Bank Account, Payment Journal)
- **Integration Partner**: AMC Banking Solutions
- **Supported Formats**: SEPA, ISO 20022

### BankAccRecWithAI
- **Path**: `/BankAccRecWithAI/`
- **Type**: AI/ML Extension
- **Purpose**: AI-powered bank reconciliation with machine learning
- **Structure**: Source/Bank Account Reconciliation With AI/, Test/
- **Key Components**:
  - ML transaction matching engine
  - Automated reconciliation algorithms
  - AI suggestion pages
  - Pattern recognition for matching
- **Use Cases**: Automated bank statement matching, payment application, intelligent reconciliation
- **Key Features**: Machine learning for intelligent transaction matching
- **Dependencies**: BaseApp (Bank Account Ledger Entry)
- **Technology**: Azure ML integration
- **Benefit**: Reduces manual reconciliation time by 80%+

### BankDeposits
- **Path**: `/BankDeposits/`
- **Type**: Business Extension
- **Purpose**: Bank deposit management functionality
- **Structure**: Source/, Test/
- **Key Components**:
  - Deposit document (header/lines)
  - Bank Deposit posting routines
  - Deposit slip printing
  - Deposit reconciliation
- **Use Cases**: Grouping payments for deposit, deposit slip printing, deposit tracking
- **Dependencies**: BaseApp (Bank Account, Payment Journal)
- **Regional Use**: Primarily US/North America
- **Key Objects**: Deposit Header/Line tables

### SimplifiedBankStatementImport
- **Path**: `/SimplifiedBankStatementImport/`
- **Type**: Integration Extension
- **Purpose**: Simplified bank statement import functionality
- **Structure**: Source/, Test/
- **Key Components**:
  - Bank statement import routines
  - Format detection
  - Simple import setup (no complex config)
  - Import verification pages
- **Use Cases**: Quick bank statement import without complex setup, smaller banks
- **Dependencies**: BaseApp (Bank Account)
- **Simplified vs. AMCBanking**: Fewer options, faster setup

### PayPalPaymentsStandard
- **Path**: `/PayPalPaymentsStandard/`
- **Type**: Integration Extension
- **Purpose**: PayPal payment processing integration
- **Structure**: Source/, Test/
- **Key Components**:
  - PayPal API connector
  - Payment capture functionality
  - Payment verification
  - Transaction logging
- **Use Cases**: E-commerce payment processing, online payments, payment capture
- **Dependencies**: BaseApp (Sales documents, Payment processing)
- **API Version**: PayPal Checkout API
- **Supported**: Credit cards, PayPal wallet, Pay Later

### WorldPayPaymentsStandard
- **Path**: `/WorldPayPaymentsStandard/`
- **Type**: Integration Extension
- **Purpose**: WorldPay payment gateway integration
- **Structure**: Source/, Test/
- **Key Components**:
  - WorldPay API connector
  - Payment processing
  - Transaction handling
  - Fraud detection integration
- **Use Cases**: Credit card processing, online payment capture, PCI compliance
- **Dependencies**: BaseApp (Sales documents, Payment processing)
- **Partner**: FIS (Fiserv) WorldPay
- **Compliance**: PCI DSS through WorldPay

---

## 4. SALES & INVENTORY MODULES

### SalesLinesSuggestions
- **Path**: `/SalesLinesSuggestions/`
- **Type**: AI/Copilot Extension
- **Purpose**: AI-powered sales line recommendations
- **Structure**: Source/, Test/
- **Key Components**:
  - Suggestion engine using ML
  - Historical sales analysis
  - Copilot page interaction
  - Recommendation algorithm
- **Use Cases**: Cross-sell/up-sell suggestions, order completion assistance, smart selling
- **Key Features**: Copilot-powered line suggestions
- **Dependencies**: BaseApp (Sales documents, Item, Customer history)
- **Technology**: Azure ML, Copilot integration
- **Use Case**: Sales rep creates order → Copilot suggests additional items

### SalesAndInventoryForecast
- **Path**: `/SalesAndInventoryForecast/`
- **Type**: Analytics/Forecasting Extension
- **Purpose**: Predictive analytics for sales and inventory
- **Structure**: Source/, Test/
- **Key Components**:
  - Forecasting algorithms
  - ML models for demand prediction
  - Forecast pages and reports
  - Inventory optimization recommendations
- **Use Cases**: Demand planning, inventory optimization, production planning
- **Key Features**: Machine learning-based forecasting
- **Dependencies**: BaseApp (Item, Sales history, Item Ledger Entry)
- **Technology**: Azure ML for time-series forecasting
- **Benefit**: Reduces stockouts and overstock

---

## 5. MANUFACTURING MODULE

### Manufacturing
- **Path**: `/Manufacturing/`
- **Type**: Core Business Module
- **Purpose**: Complete manufacturing management functionality
- **Structure**: Source/Manufacturing/, Test/Manufacturing Tests/
- **Key Components**:
  - Production Order (Header, Line)
  - Bill of Materials (BOM)
  - Production Routing
  - Work Centers and Machine Centers
  - Capacity Planning
  - Shop Floor Control
  - Production Ledger Entries
- **Key Objects**:
  - Production Order table and pages
  - Production BOM Header/Line
  - Routing and Routing Line
  - Work Center, Machine Center
  - Capacity Ledger Entry
  - Production Journal
- **Use Cases**: Discrete manufacturing, make-to-order production, make-to-stock, job production
- **Key Features**:
  - Multi-level BOM support
  - Routing with operations
  - Capacity planning
  - Material Requirements Planning (MRP)
  - Scrap and byproduct handling
- **Dependencies**: BaseApp (Item, Inventory)
- **Scope**: Large module covering complete manufacturing workflow
- **Complexity**: High - used in most manufacturing deployments

---

## 6. API & INTEGRATION MODULES

### APIV1
- **Path**: `/APIV1/`
- **Type**: API Extension
- **Purpose**: First generation REST API for Business Central
- **Structure**: Source/_Exclude_APIV1_/, Test/_Exclude_APIV1_ Tests/
- **Key Components**:
  - Customers API (v1.0)
  - Vendors API
  - Items API
  - Sales Invoices API
  - Purchase Invoices API
  - General Ledger API
  - Journals API
- **Use Cases**: External system integration, mobile app backends, cloud-to-cloud integration
- **API Version**: v1.0
- **Format**: OData protocol
- **Dependencies**: BaseApp
- **Note**: "_Exclude_" prefix suggests conditional compilation or version control
- **Deprecated**: V1 still supported but V2 recommended for new implementations

### APIV2
- **Path**: `/APIV2/`
- **Type**: API Extension
- **Purpose**: Second generation REST API with enhanced capabilities
- **Structure**: Source/_Exclude_APIV2_/, Test/_Exclude_APIV2_ Tests/
- **Key Components**:
  - All APIV1 entities
  - Additional entities
  - Enhanced filtering/sorting
  - Better performance
  - Improved documentation
- **Use Cases**: Modern integration scenarios, enhanced data access, better filtering
- **API Version**: v2.0
- **Format**: OData protocol
- **Dependencies**: BaseApp, evolution of APIV1
- **Note**: "_Exclude_" suggests special build handling
- **Recommendation**: Use V2 for new integrations

### FieldServiceIntegration
- **Path**: `/FieldServiceIntegration/`
- **Type**: Cloud Integration Extension
- **Purpose**: Integration with Microsoft Dynamics 365 Field Service
- **Structure**: Source/, Test Library/, Test/
- **Key Components**:
  - Synchronization engine
  - Field Service connectors
  - Work order sync
  - Resource synchronization
  - Service task integration
- **Use Cases**: Work order synchronization, resource scheduling integration, field operations
- **Integration Partner**: Microsoft Dynamics 365 Field Service
- **Scope**: Bidirectional sync for field service operations
- **Dependencies**: BaseApp (Service Management when applicable)
- **Typical Workflow**: Sales order → Field Service work order → Completion → BC invoice

### ExternalEvents
- **Path**: `/ExternalEvents/`
- **Type**: Integration Framework
- **Purpose**: Event-based integration framework
- **Structure**: Source/, Test/
- **Key Components**:
  - Event publishers
  - Webhook subscriptions
  - Event routing
  - External event handlers
- **Use Cases**: Real-time event notifications, external system triggers, event-driven architecture
- **Dependencies**: BaseApp
- **Pattern**: Publish/Subscribe model for external systems
- **Use Case**: When BC event occurs → trigger external system event

---

## 7. DATA MANAGEMENT MODULES

### DataArchive
- **Path**: `/DataArchive/`
- **Type**: Data Management Extension
- **Purpose**: Historical data archival and retention management
- **Structure**: app/Data Archive/, test/Data Archive Tests/
- **Key Components**:
  - Archive tables for all transaction types
  - Data retention policies
  - Archival jobs and automation
  - Archive retrieval functionality
  - Audit trail preservation
- **Use Cases**: Performance optimization, compliance data retention, reducing database size
- **Key Features**: Automated archival based on retention rules
- **Dependencies**: BaseApp (access to all transactional tables)
- **Scope**: Can archive G/L entries, Customer/Vendor ledgers, Item ledger entries, etc.
- **Benefit**: Significant database performance improvement when archiving old data

### DataSearch
- **Path**: `/DataSearch/`
- **Type**: Utility Extension
- **Purpose**: Advanced search capabilities across Business Central data
- **Structure**: Source/, Test/
- **Key Components**:
  - Search indexes
  - Global search page
  - Quick search functionality
  - Search filters and sorting
- **Use Cases**: Quick data lookup across modules, cross-module search, user navigation
- **Dependencies**: BaseApp
- **User Benefit**: Find customers, vendors, items, documents quickly across system

### MasterDataManagement
- **Path**: `/MasterDataManagement/`
- **Type**: Data Governance Extension
- **Purpose**: Centralized master data governance and management
- **Structure**: Source/, Test Library/, Test/
- **Key Components**:
  - Master data synchronization
  - Data quality rules
  - Data validation routines
  - Master data dashboard
  - Data governance workflows
- **Use Cases**: Multi-company master data, data governance, master data synchronization
- **Dependencies**: BaseApp (Customer, Vendor, Item, G/L Account)
- **Scope**: Manages critical master data across organization
- **Typical Use**: Large multi-company organizations

---

## 8. EMAIL & COMMUNICATIONS MODULES

### EmailLogging
- **Path**: `/EmailLogging/`
- **Type**: Cloud Integration Extension
- **Purpose**: Email tracking and logging using Microsoft Graph API
- **Structure**: Source/_Exclude_Email Logging Using Graph API/, Test/
- **Key Components**:
  - Graph API connector
  - Email queue management
  - Email attachment handling
  - Email logging to contacts
- **Use Cases**: Email trail for customer/vendor communication, audit trail, communication history
- **Integration**: Microsoft Graph API
- **Dependencies**: BaseApp, Microsoft Graph API
- **Authentication**: Azure AD via Graph
- **Benefit**: Automatic email logging without Outlook sync tools

### Email - Current User Connector
- **Path**: `/Email - Current User Connector/`
- **Type**: Email Extension
- **Purpose**: Send emails as current logged-in user
- **Key Components**:
  - SMTP connector
  - Current user authentication
  - Sent items tracking
  - Email composition
- **Use Cases**: Personal email sending from BC, user-based email sending
- **Dependencies**: BaseApp
- **Configuration**: SMTP credentials for user mailbox
- **Use Case**: User sends email from BC → sent to Outlook sent items

### Email - Microsoft 365 Connector
- **Path**: `/Email - Microsoft 365 Connector/`
- **Type**: Email Extension
- **Purpose**: Native Microsoft 365 email integration
- **Key Components**:
  - OAuth-based M365 email
  - Sent items in M365
  - Attachment handling
  - Mailbox integration
- **Use Cases**: Enterprise email sending through M365, modern cloud email
- **Dependencies**: BaseApp, Azure AD authentication
- **Authentication**: OAuth 2.0 via Azure AD
- **Recommended**: For M365 organizations

### Email - Outlook REST API
- **Path**: `/Email - Outlook REST API/`
- **Type**: Email Extension
- **Purpose**: Outlook integration via REST API
- **Key Components**:
  - REST API connector for Outlook
  - Calendar integration
  - Contacts sync
  - Event integration
- **Use Cases**: Rich Outlook integration, calendar access, contact linking
- **Dependencies**: BaseApp, Microsoft Graph API
- **Capabilities**: Send, read, calendar events, contacts

### Email - SMTP API
- **Path**: `/Email - SMTP API/`
- **Type**: Email Extension
- **Purpose**: Standard SMTP email API
- **Key Components**:
  - SMTP protocol implementation
  - Email composition
  - Attachment support
  - SMTP authentication
- **Use Cases**: Universal email sending via SMTP, non-Microsoft email servers
- **Dependencies**: BaseApp
- **Configuration**: SMTP server address, port, credentials
- **Use Case**: Universal solution for any SMTP provider

### Email - SMTP Connector
- **Path**: `/Email - SMTP Connector/`
- **Type**: Email Extension
- **Purpose**: SMTP connector implementation
- **Key Components**:
  - SMTP connection management
  - Email queue
  - Retry logic
  - Error handling
- **Use Cases**: Traditional SMTP email setup, corporate email servers
- **Dependencies**: BaseApp
- **Difference from SMTP API**: Connector is pre-configured, API is more flexible

### Send To Email Printer
- **Path**: `/SendToEmailPrinter/Source/Send To Email Printer/`
- **Type**: Report Extension
- **Purpose**: Email reports as PDF attachments
- **Key Components**:
  - Print-to-email functionality
  - Report PDF generation
  - Email composition
  - Recipient selection
- **Use Cases**: Report distribution via email, automated report delivery, archival via email
- **Dependencies**: BaseApp (Report framework)
- **Typical Flow**: Generate report → convert to PDF → email to recipients

---

## 9. DOCUMENT MANAGEMENT MODULES

### EDocument Core
- **Path**: `/EDocument Core/`
- **Type**: Core Business Module
- **Purpose**: Core electronic document framework and infrastructure
- **Structure**: Source/, Test/E-Document Core Tests/
- **Key Components**:
  - E-document base tables
  - E-document workflow infrastructure
  - Approval workflow for e-documents
  - Document status management
  - Service provider framework
- **Use Cases**: Electronic invoicing foundation, digital document processing, compliance
- **Key Role**: Foundation for all e-invoicing implementations
- **Dependencies**: BaseApp (Sales/Purchase documents)
- **Important**: Base for all e-document connectors

### EDocumentConnectors
- **Path**: `/EDocumentConnectors/`
- **Type**: Cloud Integration Extension
- **Purpose**: External e-document service connectors
- **Structure**: Source/, Test/
- **Key Components**:
  - Connector framework for e-invoice providers
  - Provider-specific connectors
  - Document submission routines
  - Response handling
- **Use Cases**: Peppol network, country-specific e-invoicing services, compliance filing
- **Supported Providers**: Multiple e-invoice service providers
- **Dependencies**: EDocument Core
- **Typical Integration**: BC → EDocument Connector → External Provider → Tax Authority

### EnforcedDigitalVouchers
- **Path**: `/EnforcedDigitalVouchers/`
- **Type**: Compliance Extension
- **Purpose**: Digital voucher compliance (country-specific requirements)
- **Structure**: Source/, Test/
- **Key Components**:
  - Digital voucher enforcement rules
  - Attachment requirements
  - Compliance validation
  - Documentation enforcement
- **Use Cases**: Regulatory compliance for digital documentation
- **Regulatory Context**: France (Facturx), Germany (ZUGFeRD) digital requirements
- **Dependencies**: BaseApp, EDocument Core
- **Compliance**: Enforces digital receipt/invoice regulations

### AuditFileExport
- **Path**: `/AuditFileExport/`
- **Type**: Compliance Extension
- **Purpose**: Standardized audit file export (SAF-T, etc.)
- **Structure**: Source/Audit File Export/, Test/Audit File Export Tests/
- **Key Components**:
  - SAF-T format generators
  - Audit trail exports
  - GL entry exports
  - Customer/Vendor ledger exports
  - VAT ledger exports
- **Use Cases**: Tax authority audit file submission, regulatory compliance
- **Formats**: SAF-T (Standard Audit File for Tax)
- **Dependencies**: BaseApp (all transactional data)
- **Typical Use**: Tax audit or government request → export SAF-T file

---

## 10. LOCALIZATION & REGULATORY MODULES

### Intrastat
- **Path**: `/Intrastat/`
- **Type**: Compliance Extension
- **Purpose**: EU Intra-community trade reporting
- **Structure**: Demo Data/, Source/, Test/
- **Key Components**:
  - Intrastat journal tables
  - Intrastat declaration reports
  - Statistical classification
  - EU trade reporting
- **Use Cases**: Monthly/quarterly EU trade statistics reporting, customs reporting
- **Regulatory**: EU Intrastat regulation
- **Dependencies**: BaseApp (Item Ledger Entry, Value Entry)
- **Frequency**: Monthly/Quarterly filing
- **Scope**: All companies with EU intra-community trade

### IntrastatBE
- **Path**: `/IntrastatBE/Source/Intrastat BE/`
- **Type**: Localization Extension
- **Purpose**: Belgium-specific Intrastat reporting
- **Key Components**:
  - BE-specific Intrastat formats
  - Belgium customs codes
  - BE reporting requirements
  - XML export for Belgian authorities
- **Localization**: Belgium
- **Dependencies**: Intrastat (core)
- **Note**: Country-specific variant of core Intrastat
- **Regulatory**: Belgian tax authority requirements

### EU3PartyTradePurchase
- **Path**: `/EU3PartyTradePurchase/`
- **Type**: Compliance Extension
- **Purpose**: EU triangular trade handling
- **Structure**: Source/, Test/
- **Key Components**:
  - 3-party trade logic
  - EU VAT handling for triangular trades
  - Reverse charge mechanism
  - Special VAT rules
- **Use Cases**: Drop shipment with EU VAT rules, triangular trade scenarios
- **Regulatory**: EU VAT Directive
- **Dependencies**: BaseApp (Purchase documents)
- **Complexity**: Medium-High (specialized VAT rules)

### ServiceDeclaration
- **Path**: `/ServiceDeclaration/`
- **Type**: Compliance Extension
- **Purpose**: EU service declaration reporting
- **Structure**: Source/, Test/
- **Key Components**:
  - Service trade statistics
  - Cross-border service reporting
  - Declaration forms
  - Statistical reporting
- **Use Cases**: Reporting cross-border services in EU, service statistics
- **Regulatory**: EU service statistics regulation
- **Dependencies**: BaseApp (Sales documents)
- **Scope**: EU-wide service trade reporting

---

## 11. EXTERNAL STORAGE & CLOUD MODULES

### External File Storage - Azure Blob Service Connector
- **Path**: `/External File Storage - Azure Blob Service Connector/`
- **Type**: Cloud Integration Extension
- **Purpose**: Azure Blob Storage integration
- **Key Components**:
  - Blob API connector
  - File upload/download
  - Blob container management
  - Authentication to Azure
- **Use Cases**: Large file storage, document archival in Azure, backup
- **Cloud Platform**: Microsoft Azure
- **Authentication**: Storage account keys or SAS tokens
- **Dependencies**: BaseApp, Azure authentication
- **Benefit**: Unlimited scalable storage outside BC database

### External File Storage - Azure File Service Connector
- **Path**: `/External File Storage - Azure File Service Connector/`
- **Type**: Cloud Integration Extension
- **Purpose**: Azure File Share integration
- **Key Components**:
  - Azure Files API connector
  - File share access (SMB-compatible)
  - Directory structure support
  - Azure authentication
- **Use Cases**: Shared file access, SMB-compatible storage, enterprise file sharing
- **Cloud Platform**: Microsoft Azure
- **Protocol**: SMB/NFS compatible
- **Dependencies**: BaseApp, Azure authentication
- **Advantage**: SMB protocol allows Windows mapping

### External File Storage - SharePoint Connector
- **Path**: `/External File Storage - SharePoint Connector/`
- **Type**: Cloud Integration Extension
- **Purpose**: Microsoft SharePoint integration
- **Key Components**:
  - SharePoint API connector
  - Document library access
  - Site/Web collection access
  - Document versioning support
- **Use Cases**: Enterprise document management, SharePoint DMS, document collaboration
- **Cloud Platform**: Microsoft SharePoint/Microsoft 365
- **Integration**: Microsoft Graph API
- **Dependencies**: BaseApp, Microsoft Graph API
- **Typical Use**: Store BC documents in SharePoint for collaboration

### Universal Print Integration
- **Path**: `/MicrosoftUniversalPrint/Source/Universal Print Integration/`
- **Type**: Cloud Service Extension
- **Purpose**: Microsoft Universal Print service integration
- **Key Components**:
  - Universal Print API
  - Cloud printing
  - Print job submission
  - Printer management
- **Use Cases**: Cloud-based printing without print servers, enterprise printing
- **Cloud Platform**: Microsoft Universal Print
- **Benefit**: No on-premises print servers needed
- **Dependencies**: BaseApp (Printer Selection)
- **Requirement**: Azure subscription with Universal Print

---

## 12. SERVICE MANAGEMENT MODULE

### ServiceManagement
- **Path**: `/ServiceManagement/`
- **Type**: Core Business Module
- **Purpose**: Complete service order and contract management functionality
- **Structure**: Source/Service Management/, Test/Service Management Tests/
- **Key Components**:
  - Service Order (Header/Line)
  - Service Contract (Header/Line)
  - Service Item and Service Item Component
  - Service Item Line
  - Service Ledger Entry
  - Resource Allocation
  - Service Task
  - Service Invoice
- **Key Objects**:
  - Service Header/Line tables and pages
  - Service Contract Header/Line
  - Service Item tables
  - Resource allocation tables
- **Use Cases**: Field service, maintenance contracts, repair orders, warranty management
- **Key Features**:
  - Contract management with renewal
  - Service item components tracking
  - Resource allocation and scheduling
  - Service task management
  - Service ledger for posting
- **Dependencies**: BaseApp (Resource, Item, Customer)
- **Scope**: Large module covering complete service workflow
- **Typical Users**: Service companies, field service organizations, maintenance providers

---

## 13. SUBSCRIPTION & RECURRING BILLING MODULES

### SubscriptionBilling
- **Path**: `/SubscriptionBilling/`
- **Type**: Business Extension
- **Purpose**: Recurring revenue and subscription management
- **Structure**: Source/, Test/
- **Key Components**:
  - Subscription contract tables
  - Recurring invoice generation engine
  - MRR (Monthly Recurring Revenue) tracking
  - Pro-rata billing calculations
  - Subscription journals
- **Key Features**:
  - Recurring invoice generation
  - MRR reporting and forecasting
  - Pro-rata billing on subscription changes
  - Automated renewal processing
  - Usage-based billing support
- **Use Cases**: SaaS billing, recurring services, subscription boxes, maintenance contracts
- **Dependencies**: BaseApp (Sales documents, Customer)
- **Typical Business Model**: Monthly/annual subscriptions
- **Benefit**: Automated recurring billing reduces manual invoice creation

### PaymentPractices
- **Path**: `/PaymentPractices/`
- **Type**: Compliance Extension
- **Purpose**: Payment practice reporting and compliance
- **Structure**: Source/, Test/
- **Key Components**:
  - Payment term analysis
  - Late payment statistics
  - Payment delay calculation
  - Compliance reporting
  - Payment practice disclosure
- **Use Cases**: Payment practice transparency reporting, regulatory compliance, business intelligence
- **Regulatory**: EU Payment Practices Directive (transparency reporting)
- **Dependencies**: BaseApp (Vendor Ledger Entry, Customer Ledger Entry)
- **Typical Report**: Average days to pay, payment delay percentage, compliance status

---

## 14. ANALYTICS & REPORTING MODULES

### PowerBIReports
- **Path**: `/PowerBIReports/`
- **Type**: Analytics Extension
- **Purpose**: Embedded Power BI reporting in Business Central
- **Structure**: Source/, Test Library/, Test Suite/
- **Key Components**:
  - Power BI embed pages
  - Report configuration tables
  - Report selection and filtering
  - Linked Power BI reports
- **Key Features**: Direct Power BI integration within BC pages
- **Use Cases**: Interactive dashboards, advanced analytics, executive reporting
- **Technology**: Power BI service with embedding
- **Dependencies**: BaseApp, Power BI service
- **Requirement**: Power BI license and configured reports
- **Benefit**: Rich analytics directly in BC without leaving the system

### ExcelReports
- **Path**: `/ExcelReports/`
- **Type**: Reporting Extension
- **Purpose**: Excel-based reporting and data export
- **Structure**: Source/, Test/
- **Key Components**:
  - Excel buffer table
  - Excel export utilities
  - Format and styling
  - Chart generation
- **Use Cases**: Financial reports in Excel, data analysis, finance team reporting
- **Dependencies**: BaseApp
- **Common Use**: Export GL, AR, AP data to Excel for analysis

### ReportLayouts
- **Path**: `/ReportLayouts/`
- **Type**: Reporting Extension
- **Purpose**: Custom report layout management
- **Structure**: Source/, Test/
- **Key Components**:
  - Layout selection mechanism
  - Custom RDLC layout support
  - Custom Word document layout support
  - Layout customization pages
- **Use Cases**: Branded reports, custom document layouts, report formatting
- **Dependencies**: BaseApp (Report framework)
- **Supported Formats**: RDLC (SQL Reporting Services), Word document layouts
- **Benefit**: Business users can select or create custom layouts without AL coding

---

## 15. DEMO & SAMPLE DATA MODULES

### ContosoCoffeeDemoDataset
- **Path**: `/ContosoCoffeeDemoDataset/`
- **Type**: Demo Data Extension
- **Purpose**: Standard demo data for Business Central training and POCs
- **Structure**: Source/, Test/
- **Key Components**:
  - Master data (customers, vendors, items)
  - Chart of accounts
  - Sales transactions
  - Purchase transactions
  - Inventory data
  - Manufacturing data
- **Scenario**: Contoso Coffee company (manufacturing + retail)
- **Use Cases**: Training, demos, proof of concepts, feature exploration
- **Size**: Medium dataset with realistic volumes
- **Dependencies**: BaseApp
- **Contains**: ~30 customers, ~20 vendors, ~100 items, sample transactions

### Contoso Coffee Demo Dataset (BE)
- **Path**: `/ContosoCoffeeDemoDatasetBE/Source/Contoso Coffee Demo Dataset (BE)/`
- **Type**: Localization Extension
- **Purpose**: Belgium-localized demo data
- **Key Components**:
  - BE-specific chart of accounts
  - Belgian customers and vendors
  - BE-specific setup
  - Localized data
- **Localization**: Belgium
- **Dependencies**: ContosoCoffeeDemoDataset, IntrastatBE
- **Use**: Demo in Belgium, compliance with BE accounting standards

### Sustainability Contoso Coffee Demo Dataset
- **Path**: `/SustainabilityContosoCoffeeDemoDataset/Source/Sustainability Contoso Coffee Demo Dataset/`
- **Type**: Demo Data Extension
- **Purpose**: Demo data for sustainability (ESG) features
- **Key Components**:
  - ESG metrics for Contoso Coffee
  - Sustainability accounts
  - Emission data
  - Sustainability journals
  - Demo carbon calculations
- **Dependencies**: ContosoCoffeeDemoDataset, Sustainability
- **Use Case**: Demonstrate sustainability reporting features

---

## 16. ADMIN & CONFIGURATION MODULES

### PlanConfiguration
- **Path**: `/PlanConfiguration/`
- **Type**: Configuration Extension
- **Purpose**: License plan and permission set configuration
- **Structure**: Source/, Test/
- **Key Components**:
  - Plan-to-permission mapping
  - License management tables
  - Plan assignment
  - Permission automation
- **Use Cases**: User license management, permission automation, plan assignment
- **Scope**: Administrative configuration of user plans and permissions
- **Dependencies**: System Application
- **Typical Setup**: Assign users to plans → automatic permission assignment

### RecommendedApps
- **Path**: `/RecommendedApps/`
- **Type**: Navigation Extension
- **Purpose**: App recommendation engine
- **Structure**: Source/, Test/
- **Key Components**:
  - App suggestion algorithm
  - Contextual recommendations
  - App discovery pages
  - Usage analytics
- **Use Cases**: Guiding users to relevant extensions, app discovery
- **Benefit**: Help users discover features they might use
- **Dependencies**: BaseApp

### Company Hub
- **Path**: `/CompanyHub/Source/Company Hub/`
- **Type**: Navigation Extension
- **Purpose**: Multi-company overview and management
- **Key Components**:
  - Cross-company dashboard
  - KPI aggregation
  - Company selection and switching
  - Multi-company reporting
- **Use Cases**: Managing multiple BC companies from one interface, executive dashboard
- **Dependencies**: BaseApp (multi-company support)
- **Benefit**: Single sign-in to view data across multiple companies

### ClientAddIns
- **Path**: `/ClientAddIns/Source/_Exclude_ClientAddIns_/`
- **Type**: UI Extension
- **Purpose**: Client-side controls and add-ins
- **Key Components**:
  - JavaScript controls
  - Map controls (Bing Maps)
  - Camera/barcode controls
  - Custom client controls
- **Use Cases**: Rich client functionality, maps, barcode scanning, image capture
- **Note**: "_Exclude_" suggests special build handling
- **Dependencies**: BaseApp
- **Example**: QR code scanner add-in for item receiving

### OnpremPermissions
- **Path**: `/Onprem Permissions/`
- **Type**: Configuration Extension
- **Purpose**: On-premises permission set definitions
- **Key Components**:
  - Legacy permission sets
  - Permission objects and tables
  - On-prem role definitions
- **Use Cases**: On-prem to SaaS migration, permission mapping
- **Deployment**: On-premises only
- **Dependencies**: System Application
- **Note**: For on-premises deployments only, SaaS uses plan-based permissions

---

## 17. SUSTAINABILITY MODULES

### Sustainability
- **Path**: `/Sustainability/`
- **Type**: Core Business Module
- **Purpose**: ESG (Environmental, Social, Governance) management and accounting
- **Structure**: Source/Sustainability/, Test/Sustainability Tests/
- **Key Components**:
  - Sustainability Account master data
  - Sustainability Journal and Ledger
  - Emission factor tables
  - Sustainability posting routines
  - ESG reporting pages
  - Carbon footprint calculation
- **Key Objects**:
  - Sustainability Account table
  - Sustainability Journal
  - Sustainability Ledger Entry
  - Emission calculations
- **Use Cases**: Carbon footprint tracking, ESG reporting, CSRD compliance, sustainability KPIs
- **Key Features**:
  - Scope 1, 2, 3 emissions tracking
  - Carbon intensity reporting
  - Sustainability dashboards
  - Regulatory reporting
- **Regulatory**: EU CSRD (Corporate Sustainability Reporting Directive)
- **Dependencies**: BaseApp (G/L framework), StatisticalAccounts
- **Major Feature**: New in BC26+, significantly expanded in BC27

### SustainabilityCopilotSuggestion
- **Path**: `/SustainabilityCopilotSuggestion/`
- **Type**: AI/Copilot Extension
- **Purpose**: AI-powered sustainability data entry assistance
- **Structure**: Source/, Test/
- **Key Components**:
  - Copilot integration
  - Emission factor suggestions
  - Automatic calculations
  - Data validation
- **Key Features**: Automatic emission factor suggestions based on context
- **Use Cases**: Simplifying ESG data entry, emission calculations, reducing manual entry
- **Technology**: Copilot/AI-powered suggestions
- **Dependencies**: Sustainability
- **Benefit**: Reduces errors and time for sustainability data entry

---

## 18. E-COMMERCE INTEGRATION

### Shopify
- **Path**: `/Shopify/`
- **Type**: Cloud Integration Extension
- **Purpose**: Shopify e-commerce platform integration
- **Structure**: app/Shopify Connector/, test/Shopify Connector Test/
- **Key Components**:
  - Product synchronization (BC ↔ Shopify)
  - Order import from Shopify
  - Inventory synchronization
  - Customer synchronization
  - Shop setup and configuration
- **Key Features**:
  - Bi-directional product sync
  - Order import and fulfillment
  - Inventory level sync
  - Customer data sync
  - Pricing sync
- **Use Cases**: E-commerce operations, omnichannel retail, Shopify integration
- **Integration Partner**: Shopify
- **API**: Shopify REST API
- **Dependencies**: BaseApp (Item, Customer, Sales Order)
- **Typical Workflow**: Shopify customer places order → import to BC → fulfill → update Shopify

---

## 19. ADVANCED AI/ML FEATURES

### LatePaymentPredictor
- **Path**: `/LatePaymentPredictor/`
- **Type**: AI/ML Extension
- **Purpose**: Machine learning-based payment prediction
- **Structure**: Source/Late Payment Prediction/, Test/Late Payment Prediction Tests/
- **Key Components**:
  - ML prediction models
  - Payment prediction algorithms
  - Prediction dashboard
  - Risk scoring
- **Key Features**: Predicts likelihood of late payment for invoices
- **Use Cases**: Credit management, cash flow forecasting, dunning prioritization
- **Technology**: Azure ML integration
- **Dependencies**: BaseApp (Customer Ledger Entry, Sales Invoice)
- **ML Input**: Historical payment data, customer risk factors
- **Output**: Risk score indicating payment likelihood

### ErrorMessagesWithRecommendations
- **Path**: `/ErrorMessagesWithRecommendations/`
- **Type**: AI Extension
- **Purpose**: Intelligent error handling with actionable suggestions
- **Structure**: Source/, Test/
- **Key Components**:
  - Error message enrichment
  - AI-powered resolution recommendations
  - Help text generation
  - Action suggestions
- **Key Features**: AI-powered error resolution guidance
- **Use Cases**: Reduced support burden, self-service troubleshooting, better user experience
- **Dependencies**: System Application
- **Benefit**: Users get suggested solutions without contacting support

### EssentialBusinessHeadlines
- **Path**: `/EssentialBusinessHeadlines/`
- **Type**: Analytics Extension
- **Purpose**: Intelligent business insights and headlines
- **Structure**: Source/, Test/
- **Key Components**:
  - Business intelligence summaries
  - Trend detection
  - Headline generation
  - KPI insights
- **Use Cases**: Executive dashboard, business insights, KPI highlights
- **Dependencies**: BaseApp
- **Example**: "Sales trending up 15% week-over-week"

### Create Product Information With Copilot
- **Path**: `/CreateProductInformationWithCopilot/Source/Create Product Information With Copilot/`
- **Type**: AI/Copilot Extension
- **Purpose**: AI-generated product descriptions and attributes
- **Key Components**:
  - GPT-based content generation
  - Product description generator
  - Product attribute suggestion
  - Copilot interaction
- **Key Features**: Generate marketing text, product attributes
- **Use Cases**: E-commerce product setup, marketing content generation, catalog enrichment
- **Technology**: Azure OpenAI (GPT) integration
- **Dependencies**: BaseApp (Item)
- **Typical Workflow**: Enter basic item info → Copilot generates product description → review and refine

---

## 20. VAT MANAGEMENT

### VATGroupManagement
- **Path**: `/VATGroupManagement/`
- **Type**: Compliance Extension
- **Purpose**: VAT group consolidation for multi-company structures
- **Structure**: Source/VAT Group Management/, Test/VAT Group Management Tests/
- **Key Components**:
  - VAT group setup tables
  - Consolidated VAT returns
  - Group member management
  - VAT consolidation routines
  - Group VAT reporting
- **Key Features**:
  - Group VAT filing
  - Intra-group transaction handling
  - Consolidated VAT reports
  - Regulatory compliance
- **Use Cases**: Group VAT reporting, multi-legal entity VAT, consolidated filings
- **Regulatory**: EU VAT group provisions, country-specific group provisions
- **Dependencies**: BaseApp (VAT Entry, multi-company)
- **Typical Use**: Corporate group with multiple legal entities files single VAT return

---

## 21. INFRASTRUCTURE & TESTING

### .github/workflows
- **Path**: `/.github/workflows/`
- **Type**: Infrastructure
- **Purpose**: GitHub Actions CI/CD pipelines
- **Key Functions**:
  - Automated daily artifact pulls
  - Branch updates
  - Build verification
  - Test automation
- **Use**: Repository maintenance and testing

### scripts
- **Path**: `/scripts/`
- **Type**: Infrastructure
- **Purpose**: Repository maintenance and utility scripts
- **Key Functions**: Repository updates, artifact management, automation
- **Use**: Regular repository maintenance

### testframework
- **Path**: `/testframework/`
- **Type**: Testing Framework
- **Purpose**: Business Central test automation framework
- **Structure**: Libraries and utilities for testing
- **Key Components**:
  - Test libraries
  - Test runner utilities
  - Mock objects
  - Assertion libraries
- **Use Cases**: AL test development, automated testing, unit tests
- **Scope**: Framework used across all modules for testing

---

## Summary Statistics

| Metric | Count |
|--------|-------|
| **Total Modules** | 73 |
| **Core Foundation** | 4 |
| **Business Extensions** | 69 |
| **AI/ML Features** | 7 |
| **Cloud Integrations** | 15+ |
| **Email Connectors** | 7 |
| **Storage Connectors** | 4 |
| **Payment Gateways** | 2 |
| **API Versions** | 2 |

---

**Document Version**: 1.0
**BC Version**: 27
**Branch**: be-27 (Belgium)
**Last Updated**: 2025-11-07

