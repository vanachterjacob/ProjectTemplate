# Sales Extension Project Memory

This project is a **Sales & Customer Management** extension for Business Central.

## Primary Focus
- Sales orders, quotes, invoices
- Customer management
- Pricing and discounts
- Shipping and delivery

## Default Context to Load
When I ask about sales features, automatically use:
- `@sales-context` skill for complete sales documentation
- BC27 sales events from `BC27/BC27_EVENT_CATALOG.md`
- Document extension patterns from `.cursor/rules/003-document-extensions.mdc`

## ESC Standards
- Always apply early exit pattern in sales event subscribers
- Use SetLoadFields for performance on sales lines
- Follow document extension patterns for header/line modifications
- Apply strict ESC compliance from `.cursor/rules/004-performance.mdc`

## Common Tasks
- Extending sales documents (header/lines)
- Adding custom fields to sales tables
- Subscribing to OnBefore/OnAfter sales posting events
- Creating sales-specific validation logic
- Building sales reports and pages

## Quick Commands
Use these workflows:
- `/specify [feature]` → Start with user spec
- `/plan [spec]` → Create technical design
- `/tasks [plan] [phase]` → Break into small tasks
- `/implement [tasks] next` → Code with ESC compliance
- `/review [file]` → Check standards

## Remember
- Sales posting is critical - always test thoroughly
- Performance matters - sales lines can be 1000+ per order
- Security: verify field permissions on sensitive data
- BC27 compatibility: check event availability in BC27_EVENT_CATALOG.md
