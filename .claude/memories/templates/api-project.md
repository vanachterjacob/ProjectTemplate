# API Integration Project Memory

This project is an **API & Integration** extension for Business Central.

## Primary Focus
- REST API endpoints
- Web services (SOAP/REST)
- External system integrations
- Webhooks and event subscriptions
- OAuth/authentication

## Default Context to Load
When I ask about API features, automatically use:
- `@api-context` skill for complete API documentation
- BC27 API events from `BC27/events/BC27_EVENTS_API.md`
- Integration patterns and security rules

## ESC Standards
- Security first: validate ALL external inputs
- Use TryFunction for external calls (network can fail)
- Implement proper error handling and logging
- Apply rate limiting for external endpoints
- Never expose internal IDs directly in APIs

## Common Tasks
- Creating custom API pages (OData)
- Building REST API endpoints
- Integrating with external web services
- Implementing OAuth 2.0 flows
- Webhook receivers and senders
- JSON/XML parsing and serialization

## Quick Commands
Use these workflows:
- `/specify [feature]` → Start with user spec
- `/plan [spec]` → Create technical design
- `/tasks [plan] [phase]` → Break into small tasks
- `/implement [tasks] next` → Code with ESC compliance
- `/review [file]` → Check standards (especially security)

## Security Checklist
- ✅ Validate all external inputs
- ✅ Sanitize before database writes
- ✅ Use HTTPS only
- ✅ Implement proper authentication
- ✅ Log all API calls for audit
- ✅ Rate limiting on public endpoints
- ✅ Never log sensitive data (passwords, tokens)

## Remember
- APIs are public attack surface - security paramount
- External calls can fail - always use TryFunction
- Performance: consider async patterns for long operations
- BC27 compatibility: check API events in BC27_EVENTS_API.md
- Test with malformed inputs, not just happy path
