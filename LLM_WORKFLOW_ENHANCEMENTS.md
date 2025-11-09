# LLM Workflow Enhancements - Beyond Editor Features
**Focus:** Multi-project AL development workflow optimalisaties

**Context:** AL developer met meerdere BC26/27 SaaS klanten
**Problem:** Editor features (snippets, IntelliSense) helpen per file, maar niet met workflow/context management

---

## 🎯 Real LLM-Specific Optimizations

### **1. Architecture Decision Records (ADR) - Conversational Memory**

**Probleem:**
- Je maakt development keuzes in LLM conversatie
- Volgende sessie/developer kent de context niet
- "Waarom hebben we dit zo gedaan?" → niemand weet het meer

**Oplossing: Auto-tracked ADR tijdens development**

```markdown
.claude/adr/
├── 0001-use-custom-ledger-for-commission.md
├── 0002-event-subscriber-over-table-trigger.md
└── 0003-separate-api-per-customer.md
```

**Voorbeeld ADR (auto-generated door LLM):**
```markdown
# ADR-0001: Use Custom Ledger for Commission Tracking

**Date:** 2025-11-09
**Status:** Accepted
**Context:** Customer ABC needs commission tracking separate from G/L

**Decision:**
Create custom "ABC Commission Ledger Entry" table instead of using G/L Entry

**Rationale:**
1. Commission data has different retention requirements (7 years vs 10 years)
2. Different security model (sales team access vs accounting)
3. Performance: G/L Entry table has 10M+ records
4. BC27 ESC: Custom ledger tables are best practice for domain-specific data

**Consequences:**
- Positive: Faster queries, better security, clearer data model
- Negative: Extra table to maintain, custom posting routine needed
- Migration: One-time data migration from G/L custom fields

**Implementation:**
- Table 77105 "ABC Commission Ledger Entry"
- Codeunit 77106 "ABC Commission Post"
- Event subscriber on Sales-Post (OnAfterSalesPost)

**Review Date:** 2025-12-09 (verify performance after 1 month)
```

**LLM Integration:**
```markdown
# In .claude/commands/adr-create.md
When making architectural decisions during conversation:
1. Auto-detect decision points (e.g., "I'll create a custom table instead of...")
2. Prompt: "Should I document this as ADR?"
3. Generate ADR from conversation context
4. Save to .claude/adr/NNNN-decision-name.md
5. Reference ADR in code comments

# Auto-loaded in future sessions
When user asks "why did we...", search ADR folder first
```

**Benefits:**
- ✅ No info loss between sessions
- ✅ Toekomstige LLM sessies kennen context
- ✅ Team knowledge preservation
- ✅ Audit trail voor klant

---

### **2. Multi-Project Context Switching Matrix**

**Probleem:**
- Je werkt aan Klant A (prefix ABC, warehouse focus)
- Switch naar Klant B (prefix XYZ, API focus)
- LLM moet elke keer opnieuw uitleg krijgen

**Oplossing: Project Context Matrix**

```markdown
.claude/projects/
├── customer-abc.project.md
├── customer-xyz.project.md
└── internal-tools.project.md
```

**Voorbeeld: customer-abc.project.md**
```yaml
---
prefix: ABC
bc_version: BC27
environment: SaaS Production
focus_areas: [warehouse, inventory, shipping]
customer_name: "ABC Logistics B.V."
go_live: "2024-03-15"
---

# Project Context: ABC Logistics

## Quick Facts
- **BC Version:** BC27 (SaaS)
- **Object Range:** 77100-77200 (dev), 50100-50200 (prod)
- **Customizations:** WMS, advanced shipping, EDI integration
- **Team:** 2 developers, 1 consultant
- **Deploy Schedule:** Every 2 weeks (Friday 18:00)

## Architecture Decisions
- Use Job Queue for EDI processing (not real-time) → See ADR-0003
- Custom bin optimization algorithm → See ADR-0008
- Separate permission sets per warehouse location

## Customer-Specific Patterns
```al
// ABC always wants confirm dialogs with default = Yes
if not ConfirmManagement.GetResponseOrDefault(QuestionTxt, true) then
    exit;

