---
description: Analyze impact of proposed code change before implementing
model: sonnet
---

# Impact Analysis

**Purpose:** Assess impact of proposed changes before implementation

**Usage:** `/impact-analyze [object-type] [object-name] [change-type]`

**Examples:**
- `/impact-analyze table "Sales Header" modify-field`
- `/impact-analyze codeunit "Sales-Post" add-event-subscriber`
- `/impact-analyze page "Customer Card" add-field`

---

## Your Task

You are performing a pre-implementation impact analysis to identify potential breaking changes, dependencies, and risks.

### Step 1: Understand the Proposed Change

Ask user for details if not provided:

1. **What object is being changed?**
   - Type: Table, Page, Codeunit, Report, etc.
   - Name: Exact object name
   - ID: Object ID (if known)

2. **What type of change?**
   - **modify-field**: Change field type, length, or properties
   - **add-field**: Add new field to table
   - **delete-field**: Remove field from table
   - **modify-procedure**: Change procedure signature
   - **add-event-subscriber**: Subscribe to new event
   - **modify-api**: Change API page structure
   - **rename-object**: Rename table/page/codeunit

3. **Specific details:**
   - Which field/procedure?
   - What's changing (type, length, name)?
   - Why is this change needed?

---

### Step 2: Build Dependency Graph

Search the codebase for dependencies:

```bash
# Find all references to the object
grep -r "{object-name}" src/ --include="*.al"

# For field changes, find all uses of that field
grep -r "{field-name}" src/ --include="*.al"

# For procedure changes, find all callers
grep -r "{procedure-name}" src/ --include="*.al"
```

Identify:
1. **Direct dependencies** - Objects that directly use this
2. **Indirect dependencies** - Objects that depend on direct dependencies
3. **External dependencies** - APIs, integrations, reports

---

### Step 3: Analyze Impact Categories

#### A) Breaking Changes

Check if change breaks existing functionality:

**Field Type/Length Changes:**
- ❌ Changing Code[20] → Code[10] = DATA LOSS
- ✅ Changing Code[20] → Code[50] = Safe expansion
- ❌ Changing Code → Integer = Type mismatch breaks code
- ⚠️ Changing field name = All references must update

**Procedure Signature Changes:**
- ❌ Changing parameter types = Compile errors
- ❌ Removing parameters = Breaks all callers
- ✅ Adding optional parameters = Backward compatible
- ⚠️ Changing return type = May break callers

**API Changes:**
- ❌ Removing API fields = Breaks external integrations
- ❌ Changing field types = Contract violation
- ⚠️ Adding fields = Usually safe, but check API version
- ❌ Renaming = External systems won't find field

#### B) Data Migration Needs

Assess if data migration required:

**Field Changes:**
- Code[20] → Code[50]: No migration (expansion)
- Code → Integer: Migration needed (+ validation of existing data)
- Rename: Data preservation via upgrade codeunit
- Delete: Archive data before deleting

**Table Structure:**
- New table: No migration
- Delete table: Archive/migrate data first
- Rename table: Upgrade codeunit needed

#### C) Permission Changes

Check if permissions need updating:

- New table/page → New permission set entries
- API changes → May need new OAuth scopes
- Field changes → May affect field-level security
- Codeunit changes → Execution permissions

#### D) Integration Impact

Identify affected integrations:

- **External APIs**: Will contract break?
- **Reports**: Do layouts need updating?
- **Power BI**: Do datasets change?
- **External systems**: Webhooks, EDI, file exports

#### E) Performance Impact

Estimate performance changes:

- New fields → Larger record size, slower queries
- Index changes → Query plan changes
- Field type changes → Index rebuild needed
- Code logic changes → May improve/degrade performance

---

### Step 4: Generate Impact Report

Create detailed report:

