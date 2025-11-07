# BC27 - Complete Features Index

Comprehensive feature reference for Business Central version 27, organized by capability and module.

---

## Table of Contents
[Business Management](#business-management) | [Financial Management](#financial-management) | [Inventory & Warehouse](#inventory--warehouse) | [Manufacturing](#manufacturing) | [Sales](#sales) | [Purchasing](#purchasing) | [Banking](#banking) | [Service Management](#service-management) | [Recurring Billing](#recurring-billing) | [Human Resources](#human-resources) | [Reporting & Analytics](#reporting--analytics) | [AI & Copilot](#ai--copilot-features) | [Integration](#integration) | [Cloud Services](#cloud-services) | [Compliance](#compliance) | [Sustainability](#sustainability)

---

## BUSINESS MANAGEMENT

### Multi-Company Management
- **Module**: Company Hub
- **Feature**: Single-sign-on to multiple companies
- **Capability**: Cross-company reporting and KPI tracking
- **Use Case**: Corporate group management

### Master Data Management
- **Module**: MasterDataManagement
- **Features**:
  - Centralized master data governance
  - Data quality rules
  - Data synchronization across companies
- **Use Case**: Multi-company organizations

### Dimension Management
- **Module**: BaseApp
- **Features**:
  - Department, project, cost center tracking
  - Custom dimensions
  - Dimension set entries
  - Dimension filtering on transactions
- **Use Cases**: Cost allocation, profit center reporting

### Chart of Accounts (COA)
- **Module**: BaseApp
- **Features**:
  - GL Account master data
  - Account types and categories
  - Consolidated accounts
  - Account schedules
  - Financial statement layout
- **Scope**: Foundation for all financial reporting

### Document Management
- **Module**: EDocument Core, EDocumentConnectors
- **Features**:
  - Electronic document framework
  - Digital document workflows
  - E-invoicing infrastructure
  - Document approval workflows
- **Use Case**: Paperless operations

---

## FINANCIAL MANAGEMENT

### General Ledger
- **Module**: BaseApp
- **Features**:
  - GL Account master data
  - GL Entries (transactions)
  - Posting groups
  - Account schedules
  - GL reconciliation
  - Period closing
- **Key Objects**: GL Account, GL Entry

### Accounts Receivable (AR)
- **Module**: BaseApp
- **Features**:
  - Customer master data
  - Customer ledger entries
  - Sales invoices/credit memos
  - Payment application
  - Finance charges
  - Payment methods
  - Collection letters
- **Key Objects**: Customer, Customer Ledger Entry, Sales Invoice

### Accounts Payable (AP)
- **Module**: BaseApp
- **Features**:
  - Vendor master data
  - Vendor ledger entries
  - Purchase invoices/credit memos
  - Payment scheduling
  - Purchase discounts
  - Vendor holds
- **Key Objects**: Vendor, Vendor Ledger Entry, Purchase Invoice

### Cash Management
- **Module**: BaseApp, Banking modules
- **Features**:
  - Bank account master data
  - Bank reconciliation (automated with AI)
  - Cash flow forecasting
  - Payment journal
  - Bank transactions
  - Check printing
- **Enhanced By**: BankAccRecWithAI (machine learning matching)

### Fixed Assets
- **Module**: BaseApp
- **Features**:
  - Fixed asset register
  - Depreciation schedules
  - Maintenance tracking
  - FA categories and classes
  - Asset disposals
  - FA value adjustments
- **Key Objects**: Fixed Asset, FA Depreciation Book

### Asset Accounting
- **Module**: BaseApp, DataCorrectionFA
- **Features**:
  - Depreciation calculation
  - Straight-line, declining balance methods
  - Book values and adjusted values
  - FA ledger entries
  - Asset life management
- **Maintenance**: DataCorrectionFA for corrections

### Cost Accounting
- **Module**: BaseApp
- **Features**:
  - Cost centers
  - Cost allocations
  - Overhead allocation
  - Costing methods (Standard, Average, FIFO, LIFO)
  - Variance analysis
- **Integration**: Links to Manufacturing, Inventory

### Period Closing
- **Module**: BaseApp, ReviewGLEntries
- **Features**:
  - G/L reconciliation
  - Period entry review
  - Adjustment journal posting
  - Closing procedures
  - Closing tolerances
- **Analysis**: ReviewGLEntries module for detailed analysis

### Statistical Accounts
- **Module**: StatisticalAccounts
- **Features**:
  - Non-financial metrics tracking
  - Statistical journals
  - Statistical ledger entries
  - KPI tracking
  - Performance metrics
- **Examples**: Units produced, headcount, environmental units

### Tax Compliance
- **Module**: BaseApp, Compliance modules
- **Features**:
  - Tax group setup
  - Sales tax (GST, VAT)
  - Purchase tax
  - Tax reporting
  - Tax calculation
- **Enhanced By**: VATGroupManagement (group tax), Intrastat (EU trade)

### VAT Group Management
- **Module**: VATGroupManagement
- **Features**:
  - Consolidated VAT returns
  - Group member management
  - VAT consolidation routines
  - Intra-group transaction handling
- **Use Case**: Multi-company VAT filing

---

## INVENTORY & WAREHOUSE

### Item Master Data
- **Module**: BaseApp
- **Features**:
  - Item register (products and services)
  - Item variants and versions
  - Item pictures and media
  - Item genealogy
  - Item tracking (serial/batch)
- **Key Objects**: Item, Item Variant, Item Ledger Entry

### Inventory Valuation
- **Module**: BaseApp
- **Features**:
  - Inventory aging
  - Value entries
  - Costing methods
  - Inventory adjustments
  - Stock valuations
  - ABC analysis
- **Cost Methods**: Standard, Average, FIFO, LIFO

### Warehouse Management
- **Module**: BaseApp, Manufacturing
- **Features**:
  - Location management
  - Bin structure
  - Stock movement
  - Bin contents
  - Physical inventory
  - Cycle counts
  - Warehouse documents
- **Advanced**: Directed put-away and picking

### Stock Keeping Unit (SKU)
- **Module**: BaseApp
- **Features**:
  - SKU-specific setup
  - Location-specific item data
  - Replenishment parameters
  - Safety stock levels
- **Use Case**: Multi-location inventory management

### Item Charges
- **Module**: BaseApp
- **Features**:
  - Landing costs
  - Freight allocation
  - Duty allocation
  - Charge codes
  - Item charge assignments
- **Use Case**: Landed cost accounting

### Goods in Transit
- **Module**: BaseApp
- **Features**:
  - In-transit inventory
  - Transfer in transit
  - Shipping agents
  - Customs handling
- **Use Case**: Inter-location transfers

---

## MANUFACTURING

### Production Orders
- **Module**: Manufacturing
- **Features**:
  - Make-to-order production
  - Make-to-stock production
  - Job production
  - Production order header/line
  - Production planning
  - Production scheduling
- **Key Objects**: Production Order, Production Line

### Bill of Materials (BOM)
- **Module**: Manufacturing
- **Features**:
  - Multi-level BOMs
  - Component quantities
  - Scrap percentages
  - Byproduct handling
  - Phantom BOMs
  - BOM lines and versions
- **Key Objects**: Production BOM, Production BOM Line

### Routing & Operations
- **Module**: Manufacturing
- **Features**:
  - Production routing
  - Operations and sequences
  - Operation times (setup, run, move, wait)
  - Parallel operations
  - Work center selection
  - Machine center assignment
- **Key Objects**: Routing, Routing Line

### Capacity Planning
- **Module**: Manufacturing
- **Features**:
  - Work center capacity
  - Machine center capacity
  - Capacity loads
  - Bottleneck identification
  - Capacity requirements planning
  - Routing calendars
- **Key Objects**: Work Center, Machine Center, Capacity Ledger Entry

### Production Scheduling
- **Module**: Manufacturing
- **Features**:
  - Finite capacity scheduling
  - Infinite capacity scheduling
  - Operation scheduling
  - Production order scheduling
  - Backward/forward scheduling
- **Optimization**: Automatic schedule optimization

### Material Requirements Planning (MRP)
- **Module**: Manufacturing
- **Features**:
  - MRP calculations
  - Net requirements
  - Demand forecasting
  - Supply planning
  - Planned orders
  - Purchase requisitions
- **Enhanced By**: SalesAndInventoryForecast

### Shop Floor Control
- **Module**: Manufacturing
- **Features**:
  - Production consumption
  - Labor tracking
  - Machine tracking
  - Output registration
  - Production journals
  - Work center queues
- **Reporting**: Shop floor dashboards

### Costing of Production
- **Module**: Manufacturing
- **Features**:
  - Labor cost allocation
  - Machine cost allocation
  - Overhead allocation
  - Variance analysis
  - Cost rollup
  - Material cost adjustment
- **Methods**: Standard and actual costing

### Quality Management
- **Module**: Manufacturing
- **Features**:
  - Quality measurements
  - Quality control points
  - Defect tracking
  - Quality issues
  - Non-conformance recording
- **Integration**: Quality checks in production workflow

---

## SALES

### Sales Orders
- **Module**: BaseApp
- **Features**:
  - Sales order entry
  - Line items with quantities and prices
  - Shipping and billing addresses
  - Order confirmation printing
  - Partial shipping
  - Backorder handling
  - Sales order scheduling
- **Key Objects**: Sales Header, Sales Line

### Sales Invoices
- **Module**: BaseApp
- **Features**:
  - Sales invoice creation
  - Direct posting or from order
  - Invoice discounts
  - Payment terms
  - Line-level tracking
  - Invoice archival
- **Key Objects**: Sales Invoice Header/Line

### Sales Quotes
- **Module**: BaseApp
- **Features**:
  - Quote creation and expiration
  - Quote conversion to order
  - Quote version control
  - Validity periods
  - Quote response tracking
- **Key Objects**: Sales Header (Quote type)

### Credit Memos
- **Module**: BaseApp
- **Features**:
  - Full and partial credits
  - Return authorization linking
  - Adjustment handling
  - Credit memo archival
- **Key Objects**: Sales Cr. Memo Header/Line

### Sales Pricing
- **Module**: BaseApp
- **Features**:
  - Unit pricing
  - Volume discounts
  - Line discounts
  - Invoice discounts
  - Customer pricing agreements
  - Currency conversion
  - Date-based pricing
- **Objects**: Sales Price, Sales Line Discount

### Sales Discounts
- **Module**: BaseApp
- **Features**:
  - Line item discounts
  - Order-level discounts
  - Customer group discounts
  - Promotional discounts
  - Discount combinations
- **Calculation**: Automatic application

### Shipping
- **Module**: BaseApp
- **Features**:
  - Shipment documents
  - Partial shipments
  - Shipping agents
  - Tracking numbers
  - Shipping addresses
  - Shipping costs
- **Documents**: Packing slips, shipping labels

### AI Sales Assistance
- **Module**: SalesLinesSuggestions
- **Features**:
  - Copilot-powered line suggestions
  - Cross-sell recommendations
  - Up-sell recommendations
  - Historical analysis
  - Intelligent matching
- **Benefit**: Increased order values

### Sales Forecasting
- **Module**: SalesAndInventoryForecast
- **Features**:
  - Demand forecasting
  - Sales trend analysis
  - Historical forecasting
  - AI-powered predictions
  - Forecast accuracy tracking
- **Technology**: Azure ML

### Customer Management
- **Module**: BaseApp
- **Features**:
  - Customer master data
  - Credit limits
  - Payment terms
  - Shipping methods
  - Contact information
  - Customer relationships
  - Customer categories
- **Key Objects**: Customer, Customer Posting Group

---

## PURCHASING

### Purchase Orders
- **Module**: BaseApp
- **Features**:
  - Purchase order creation
  - Multi-line ordering
  - Receipt scheduling
  - Partial receipts
  - Backorder management
  - Purchase order archival
- **Key Objects**: Purchase Header, Purchase Line

### Purchase Invoices
- **Module**: BaseApp
- **Features**:
  - Invoice receipt from vendor
  - Three-way matching (PO, receipt, invoice)
  - Invoice discounts
  - Payment scheduling
  - Vendor invoice tracking
- **Key Objects**: Purchase Invoice Header/Line

### Purchase Credit Memos
- **Module**: BaseApp
- **Features**:
  - Return authorization
  - Credit memo creation
  - Full and partial returns
  - Adjustment handling
- **Key Objects**: Purchase Cr. Memo Header/Line

### Purchase Pricing
- **Module**: BaseApp
- **Features**:
  - Vendor pricing
  - Volume pricing
  - Effective dating
  - Currency handling
  - Price agreements
  - Blanket orders
- **Objects**: Purchase Price, Purchase Line Discount

### Vendor Management
- **Module**: BaseApp
- **Features**:
  - Vendor master data
  - Vendor contact information
  - Payment terms
  - Shipping methods
  - Vendor categories
  - Preferred vendors
- **Key Objects**: Vendor, Vendor Posting Group

### Receipt and Acceptance
- **Module**: BaseApp
- **Features**:
  - Goods receipt documents
  - Receiving journals
  - Quality acceptance
  - Partial receipt handling
  - Receipt confirmation
  - Return handling
- **Integration**: Links to Warehouse

### Landed Cost
- **Module**: BaseApp
- **Features**:
  - Cost allocation to purchase items
  - Freight costs
  - Insurance costs
  - Duty and customs
  - Overhead allocation
- **Calculation**: Automatic cost spreading

### Vendor 3-Party Trades
- **Module**: EU3PartyTradePurchase
- **Features**:
  - Triangular trade handling
  - Special VAT rules
  - Three-party transaction management
  - Regulatory compliance
- **Regulatory**: EU VAT Directive

---

## BANKING

### Bank Accounts
- **Module**: BaseApp, Banking modules
- **Features**:
  - Bank account master data
  - Multi-currency accounts
  - Bank account balances
  - Interest calculation
  - Overdraft management
  - Bank account posting groups
- **Key Objects**: Bank Account

### Bank Reconciliation
- **Module**: BaseApp, BankAccRecWithAI
- **Features**:
  - Manual bank reconciliation
  - AI-powered reconciliation (new in BC27)
  - Statement matching
  - Outstanding transaction tracking
  - Reconciliation differences
  - Multi-period reconciliation
- **Advanced**: Machine learning for automatic matching

### Bank Statements
- **Module**: BaseApp, SimplifiedBankStatementImport
- **Features**:
  - Bank statement import
  - Transaction matching
  - Statement reconciliation
  - Automated bank import
  - Statement formatting
  - Balance verification
- **Formats**: CSV, CAMT.053, MT940

### Payment Journals
- **Module**: BaseApp
- **Features**:
  - Payment entry
  - Check printing
  - EFT transmission
  - Payment posting
  - Payment application
  - Batch payments
- **Documents**: Payment journals, Check registers

### Check Printing
- **Module**: BaseApp
- **Features**:
  - Check design and printing
  - Voided checks
  - Check registers
  - Check stubs
  - MICR encoding
- **Support**: Custom check formats

### Bank Deposits
- **Module**: BankDeposits
- **Features**:
  - Deposit document creation
  - Deposit line items
  - Deposit posting
  - Deposit slip printing
  - Multi-payment deposits
- **Use Case**: North American deposit management

### International Payments
- **Module**: AMCBanking365Fundamentals
- **Features**:
  - SEPA payment formats
  - ISO 20022 support
  - Multi-currency payments
  - Bank file export
  - International bank codes
- **Partner**: AMC Banking Solutions

### Payment Gateways
- **Module**: PayPalPaymentsStandard, WorldPayPaymentsStandard
- **Features**:
  - Online payment capture
  - Credit card processing
  - Payment authorization
  - Fraud detection
  - Payment confirmation
  - Settlement tracking
- **Providers**: PayPal, WorldPay (FIS)

---

## SERVICE MANAGEMENT

### Service Orders
- **Module**: ServiceManagement
- **Features**:
  - Service order creation
  - Service order lines
  - Service tasks
  - Resource allocation
  - Service item linking
  - Labor tracking
  - Parts consumption
- **Key Objects**: Service Header, Service Line

### Service Contracts
- **Module**: ServiceManagement, SubscriptionBilling
- **Features**:
  - Service contract creation
  - Contract lines
  - Service items included
  - Contract renewal
  - Contract pricing
  - Warranty management
  - Contract invoicing
- **Key Objects**: Service Contract Header/Line

### Service Items
- **Module**: ServiceManagement
- **Features**:
  - Service item master data
  - Components of service items
  - Fault codes
  - Resolution codes
  - Serial numbers
  - Warranty information
- **Tracking**: Item history and components

### Work Orders
- **Module**: ServiceManagement, FieldServiceIntegration
- **Features**:
  - Work order creation from service order
  - Resource assignment
  - Time tracking
  - Material consumption
  - Completion status
  - Field Service integration
- **Integration**: Sync with Dynamics 365 Field Service

### Resource Management
- **Module**: ServiceManagement
- **Features**:
  - Resource master data
  - Resource capacity
  - Resource skills
  - Availability calendar
  - Resource allocation
  - Time tracking
- **Key Objects**: Resource, Resource Capacity

### Service Ledger
- **Module**: ServiceManagement
- **Features**:
  - Service transaction posting
  - Service ledger entries
  - Service hours tracking
  - Service cost tracking
  - Service profitability analysis
- **Key Objects**: Service Ledger Entry

### Service Invoicing
- **Module**: ServiceManagement
- **Features**:
  - Service invoice creation
  - Contract-based invoicing
  - Labor invoicing
  - Parts invoicing
  - Service invoice posting
- **Integration**: Links to AR module

---

## RECURRING BILLING

### Subscription Contracts
- **Module**: SubscriptionBilling
- **Features**:
  - Subscription contract creation
  - Contract items and pricing
  - Renewal management
  - Billing schedules
  - Pro-rata adjustments
  - Subscription status tracking
- **Key Objects**: Subscription Contract

### Recurring Invoices
- **Module**: SubscriptionBilling
- **Features**:
  - Automated invoice generation
  - Billing period management
  - MRR (Monthly Recurring Revenue) tracking
  - Usage-based billing
  - Subscription invoicing
  - Recurring revenue recognition
- **Automation**: Scheduled invoice batch jobs

### Subscription Management
- **Module**: SubscriptionBilling
- **Features**:
  - Subscription administration
  - Subscription changes
  - Subscription cancellation
  - Upgrade/downgrade handling
  - Billing date management
  - Invoice frequency options
- **Options**: Monthly, quarterly, annual billing

---

## HUMAN RESOURCES

### Employee Master
- **Module**: BaseApp
- **Features**:
  - Employee information
  - Employment contracts
  - Compensation tracking
  - Department assignment
  - Job titles
  - Reporting relationships
- **Key Objects**: Employee

### Payroll (Basic)
- **Module**: BaseApp
- **Features**:
  - Payroll setup
  - Pay periods
  - Salary and wages
  - Deductions
  - Tax withholding
  - Payroll posting
- **Note**: Full payroll typically requires payroll module (not in base)

### Resource Management
- **Module**: ServiceManagement
- **Features**:
  - Resource data (can be employees)
  - Capacity management
  - Skills and certifications
  - Availability scheduling
  - Time tracking
- **Key Objects**: Resource

---

## REPORTING & ANALYTICS

### Financial Statements
- **Module**: BaseApp, Analytics modules
- **Features**:
  - Trial balance
  - Income statement
  - Balance sheet
  - Cash flow statement
  - Statement of changes
  - Consolidated statements
- **Layout**: Customizable report layouts

### Account Schedules
- **Module**: BaseApp
- **Features**:
  - Custom account groupings
  - Multi-dimensional analysis
  - Comparative reporting
  - Period comparisons
  - Account roll-ups
  - Formula-based calculations
- **Flexibility**: Unlimited account schedule combinations

### GL Reports
- **Module**: BaseApp, ReviewGLEntries
- **Features**:
  - GL balance reports
  - GL detail reports
  - GL aging reports
  - GL variance reports
  - Dimension reports
- **Analysis**: ReviewGLEntries for deeper analysis

### Customer/Vendor Reports
- **Module**: BaseApp, Analytics
- **Features**:
  - AR aging reports
  - AP aging reports
  - Customer sales reports
  - Vendor purchase reports
  - Customer balance reports
  - Collection reports
- **Insights**: Payment behavior analysis

### Inventory Reports
- **Module**: BaseApp, Analytics
- **Features**:
  - Inventory aging
  - Stock status
  - Slow-moving items
  - Inventory costing
  - Inventory valuation
  - ABC analysis
- **Forecasting**: Integrated with forecasting module

### Manufacturing Reports
- **Module**: Manufacturing, Analytics
- **Features**:
  - Production orders status
  - Capacity utilization
  - Material requirements
  - Work-in-progress (WIP)
  - Cost analysis
  - Production efficiency
- **Dashboards**: Shop floor dashboards

### API-Based Reports
- **Module**: APIReportsFinance, APIV1/V2
- **Features**:
  - Financial data APIs
  - REST-based reporting
  - BI tool integration
  - Third-party analytics
  - Power BI integration
  - Excel integration
- **Technology**: OData protocol

### Power BI Reports
- **Module**: PowerBIReports
- **Features**:
  - Embedded Power BI
  - Interactive dashboards
  - Real-time analytics
  - Custom visualizations
  - Report sharing
  - Report alerts
- **Technology**: Power BI embedded service

### Excel Reports
- **Module**: ExcelReports
- **Features**:
  - Data export to Excel
  - Excel buffer management
  - Formatting and styling
  - Chart generation
  - Template support
- **Common Use**: Finance team reporting

### Report Layouts
- **Module**: ReportLayouts
- **Features**:
  - Custom RDLC layouts
  - Custom Word layouts
  - Layout selection
  - Business user customization
  - Layout versioning
- **Benefit**: No AL coding needed for layout changes

### Audit File Export
- **Module**: AuditFileExport
- **Features**:
  - SAF-T file generation
  - Audit trail export
  - GL entry export
  - Tax transaction export
  - Regulatory compliance
- **Format**: Standard Audit File for Tax (SAF-T)

---

## AI & COPILOT FEATURES

### Bank Reconciliation AI
- **Module**: BankAccRecWithAI
- **Features**:
  - ML-powered transaction matching
  - Automatic reconciliation suggestions
  - Pattern recognition
  - Confidence scoring
  - Manual override capability
- **Benefit**: 80%+ reduction in manual reconciliation time

### Sales Line Suggestions
- **Module**: SalesLinesSuggestions
- **Features**:
  - Copilot-powered suggestions
  - Cross-sell recommendations
  - Up-sell recommendations
  - Item matching based on history
  - Intelligent quantity suggestions
- **Context**: Works within sales order entry

### Sales & Inventory Forecasting
- **Module**: SalesAndInventoryForecast
- **Features**:
  - Demand forecasting
  - ML-based predictions
  - Inventory optimization
  - Trend analysis
  - Forecast accuracy metrics
- **Technology**: Azure ML time-series forecasting

### Late Payment Prediction
- **Module**: LatePaymentPredictor
- **Features**:
  - ML-based payment prediction
  - Customer risk scoring
  - Payment likelihood estimation
  - Collection prioritization
  - Cash flow forecasting
- **Technology**: Azure ML models

### Sustainability Copilot
- **Module**: SustainabilityCopilotSuggestion
- **Features**:
  - Emission factor suggestions
  - Automatic calculations
  - Context-aware recommendations
  - Data validation
- **Use Case**: Simplify ESG data entry

### Product Content Generation
- **Module**: Create Product Information With Copilot
- **Features**:
  - AI-generated product descriptions
  - Product attribute suggestion
  - Marketing text generation
  - Multi-language support
- **Technology**: Azure OpenAI (GPT)

### Error Messages with Recommendations
- **Module**: ErrorMessagesWithRecommendations
- **Features**:
  - Intelligent error suggestions
  - Recommended actions
  - Help text generation
  - Self-service troubleshooting
- **Benefit**: Reduced support tickets

### Business Headlines
- **Module**: EssentialBusinessHeadlines
- **Features**:
  - Executive business insights
  - Trend detection
  - KPI highlights
  - Automatic insights generation
- **Dashboard**: Executive role center

---

## INTEGRATION

### REST APIs (V1 & V2)
- **Module**: APIV1, APIV2
- **Features**:
  - Standardized API endpoints
  - OData protocol support
  - Customer/Vendor/Item APIs
  - Sales/Purchase APIs
  - GL APIs
  - Advanced filtering and sorting
- **Authentication**: OAuth 2.0, API Keys

### External Events
- **Module**: ExternalEvents
- **Features**:
  - Event publishing framework
  - Webhook subscriptions
  - Event routing
  - Real-time notifications
  - External system triggers
- **Pattern**: Pub/Sub architecture

### Field Service Integration
- **Module**: FieldServiceIntegration
- **Features**:
  - Bidirectional sync with D365 Field Service
  - Work order synchronization
  - Resource scheduling
  - Service task integration
  - Equipment linking
- **Partner**: Microsoft Dynamics 365

### Email Connectors
- **Module**: Email modules (multiple)
- **Options**:
  - Microsoft 365 (OAuth)
  - Outlook REST API
  - SMTP (traditional)
  - Current user connector
- **Features**: Send, receive, logging, attachments

### Email Logging
- **Module**: EmailLogging
- **Features**:
  - Automatic email logging
  - Attachment storage
  - Communication history
  - Contact linking
  - Email trail audit
- **Technology**: Microsoft Graph API

### E-Commerce Integration
- **Module**: Shopify
- **Features**:
  - Product synchronization
  - Order import
  - Inventory sync
  - Customer sync
  - Pricing sync
- **Partner**: Shopify

### Cloud Storage Integration
- **Module**: Azure Blob/Files, SharePoint
- **Options**:
  - Azure Blob Storage
  - Azure File Shares (SMB)
  - SharePoint Document Libraries
- **Use**: Document storage, file management

### Payment Gateway Integration
- **Module**: PayPalPaymentsStandard, WorldPayPaymentsStandard
- **Features**:
  - Online payment capture
  - Transaction processing
  - Payment authorization
  - Settlement management
  - PCI compliance

### Print Services
- **Module**: Universal Print Integration
- **Features**:
  - Cloud-based printing
  - Enterprise print management
  - Queue management
  - Device management
- **Technology**: Microsoft Universal Print

---

## CLOUD SERVICES

### Azure Integration
- **Modules**: Storage connectors, Analytics
- **Services**:
  - Blob Storage (documents)
  - File Shares (file management)
  - Azure ML (forecasting, predictions)
  - Azure OpenAI (content generation)
- **Benefits**: Unlimited scalability, high availability

### Microsoft 365 Integration
- **Email**: Microsoft 365 email connector
- **Files**: SharePoint connector
- **Calendar**: Outlook REST API
- **Authentication**: Azure AD

### Power BI Integration
- **Module**: PowerBIReports
- **Features**:
  - Embedded Power BI
  - Interactive dashboards
  - Real-time data
  - Custom visuals
- **Licensing**: Requires Power BI

### Microsoft Teams Integration
- **Communication**: Teams webhooks
- **Notifications**: Real-time alerts
- **Workflow**: Teams-based approvals

---

## COMPLIANCE

### Intrastat Reporting
- **Module**: Intrastat, IntrastatBE
- **Features**:
  - EU intra-community trade reporting
  - Monthly/quarterly declarations
  - Statistical classification
  - Country-specific formats
  - XML export
- **Regulatory**: EU Intrastat Directive

### Audit File Export
- **Module**: AuditFileExport
- **Features**:
  - SAF-T file generation
  - Transaction export
  - GL entry export
  - Tax data export
  - Compliance formatting
- **Use**: Tax authority audits

### Digital Vouchers
- **Module**: EnforcedDigitalVouchers
- **Features**:
  - Digital receipt enforcement
  - Document attachment requirements
  - Compliance validation
  - France/Germany requirements
- **Regulatory**: National regulations (FR, DE)

### Service Declaration
- **Module**: ServiceDeclaration
- **Features**:
  - EU service trade reporting
  - Cross-border service statistics
  - Annual reporting
  - Regulatory compliance
- **Scope**: International services

### Payment Practices Reporting
- **Module**: PaymentPractices
- **Features**:
  - Payment term transparency
  - Late payment statistics
  - Disclosure requirements
  - Compliance reporting
- **Regulatory**: EU Payment Practices Directive

### EU3PartyTrade
- **Module**: EU3PartyTradePurchase
- **Features**:
  - Triangular trade handling
  - VAT rule application
  - Reverse charge mechanism
  - Regulatory compliance
- **Regulatory**: EU VAT Directive

### VAT Group Reporting
- **Module**: VATGroupManagement
- **Features**:
  - Consolidated VAT returns
  - Group member consolidation
  - Intra-group transaction handling
  - Filing preparation
- **Use**: Corporate groups

---

## SUSTAINABILITY

### ESG Accounting
- **Module**: Sustainability, StatisticalAccounts
- **Features**:
  - Carbon accounting
  - Emission tracking (Scope 1, 2, 3)
  - Sustainability journals
  - Emission factor library
  - Carbon intensity reporting
- **Regulatory**: EU CSRD compliance

### Sustainability Reporting
- **Module**: Sustainability
- **Features**:
  - ESG dashboards
  - Sustainability reports
  - Regulatory reports (CSRD, SFDR)
  - Stakeholder reporting
  - Trend analysis
- **Format**: GRI, SASB, TCFD standards

### Emission Tracking
- **Module**: Sustainability
- **Features**:
  - Energy consumption tracking
  - Emission factor calculations
  - Scope categorization
  - Emission ledger
  - Baseline comparisons
- **Data**: Purchase, production, travel data

### Sustainability Copilot
- **Module**: SustainabilityCopilotSuggestion
- **Features**:
  - AI-assisted emission entry
  - Automatic factor suggestions
  - Context-aware calculations
  - Data quality checks
- **Benefit**: Simplified ESG data entry

### Statistical Accounts for ESG
- **Module**: StatisticalAccounts
- **Features**:
  - Non-monetary metrics
  - KPI tracking
  - ESG metrics journaling
  - Statistical ledger entries
  - Metric analysis
- **Integration**: Works with Sustainability module

---

## Summary: Feature Coverage by Module Count

| Feature Area | Modules | Status |
|--------------|---------|--------|
| **Business Management** | 3-4 | Core |
| **Financial Management** | 6-8 | Core |
| **Inventory & Warehouse** | 1-2 | Core |
| **Manufacturing** | 1 | Major |
| **Sales** | 2-3 | Core |
| **Purchasing** | 1-2 | Core |
| **Banking** | 6 | Major |
| **Service Management** | 1 | Major |
| **Recurring Billing** | 2 | Extended |
| **Reporting & Analytics** | 6-7 | Extended |
| **AI & Copilot** | 7 | New in BC27 |
| **Integration** | 10-12 | Extended |
| **Cloud Services** | 4 | Extended |
| **Compliance** | 7-8 | Extended |
| **Sustainability** | 3 | New in BC26+ |

---

**Document Version**: 1.0
**BC Version**: 27
**Last Updated**: 2025-11-07

