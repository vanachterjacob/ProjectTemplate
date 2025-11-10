# Innovate Phase (RIPER Step 2/5)

**Purpose:** Explore multiple solution approaches before committing to implementation.

**Phase:** Research → **Innovate** → Plan → Execute → Review

---

## What is the Innovation Phase?

The Innovation phase systematically explores alternative approaches:
- Generate 3-5 different solution designs
- Evaluate trade-offs (performance, complexity, maintainability)
- Score each approach across key criteria
- Recommend best approach with clear justification

**Key Benefit:** Avoid "first solution bias" - the first idea is rarely the best idea.

---

## Usage

```bash
/innovate [feature-name]
```

**Prerequisites:**
- Research phase must be complete
- `.agent/research/[feature-name]-research.md` must exist

**Examples:**
```bash
/innovate sales-commission-calculation
/innovate warehouse-bin-validation
/innovate api-rate-limiter
```

---

## What Happens During Innovation?

### 1. Load Research Context (Automatic)

```markdown
# Load research findings
research_doc = read_file(".agent/research/[feature-name]-research.md")

# Extract key constraints:
- Available events
- Performance requirements
- Security needs
- Dependencies
```

### 2. Generate Alternative Approaches (3-5 options)

**Approach Generation Framework:**

For each approach, define:
- **Architecture:** Event-based, job queue, codeunit call, etc.
- **Data model:** Tables to extend, fields to add
- **Processing pattern:** Real-time, batch, hybrid
- **Integration points:** Events, web services, APIs

### 3. Evaluate Trade-Offs

**Evaluation Criteria (Score 1-5):**
- **Performance:** Meets ESC requirements (<100ms)
- **Complexity:** Implementation and maintenance effort
- **Maintainability:** Code clarity, future changes
- **ESC Compliance:** Follows all mandatory patterns
- **Scalability:** Handles growth (2x, 10x volume)
- **User Experience:** Response time, feedback
- **Testability:** Easy to test, mock, validate

### 4. Score and Rank

**Scoring Matrix:**

| Approach | Perf | Complex | Maint | ESC | Scale | UX | Test | **Total** |
|----------|------|---------|-------|-----|-------|----|----- |-----------|
| Option 1 | 4    | 3       | 4     | 5   | 3     | 5  | 4    | **28/35** |
| Option 2 | 5    | 2       | 3     | 5   | 5     | 3  | 4    | **27/35** |
| Option 3 | 3    | 5       | 5     | 4   | 4     | 4  | 5    | **30/35** |

### 5. Recommend Best Approach

**Selection Criteria:**
1. **Highest total score** (primary)
2. **No score < 3** in critical areas (Performance, ESC)
3. **Business value** (if tie)

---

## Output: Innovation Document

Creates: `.agent/innovation/[feature-name]-options.md`

**Document Structure:**

```markdown
# Innovation: [Feature Name]

**Date:** YYYY-MM-DD
**Phase:** Innovate (RIPER 2/5)
**Status:** Complete
**Research Input:** `.agent/research/[feature-name]-research.md`

---

## Constraints (from Research)

- **Performance:** <100ms per sales line calculation
- **Events Available:** OnBeforePostSalesDoc, OnAfterPostSalesDoc
- **Tables:** Sales Header (36), Sales Line (37), G/L Entry (17)
- **ESC Requirements:** Early exit, TryFunction, no queries in loops

---

## Option 1: Real-Time Event Calculation

### Architecture
- **Trigger:** OnBeforePostSalesDoc event
- **Processing:** Calculate commission during posting
- **Storage:** Commission Amount field on Sales Line
- **Posting:** OnAfterPostSalesDoc creates G/L entries

### Implementation Overview
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
local procedure CalculateCommission(var SalesHeader: Record "Sales Header")
var
    SalesLine: Record "Sales Line";
    CommissionPct: Decimal;
begin
    CommissionPct := SalesHeader."Commission Percentage";

    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
    SalesLine.SetRange("Document No.", SalesHeader."No.");

    if SalesLine.FindSet() then
        repeat
            SalesLine."Commission Amount" := SalesLine."Line Amount" * CommissionPct / 100;
            SalesLine.Modify();
        until SalesLine.Next() = 0;
end;
```

