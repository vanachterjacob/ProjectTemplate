---
description: Load complete API & integration context (REST, webhooks, external systems)
category: context-loader
tags: [api, integration, rest, webhook, webservice, external]
---

# API & Integration Context Loader

**Purpose:** Instantly load all relevant context for API development and external integrations.

**Use when working on:**
- REST API pages
- Web services (SOAP/REST)
- Webhook integrations
- External system connections
- OAuth authentication
- API v2.0 extensions

## Auto-Loaded Context

### 1. BC27 Documentation
```
@BC27/BC27_LLM_QUICKREF.md
@BC27/BC27_INTEGRATION_GUIDE.md (Complete integration patterns)
@BC27/events/BC27_EVENTS_API.md (25+ REST API, webhook events)
@BC27/BC27_MODULES_OVERVIEW.md (System Application - API modules)
```

### 2. ESC Standards
```
@.cursor/rules/000-project-overview.mdc
@.cursor/rules/001-naming-conventions.mdc
@.cursor/rules/002-development-patterns.mdc
```

### 3. Performance & Security
```
@.cursor/rules/004-performance.mdc (focus: API query performance)
@.cursor/rules/007-deployment-security.mdc (focus: authentication, authorization)
```

## Key Events Available

**API Page Events:**
- OnBeforeOpenPage
- OnAfterGetRecord
- OnBeforeInsertRecord
- OnAfterInsertRecord
- OnBeforeModifyRecord
- OnAfterModifyRecord
- OnBeforeDeleteRecord

**Web Service Events:**
- OnBeforePublishWebService
- OnAfterPublishWebService
- OnBeforeWebServiceCall
- OnAfterWebServiceCall

**HTTP Client Events:**
- OnBeforeSendHttpRequest
- OnAfterReceiveHttpResponse
- OnBeforeProcessResponse

**Integration Events:**
- OnBeforeProcessInboundDocument
- OnAfterProcessOutboundDocument
- OnBeforeSyncData
- OnAfterSyncData

## Common Extension Points

**API Pages (v2.0):**
- customers (API)
- vendors (API)
- items (API)
- salesOrders (API)
- purchaseOrders (API)
- generalLedgerEntries (API)

**Integration Tables:**
- Web Service (2000000076)
- Webhook Subscription (2000000199)
- API Webhook Notification (6151)

## ESC Patterns for API Development

**Custom API Page (v2.0):**
```al
page 77100 "ABC Custom API"
{
    PageType = API;
    Caption = 'ABC Custom API';
    APIPublisher = 'yourcompany';
    APIGroup = 'custom';
    APIVersion = 'v2.0';
    EntityName = 'customEntity';
    EntitySetName = 'customEntities';
    SourceTable = "ABC Custom Table";
    DelayedInsert = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(code; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date Time';
                    Editable = false;
                }
            }
        }
    }
}
```

**HTTP Client Integration (TryFunction Pattern):**
```al
procedure TrySendToExternalAPI(DocumentNo: Code[20]): Boolean
var
    Client: HttpClient;
    Request: HttpRequestMessage;
    Response: HttpResponseMessage;
    Content: HttpContent;
    Headers: HttpHeaders;
    ResponseText: Text;
begin
    // Early exit if no document
    if DocumentNo = '' then
        exit(false);

    // Build request
    Request.Method := 'POST';
    Request.SetRequestUri('https://api.example.com/endpoint');

    Content.WriteFrom(BuildJsonPayload(DocumentNo));
    Content.GetHeaders(Headers);
    Headers.Remove('Content-Type');
    Headers.Add('Content-Type', 'application/json');

    Request.Content := Content;

    // Add authentication
    Client.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + GetAccessToken());

    // Send request with error handling
    if not Client.Send(Request, Response) then
        exit(false);

    if not Response.IsSuccessStatusCode then
        exit(false);

    Response.Content.ReadAs(ResponseText);
    exit(ProcessResponse(ResponseText));
end;

local procedure ProcessResponse(ResponseText: Text): Boolean
var
    JsonObject: JsonObject;
begin
    if not JsonObject.ReadFrom(ResponseText) then
        exit(false);

    // Process JSON response
    exit(true);
end;
```

**Webhook Subscription:**
```al
procedure CreateWebhookSubscription()
var
    WebhookSubscription: Record "Webhook Subscription";
begin
    WebhookSubscription.Init();
    WebhookSubscription."Subscription ID" := CreateGuid();
    WebhookSubscription."Client State" := 'ABC-Webhook';
    WebhookSubscription."Notification Url" := 'https://your-endpoint.com/webhook';
    WebhookSubscription."Resource" := 'salesOrders';
    WebhookSubscription."Company Name" := CompanyName;
    WebhookSubscription.Insert(true);
end;
```

**API Error Handling:**
```al
[EventSubscriber(ObjectType::Page, Page::"ABC Custom API", 'OnBeforeInsertRecord', '', true, true)]
local procedure OnBeforeInsertRecord(var Rec: Record "ABC Custom Table"; var IsHandled: Boolean)
begin
    // Early exit if already handled
    if IsHandled then
        exit;

    // Validate required fields
    if Rec.Code = '' then
        Error('Code is required');

    if not ValidateBusinessRules(Rec) then begin
        IsHandled := true;
        Error('Business validation failed');
    end;
end;
```

## Security Best Practices

**Always:**
- ✅ Use OAuth 2.0 for authentication
- ✅ Validate all incoming data
- ✅ Implement rate limiting
- ✅ Log API calls for audit
- ✅ Use HTTPS only
- ✅ Sanitize input to prevent injection
- ✅ Set proper permissions on API pages

**Permissions:**
```al
permissionset 77100 "ABC API Access"
{
    Assignable = true;
    Caption = 'ABC API Access';

    Permissions =
        page "ABC Custom API" = X,
        tabledata "ABC Custom Table" = RIMD;
}
```

## Performance Considerations

**API Query Optimization:**
- Use $filter, $select, $expand wisely
- Implement paging for large datasets
- Cache frequent requests
- Use SetLoadFields for read operations
- Index API query fields

**Example Optimized Query:**
```
GET /api/v2.0/companies({id})/customEntities?$filter=code eq 'ABC'&$select=code,description&$top=20
```

## Common Integration Scenarios

**1. External System Sync:**
```al
procedure SyncWithExternalSystem()
begin
    if not TryFetchDataFromAPI() then
        LogError('Failed to fetch data');

    if not TryUpdateLocalRecords() then
        LogError('Failed to update local records');
end;
```

**2. Outbound Document Posting:**
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header")
begin
    if not TrySendToExternalAPI(SalesHeader."No.") then
        LogWarning('Failed to send to external API: ' + SalesHeader."No.");
end;
```

**3. Real-time Validation:**
```al
procedure ValidateWithExternalAPI(ItemNo: Code[20]): Boolean
var
    Response: Text;
begin
    if not TryCallValidationAPI(ItemNo, Response) then
        exit(false);

    exit(ParseValidationResponse(Response));
end;
```

## Context Loaded ✓

You now have all necessary context for API and integration development.

**Examples:**
- "Create custom API page for external order intake"
- "Set up webhook to notify external system on sales posting"
- "Build HTTP client integration with shipping provider"
- "Extend standard API with custom fields"
- "Implement OAuth authentication for API access"
