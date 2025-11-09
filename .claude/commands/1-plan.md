---
description: Create technical plan from spec for BC27 extension
argument-hint: [spec-name]
allowed-tools: ["Read", "Write", "Grep", "Glob"]
model: sonnet
---
BC26 architect creating technical plan from: `.agent/specs/$ARGUMENTS.md`

## Ask User
1. Which spec? (from `.agent/specs/`)
2. Constraints? (integrations, performance, security)
3. Existing extensions? (conflicts to avoid)

## Step 1: Impact Analysis (Pre-Planning)

**Before creating detailed plan, analyze impact of proposed changes:**

1. **Read the spec** to understand what's being changed/added
2. **Identify affected objects:**
   - Tables being extended or created
   - Pages being modified
   - Events being subscribed to
   - APIs being added/modified

3. **Quick Impact Check:**
   ```bash
   # For table extensions, check existing usage
   grep -r "{table-name}" src/ --include="*.al"

   # For new events, verify event exists in BC27
   # Check BC27_EVENT_CATALOG.md or specific event catalogs

   # For API changes, check if API page already exists
   find src/ -name "*API*.al"
   ```

4. **Assess Risk Level:**
   - **LOW**: New objects, no dependencies, isolated change
   - **MEDIUM**: Extends existing, some integrations affected
   - **HIGH**: Modifies core logic, breaks existing functionality
   - **CRITICAL**: API contract changes, data migration needed

5. **Report Quick Findings:**
   ```markdown
   ## Impact Analysis Summary

   **Risk Level:** {LOW/MEDIUM/HIGH/CRITICAL}

   **Objects Affected:**
   - {N} tables (X new, Y extended)
   - {N} pages (X new, Y extended)
   - {N} codeunits (event subscribers, business logic)
   - {N} APIs (if applicable)

   **Breaking Changes:** {Yes/No}
   {If yes, list what breaks}

   **Data Migration:** {Yes/No}
   {If yes, what needs migration}

   **Integration Impact:** {Yes/No}
   {External systems, APIs, reports affected}

   **Recommendation:** {Proceed/Modify Approach/Needs Discussion}
   ```

   If **HIGH or CRITICAL risk**, recommend full impact analysis:
   ```
   ⚠️ HIGH RISK DETECTED

   For detailed analysis before planning, run:
   /impact-analyze {object-type} "{object-name}" {change-type}
   ```

6. **If LOW-MEDIUM risk, proceed to planning**

---

## Step 2: Load Context
@.cursor/rules/000-project-overview.mdc
@.cursor/rules/005-bc-symbols.mdc
@CLAUDE.md

Read:
- `.agent/specs/<spec-name>.md` → User requirements
- `app.json` → BC version, ID ranges, dependencies
- Existing `src/` → Current codebase structure

## BC26 Base Symbols
**Location:** `C:\Temp\BC26Objects\BaseApp`

Use Read(//mnt/c/Temp/BC26Objects/**) or Read(//c/Temp/BC26Objects/**) for:
- Standard object structure reference
- Field names and property patterns
- Event subscriber patterns
- Extension point verification

**Need additional modules?** Request from user BEFORE creating plan.

## Create `.agent/plans/<spec-name>-plan.md`

Include:

### 1. Impact Analysis Summary
{Include findings from Step 1}
- Risk level assessment
- Objects affected count
- Breaking changes identified
- Data migration requirements
- Integration impact

### 2. Technical Architecture
- **Objects** (tables/pages/codeunits with dummy IDs from 77100-77200 range)
- **ESC standards checklist** (all applicable standards)
- **Integration points** (BC26/BC27 base objects extended/subscribed)
- **File organization** (src/ structure)

### 3. Implementation Considerations
- **Performance** (SetLoadFields, background processing)
- **Security** (permissions, validation)
- **Dependencies** (app.json updates needed)
- **Migration** (upgrade codeunits if needed)

### 4. Risk Management
- **Risks** identified in impact analysis
- **Mitigation strategies** for each risk
- **Testing requirements** to verify no breaking changes
- **Rollback plan** if deployment fails

### 5. Coordination Needs
{If impact analysis revealed external dependencies}
- API partners to notify
- Customer approvals needed
- Team coordination requirements

---

## Output Template Structure

```markdown
# Technical Plan: {Feature Name}

**Created:** {Date}
**Spec Source:** .agent/specs/{spec-name}.md
**Risk Level:** {From impact analysis}

---

## Impact Analysis

{Summary from Step 1}

**Breaking Changes:** {Yes/No + details}
**Data Migration:** {Yes/No + what}
**Integration Impact:** {Yes/No + affected systems}

---

## Architecture

### Objects to Create/Modify

#### Tables
- {ID} "{PREFIX} {Name}" - {Purpose}

#### Pages
- {ID} "{PREFIX} {Name}" - {Purpose}

#### Codeunits
- {ID} "{PREFIX} {Name}" - {Purpose}

{etc.}

### BC Base Object Extensions

- Table Extension: "{Table Name}"
  - Fields added: {list}
  - Events subscribed: {list}

- Page Extension: "{Page Name}"
  - Fields added: {list}
  - Actions added: {list}

---

## ESC Standards Checklist

{All applicable ESC standards from .cursor/rules/}

---

## Implementation Details

{Detailed technical design}

---

## Risks & Mitigation

{From impact analysis + additional technical risks}

---

## Testing Requirements

{Based on risk level and impact}

---

```

Next: `/tasks <spec-name>` after user approval
