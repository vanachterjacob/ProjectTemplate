# BC27 API & Integration Events - REST API & Webhook Integration Points

Event reference for API & Integration functionality in Business Central 27. Extend REST APIs, webhooks, OData operations, and external system integrations.

**Module**: API & Integration
**Version**: 1.0
**BC Version**: 27
**Last Updated**: 2025-11-08

---

## REST API Events

### OnAfterAPIRecordInsert
- **Publisher**: Various API pages (e.g., API v2.0 Sales Orders)
- **When**: After record created via REST API
- **Parameters**: `var RecordRef: RecordRef`
- **Uses**: Sync to external databases, trigger webhooks, audit API operations, post-creation validation
- **Pattern**: Multiple API pages publish this event
- **Example Source**: API v2.0 pages in BaseApp

**Example**:
```al
[EventSubscriber(ObjectType::Page, Page::"Sales Order API", 'OnAfterAPIRecordInsert', '', false, false)]
local procedure SyncSalesOrderToExternal(var RecordRef: RecordRef)
var
    SalesHeader: Record "Sales Header";
    ABCIntegration: Codeunit "ABC External Sync";
begin
    RecordRef.SetTable(SalesHeader);
    ABCIntegration.SyncSalesOrderCreate(SalesHeader);
end;
```

### OnAfterAPIRecordModify
- **Publisher**: Various API pages
- **When**: After record modified via REST API
- **Parameters**: `var RecordRef: RecordRef`
- **Uses**: Track API changes, sync modifications to external systems, trigger change notifications, validate updates
- **Pattern**: Multiple API pages publish this event

### OnAfterAPIRecordDelete
- **Publisher**: Various API pages
- **When**: After record deleted via REST API
- **Parameters**: `var RecordRef: RecordRef`
- **Uses**: Cascade deletes to external systems, archive deleted data, notify subscribers, maintain audit trail
- **Pattern**: Multiple API pages publish this event

### OnBeforeAPIValidation
- **Publisher**: API page controllers
- **When**: Before API request validation
- **Cancellable**: Yes (via validation error)
- **Parameters**: Varies by API endpoint
- **Uses**: Custom API validation rules, rate limiting, IP whitelist check, API quota enforcement

### OnAfterAPIQuery
- **Publisher**: API query pages
- **When**: After API query execution
- **Parameters**: Result set, filter applied
- **Uses**: Log API usage, apply additional filtering, transform response data, track performance metrics

---

## OData Events

### OnBeforeODataV4Query
- **Publisher**: OData query handlers
- **When**: Before OData query execution
- **Parameters**: `var ODataQuery: Text`, `var Handled: Boolean`
- **Uses**: Modify query filters, apply tenant-specific filters, enforce row-level security, optimize queries

### OnAfterODataV4Response
- **Publisher**: OData response handlers
- **When**: After OData response prepared
- **Parameters**: `var ResponseText: Text`
- **Uses**: Transform response format, add metadata, apply data masking, compress response

---

## Webhook Events

### OnBeforeRegisterWebhook
- **Publisher**: Codeunit 6155 "Webhook Management"
- **When**: Before webhook subscription registration
- **Cancellable**: Yes
- **Parameters**: `var WebhookSubscription: Record "Webhook Subscription"`, `var Handled: Boolean`
- **Uses**: Validate webhook endpoint, verify authentication, check subscription limits, whitelist domains
- **Source**: [WebhookManagement.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Integration/Webhook/WebhookManagement.Codeunit.al)

**Example**:
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Webhook Management", 'OnBeforeRegisterWebhook', '', false, false)]
local procedure ValidateWebhookEndpoint(var WebhookSubscription: Record "Webhook Subscription"; var Handled: Boolean)
begin
    if not ABCSecurityMgmt.IsWhitelistedDomain(WebhookSubscription."Endpoint URL") then begin
        Error('Webhook endpoint %1 is not whitelisted', WebhookSubscription."Endpoint URL");
        Handled := true;
    end;