// ABC uses custom shipping agent integration
procedure ValidateShippingAgent()
begin
    if "Shipping Agent Code" <> '' then
        ABCShippingIntegration.ValidateAgent("Shipping Agent Code");
end;
```

## Known Issues / Quirks
- Customer uses non-standard item numbering (starts with location code)
- Warehouse team works 24/7, be careful with Job Queue timing
- EDI partner uses custom XML schema (not standard EDIFACT)

## Integration Points
- External WMS: REST API on https://wms.abc-logistics.nl/api
- EDI Provider: SFTP polling every 15 min
- Label Printer: Direct IP printing (not Windows driver)

## Performance Notes
- Item Ledger Entry: 5M+ records, ALWAYS use SetLoadFields
- Bin Content: 500K+ records, use SIFT for aggregations
- Customer ships 5000+ orders/day peak season

## Contact / Escalation
- Functional: Jan Janssen (jan@abc.nl)
- Technical: Piet Pietersen (piet@abc.nl)
- Emergency: +31 6 12345678

## Memory Triggers
When working on ABC project:
- Load @warehouse-context
- Load @performance-context (high volume!)
- Remember: Confirm dialogs default to Yes
- Check ADR folder for warehouse decisions
```

**LLM Command: /switch-project**
```markdown
# .claude/commands/switch-project.md
---
description: Switch LLM context to different customer project
model: haiku
---

**Usage:** `/switch-project [customer-name]`

**Example:** `/switch-project abc`

**Process:**
1. Load .claude/projects/{customer-name}.project.md
2. Load project-specific ADRs
3. Load relevant context preset (from project config)
4. Update prefix in working memory
5. Load recent conversation summary (if exists)

**Output:**
"Switched to ABC Logistics project
- Prefix: ABC
- Focus: Warehouse, Inventory
- BC Version: BC27 SaaS
- Remember: Confirm dialogs default to Yes
Ready to work on ABC project."
```

**Benefits:**
- ✅ Zero context switch overhead
- ✅ Customer-specific patterns remembered
- ✅ No meer vergeten welke prefix/conventions
- ✅ Instant project context loading

---

### **3. Session Checkpoints & Resumption**

**Probleem:**
- Lange development sessie (bijv. complex feature over 2 dagen)
- LLM conversatie wordt te lang/duur
- Of je moet stoppen en later verder

**Oplossing: Conversation Checkpoints**

```markdown
.claude/sessions/
├── 2025-11-09-commission-feature.checkpoint.md
└── 2025-11-08-api-refactor.checkpoint.md
```

**Voorbeeld Checkpoint:**
```markdown
# Session Checkpoint: Commission Feature Implementation
**Date:** 2025-11-09 14:30
**Project:** ABC Logistics
**Status:** In Progress (60% complete)

## Session Summary
Implementing custom commission tracking system for sales team.

## Completed Tasks
- ✅ Created table 77105 "ABC Commission Ledger Entry"
- ✅ Created codeunit 77106 "ABC Commission Post"
- ✅ Event subscriber on Sales-Post working
- ✅ Permission sets created

## In Progress
- 🔄 Building commission calculation rules engine (70% done)
- 🔄 Page 77105 "Commission Entries" (UI sketched, not implemented)

## Pending Tasks
- ⏳ Report 77105 "Commission Statement"
- ⏳ API endpoint for external reporting tool
- ⏳ Data migration from old G/L custom fields
- ⏳ Testing & ESC review

## Key Decisions Made
- Using custom ledger instead of G/L (see ADR-0001)
- Commission % stored per customer, not per salesperson
- Monthly settlement, not per-invoice

## Current Context
Working on: Codeunit 77107 "ABC Commission Calculator"
Issue: Need to handle split commissions (multiple salespeople per order)
Approach: Using temporary table for calculation, then post in batch

## Next Session TODO
1. Finish split commission logic in Calculator codeunit
2. Implement Commission Entries page (list + card)
3. Add filters for date range and salesperson

## Files Modified
- src/Tables/ABCCommissionLedgerEntry.Table.al
- src/Codeunits/ABCCommissionPost.Codeunit.al
- src/Codeunits/ABCCommissionCalculator.Codeunit.al (IN PROGRESS)
- src/EventSubscribers/SalesPostEvents.Codeunit.al

## Technical Notes
- Performance: 10K commission entries/month expected, no SetLoadFields needed yet
- Security: New permission set "ABC-COMMISSION-VIEW" for sales team
- Integration: Will need webhook to notify external BI tool (future sprint)

## Questions / Blockers
- Customer hasn't decided: Commission on invoiced or shipped amount?
- Waiting for: Final commission % per customer category (expect Monday)
```