```markdown
# Impact Analysis: {Change Description}

**Date:** {YYYY-MM-DD}
**Analyzed By:** AI Assistant
**Change Type:** {modify-field/add-field/etc.}

---

## Proposed Change

**Object:** {Object Type} {Object ID} "{Object Name}"
**Change:** {Specific change description}
**Reason:** {Why this change is needed}

---

## Direct Impact ({N} objects affected)

### High Priority ❌ (Breaking Changes)
- **{Object 1}**: {Why it breaks}
  - **Location**: {file:line}
  - **Fix Required**: {What needs to change}
  - **Effort**: {hours/days}

- **{Object 2}**: {Why it breaks}
  - **Location**: {file:line}
  - **Fix Required**: {What needs to change}
  - **Effort**: {hours/days}

### Medium Priority ⚠️ (Needs Attention)
- **{Object 3}**: {What needs reviewing}
  - **Location**: {file:line}
  - **Action**: {What to check/update}
  - **Effort**: {hours}

### Low Priority ✅ (Safe/No Action)
- **{Object 4}**: {Why no impact}
  - No changes needed

---

## Indirect Impact

**Downstream Effects:**
- {Effect 1}: {Description}
- {Effect 2}: {Description}

**Upstream Dependencies:**
- {Dependency 1}: {May need adjustment}

---

## Data Migration

**Required:** {Yes/No}

**If Yes:**
- **Migration Type**: {Upgrade codeunit / Manual script}
- **Data At Risk**: {Records/fields affected}
- **Validation Needed**: {What to verify}
- **Rollback Plan**: {How to undo if needed}

**Code:**
```al
codeunit {ID} "ABC Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    begin
        // Migration logic here
    end;
}
```

---

## Permission Changes

**Required:** {Yes/No}

**If Yes:**
- **Permission Set**: {Which sets to update}
- **New Permissions**: {What to add}
- **Objects**: {Tables/pages/codeunits affected}

---

## Integration Impact

### External APIs
- **API Contract**: {Broken/Compatible/Enhanced}
- **Partners Affected**: {Who to notify}
- **API Version**: {Bump major/minor?}

### Reports
- **Layouts**: {Number} layouts need updating
- **Datasets**: {Changes to data structure}

### External Systems
- **{System 1}**: {Impact description}
- **{System 2}**: {Impact description}

---

## Performance Impact

**Expected Change:** {Positive/Negative/Neutral}

**Analysis:**
- **Query Performance**: {Impact on common queries}
- **Index Changes**: {New/modified/dropped indexes}
- **Record Size**: {Increase/decrease in bytes}
- **Database Load**: {Estimation}

**Recommendation:**
{Performance optimization suggestions if needed}

---

## BC26/27 Compatibility

**Breaks BC26 Compatibility:** {Yes/No}
**Breaks BC27 Features:** {Yes/No}

**If Yes:**
- {What breaks and why}
- {Minimum version required}

---

## Estimated Effort

**Implementation:**
- Code changes: {hours}
- Testing: {hours}
- Data migration: {hours}
- Documentation: {hours}

**Coordination:**
- API partner communication: {days}
- Customer approval: {days}
- Team review: {hours}

**Total:** {hours/days}

---

## Risk Assessment

**Risk Level:** {LOW/MEDIUM/HIGH/CRITICAL}

**Risks:**
1. {Risk 1}: {Description}
   - **Probability**: {Low/Medium/High}
   - **Impact**: {Low/Medium/High}
   - **Mitigation**: {How to reduce risk}

2. {Risk 2}: {Description}
   - **Probability**: {Low/Medium/High}
   - **Impact**: {Low/Medium/High}
   - **Mitigation**: {How to reduce risk}

---

## Recommendations

### Option 1: Proceed as Planned
**Pros:**
- {Benefit 1}
- {Benefit 2}

**Cons:**
- {Drawback 1}
- {Drawback 2}

**Action Items:**
1. {Task 1}
2. {Task 2}
3. {Task 3}

### Option 2: Alternative Approach
**Description:** {Alternative solution}

**Pros:**
- {Benefit 1}
- {Benefit 2}

**Cons:**
- {Drawback 1}
- {Drawback 2}

### Option 3: Don't Implement
**Rationale:** {Why impact is too high}

**Alternatives:**
- {Alternative 1}
- {Alternative 2}

---

## Recommended Decision

**{Option N}: {Option name}**

**Rationale:**
{Why this option is best given the analysis}

---

## Next Steps

**If proceeding:**
1. {Step 1}
2. {Step 2}
3. {Step 3}

**If needs discussion:**
- Review with: {stakeholders}
- Questions to resolve: {list}
- Expected timeline: {when decision needed}

---

**Analysis Confidence:** {High/Medium/Low}
**Assumptions:**
- {Assumption 1}
- {Assumption 2}

**Limitations:**
- {What wasn't analyzed}
- {What needs manual verification}
```

---

### Step 5: Present to User

Summarize findings:

```markdown
## 📊 Impact Analysis Complete

**Change:** {Brief description}

### Summary
- **Objects Affected:** {N} direct, {M} indirect
- **Breaking Changes:** {N} ❌
- **Data Migration:** {Yes/No}
- **Estimated Effort:** {X} hours/days
- **Risk Level:** {LOW/MEDIUM/HIGH}

### Key Findings
🚨 **Critical**: {Most important finding}
⚠️ **Important**: {Second most important}
ℹ️ **Note**: {Additional info}

### Recommendation
**{Proceed/Modify Approach/Don't Implement}**

{One-sentence rationale}

---

**Full analysis saved to:** `.agent/impact-analysis-{timestamp}.md`

**Would you like to:**
A) Proceed with implementation (/plan based on this analysis)
B) Explore alternative approaches
C) Request more detailed analysis of specific area
D) Cancel proposed change
```

---

## Important Notes

### Analysis Accuracy

**High Confidence:**
- Direct code dependencies (grep search results)
- Breaking changes (type mismatches, missing parameters)
- Data migration needs (field type changes)

**Medium Confidence:**
- Performance impact (estimated based on change type)
- External integration impact (depends on integration design)
- Effort estimates (varies by developer experience)

**Low Confidence:**
- Business impact (requires domain knowledge)
- Customer acceptance (subjective)
- Future compatibility (BC roadmap unknown)

### Limitations

- **Cannot detect:** Runtime dependencies, reflection-based code, external system details
- **Requires manual verification:** Actual API contracts, customer-specific integrations
- **Estimates are rough:** Real effort may vary ±50%

---

## Examples

### Example 1: Modify Field Length

```
User: /impact-analyze table "Sales Header" modify-field

AI: Which field are you modifying?

User: "ABC Custom Reference", changing from Code[20] to Code[50]

AI: Why is this change needed?

User: Customer needs longer reference numbers

AI: *Performs analysis*

📊 Impact Analysis Complete

**Change:** Expand "ABC Custom Reference" from Code[20] to Code[50]

### Summary
- **Objects Affected:** 3 direct (1 page, 1 report, 1 API), 0 indirect
- **Breaking Changes:** 1 ❌ (API contract)
- **Data Migration:** No (field expansion is safe)
- **Estimated Effort:** 2-3 days (mostly API partner coordination)
- **Risk Level:** MEDIUM

### Key Findings
🚨 **Critical**: API Page "ABC Sales API" exposes this field. External integration expects max 20 chars.
   - Partner: XYZ Corp integration
   - Impact: May truncate data or reject requests
   - Action: Contact partner before deploying

⚠️ **Important**: Page field width needs update from 20 to 50

ℹ️ **Note**: Report layout auto-adjusts, no changes needed

### Recommendation
**Proceed with Caution**

Coordinate with XYZ Corp integration team. Options:
1. Keep API at 20 chars for compatibility (add separate field)
2. Bump API version and notify partner of breaking change
3. Add validation layer in API to truncate for old API version

---

**Would you like to:**
A) Proceed with Option 1 (API compatibility layer)
B) Proceed with Option 2 (API version bump)
C) Explore different field name (non-breaking)
D) Cancel change
```

### Example 2: Add Event Subscriber

```
User: /impact-analyze codeunit "Sales-Post" add-event-subscriber

AI: Which event are you subscribing to?

User: OnBeforePostSalesDoc

AI: *Performs analysis*

📊 Impact Analysis Complete

**Change:** Subscribe to OnBeforePostSalesDoc event

### Summary
- **Objects Affected:** 0 (new subscriber, no existing dependencies)
- **Breaking Changes:** 0 ✅
- **Data Migration:** No
- **Estimated Effort:** 2 hours (implementation + testing)
- **Risk Level:** LOW

### Key Findings
✅ **Safe**: Event subscription is non-breaking
ℹ️ **Note**: Remember early exit pattern (ESC requirement)
ℹ️ **Note**: Performance consideration if heavy logic (called on every sales post)

### Recommendation
**Proceed**

This is a safe, non-breaking change. Follow ESC patterns:
1. Early exit if subscriber doesn't apply
2. TryFunction for validation logic
3. No blocking dialogs
4. Performance testing with realistic data

---

**Would you like to:**
A) Proceed with implementation
B) See similar event subscriber patterns from library
C) Review ESC requirements for event subscribers
```

---

## Integration with Other Features

### With /plan Command
```markdown
When /plan is run, automatically perform impact analysis first:
"Before planning implementation, let me analyze the impact..."
*Runs impact analysis*
"Based on impact analysis, here's the recommended plan..."
```

### With /find-pattern
```markdown
If impact analysis reveals common scenarios:
"This change requires data migration. Found pattern:
/find-pattern data-migration-upgrade"
```

### With ADR
```markdown
If change has significant impact:
"This is a major architectural change. Should I create ADR?
/adr-create {decision-name}"
```

---

**Version:** 1.0
**Created:** 2025-11-09
