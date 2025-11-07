---
name: bc27-context-loader
description: Automatically loads BC27 project context when user asks about BC/AL development
invoke-when: |
  User mentions Business Central, BC27, BC26, AL development, or asks about project configuration.
  Examples:
  - "What's our prefix?"
  - "Let's work on a new feature"
  - "How do I extend Sales Order?"
  - "What BC27 modules are available?"
model: haiku
---

# BC27 Project Context Loader

## Purpose
Automatically provide project context when user starts working or asks BC27-related questions.

## When to Activate
Claude decides to invoke this skill when user:
- Mentions "Business Central", "BC27", "BC26", "AL"
- Asks about project configuration
- Starts working on a feature
- Asks "what's our prefix?"
- Needs BC27 module information

## What This Skill Does

### 1. Load Project Configuration
Read `.cursor/rules/000-project-overview.mdc` and extract:
- Current PREFIX (e.g., ABC)
- Object ID Range (e.g., 77100-77200)
- BC Version (27)
- Publisher name

### 2. Show Development Context
```
🚀 BC27 Project Context Loaded

**Project Configuration:**
- Prefix: ABC (verify in 000-project-overview.mdc before use)
- ID Range: 77100-77200 (dummy, Object Ninja assigns production)
- BC Version: 27 (SaaS)
- Publisher: [Your Publisher Name]

**Development Workflow:**
1. /specify [feature-name] - Create specification
2. /plan [feature-name] - Design architecture
3. /tasks [feature-name] all - Break into tasks
4. /implement [feature-name] next - Write code
5. /review src/ - Check ESC compliance

**ESC Standards (Always Enforce):**
✅ ABC prefix consistently
✅ English-only code
✅ Early exit pattern
✅ TryFunction for errors
✅ ConfirmManagement (not Confirm())
✅ SetLoadFields ONLY for read-only
✅ Complete document extensions
✅ Performance tested

**BC27 Resources:**
- Quick Reference: @.cursor/rules/008-bc27-quick-reference.mdc
- Architecture: @.cursor/rules/009-bc27-architecture.mdc
- Full Docs: /BC27/ directory (7 files, 161 KB)

**Available Tools:**
- bc27-reviewer - Code review specialist
- bc27-architect - Architecture guidance

**Symbols:** C:\Temp\BC26Objects\BaseApp (also valid for BC27)
```

### 3. Answer User's Question
After showing context, address the specific question they asked.

## Examples

**Example 1:**
```
User: "What's our prefix?"
Skill: [Loads context, shows above box]
"Your current prefix is ABC. This is configured in .cursor/rules/000-project-overview.mdc.

Remember to:
- Use ABC consistently on all objects
- Replace ABC with customer code when setting up new project
- Object names: 'ABC <ObjectName>'
- Extensions: 'ABC <BaseObjectName>'"
```

**Example 2:**
```
User: "Let's add a customer credit limit feature"
Skill: [Loads context, shows above box]
"Great! Let's start with the specification. I recommend following the workflow:

1. First, let's create a spec:
   /specify customer-credit-limit

This will create a user-focused specification document. After that, we'll design the architecture and break it into tasks.

Would you like me to help create the specification now, or would you prefer to explore the BC27 Customer module first to understand the base structure?"
```

**Example 3:**
```
User: "Which BC27 modules handle e-commerce?"
Skill: [Loads context, shows above box]
"Based on the BC27 module index, here are the e-commerce related modules:

**Primary:**
- Shopify Connector - Bidirectional sync with Shopify stores
- SalesLinesSuggestions (Copilot) - AI product recommendations

**Payments:**
- PayPal Payments Standard
- WorldPay Payments Standard

**Supporting:**
- SalesAndInventoryForecast - AI demand forecasting
- Email connectors - Order confirmations

For detailed information:
- Module details: BC27/BC27_MODULES_OVERVIEW.md
- Integration guide: BC27/BC27_INTEGRATION_GUIDE.md
- Or use bc27-architect: 'bc27-architect: design e-commerce setup'"
```

## Implementation Notes

**Keep it Fast:**
- Use haiku model (fast, lightweight)
- Only read 000-project-overview.mdc (small file)
- Don't read entire BC27 docs (too large)
- Provide links to resources instead

**Be Helpful:**
- Answer the user's question
- Suggest next steps
- Provide workflow guidance
- Reference relevant tools/docs

**Don't Overwhelm:**
- Show context box ONCE per session
- After first load, just answer questions
- Don't repeat context unnecessarily

## Skill Invocation Examples

User phrases that should trigger this skill:
- "What's our prefix?"
- "Let's work on [feature]"
- "How do I extend [table]?"
- "Which BC27 modules [...]?"
- "What's the development workflow?"
- "I need to add a field to Customer"
- "How do we handle confirmations?"
- "What are the ESC standards?"

## After Loading Context

Always end with:
```
💡 Tip: For code review, use 'bc27-reviewer'
💡 Tip: For architecture help, use 'bc27-architect'
💡 Tip: All ESC standards: CLAUDE.md
```

## Files This Skill Reads
- `.cursor/rules/000-project-overview.mdc` (required)
- `.claude/settings.json` (optional, for BC_SYMBOLS_PATH)
- `CLAUDE.md` (optional, for workflow details)

## Files This Skill Does NOT Read
- BC27/*.md (too large, reference only)
- Other .cursor/rules/*.mdc (loaded automatically when relevant)
- Source code in src/ (not needed for context loading)
