# BC27 - Integration Guide & External Services

Complete reference for integrating Business Central with external systems, cloud services, and third-party platforms.

---

## Integration Architecture Overview

BC27 provides multiple integration patterns for connecting to external systems:

```
Business Central
    ├─→ REST APIs (APIV1, APIV2)
    ├─→ Event Webhooks (ExternalEvents)
    ├─→ Direct Cloud Connectors
    │   ├─→ Azure Services (storage, ML, OpenAI)
    │   ├─→ Microsoft 365 (email, files, calendar)
    │   └─→ Dynamics 365 (Field Service)
    ├─→ SaaS Integrations
    │   ├─→ Shopify (e-commerce)
    │   ├─→ Payment processors (PayPal, WorldPay)
    │   └─→ Bank connectors (AMC Banking)
    └─→ Legacy Integrations
        ├─→ SMTP email
        ├─→ File import/export
        └─→ Direct database access (on-prem only)
```

---

## REST APIs

### APIV1 (Legacy Support)

**Status**: Supported but V2 recommended
**Version**: v1.0
**Protocol**: OData v4
**Authentication**: OAuth 2.0, API Keys

#### Available Entities
- Customers (salesorder_customer)
- Vendors (purchase_vendor)
- Items (inventory_item)
- General Ledger Entries (financials_glentries)
- Customer Ledger Entries (financials_customerledger)
- Sales Orders (salesorder_order)
- Purchase Orders (purchase_order)
- Invoices (salesorder_invoice)

#### Usage Example
```
GET https://api.businesscentral.dynamics.com/v1.0/companies({id})/customers
Authorization: Bearer {token}
```

#### Limitations
- Basic filtering
- Limited performance optimization
- No complex joins

#### When to Use
- Legacy integrations
- Simple entity access
- Backward compatibility

---

### APIV2 (Recommended)

**Status**: Current and recommended
**Version**: v2.0
**Protocol**: OData v4
**Authentication**: OAuth 2.0, API Keys

#### Available Entities
- All APIV1 entities + additional ones
- Enhanced filtering and sorting
- Better pagination
- Complex queries support

#### Improvements Over V1
- ✅ Better performance
- ✅ Advanced filtering ($filter, $select, $expand)
- ✅ Batch operations
- ✅ Complex joins and navigation
- ✅ Async operations support

#### Usage Example
```
GET https://api.businesscentral.dynamics.com/v2.0/companies({id})/customers
  ?$filter=name eq 'Contoso'
  &$select=id,name,email
Authorization: Bearer {token}
```

#### When to Use
- New integrations
- Performance-critical scenarios
- Complex data retrieval
- Modern integration patterns

---

## Event-Based Integration

### ExternalEvents Module

**Pattern**: Publish/Subscribe architecture
**Communication**: Webhooks (HTTP POST)
**Real-time**: Yes, event-driven
**Reliability**: At-least-once delivery

#### Supported Events
```
Customer Events:
  - Customer Created
  - Customer Modified
  - Customer Deleted

Item Events:
  - Item Created
  - Item Price Changed
  - Item Stock Updated

Order Events:
  - Order Posted
  - Order Shipped
  - Order Completed

Payment Events:
  - Payment Posted
  - Payment Failed
  - Payment Cleared
```

#### Setup Process
1. Register webhook endpoint in BC
2. Select events to subscribe
3. Configure retry policy
4. Receive HTTP POST notifications

#### Payload Example
```json
{
  "event": "customer_created",
  "timestamp": "2025-11-07T10:30:00Z",
  "data": {
    "id": "12345",
    "name": "Acme Corp",
    "email": "contact@acme.com"
  },
  "source": "BC"
}
```

#### Advantages
- Real-time notifications
- Loose coupling
- Scalable architecture
- Multiple subscribers possible

#### Disadvantages
- Requires webhook infrastructure
- Network dependency
- Retry complexity
- Initial setup cost

---

## Microsoft Cloud Integrations

### Microsoft 365 Email Integration

**Module**: Email - Microsoft 365 Connector
**Authentication**: OAuth 2.0 via Azure AD
**Protocol**: Microsoft Graph API

#### Features
- Send emails from BC
- Automatic sent item tracking in Outlook
- Rich formatting support
- Attachment handling
- Recipient validation

#### Setup
1. Register app in Azure AD
2. Grant permissions (Mail.Send, Mail.ReadWrite)
3. Configure in BC email settings
4. Assign users

#### Advantages
- Native M365 integration
- Outlook synchronization
- Compliance with M365
- Single sign-on (AAD)

