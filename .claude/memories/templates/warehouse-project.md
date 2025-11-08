# Warehouse Management Project Memory

This project is a **Warehouse & Inventory** extension for Business Central.

## Primary Focus
- Warehouse management (picks, put-aways, movements)
- Inventory posting and tracking
- Bin management
- Item tracking (serial/lot numbers)

## Default Context to Load
When I ask about warehouse features, automatically use:
- `@warehouse-context` skill for complete warehouse documentation
- BC27 warehouse events from `BC27/events/BC27_EVENTS_WAREHOUSE.md`
- Performance patterns for inventory operations

## ESC Standards
- Performance critical: warehouse has high transaction volume
- Always use SetLoadFields on item ledger entries
- Use TryFunction for warehouse validation
- Apply batch processing patterns for bulk operations
- Strict error handling for inventory discrepancies

## Common Tasks
- Extending warehouse documents (picks, put-aways, movements)
- Custom bin logic and directed put-away
- Item tracking customizations
- Warehouse posting event subscribers
- Inventory adjustment workflows

## Quick Commands
Use these workflows:
- `/specify [feature]` → Start with user spec
- `/plan [spec]` → Create technical design
- `/tasks [plan] [phase]` → Break into small tasks
- `/implement [tasks] next` → Code with ESC compliance
- `/review [file]` → Check standards

## Remember
- Warehouse operations are transactional - ensure atomicity
- Performance critical: optimize loops over item ledger
- Security: verify warehouse employee permissions
- BC27 compatibility: check event availability in BC27_EVENTS_WAREHOUSE.md
- Always validate bin capacity before put-away
