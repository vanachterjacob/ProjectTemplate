# Posting & Financial Project Memory

This project focuses on **Posting Routines & Financial Ledgers** in Business Central.

## Primary Focus
- G/L posting and journal entries
- Custom ledger entries
- Financial reporting
- Cost accounting
- Journal modifications

## Default Context to Load
When I ask about posting features, automatically use:
- `@posting-context` skill for complete posting documentation
- BC27 posting events from `BC27/BC27_EVENT_CATALOG.md`
- Performance rules for ledger operations

## ESC Standards
- Posting is critical - NEVER skip validation
- Always use database transactions properly
- Apply TryFunction for posting validation
- Performance: ledger entries can be millions of records
- Use SetLoadFields when reading ledgers
- Follow strict error handling patterns

## Common Tasks
- Subscribing to posting events (OnBeforePost, OnAfterPost)
- Creating custom ledger entry tables
- Building posting codeunits
- G/L journal modifications
- Financial report extensions
- Custom posting validation

## Quick Commands
Use these workflows:
- `/specify [feature]` → Start with user spec
- `/plan [spec]` → Create technical design
- `/tasks [plan] [phase]` → Break into small tasks
- `/implement [tasks] next` → Code with ESC compliance
- `/review [file]` → Check standards (critical for posting!)

## Critical Rules
- ✅ NEVER modify posted documents
- ✅ Always validate before posting
- ✅ Use transactions for atomicity
- ✅ Log posting errors comprehensively
- ✅ Test posting reversal scenarios
- ✅ Verify dimension handling
- ✅ Check number series in posting

## Remember
- Posting errors affect financial accuracy - zero tolerance
- Performance critical: ledger tables are HUGE
- Security: verify posting permissions strictly
- BC27 compatibility: check posting events in BC27_EVENT_CATALOG.md
- Always test with real-world data volumes
- Posting is often irreversible - validate thoroughly