#### Use Cases
- Automated notifications
- Document delivery
- Customer communications
- Executive reporting

---

### Outlook Calendar Integration

**Module**: Email - Outlook REST API
**Authentication**: OAuth 2.0 via Azure AD
**API**: Microsoft Graph API

#### Features
- Email sending and receiving
- Calendar event creation
- Appointment scheduling
- Contact integration
- Event notifications

#### Endpoints
```
/me/messages (Email)
/me/calendar/events (Calendar)
/me/contacts (Contacts)
/me/events (All events)
```

#### Use Cases
- Project calendar integration
- Meeting scheduling
- Service appointment management
- Resource availability

---

### SharePoint Integration

**Module**: External File Storage - SharePoint Connector
**Authentication**: OAuth 2.0 via Azure AD
**API**: Microsoft Graph API (SharePoint REST)

#### Features
- Store BC documents in SharePoint
- Document versioning
- Site collection integration
- Permission inheritance
- Document metadata

#### Setup
1. Create SharePoint site/library
2. Configure BC connector
3. Map document types to libraries
4. Set up permissions

#### Use Cases
- Collaborative document management
- Archive storage
- Records management
- Team workspace
- Document versioning

#### Permissions
- BC users → SharePoint contributors
- Document access control
- Field-level security honored
- Audit trail integrated

---

### Azure Blob Storage

**Module**: External File Storage - Azure Blob Service Connector
**Authentication**: Storage account key or SAS token
**API**: Azure Storage REST API

#### Features
- Unlimited document storage
- High availability
- Scalable architecture
- Backup and disaster recovery
- Lifecycle management

#### Pricing Model
- Pay per GB stored
- Transaction charges
- Egress charges (data download)
- Scalable for any size

#### Setup
1. Create Azure storage account
2. Configure BC connector
3. Create blob containers
4. Set access policies

#### Use Cases
- Archive of large documents
- Backup storage
- Big data analytics
- Media storage
- Compliance document storage

#### Performance
- Low latency access
- Concurrent uploads
- Batch operations
- CDN integration possible

---

### Azure File Shares

**Module**: External File Storage - Azure File Service Connector
**Protocol**: SMB 3.0
**Authentication**: Storage account key

#### Features
- SMB-compatible file sharing
- Windows folder mapping
- Permission management
- Quotas per share
- File-level encryption

#### Setup
1. Create Azure storage account
2. Create file share
3. Configure BC connector
4. Users can mount as network drive

#### Advantages vs Blob
- SMB protocol (Windows native)
- Folder hierarchy (not flat object store)
- File permissions
- Can map to drive letter
- Legacy app compatibility

#### Use Cases
- Shared document folders
- Legacy integration
- Windows-based workflows
- File collaboration

---

### Azure Machine Learning Integration

**Modules**: SalesAndInventoryForecast, LatePaymentPredictor, BankAccRecWithAI
**Authentication**: Azure Service Principal
**API**: Azure ML REST endpoints

#### Capabilities
- Demand forecasting
- Payment prediction
- Transaction matching
- Anomaly detection
- Custom models

#### Models Available
- Time-series forecasting
- Classification (payment likelihood)
- Clustering (customer segments)
- Regression (price optimization)

#### Process
1. Historical data exports to Azure ML
2. Model training
3. Predictions imported back to BC
4. Results actionable in BC

#### Security
- Service principal auth
- Data encryption in transit
- Model versioning
- Audit trail

---

### Azure OpenAI Integration

**Module**: Create Product Information With Copilot
**Authentication**: API key
**Model**: GPT models

#### Capabilities
- Product description generation
- Product attribute suggestions
- Multi-language support
- Brand tone customization
- SEO optimization

#### Usage
1. Enter basic product info in BC
2. GPT generates descriptions
3. User reviews and edits
4. Description saved to item

#### Quality Considerations
- Review AI-generated content
- Brand consistency
- Legal compliance
- Factual accuracy

#### Cost
- Pay per token (input + output)
- Scalable pricing
- Usage limits configurable

---

### Microsoft Universal Print

**Module**: Universal Print Integration
**Authentication**: OAuth 2.0 via Azure AD
**API**: Microsoft Graph API (Print)

#### Features
- Cloud-based print queues
- Device management
- Queue management
- Job tracking
- Automatic printer discovery

#### Setup
1. Configure Universal Print in Azure
2. Register printers
3. Setup BC connector
4. Configure print settings

