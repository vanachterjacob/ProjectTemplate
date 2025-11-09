---
description: Save current solution as reusable pattern
model: sonnet
---

# Save Pattern to Library

**Purpose:** Document current solution as reusable pattern for future projects

**Usage:** `/save-pattern [pattern-name]`

**Example:** `/save-pattern custom-ledger-posting`

---

## Your Task

You are extracting a reusable pattern from the current development work and documenting it for future use.

### Step 1: Analyze Current Work

Review recent conversation and code to identify:

1. **The problem solved**
   - What challenge did we address?
   - What were the constraints?
   - Why is this noteworthy?

2. **The solution approach**
   - What pattern/technique did we use?
   - Why this approach over alternatives?
   - What makes it work well?

3. **Key code elements**
   - Tables, codeunits, pages involved
   - Critical code snippets
   - ESC compliance patterns applied

4. **Applicability**
   - When should this pattern be used?
   - When should it NOT be used?
   - What variations exist?

---

### Step 2: Extract Genericized Code

From the actual implementation:

1. **Replace project-specific elements:**
   - Prefix (ABC → {PREFIX})
   - Entity names (Commission → {Entity})
   - Object IDs (77105 → {ID})
   - Customer-specific logic → Configurable

2. **Keep essential pattern elements:**
   - Structure and flow
   - ESC compliance patterns
   - Error handling approach
   - Transaction management

3. **Add comments explaining:**
   - Why this pattern works
   - Key design decisions
   - Performance considerations

---

### Step 3: Generate Pattern File

Create pattern file at: `.claude/patterns/learned/{pattern-name}.pattern.md`

Use this template:

```markdown
# Pattern: {Pattern Name}

**Source Project:** {Project name}
**Date:** {YYYY-MM-DD}
**Reusability:** {High/Medium/Low}
**Tags:** {tag1}, {tag2}, {tag3}

## Problem

{1-2 paragraphs describing the problem this pattern solves}

**Constraints:**
- Constraint 1
- Constraint 2
- Constraint 3

**Requirements:**
- Requirement 1
- Requirement 2

## Solution

{1-2 paragraphs explaining the approach}

**Key Design Decisions:**
- Decision 1: Rationale
- Decision 2: Rationale

### Architecture

```
{Simple ASCII diagram or description of component structure}
```

### Code Implementation

```al
{Genericized AL code showing the pattern}
```

**Explanation:**
{Line-by-line or section-by-section explanation of key parts}

## When to Use

**✅ Use this pattern when:**
- Scenario 1
- Scenario 2
- Scenario 3

**❌ Don't use this pattern when:**
- Scenario 1
- Scenario 2
- Scenario 3

**Alternatives:**
- Alternative 1: When to use instead
- Alternative 2: When to use instead

## Benefits

- ✅ Benefit 1
- ✅ Benefit 2
- ✅ Benefit 3

## Trade-offs

- ⚠️ Trade-off 1
- ⚠️ Trade-off 2

## Variants

### Variant 1: {Name}
{Description and when to use}

```al
{Code showing variant}
```

### Variant 2: {Name}
{Description and when to use}

## Used In Projects

- {Project 1} - {Specific use case}
- {Project 2} - {Specific use case}

## ESC Compliance

- ✅ Pattern 1 applied
- ✅ Pattern 2 applied
- ⚠️ Consideration 1

## Performance

**Characteristics:**
- Time complexity: {O(n), O(1), etc.}
- Memory usage: {Low/Medium/High}
- Database calls: {Number or estimate}

**Tested with:**
- {Volume 1}: {Performance result}
- {Volume 2}: {Performance result}

**Optimization notes:**
- Note 1
- Note 2

## Related Patterns

- **{Pattern A}**: Similar but for different domain
- **{Pattern B}**: Can be combined with this pattern
- **{Pattern C}**: Alternative approach

## Examples

### Example 1: {Use Case}

**Context:** {Specific scenario}

```al
{Concrete example with real entity names}
```

### Example 2: {Use Case}

**Context:** {Another scenario}

```al
{Another concrete example}
```

## References

- ADR: {Link to related architectural decision record}
- BC Documentation: {Link if applicable}
- External resource: {Link if any}

---

**Version:** 1.0
**Created:** {YYYY-MM-DD}
**Last Used:** {YYYY-MM-DD}
**Times Reused:** {N}
```

---

### Step 4: Update Pattern Index

Add entry to `.claude/patterns/index.md`:

```markdown
### {Pattern Name}

**File:** [learned/{pattern-name}.pattern.md](learned/{pattern-name}.pattern.md)
**Problem:** {One-line problem description}
**Domain:** {sales/posting/api/warehouse/etc.}
**Tags:** {tag1}, {tag2}, {tag3}
**Reusability:** {High/Medium/Low}
**Source:** {Project name}
**Created:** {YYYY-MM-DD}
```

---

### Step 5: Confirm to User