end;
```

### OnAfterSendWebhookNotification
- **Publisher**: Codeunit 6155 "Webhook Management"
- **When**: After webhook notification sent
- **Parameters**: `WebhookSubscription: Record "Webhook Subscription"`, `Success: Boolean`, `ResponseText: Text`
- **Uses**: Log webhook delivery, handle failures, retry failed notifications, update subscription status
- **Source**: [WebhookManagement.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Integration/Webhook/WebhookManagement.Codeunit.al)

### OnWebhookSubscriptionExpiring
- **Publisher**: Codeunit 6155 "Webhook Management"
- **When**: Webhook subscription approaching expiration
- **Parameters**: `WebhookSubscription: Record "Webhook Subscription"`, `DaysUntilExpiry: Integer`
- **Uses**: Send renewal notifications, auto-renew subscriptions, clean up expired subscriptions, notify administrators
- **Source**: [WebhookManagement.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Integration/Webhook/WebhookManagement.Codeunit.al)

---

## Authentication & Security Events

### OnBeforeAPIAuthentication
- **Publisher**: API authentication handlers
- **When**: Before API authentication check
- **Cancellable**: Yes
- **Parameters**: `var AuthToken: Text`, `var Authenticated: Boolean`, `var Handled: Boolean`
- **Uses**: Custom authentication logic, multi-factor authentication, API key validation, OAuth integration

### OnAfterAPIAuthenticationFailed
- **Publisher**: API authentication handlers
- **When**: After API authentication failure
- **Parameters**: `AuthToken: Text`, `FailureReason: Text`
- **Uses**: Log security events, trigger account lockout, send security alerts, update failure metrics

### OnBeforeAPIAuthorization
- **Publisher**: API authorization handlers
- **When**: Before API permission check
- **Cancellable**: Yes
- **Parameters**: `var Resource: Text`, `var Permission: Text`, `var Authorized: Boolean`, `var Handled: Boolean`
- **Uses**: Custom authorization logic, role-based access control, resource-level permissions, tenant isolation

---

## Data Synchronization Events

### OnBeforeSyncToExternal
- **Publisher**: Data sync codeunits
- **When**: Before data sync to external system
- **Cancellable**: Yes
- **Parameters**: `var RecordRef: RecordRef`, `ExternalSystemID: Text`, `var Handled: Boolean`
- **Uses**: Transform data format, apply field mapping, validate sync eligibility, handle sync conflicts

**Example**:
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"ABC External Sync", 'OnBeforeSyncToExternal', '', false, false)]
local procedure TransformCustomerData(var RecordRef: RecordRef; ExternalSystemID: Text; var Handled: Boolean)
var
    Customer: Record Customer;
    ABCDataTransform: Codeunit "ABC Data Transform";
begin
    if RecordRef.Number = Database::Customer then begin
        RecordRef.SetTable(Customer);
        ABCDataTransform.ApplyCustomerMapping(Customer, ExternalSystemID);
        Handled := true;
    end;
end;
```

### OnAfterSyncFromExternal
- **Publisher**: Data sync codeunits
- **When**: After data synced from external system
- **Parameters**: `var RecordRef: RecordRef`, `ExternalSystemID: Text`, `Success: Boolean`
- **Uses**: Trigger dependent updates, validate imported data, log sync results, handle sync errors

### OnSyncConflictDetected
- **Publisher**: Data sync codeunits
- **When**: Sync conflict detected (concurrent edits)
- **Parameters**: `LocalRecord: RecordRef`, `ExternalRecord: RecordRef`, `var Resolution: Option`
- **Uses**: Apply conflict resolution strategy, notify users, log conflicts, apply merge logic

---

## External System Integration Events

### OnBeforeCallExternalAPI
- **Publisher**: External API wrappers
- **When**: Before calling external REST API
- **Cancellable**: Yes
- **Parameters**: `var EndpointURL: Text`, `var RequestBody: Text`, `var Handled: Boolean`
- **Uses**: Add authentication headers, transform request format, log API calls, apply rate limiting

### OnAfterCallExternalAPI
- **Publisher**: External API wrappers
- **When**: After external API call completed
- **Parameters**: `EndpointURL: Text`, `ResponseCode: Integer`, `ResponseText: Text`, `Success: Boolean`
- **Uses**: Parse API response, handle errors, update sync status, log response times

### OnExternalAPITimeout
- **Publisher**: External API wrappers
- **When**: External API call timeout
- **Parameters**: `EndpointURL: Text`, `TimeoutSeconds: Integer`
- **Uses**: Retry logic, fallback handling, alert administrators, update availability metrics

### OnExternalAPIRateLimitReached
- **Publisher**: External API wrappers
- **When**: External API rate limit exceeded
- **Parameters**: `EndpointURL: Text`, `RetryAfterSeconds: Integer`
- **Uses**: Queue requests, apply backoff strategy, notify administrators, switch to alternative endpoints

---

## Data Exchange Events

### OnBeforeImportDataExchange
- **Publisher**: Codeunit 1220 "Data Exch. Def"
- **When**: Before data exchange import
- **Cancellable**: Yes
- **Parameters**: `var DataExch: Record "Data Exch."`, `var Handled: Boolean`
- **Uses**: Validate import file, transform data format, apply import rules, check data quality
- **Source**: [DataExchDef.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Foundation/DataExchange/DataExchDef.Codeunit.al)

### OnAfterImportDataExchange
- **Publisher**: Codeunit 1220 "Data Exch. Def"
- **When**: After data exchange import completed
- **Parameters**: `var DataExch: Record "Data Exch."`, `Success: Boolean`, `ErrorText: Text`
- **Uses**: Trigger post-import processing, generate import summary, notify users, archive import files
- **Source**: [DataExchDef.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Foundation/DataExchange/DataExchDef.Codeunit.al)