#### Advantages
- No on-premises print servers
- Mobile printing support
- Cloud-based management
- Enterprise scale

#### Use Cases
- Hybrid work environments
- Managed print services
- Enterprise printing
- Remote office printing

---

## Payment Processing

### PayPal Payments

**Module**: PayPalPaymentsStandard
**Partner**: PayPal
**Integration Type**: Payment gateway

#### Capabilities
- Online payment capture
- Credit card processing
- PayPal wallet
- PayPal Pay Later
- Fraud detection (PayPal)

#### Setup
1. Create PayPal business account
2. Configure API credentials
3. Setup BC connector
4. Configure payment terms

#### Transaction Flow
```
Customer initiates payment
  → BC shows PayPal interface
  → Customer enters payment info
  → PayPal processes securely
  → Payment confirmation returned to BC
  → Invoice marked as paid
```

#### PCI Compliance
- PayPal handles card data
- BC never sees credit card numbers
- Hosted payment pages
- Full PCI DSS compliance

#### Fees
- Transaction percentage (~2.9%)
- Fixed transaction fee (~$0.30)
- Volume discounts possible

---

### WorldPay Payments

**Module**: WorldPayPaymentsStandard
**Partner**: FIS (Fiserv)
**Integration Type**: Payment gateway

#### Capabilities
- Credit card processing
- Debit card processing
- Alternative payment methods
- Multi-currency support
- Advanced fraud detection

#### Setup
1. Create WorldPay merchant account
2. Configure merchant ID
3. Setup BC connector
4. Configure terminal settings

#### Advantages
- Enterprise-grade fraud detection
- Multiple payment methods
- Global payment support
- Advanced reporting

#### Fees
- Interchange + markup model
- Volume-based discounts
- Monthly fees possible
- No PCI DSS burden (hosted)

---

### AMC Banking

**Module**: AMCBanking365Fundamentals
**Partner**: AMC Banking Solutions
**Integration Type**: Bank integration

#### Capabilities
- Bank file formats (SEPA, ISO 20022)
- International payment formats
- Bank statement import
- Payment file creation
- Multi-bank support

#### Supported Formats
- **SEPA**: CT, DD, C2B
- **ISO 20022**: PAIN, CAMT
- **Legacy**: MT940, SWIFT
- **Regional**: Country-specific formats

#### Setup
1. Subscribe to AMC service
2. Configure bank accounts
3. Setup AMC connector
4. Test with test bank files

#### Use Cases
- International payments (SEPA)
- Automated bank imports
- Multi-format support
- Regulatory compliance

#### Advantages
- Largest bank support (100+)
- Frequent updates
- Professional support
- Proven platform

---

## E-Commerce Integration

### Shopify Connector

**Module**: Shopify
**Partner**: Shopify
**Integration Type**: E-commerce connector
**Pattern**: Bidirectional sync

#### Capabilities

##### Product Sync
- Sync BC items to Shopify products
- Price synchronization
- Inventory level sync
- Product image sync
- Description and attributes

##### Order Management
- Import Shopify orders to BC
- Order line mapping
- Customer synchronization
- Payment status tracking
- Shipping address handling

##### Inventory Sync
- Real-time inventory levels
- Stock allocation
- Backorder handling
- Multi-location inventory
- Reserved inventory

##### Customer Sync
- Customer creation in BC
- Shipping address sync
- Billing address sync
- Contact information
- Customer segments

#### Setup
1. Create Shopify API credentials
2. Configure BC Shopify connector
3. Map BC items to Shopify products
4. Configure synchronization schedules
5. Test sync workflows

#### Synchronization Flow
```
Shopify Customer places order
  → Order imported to BC
  → BC creates Sales Order
  → User fulfills in BC
  → Shipment posted
  → Inventory updated in Shopify
  → Shopify shows updated stock
```

#### Advantages
- Automated order flow
- Inventory accuracy
- Reduced manual entry
- Real-time synchronization
- Omnichannel capability

#### Limitations
- Shopify Plus for some features
- Price sync one-way (BC → Shopify)
- Custom field limitations
- API rate limits

#### Cost
- BC subscription
- Shopify subscription
- API usage fees (if applicable)

---

## Field Service Integration

### Dynamics 365 Field Service

**Module**: FieldServiceIntegration
**Partner**: Microsoft Dynamics 365
**Integration Type**: Business process integration

#### Capabilities
- Work order synchronization
- Resource allocation sync
- Service item linking
- Task assignment
- Equipment tracking
- Completion status