**LLM Command: /checkpoint**
```markdown
# .claude/commands/checkpoint.md
---
description: Save current development session state
model: sonnet
---

**Usage:** `/checkpoint [session-name]`

**Example:** `/checkpoint commission-feature`

**Process:**
1. Analyze conversation history (last 50-100 messages)
2. Extract:
   - Completed tasks (from commits, code changes)
   - In-progress work (from recent discussion)
   - Pending tasks (from user statements)
   - Key decisions made
   - Current blockers
3. Generate checkpoint markdown
4. Save to .claude/sessions/YYYY-MM-DD-{session-name}.checkpoint.md

**Benefits:**
- Resume session later with full context
- Share progress with team/customer
- Track development velocity
- Audit trail
```

**LLM Command: /resume**
```markdown
# .claude/commands/resume.md
---
description: Resume previous development session
model: sonnet
---

**Usage:** `/resume [session-name]`

**Example:** `/resume commission-feature`

**Process:**
1. Load .claude/sessions/*-{session-name}.checkpoint.md
2. Load associated project context
3. Restore:
   - Working context (what was being worked on)
   - Pending decisions
   - Next tasks
   - Files in scope
4. Check git status for any changes since checkpoint
5. Prompt: "Ready to continue. Last worked on: [X]. Next task: [Y]?"

**Output:**
"Resumed session: Commission Feature Implementation
Last checkpoint: 2025-11-09 14:30 (60% complete)
Working on: Split commission logic in Calculator codeunit
Next: Finish calculator, then implement UI pages
Blockers: Waiting for customer decision on invoiced vs shipped amount
Ready to continue?"
```

**Benefits:**
- ✅ No context loss tussen sessies
- ✅ Pick up waar je gebleven was
- ✅ Deel voortgang met team
- ✅ Long-running features trackable

---

### **4. Cross-Project Pattern Learning**

**Probleem:**
- Je bouwt geweldige pattern in Project A
- Project B heeft zelfde probleem
- LLM weet niet dat je dit al opgelost hebt

**Oplossing: Pattern Library met Cross-References**

```markdown
.claude/patterns/
├── learned/
│   ├── custom-ledger-posting.pattern.md
│   ├── edi-error-handling.pattern.md
│   └── batch-api-calls.pattern.md
└── index.md
```