### OnBeforeExportDataExchange
- **Publisher**: Codeunit 1220 "Data Exch. Def"
- **When**: Before data exchange export
- **Cancellable**: Yes
- **Parameters**: `var DataExch: Record "Data Exch."`, `var Handled: Boolean`
- **Uses**: Apply export filters, transform export format, add metadata, compress export data
- **Source**: [DataExchDef.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Foundation/DataExchange/DataExchDef.Codeunit.al)

---

## Message Queue Events

### OnBeforeEnqueueMessage
- **Publisher**: Message queue handlers
- **When**: Before message added to queue
- **Cancellable**: Yes
- **Parameters**: `var MessageText: Text`, `QueueName: Text`, `var Handled: Boolean`
- **Uses**: Validate message format, apply priority rules, encrypt sensitive data, enforce queue limits

### OnAfterDequeueMessage
- **Publisher**: Message queue handlers
- **When**: After message retrieved from queue
- **Parameters**: `MessageText: Text`, `QueueName: Text`
- **Uses**: Decrypt message, validate message integrity, update processing status, trigger message processing

### OnMessageProcessingFailed
- **Publisher**: Message queue handlers
- **When**: Message processing failed
- **Parameters**: `MessageText: Text`, `ErrorMessage: Text`, `RetryCount: Integer`
- **Uses**: Apply retry logic, move to dead letter queue, alert administrators, log failures

---

## API Performance Events

### OnAfterAPIRequestCompleted
- **Publisher**: API telemetry handlers
- **When**: After API request processed
- **Parameters**: `Endpoint: Text`, `Method: Text`, `DurationMs: Integer`, `StatusCode: Integer`
- **Uses**: Track API performance, identify slow endpoints, generate SLA reports, optimize caching

### OnAPIPerformanceThresholdExceeded
- **Publisher**: API telemetry handlers
- **When**: API response time exceeds threshold
- **Parameters**: `Endpoint: Text`, `ActualDurationMs: Integer`, `ThresholdMs: Integer`
- **Uses**: Trigger performance alerts, apply caching, optimize queries, scale resources

---

## Event Subscriber Template

```al
codeunit 77104 "ABC API Integration Subs"
{
    // API Record Create
    [EventSubscriber(ObjectType::Page, Page::"Sales Order API", 'OnAfterAPIRecordInsert', '', false, false)]
    local procedure SyncAPICreate(var RecordRef: RecordRef)
    var
        SalesHeader: Record "Sales Header";
        ABCSync: Codeunit "ABC External Sync";
    begin
        RecordRef.SetTable(SalesHeader);
        ABCSync.QueueSyncCreate(SalesHeader);
    end;

    // Webhook Validation
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Webhook Management", 'OnBeforeRegisterWebhook', '', false, false)]
    local procedure ValidateWebhook(var WebhookSubscription: Record "Webhook Subscription"; var Handled: Boolean)
    begin
        if not ABCSecurityMgmt.ValidateWebhookEndpoint(WebhookSubscription."Endpoint URL") then begin
            Error('Invalid webhook endpoint');
            Handled := true;
        end;
    end;

    // External API Call
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ABC External API", 'OnBeforeCallExternalAPI', '', false, false)]
    local procedure AddAPIAuthentication(var EndpointURL: Text; var RequestBody: Text; var Handled: Boolean)
    begin
        // Add OAuth token to request
        ABCAuth.AddAuthHeader(RequestBody);
    end;
}
```

---

## Best Practices

### 1. **API Security**
- Always validate API inputs
- Use OAuth 2.0 for authentication
- Implement rate limiting
- Log all API access

### 2. **Webhook Reliability**
- Implement retry logic (exponential backoff)
- Validate webhook signatures
- Handle webhook failures gracefully
- Monitor webhook delivery rates

### 3. **Data Synchronization**
- Handle sync conflicts consistently
- Implement idempotent operations
- Use change tracking
- Log all sync operations

### 4. **Performance**
- Cache API responses
- Use batch operations
- Implement async processing
- Monitor API latency

---

## Additional Resources

- **Main Event Catalog**: [BC27_EVENT_CATALOG.md](../BC27_EVENT_CATALOG.md)
- **Event Index**: [BC27_EVENT_INDEX.md](../BC27_EVENT_INDEX.md)
- **Integration Guide**: [BC27_INTEGRATION_GUIDE.md](../BC27_INTEGRATION_GUIDE.md)
- **API Modules**: [BC27_MODULES_BY_CATEGORY.md](../BC27_MODULES_BY_CATEGORY.md#api--integration-modules-4)
- **Source Repository**: [BC27 GitHub](https://github.com/StefanMaron/MSDyn365BC.Code.History/tree/be-27)

---

**Coverage**: 25+ API events from REST APIs, Webhooks, OData, Authentication, Data Sync, and External Integrations
**Version**: 1.0
**Last Updated**: 2025-11-08