#### Data Sync
```
BC Service Order
  → Creates Field Service Work Order
  → FS assigns resources and schedule
  → FS technician completes work
  → FS sends completion to BC
  → BC updates Service Order status
  → BC creates Invoice
```

#### Setup
1. Setup Dynamics 365 Field Service
2. Configure Azure AD integration
3. Setup BC connector
4. Map service items and resources
5. Test synchronization

#### Advantages
- Unified service management
- Real-time resource visibility
- Mobile field operations
- Automatic invoice generation
- Route optimization

#### Use Cases
- Field service operations
- On-site maintenance
- Installation services
- Customer support
- Equipment service contracts

#### Data Mapping
```
BC Service Order ↔ FS Work Order
BC Service Item ↔ FS Service Item
BC Resource ↔ FS Resource
BC Customer ↔ FS Account
```

---

## Email Integration

### Email Connector Options

| Option | Module | Use Case | Setup |
|--------|--------|----------|-------|
| **Microsoft 365** | Email - M365 Connector | Enterprise M365 users | OAuth via AAD |
| **Outlook REST** | Email - Outlook REST API | Rich Outlook integration | OAuth via AAD |
| **SMTP** | Email - SMTP Connector | Any SMTP provider | SMTP credentials |
| **Current User** | Email - Current User | Personal mailbox | User credentials |
| **Logging** | EmailLogging | Auto email logging | Graph API |

#### Configuration by Provider

##### Gmail
```
Provider: SMTP
Server: smtp.gmail.com
Port: 587
TLS: Yes
Auth: OAuth or App Password
```

##### Office 365
```
Provider: Microsoft 365 Connector or SMTP
SMTP Server: smtp.office365.com
Port: 587
TLS: Yes
Auth: OAuth or Password
```

##### Custom SMTP
```
Provider: SMTP Connector
Server: [your-mail-server]
Port: 25, 465, or 587 (TLS)
Auth: Username/Password
```

#### Email Logging

**Module**: EmailLogging
**Automatic**: Yes (with Graph API)
**Logging**: Email → Customer/Vendor contact

```
Email sent from BC
  → Automatically logged to contact record
  → Attachment stored in BC
  → Audit trail created
  → Communication history maintained
```

#### Send to Email Printer

**Module**: Send To Email Printer
**Purpose**: Email reports to recipients

```
Generate Report
  → Convert to PDF
  → Email to recipients
  → Recipients get documents
  → Archive in BC
```

---

## Data Import/Export

### CSV Import/Export
- **Method**: Bulk via data workspaces
- **Format**: Comma-separated values
- **Common Use**: Master data, transactions
- **Limitation**: No header validation

### Excel Export
- **Module**: ExcelReports
- **Format**: XLSX with formatting
- **Features**: Formulas, charts, styling
- **Use**: Finance team reporting

### SAF-T Export
- **Module**: AuditFileExport
- **Format**: XML (Standard Audit File for Tax)
- **Use**: Tax authority submissions
- **Regulatory**: International compliance

### Database Integration (On-Prem Only)
- **Method**: Direct SQL Server access
- **Performance**: High-speed bulk operations
- **Security**: Windows authentication
- **Note**: Not available in SaaS

---

## Integration Patterns & Best Practices

### Pattern 1: Real-Time API Calls
**When**: Need immediate response
**Method**: Direct REST API calls
**Example**: Payment processing
**Consideration**: Timeout handling

```
Order Created in BC
  → Call Payment API synchronously
  → Get payment confirmation
  → Update order status
  → Continue workflow
```

### Pattern 2: Asynchronous Events
**When**: Non-critical background work
**Method**: Webhook events
**Example**: Notification to Field Service
**Benefit**: Decoupled systems

```
Order Posted
  → Raise event
  → Continue in BC immediately
  → Field Service receives async notification
  → Updates independently
```

### Pattern 3: Scheduled Batch Sync
**When**: Volume data
**Method**: Scheduled jobs
**Example**: Shopify inventory sync
**Frequency**: Hourly, daily, etc.

```
Every Hour:
  → Read BC inventory
  → Calculate changes
  → Sync to Shopify
  → Log results
```

### Pattern 4: On-Demand Export
**When**: User-initiated
**Method**: Manual export
**Example**: Report to accountant
**Frequency**: As needed

```
User exports data
  → Select date range
  → Choose format (Excel, CSV, PDF)
  → Download file
  → User uses externally
```

---

## Security Considerations

### Authentication Methods