### Pros
✅ Real-time calculation (immediate feedback)
✅ Simple architecture (single event)
✅ Atomic with posting (all-or-nothing)
✅ User sees commission before confirming

### Cons
❌ Performance risk (if 1000+ lines)
❌ Modifies lines during posting (potential lock issues)
❌ No commission history (overwrites on repost)

### Evaluation Scores
- Performance: **4/5** (fast for <500 lines, risk at scale)
- Complexity: **5/5** (very simple)
- Maintainability: **4/5** (straightforward logic)
- ESC Compliance: **5/5** (follows all patterns)
- Scalability: **3/5** (struggles with 1000+ lines)
- User Experience: **5/5** (immediate feedback)
- Testability: **4/5** (easy to test)

**Total: 30/35**

---

## Option 2: Batch Job Queue Calculation

### Architecture
- **Trigger:** OnAfterPostSalesDoc schedules job queue entry
- **Processing:** Background job calculates commission
- **Storage:** Commission Entry table (new)
- **Posting:** Job creates G/L entries asynchronously

### Implementation Overview
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
local procedure ScheduleCommissionCalculation(var SalesHeader: Record "Sales Header")
var
    JobQueueEntry: Record "Job Queue Entry";
begin
    JobQueueEntry.ScheduleJobQueueEntry(
        Codeunit::"ABC Commission Calculator",
        SalesHeader.RecordId
    );