**Voorbeeld Pattern:**
```markdown
# Pattern: Custom Ledger Posting with Rollback

**Source Project:** ABC Logistics (commission tracking)
**Date:** 2025-11-09
**Reusability:** High (any custom ledger scenario)

## Problem
Need to post custom ledger entries with full rollback on error (like G/L posting)

## Solution
```al
codeunit 77106 "ABC Commission Post"
{
    var
        TempCommissionEntry: Record "ABC Commission Ledger Entry" temporary;
        PostingInProgress: Boolean;

    procedure Post(var CommissionEntry: Record "ABC Commission Ledger Entry"): Boolean
    var
        CommissionLedgerEntry: Record "ABC Commission Ledger Entry";
    begin
        // Use Try-function pattern for full rollback
        if not TryPost(CommissionEntry) then begin
            RollbackPosting();
            exit(false);
        end;

        CommitPosting();
        exit(true);
    end;

    [TryFunction]
    local procedure TryPost(var CommissionEntry: Record "ABC Commission Ledger Entry")
    var
        EntryNo: Integer;
    begin
        PostingInProgress := true;
        TempCommissionEntry.DeleteAll();

        // Stage all entries in temp table first
        repeat
            TempCommissionEntry := CommissionEntry;
            TempCommissionEntry.Insert();
        until CommissionEntry.Next() = 0;

        // Assign entry numbers
        EntryNo := GetLastEntryNo() + 1;
        if TempCommissionEntry.FindSet() then
            repeat
                CommissionLedgerEntry := TempCommissionEntry;
                CommissionLedgerEntry."Entry No." := EntryNo;
                CommissionLedgerEntry.Insert(true);
                EntryNo += 1;
            until TempCommissionEntry.Next() = 0;

        PostingInProgress := false;
    end;

    local procedure RollbackPosting()
    begin
        TempCommissionEntry.DeleteAll();
        PostingInProgress := false;
        // Transaction auto-rolls back due to TryFunction error
    end;

    local procedure CommitPosting()
    begin
        TempCommissionEntry.DeleteAll();
        Commit();
    end;
}
```

## When to Use
- Custom ledger tables (commission, points, custom G/L)
- Any "posting" scenario needing atomicity
- Batch operations that must be all-or-nothing

## Benefits
- Full rollback on error (no partial posts)
- Performance: Temp table staging
- ESC compliant: TryFunction pattern
- Testable: Can verify temp table before commit

## Variants
- **With progress dialog:** Add GuiAllowed checks and dialog updates
- **With batch commit:** Commit every N entries for large batches
- **With event publishing:** OnBeforePost, OnAfterPost events

## Used In Projects
- ABC Logistics (commission posting)
- XYZ Manufacturing (production output)
- DEF Retail (loyalty points)

## ESC Compliance
- ✅ TryFunction pattern
- ✅ No direct Error() calls
- ✅ Transaction management
- ✅ Temp tables for staging

## Performance
- Temp table overhead: ~5ms for 100 entries
- Entry number locking: Uses DB sequence, no deadlocks
- Tested with: 10K entries/batch = 2.5s
```

**LLM Integration:**
```markdown
# In .claude/commands/find-pattern.md
When user describes a problem, search pattern library:
1. Check .claude/patterns/index.md for keyword matches
2. Load relevant pattern file
3. Ask: "This is similar to [Pattern X] from [Project Y]. Apply this pattern?"
4. Adapt pattern to current project (prefix, table names, etc.)

**Benefits:**
- Reuse proven solutions
- Cross-project knowledge sharing
- Faster development (don't reinvent)
```

---

### **5. Impact Analysis Before Code Changes**

**Probleem:**
- Je wijzigt table field of event subscriber
- LLM weet niet welke andere customizations impact hebben
- Breaking changes ontdekt te laat

**Oplossing: Dependency Graph + Impact Analysis**

```markdown
# .claude/commands/impact-analyze.md
---
description: Analyze impact of proposed code change
model: sonnet
---

**Usage:** `/impact-analyze [object-type] [object-name] [change-type]`

**Example:** `/impact-analyze table "Sales Header" modify-field`

**Process:**
1. Build dependency graph:
   - Which pages use this table?
   - Which codeunits reference this field?
   - Which event subscribers hook into this?
   - Which reports query this?

2. Check for:
   - Breaking changes (field rename, type change)
   - Data migration needs
   - Permission changes needed
   - API contract breaks

3. Analyze upgrade impact:
   - Will this break BC26 compatibility?
   - Need upgrade codeunit?
   - Data migration required?

4. Generate impact report:

**Output:**
```markdown
# Impact Analysis: Modify "Sales Header"."ABC Custom Field"