| Method | Security | Use Case | Best For |
|--------|----------|----------|----------|
| **OAuth 2.0** | High | Cloud APIs | Microsoft, public APIs |
| **API Keys** | Medium | Simple APIs | Development, internal |
| **Certificates** | Very High | Critical | Banking, compliance |
| **Passwords** | Low | Legacy | On-prem, SMTP |
| **Service Principal** | High | Backend | Automated jobs |

### Data Protection

#### In Transit
- ✅ HTTPS encryption mandatory
- ✅ TLS 1.2 minimum
- ✅ Certificate pinning recommended
- ✅ Avoid HTTP

#### At Rest
- ✅ Encrypted databases (SaaS default)
- ✅ Field-level encryption for sensitive data
- ✅ SecretText for credentials
- ✅ No credentials in code

#### Access Control
- ✅ Least privilege principle
- ✅ Role-based integration accounts
- ✅ Audit logging
- ✅ IP whitelisting where possible

### API Security

#### Rate Limiting
- Monitor API calls
- Implement backoff/retry
- Cache responses where possible
- Use batch operations

#### Error Handling
- ✅ Handle timeouts gracefully
- ✅ Implement exponential backoff
- ✅ Log errors properly
- ✅ Alert on repeated failures

#### Credential Management
- ✅ Store in secure vault (Key Vault)
- ✅ Rotate keys regularly
- ✅ Don't hardcode credentials
- ✅ Use managed identities (Azure)

---

## Troubleshooting Integration Issues

### Common Issues & Solutions

#### Authentication Failures
**Problem**: 401 Unauthorized
**Causes**:
- Expired token
- Invalid credentials
- Wrong permissions

**Solutions**:
1. Verify credentials in connector
2. Check token expiration
3. Review permissions in external system
4. Regenerate API keys if needed

#### Performance Issues
**Problem**: Slow integration
**Causes**:
- Large data volume
- Network latency
- API rate limiting
- Inefficient queries

**Solutions**:
1. Use batch operations
2. Filter data (don't sync all)
3. Implement pagination
4. Cache results
5. Schedule during off-peak

#### Data Mismatch
**Problem**: Data inconsistency between systems
**Causes**:
- Sync failures
- Partial updates
- Timezone differences
- Field mapping errors

**Solutions**:
1. Add validation logic
2. Implement reconciliation reports
3. Log all changes
4. Use audit trails
5. Test before production

#### Connectivity Issues
**Problem**: "Cannot reach external system"
**Causes**:
- Network outage
- Firewall blocking
- Service unavailable
- DNS issues

**Solutions**:
1. Test external system connectivity
2. Check firewall rules
3. Verify service status page
4. Check DNS resolution
5. Implement retry logic

---

## Integration Roadmap

### Quick Start (Week 1)
- [ ] Choose primary API version (V2 recommended)
- [ ] Setup email connector
- [ ] Test basic data retrieval

### Standard (Week 2-3)
- [ ] Implement payment processing
- [ ] Setup cloud storage (SharePoint/Azure)
- [ ] Configure email logging

### Advanced (Week 4+)
- [ ] E-commerce sync (Shopify)
- [ ] Field Service integration
- [ ] Advanced API scenarios
- [ ] Custom webhook implementation

### Enterprise (Month 2+)
- [ ] Full suite integration
- [ ] Master data sync
- [ ] Compliance automation
- [ ] Performance optimization

---

## External System Checklist

Before integrating any external system:

- [ ] Verify API documentation
- [ ] Test in development environment
- [ ] Plan data mapping
- [ ] Implement error handling
- [ ] Setup security (auth, encryption)
- [ ] Plan scheduling/frequency
- [ ] Test with sample data
- [ ] Document configuration
- [ ] Create runbooks
- [ ] Train users
- [ ] Setup monitoring/alerting
- [ ] Plan for disaster recovery

---

## Support & Resources

### Microsoft Documentation
- [Business Central API Docs](https://docs.microsoft.com/dynamics365/business-central)
- [Microsoft Graph API](https://graph.microsoft.com)
- [Azure Service Documentation](https://docs.microsoft.com/azure)

### Partner Resources
- AMC Banking: https://www.amcbanking.com
- Shopify: https://www.shopify.com/partners
- Dynamics 365 Field Service: https://dynamics.microsoft.com/field-service

### Community
- BC Forums: https://community.dynamics.com
- Stack Overflow: BC tag
- GitHub: BC samples and tools

---

**Document Version**: 1.0
**BC Version**: 27
**Last Updated**: 2025-11-07

