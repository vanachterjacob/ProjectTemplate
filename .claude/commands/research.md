# Research Phase (RIPER Step 1/5)

**Purpose:** Gather all context before planning implementation.

**Phase:** Research → Innovate → Plan → Execute → Review

---

## What is the Research Phase?

The Research phase is the foundation of successful feature development. It systematically gathers:
- Relevant BC27 events and extension points
- Existing similar features in codebase
- Dependencies and module relationships
- Performance considerations
- Security and permission requirements

**Key Benefit:** Prevents rework by ensuring complete context before technical planning.

---

## Usage

```bash
/research [feature-name]
```

**Examples:**
```bash
/research sales-commission-calculation
/research warehouse-bin-validation
/research api-rate-limiter
```

---

## What Happens During Research?

### 1. BC27 Event Discovery (Automatic)

**Using RAG (if available):**
```python
from tools.rag_bc27 import BC27RAG

rag = BC27RAG()

# Intelligent search for relevant events
events = rag.query_with_claude(
    f"What BC27 events are relevant for {feature_name}?",
    filter_category="events"
)
```

**Using MCP Server (if available):**
```python
# MCP server automatically called for event discovery
search_bc_events({
    "table_name": identified_table,
    "operation": identified_operation
})
```

**Fallback (manual search):**
- Search BC27_EVENT_CATALOG.md
- Search module-specific event catalogs

### 2. Codebase Analysis (Automatic)

Search existing code for similar patterns:
```bash
# Find similar features
grep -r "commission" src/
grep -r "calculation" src/

# Find related table extensions
find src/ -name "*Sales*Header*.al"
```

### 3. Dependency Analysis (Automatic)

**Check BC27 modules:**
- Load BC27_MODULES_OVERVIEW.md
- Identify dependent modules
- Check for integration points

**Check app.json:**
- Review existing dependencies
- Identify potential new dependencies

### 4. Performance Considerations (Automatic)

**Load performance rules:**
- `.cursor/rules/004-performance.mdc`

**Check for:**
- Database query patterns (avoid FINDFIRST in loops)
- Set-based operations requirements
- Caching opportunities

### 5. Security Analysis (Automatic)

**Check permission requirements:**
- Load `.cursor/rules/007-deployment-security.mdc`

**Identify:**
- Required permission sets
- Data access levels (Read/Insert/Modify/Delete)
- Indirect permissions needed

---

## Output: Research Document

Creates: `.agent/research/[feature-name]-research.md`

**Document Structure:**

```markdown
# Research: [Feature Name]

**Date:** YYYY-MM-DD
**Phase:** Research (RIPER 1/5)
**Status:** Complete

---

## Feature Overview

[Brief description of what this feature does]

---

## BC27 Events Discovered

### Recommended Events
1. **OnBeforePostSalesDoc** (Codeunit 80 - Sales-Post)
   - **When:** Before posting sales document
   - **Use for:** Validation, commission calculation
   - **Signature:** `OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; ...)`

2. **OnAfterPostSalesDoc** (Codeunit 80 - Sales-Post)
   - **When:** After successful posting
   - **Use for:** Commission entry creation, notifications
   - **Signature:** `OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; ...)`

### Alternative Events
[Other events considered but not recommended]

---

## Existing Similar Features

### Found in Codebase
- `src/SalesDiscountCalculation.al` - Similar calculation pattern
- `src/CustomerCommission.al` - Related commission logic (deprecated?)

### Patterns to Reuse
1. Discount calculation pattern (line 42-67 in SalesDiscountCalculation.al)
2. Validation pattern (line 89-103)

### Patterns to Avoid
1. FINDFIRST in loop (CustomerCommission.al:145) - performance issue

---

## Dependencies

### BC27 Modules Required
- **Sales & Receivables** (already included)
- **General Ledger** (for commission entries)

### app.json Dependencies
- No new dependencies required
- All modules available in BC27 base

### Integration Points
- Sales Header table (36)
- Sales Line table (37)
- G/L Entry table (17) - for commission postings

---

## Performance Considerations

### Expected Volume
- 100-500 sales invoices per day
- Real-time calculation (posting time)

### Performance Requirements (ESC)
- <100ms per calculation (per-line operation)
- No database queries in loops
- Use SETAUTOCALCFIELDS for Amounts

### Recommended Pattern
- Calculate during OnBeforePostSalesDoc
- Batch commission entries (one per posting, not per line)

---

## Security & Permissions

### Permission Sets Needed
**New Permission Set:** ABC Commission Management
- **Tables:**
  - Sales Header: Read, Modify
  - Sales Line: Read
  - G/L Entry: Insert (commission entries)

- **Pages:**
  - Sales Order: Modify
  - Sales Invoice: Read

### User Roles
- Sales Manager: Full access
- Salesperson: Read-only (view commission)

---

## Recommended Approach

Based on research:

1. **Event-based calculation** (OnBeforePostSalesDoc)
   - ✅ Real-time validation
   - ✅ Atomic with posting
   - ⚠️ Must be <100ms (ESC requirement)

2. **Table extensions:**
   - Sales Header: Add "Commission Percentage" field
   - Sales Line: Add "Commission Amount" field

3. **Commission posting:**
   - OnAfterPostSalesDoc: Create G/L entries for commission

---

## Next Steps

1. **Run:** `/innovate sales-commission-calculation`
   - Explore 3-5 solution approaches
   - Evaluate trade-offs
   - Select best approach

2. **Then run:** `/plan sales-commission-calculation`
   - Create technical design
   - Define object structure
   - Plan implementation

---

## References

- BC27_EVENT_CATALOG.md (Sales events)
- BC27_EVENTS_SALES.md (detailed signatures)
- .cursor/rules/002-development-patterns.mdc (ESC patterns)
- .cursor/rules/004-performance.mdc (performance rules)
- src/SalesDiscountCalculation.al (similar pattern)

---

**Research Status:** ✅ Complete
**Time Invested:** [Auto-calculated]
**Ready for Innovation Phase:** Yes
```

---

## Integration with Other Tools

### With RAG (Priority 4)
```python
# Automatically retrieves relevant BC27 docs
rag = BC27RAG()
results = rag.query_with_claude(
    f"What are the best practices for implementing {feature_name}?"
)
```

### With MCP Server (Priority 3)
```python
# Automatically queries BC database/catalog
mcp.call_tool("search_bc_events", {
    "table_name": "Sales Header",
    "operation": "posting"
})
```

### With Prompt Caching (Priority 1)
```python
# Cache BC27 docs during research
cached_context = get_bc27_context(
    quick_ref=True,
    event_catalog=True,
    module="sales"
)
```

---

## Success Criteria

Research phase is complete when:
- ✅ All relevant BC27 events identified
- ✅ Similar codebase patterns found
- ✅ Dependencies documented
- ✅ Performance requirements understood
- ✅ Security needs identified
- ✅ Recommended approach documented

---

## Tips

1. **Be thorough:** 30 minutes of research saves 3 hours of rework
2. **Document everything:** Future you will thank present you
3. **Find patterns:** Reuse > reinvent
4. **Think performance:** ESC requirements are strict
5. **Consider security:** Permission sets are mandatory

---

**Next Command:** `/innovate [feature-name]`
