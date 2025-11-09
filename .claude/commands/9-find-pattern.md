---
description: Search pattern library for reusable solutions
model: sonnet
---

# Find Pattern in Library

**Purpose:** Search for existing patterns that solve similar problems

**Usage:** `/find-pattern [problem-description]`

**Example:** `/find-pattern custom ledger posting`

---

## Your Task

You are searching the pattern library to find reusable solutions for the user's problem.

### Step 1: Understand the Problem

Analyze the user's problem description and extract:

1. **Problem domain** (e.g., posting, API, validation, batch processing)
2. **Key challenges** (e.g., performance, transaction management, error handling)
3. **BC objects involved** (e.g., ledger entries, documents, codeunits)
4. **Technical requirements** (e.g., rollback, atomicity, async processing)

---

### Step 2: Search Pattern Index

Read `.claude/patterns/index.md` and search for:

1. **Matching keywords** in pattern titles
2. **Similar problem descriptions**
3. **Related domains** (sales, warehouse, posting, etc.)
4. **Matching tags** (performance, ESC, transactions, etc.)

---

### Step 3: Load Matching Patterns

For each potential match:

```bash
# Read pattern file
cat .claude/patterns/learned/{pattern-name}.pattern.md
```

Evaluate relevance:
- Does it solve the same/similar problem?
- Are the constraints similar?
- Is it applicable to current project?

---

### Step 4: Rank and Present

Present top 3 most relevant patterns:

```markdown
## 🔍 Pattern Search Results

**Your problem:** {User's problem description}

**Found {N} potentially relevant patterns:**

---

### 1. {Pattern Name} ⭐ (Best Match)

**Relevance:** {90-100}%
**Source:** {Project name}
**Solves:** {Problem this pattern addresses}

**Key Features:**
- Feature 1
- Feature 2
- Feature 3

**When to Use:**
- Scenario 1
- Scenario 2

**Used in:**
- {Project A}
- {Project B}

[Read full pattern](.claude/patterns/learned/{filename}.pattern.md)

---

### 2. {Pattern Name}

**Relevance:** {70-89}%
**Source:** {Project name}
**Solves:** {Problem}

**Key Features:**
- ...

[Read full pattern](.claude/patterns/learned/{filename}.pattern.md)

---

### 3. {Pattern Name}

**Relevance:** {50-69}%
**Source:** {Project name}
**Solves:** {Problem}

[Read full pattern](.claude/patterns/learned/{filename}.pattern.md)

---

**Would you like me to:**
A) Apply Pattern #{N} to your current situation
B) Show full details of Pattern #{N}
C) Combine elements from multiple patterns
D) Create new pattern (none match well enough)
```

---

### Step 5: Apply Pattern (If Requested)

When user chooses to apply a pattern:

1. **Load full pattern** from file
2. **Adapt to current project:**
   - Replace prefix (ABC → {current prefix})
   - Replace table/object names
   - Adjust object ID ranges
   - Apply customer-specific variations
3. **Generate code** based on pattern
4. **Explain adaptations** made

```markdown
## 🎯 Applying Pattern: {Pattern Name}

**Adaptations made for your project:**
- Prefix: ABC → {YOUR_PREFIX}
- Table: "ABC Commission Entry" → "{YOUR_PREFIX} {Your Entity}"
- Object IDs: 77105-77110 → {Your ID Range}
- Customer-specific: {Any special requirements}

**Generated code:**

```al
{Adapted AL code based on pattern}
```

**Next steps:**
1. Review generated code
2. Adjust business logic as needed
3. Test with your data
4. Run ESC compliance check

**Pattern source:** .claude/patterns/learned/{filename}.pattern.md
```

---

## Important Notes

### Pattern Matching Criteria

**High Relevance (80-100%):**
- Exact same problem domain
- Similar technical constraints
- Same BC objects involved
- ESC requirements match

**Medium Relevance (50-79%):**
- Related problem domain
- Some constraints match
- Similar patterns but different objects
- Partially applicable

**Low Relevance (<50%):**
- Different domain but useful technique
- Generic pattern that could be adapted
- Tangentially related

### When No Good Matches Found

If no patterns score >50% relevance:

```markdown
## 🔍 Pattern Search Results

**Your problem:** {User's problem}

**No close matches found** in pattern library.

**However, these tangentially related patterns might inspire:**
- {Pattern 1} - Similar technique in different domain
- {Pattern 2} - Related ESC compliance approach

**Recommendation:**
Let's solve this problem from scratch, then save it as a new pattern:
/save-pattern {pattern-name}

This will help future projects with similar challenges.
```

---

## Example Searches

### Example 1: Custom Ledger
```
User: /find-pattern custom ledger posting with rollback

Results:
1. ⭐ "Custom Ledger Posting with Rollback" (95% match)
   - Exact match from ABC Logistics commission tracking
2. "Batch Posting with Transaction Management" (70% match)
   - Similar rollback pattern, generic approach
3. "G/L Entry Posting Pattern" (60% match)
   - Related to ledgers, but for standard G/L
```

### Example 2: API Error Handling
```
User: /find-pattern api rate limiting and retry logic

Results:
1. ⭐ "API Rate Limiter with Exponential Backoff" (90% match)
   - From XYZ Manufacturing integration project
2. "Batch API Calls with Throttling" (85% match)
   - Similar rate limiting, batch context
3. "External API Error Handler" (75% match)
   - Error handling focus, some retry logic
```

### Example 3: Performance Optimization
```
User: /find-pattern optimize large dataset query

Results:
1. ⭐ "Batch Processing with SetLoadFields" (88% match)
   - ABC Logistics warehouse optimization
2. "SIFT Index Usage Pattern" (80% match)
   - Query optimization, aggregation focus
3. "Temporary Table Staging" (70% match)
   - Performance pattern, different use case
```

---

## Integration with Other Features

### With /save-pattern
```markdown
If pattern search finds nothing useful:
"No good matches found. After solving this, save as new pattern:
/save-pattern {pattern-name}"
```

### With ADRs
```markdown
If pattern references architectural decisions:
"This pattern relates to ADR-0001 (custom ledger decision).
Load ADR for full context?"
```

### With Project Context
```markdown
When adapting pattern:
"Current project: ABC Logistics (warehouse focus)
Pattern originally from: XYZ Manufacturing (production focus)
Adapting for warehouse domain..."
```

---

## Edge Cases

**Multiple equally good matches:**
```markdown
Found 2 patterns with similar relevance (both ~90%):

1. Pattern A - Approach X
2. Pattern B - Approach Y

Both solve your problem but with different trade-offs:
- Pattern A: Better performance, more complex
- Pattern B: Simpler code, slightly slower

Which approach do you prefer?
```

**Pattern from very old project:**
```markdown
⚠️ Note: This pattern is from BC23 project (2 years old)

BC27 may have better approaches now. Consider:
- Review pattern for BC27 compatibility
- Check if new BC27 features simplify this
- Validate ESC compliance with current standards

Still want to apply this pattern?
```

**Pattern requires dependencies:**
```markdown
⚠️ This pattern requires:
- Custom library: "ABC Helper Functions"
- External integration: "XYZ API"

These don't exist in your project yet. Options:
A) Port required dependencies
B) Find alternative pattern
C) Adapt pattern to work without dependencies
```

---

**Version:** 1.0
**Created:** 2025-11-09
