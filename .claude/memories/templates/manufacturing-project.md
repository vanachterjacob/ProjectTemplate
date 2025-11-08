# Manufacturing Project Memory

This project is a **Manufacturing & Production** extension for Business Central.

## Primary Focus
- Production orders
- Bills of Materials (BOMs)
- Routing and work centers
- Capacity planning
- Output posting

## Default Context to Load
When I ask about manufacturing features, automatically use:
- `@manufacturing-context` skill for complete manufacturing documentation
- BC27 manufacturing events from `BC27/events/BC27_EVENTS_MANUFACTURING.md`
- Performance patterns for production orders

## ESC Standards
- Production orders are complex - validate state transitions
- Use SetLoadFields on production order lines (can be 100+ lines)
- Apply TryFunction for BOM explosion calculations
- Batch processing for output posting
- Strict validation on routing and capacity

## Common Tasks
- Extending production order tables/pages
- Custom BOM calculation logic
- Routing and work center customizations
- Output posting event subscribers
- Capacity planning extensions
- Production journal modifications

## Quick Commands
Use these workflows:
- `/specify [feature]` → Start with user spec
- `/plan [spec]` → Create technical design
- `/tasks [plan] [phase]` → Break into small tasks
- `/implement [tasks] next` → Code with ESC compliance
- `/review [file]` → Check standards

## Remember
- Production state machine is complex - validate transitions
- BOM explosions can be recursive - watch for infinite loops
- Performance: production lines and routing have many records
- Security: verify production planning permissions
- BC27 compatibility: check events in BC27_EVENTS_MANUFACTURING.md
- Always test with multi-level BOMs