end;
```

### Pros
✅ Zero performance impact on posting
✅ Scalable (handles any volume)
✅ Commission history preserved
✅ Retry logic for failed calculations

### Cons
❌ Delayed calculation (not real-time)
❌ Complex architecture (job queue + table)
❌ User doesn't see commission immediately
❌ Requires monitoring/error handling

### Evaluation Scores
- Performance: **5/5** (zero impact on posting)
- Complexity: **2/5** (job queue + retry logic)
- Maintainability: **3/5** (more moving parts)
- ESC Compliance: **5/5** (follows all patterns)
- Scalability: **5/5** (unlimited scale)
- User Experience: **2/5** (delayed feedback)
- Testability: **3/5** (async testing hard)

**Total: 25/35**

---

## Option 3: Hybrid (Event + Validation)

### Architecture
- **Validation:** OnValidate for "Commission Percentage" field
- **Processing:** Calculate commission on field change
- **Storage:** Commission Amount on Sales Line
- **Posting:** OnAfterPostSalesDoc creates G/L entries

### Implementation Overview
```al
tableextension 77100 "ABC Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(77100; "Commission Percentage"; Decimal)
        {
            trigger OnValidate()
            begin
                // Recalculate all line commissions
                RecalculateCommissions();
            end;
        }
    }

    local procedure RecalculateCommissions()
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");

        if SalesLine.FindSet() then
            repeat
                SalesLine."Commission Amount" := SalesLine."Line Amount" * "Commission Percentage" / 100;
                SalesLine.Modify();
            until SalesLine.Next() = 0;
    end;
}
```

### Pros
✅ Real-time feedback (on field change)
✅ Zero impact on posting (pre-calculated)
✅ User controls when calculation happens
✅ Simple architecture (no job queue)

### Cons
❌ Requires user to set percentage before posting
❌ Multiple recalculations if user changes value
❌ Recalculates all lines (even unchanged)

### Evaluation Scores
- Performance: **5/5** (no posting impact)
- Complexity: **4/5** (straightforward)
- Maintainability: **5/5** (simple logic)
- ESC Compliance: **5/5** (follows all patterns)
- Scalability: **4/5** (good for normal volumes)
- User Experience: **4/5** (controlled by user)
- Testability: **5/5** (very testable)

**Total: 32/35** ⭐ **HIGHEST SCORE**

---

## Option 4: Cached Calculation Service

### Architecture
- **Service:** Codeunit with caching
- **Trigger:** Called from multiple places (page, posting, reports)
- **Cache:** In-memory cache (session variable)
- **Storage:** Calculated on-demand, not stored

### Pros
✅ Performance (cached results)
✅ Reusable (pages, reports, posting)
✅ No data duplication
✅ Single source of truth

### Cons
❌ Cache invalidation complexity
❌ Session-dependent (doesn't work cross-session)
❌ Requires refactoring existing code
❌ Higher implementation effort

### Evaluation Scores
- Performance: **4/5** (cache helps)
- Complexity: **2/5** (cache invalidation hard)
- Maintainability: **3/5** (cache bugs tricky)
- ESC Compliance: **4/5** (mostly compliant)
- Scalability: **4/5** (good with cache)
- User Experience: **4/5** (fast after cache hit)
- Testability: **3/5** (cache state issues)

**Total: 24/35**

---

## Recommendation

### Selected Approach: **Option 3 - Hybrid (Event + Validation)**

**Score: 32/35** ⭐

**Why this approach?**

1. **Best Balance:**
   - High performance (5/5)
   - Simple architecture (4/5)
   - Excellent maintainability (5/5)
   - Perfect ESC compliance (5/5)

2. **User Experience:**
   - User controls when calculation happens
   - Real-time feedback on field change
   - No surprises during posting

3. **Implementation Clarity:**
   - Single clear pattern (OnValidate trigger)
   - No async complexity
   - Easy to test and debug

4. **Scalability:**
   - Handles normal volumes (up to 1000 lines)
   - Could optimize later if needed (only recalc changed lines)

**Runner-Up:** Option 1 (30/35) - Good alternative if immediate feedback not needed

**Avoid:** Option 2 (25/35) - Overengineered for this use case

---

## Implementation Considerations

### From Option 3

1. **Validation Optimization:**
   - Only recalculate if Commission Percentage changed
   - Track previous value to skip unnecessary recalcs

2. **Line-Level Trigger:**
   - Also add OnValidate to Sales Line."Line Amount"
   - Recalculate commission when line amount changes

3. **Performance Safeguard:**
   - If >500 lines, show confirmation dialog
   - Offer batch recalculation option

4. **ESC Patterns:**
   - Use TryFunction for Modify operations
   - Early exit if Commission Percentage = 0
   - Confirm before bulk recalculation

---

## Next Steps

1. **Run:** `/plan sales-commission-calculation`
   - Create technical design based on Option 3
   - Define exact object structure
   - Plan implementation tasks

2. **Document decision:**
   - Add to project wiki
   - Reference in code comments
   - Update team on chosen approach

---

## References

- Research: `.agent/research/sales-commission-calculation-research.md`
- ESC Patterns: `.cursor/rules/002-development-patterns.mdc`
- Performance Rules: `.cursor/rules/004-performance.mdc`

---

**Innovation Status:** ✅ Complete
**Recommended Approach:** Option 3 (Hybrid)
**Ready for Planning Phase:** Yes
```

---

## Integration with Research Phase

Innovation phase builds on research findings:

```markdown
# From research, we know:
- Available events: OnBeforePostSalesDoc, OnAfterPostSalesDoc
- Performance req: <100ms
- Tables: Sales Header, Sales Line

# Innovation explores:
- Which event to use? (Before, After, or Validate?)
- Real-time or batch?
- Store results or calculate on-demand?
```

---

## Success Criteria

Innovation phase is complete when:
- ✅ 3-5 alternative approaches explored
- ✅ Each approach scored across 7 criteria
- ✅ Clear recommendation with justification
- ✅ Runner-up identified (backup plan)
- ✅ Implementation considerations documented

---

## Tips

1. **Think divergent first:** Generate options without judging
2. **Then converge:** Evaluate and score objectively
3. **Consider extremes:** What if volume is 100x? 0.1x?
4. **Ask "what if?":** What if requirement changes later?
5. **Document rejected options:** Future you will wonder "why not X?"

---

**Next Command:** `/plan [feature-name]` (using recommended approach)