```markdown
## ✅ Pattern Saved: {Pattern Name}

**File:** `.claude/patterns/learned/{pattern-name}.pattern.md`

**Summary:**
- Problem: {Brief problem description}
- Solution: {Brief solution description}
- Reusability: {High/Medium/Low}
- Tags: {tag1}, {tag2}, {tag3}

**Pattern can now be found with:**
```bash
/find-pattern {keywords}
```

**Used in projects:**
- {Current project}

**Benefits for future work:**
{Why this pattern will be valuable}

---

**Next:** Keep building awesome stuff! This pattern will help speed up similar work in future projects. 🚀
```

---

## Important Notes

### Good Patterns to Save

**✅ Worth documenting:**
- Solved non-trivial problem
- Reusable across multiple projects
- Implements ESC compliance well
- Has performance considerations
- Tricky business logic elegantly handled
- Integration pattern with external systems

**❌ Not worth documenting:**
- Trivial/obvious solutions
- Project-specific one-off code
- Standard BC patterns (already documented by Microsoft)
- Temporary workarounds
- Incomplete/untested solutions

### Pattern Quality

**High-quality patterns include:**
- Clear problem statement
- Well-explained solution
- Genericized code (not project-specific)
- Multiple examples
- ESC compliance notes
- Performance characteristics
- When to use / when not to use

**Avoid:**
- Copying code without explanation
- Leaving in project-specific details
- Incomplete code snippets
- Missing context
- No usage guidance

---

## Examples

### Example 1: After Implementing Custom Ledger

```
User: "We just finished the commission tracking feature. The posting pattern seems reusable."

AI: /save-pattern custom-ledger-posting

AI: Analyzing commission posting implementation...

✅ Pattern Saved: Custom Ledger Posting with Rollback

**File:** .claude/patterns/learned/custom-ledger-posting.pattern.md

**Summary:**
- Problem: Need atomic posting with full rollback for custom ledger entries
- Solution: TryFunction pattern with temp table staging
- Reusability: High (any custom ledger scenario)
- Tags: posting, ledger, transactions, rollback, ESC

**Pattern can now be found with:**
```bash
/find-pattern custom ledger
/find-pattern posting rollback
/find-pattern atomic transactions
```

**Used in projects:**
- ABC Logistics (commission tracking)

This pattern will help speed up similar custom ledger implementations in future projects!
```

### Example 2: After API Integration

```
User: "This API rate limiting code is really clean. Let's save it."

AI: /save-pattern api-rate-limiter

AI: Extracting pattern from APIClient codeunit...

✅ Pattern Saved: API Rate Limiter with Exponential Backoff

**File:** .claude/patterns/learned/api-rate-limiter.pattern.md

**Summary:**
- Problem: Prevent API throttling and handle retry logic gracefully
- Solution: Token bucket algorithm with exponential backoff
- Reusability: High (any external API integration)
- Tags: api, integration, rate-limiting, retry, performance

**Pattern can now be found with:**
```bash
/find-pattern api rate limit
/find-pattern external integration retry
```

This pattern will help all future API integrations!
```

---

## Integration with Other Features

### With /find-pattern
```markdown
Pattern library builds over time:
- Save patterns as you solve problems
- Reuse patterns via /find-pattern
- Compound learning across projects
```

### With ADRs
```markdown
If pattern relates to architectural decision:
"This pattern implements ADR-0001 (custom ledger approach).
Should I reference the ADR in pattern documentation?"
```

### With Project Context
```markdown
Pattern gets tagged with source project:
- ABC Logistics → Warehouse domain patterns
- XYZ Manufacturing → Production domain patterns
- Cross-reference for similar customers
```

---

## Pattern Versioning

**When to create new version:**
- Pattern significantly improved
- BC version upgrade changes approach
- ESC standards updated

**How to version:**
```markdown
# Pattern: {Name} (v2.0)

**Changelog:**
- v2.0 (2025-11-09): Updated for BC27, added SetLoadFields
- v1.0 (2024-03-15): Initial version for BC26

**Deprecated versions:**
- v1.0 - Still works but v2.0 recommended for new projects
```

---

## Edge Cases

**Pattern already exists:**
```markdown
⚠️ Pattern "custom-ledger-posting" already exists.

Options:
A) Update existing pattern (add this project as additional use case)
B) Save as variant (e.g., "custom-ledger-posting-async")
C) Cancel (pattern is already documented well enough)

Which option?
```

**Pattern is project-specific:**
```markdown
⚠️ This solution is very specific to ABC Logistics workflow.

The following elements are hard to genericize:
- Custom commission split logic
- ABC-specific customer categories
- Integration with ABC's external BI tool

Recommendation:
- Save as "commission-tracking-ABC" (project-specific)
- OR extract just the reusable parts (e.g., split calculation algorithm)
- OR skip saving (too project-specific)

Proceed anyway?
```

**Incomplete solution:**
```markdown
⚠️ This solution is not fully complete:
- Missing error handling in edge cases
- Performance not tested with production data
- ESC review pending

Recommendation:
- Save as draft for now: learned/DRAFT-{pattern-name}.pattern.md
- Update to final after testing and review
- Remove DRAFT prefix when ready

Save as draft?
```

---

**Version:** 1.0
**Created:** 2025-11-09