## Proposed Change
Change field type from Code[20] to Code[50]

## Direct Impact (3 objects affected)
- ⚠️ Page 77101 "ABC Sales Order Ext" - Field width needs update
- ⚠️ Codeunit 77102 "ABC Sales Validation" - Validation logic OK (string length)
- ✅ Report 77100 "ABC Sales Analysis" - No impact (just displays value)

## Indirect Impact (1 object)
- ⚠️ API Page 77200 "ABC Sales API" - **BREAKING CHANGE**
  - External integration expects max 20 chars
  - Need API version bump or compatibility layer

## Data Migration
- ✅ No data loss (expanding field size)
- ⏳ Need to update existing validation rules (currently check length < 20)

## Upgrade Path
```al
codeunit 77199 "ABC Upgrade"
{
    trigger OnUpgradePerCompany()
    begin
        // No data migration needed (field expansion)
        // But validate all existing records fit new validation
        ValidateExistingRecords();
    end;
}
```

## Recommendations
1. ⚠️ Contact API integration partner before deploying
2. ✅ Update validation codeunit to allow length 20-50
3. ✅ Update page field to width 50
4. Consider: Keep API at length 20 for compatibility?

## Estimated Effort
- Code changes: 30 minutes
- Testing: 1 hour
- API partner coordination: 1-2 days
- **Total: 2-3 days** (mostly waiting for partner)

## Risk Level: MEDIUM
Breaking change for external integration.
```
```

**Benefits:**
- ✅ No surprise breaking changes
- ✅ Proactive impact assessment
- ✅ Better estimates
- ✅ Customer communication prep

---

## 📊 Comparison: Editor vs LLM Features

| Feature | Editor (Cursor/VSCode) | LLM Enhancement |
|---------|----------------------|----------------|
| Code completion | ✅ Excellent | ➖ Same |
| Error detection | ✅ Built-in | ➖ Same |
| Refactoring | ✅ Some | ➖ Same |
| **Architecture decisions** | ❌ Not tracked | ✅ **ADR auto-generation** |
| **Multi-project context** | ❌ Manual switching | ✅ **/switch-project** |
| **Session resumption** | ❌ Lost on restart | ✅ **/checkpoint & /resume** |
| **Cross-project learning** | ❌ No memory | ✅ **Pattern library** |
| **Impact analysis** | ❌ Manual | ✅ **/impact-analyze** |
| **Customer-specific patterns** | ❌ Not stored | ✅ **Project context files** |
| **Long conversation management** | ❌ Token limit issues | ✅ **Smart checkpointing** |

---

## 🚀 Implementation Priority

### Week 1: Essential (Direct productivity impact)
1. **ADR Auto-tracking** - 2 days
   - Command: /adr-create
   - Auto-detect decisions in conversation
   - Template generation

2. **Multi-Project Switching** - 2 days
   - Project context files template
   - Command: /switch-project
   - Prefix/conventions auto-load

### Week 2: High Value (Workflow improvement)
3. **Session Checkpoints** - 3 days
   - Commands: /checkpoint, /resume
   - Auto-summarization logic
   - Git integration

### Week 3: Advanced (Team value)
4. **Pattern Library** - 2 days
   - Pattern template
   - Command: /find-pattern
   - Cross-reference system

5. **Impact Analysis** - 3 days
   - Dependency graph builder
   - Command: /impact-analyze
   - Breaking change detection

---

## 💡 Which Features Are Most Valuable for You?

Given your multi-customer BC26/27 SaaS work:

**A) Must-Have** - Project switching + ADR (Week 1)
**B) Nice-to-Have** - Add session checkpoints (Week 2)
**C) Full Suite** - All 5 features (3 weeks)
**D) Custom** - Pick specific features

Let me know what fits your workflow best! 🎯
