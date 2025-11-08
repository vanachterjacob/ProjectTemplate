# Context Presets - Quick Context Loading

**Purpose:** Load complete domain-specific context with a single skill invocation.

## Why Use Context Presets?

Instead of manually loading multiple files:
```
@BC27/BC27_LLM_QUICKREF.md
@BC27/BC27_EVENT_CATALOG.md
@.cursor/rules/001-naming-conventions.mdc
@.cursor/rules/002-development-patterns.mdc
@.cursor/rules/003-document-extensions.mdc
```

Use a single preset:
```
@sales-context
```

**Time Saved:** 10-15 minutes per coding session

## Available Presets

### 1. sales-context
**Load:** Sales & customer documentation, events, patterns
**Use for:** Sales orders, invoices, customer extensions, pricing
**Tags:** `sales`, `orders`, `customers`, `invoicing`, `shipping`

### 2. posting-context
**Load:** G/L posting, ledger entries, financial events
**Use for:** Posting routines, custom ledgers, journal modifications
**Tags:** `posting`, `ledger`, `general-ledger`, `financial`, `journal`

### 3. api-context
**Load:** API documentation, integration patterns, webhooks
**Use for:** REST APIs, web services, external integrations, OAuth
**Tags:** `api`, `integration`, `rest`, `webhook`, `webservice`, `external`

### 4. warehouse-context
**Load:** Warehouse management, inventory, bin operations
**Use for:** WMS, picks, put-aways, inventory posting, item tracking
**Tags:** `warehouse`, `inventory`, `wms`, `bins`, `picks`, `put-aways`

### 5. manufacturing-context
**Load:** Production, BOMs, routing, capacity planning
**Use for:** Production orders, manufacturing, work centers, output posting
**Tags:** `manufacturing`, `production`, `bom`, `routing`, `capacity`

### 6. performance-context
**Load:** Performance rules, optimization patterns, ESC compliance
**Use for:** Performance troubleshooting, query optimization, ESC reviews
**Tags:** `performance`, `optimization`, `setloadfields`, `batch`, `caching`

## How to Use

### In Cursor AI
```markdown
# When starting a sales feature
@sales-context
Now help me add a custom field to sales orders

# When optimizing code
@performance-context
Review this code for ESC compliance
```

### In Claude Code
```bash
# Load context via skill
Use the sales-context skill
Then: Create a sales order extension

# Load context and start coding
Use the api-context skill
Then: Build a custom REST API endpoint
```

## Benefits

**Time Savings:**
- Manual context loading: 2-5 minutes
- Preset loading: 5-10 seconds
- **Saved per session: 10-15 minutes**

**Consistency:**
- ✅ Never forget required ESC rules
- ✅ Always load relevant events
- ✅ Automatic pattern examples included

**Focus:**
- ✅ Context ready immediately
- ✅ No hunting for documentation
- ✅ Start coding faster

## Best Practices

### 1. Load Before Asking Questions
```markdown
# ❌ SLOW
What events are available for sales posting?
*LLM searches, loads docs, finds events*

# ✅ FAST
@sales-context
What events are available for sales posting?
*Context already loaded, instant answer*
```

### 2. Combine Multiple Presets
```markdown
# For complex features needing multiple contexts
@sales-context
@api-context
@performance-context
Create a high-performance API for sales order intake
```

### 3. Switch Contexts as Needed
```markdown
# Start with sales
@sales-context
Add field to sales header
*implement*

# Switch to posting when needed
@posting-context
Subscribe to sales posting event
*implement*
```

## Context Preset Structure

Each preset includes:

### 1. BC27 Documentation
- Quick reference guide
- Domain-specific event catalogs
- Extension point guidelines
- Module overviews

### 2. ESC Standards
- Project configuration
- Naming conventions
- Development patterns
- Domain-specific rules (documents, performance, security)

### 3. Code Examples
- Complete table extensions
- Event subscribers with early exit
- TryFunction patterns
- ESC-compliant implementations

### 4. Best Practices
- Performance optimization
- Security considerations
- Common anti-patterns
- Testing guidelines

## Creating Custom Presets

To add your own preset:

1. Create new file in `.claude/skills/context-presets/`
2. Use this template:

```markdown
---
description: Your preset description (shown in autocomplete)
category: context-loader
tags: [tag1, tag2, tag3]
---

# Your Context Loader

**Purpose:** What this preset loads

**Use when working on:**
- Feature type 1
- Feature type 2

## Auto-Loaded Context

### 1. BC27 Documentation
```
@BC27/relevant-file.md
```

### 2. ESC Standards
```
@.cursor/rules/relevant-rule.mdc
```

## Key Events Available
- Event 1
- Event 2

## ESC Patterns
\`\`\`al
// Example code
\`\`\`

## Context Loaded ✓
Ready to assist.
```

3. Test the preset:
```markdown
@your-custom-context
Does it load correctly?
```

## Troubleshooting

**Preset not loading?**
- Check file exists in `.claude/skills/context-presets/`
- Verify YAML frontmatter is valid
- Ensure skill name matches filename

**Wrong context loaded?**
- Use specific preset name (@sales-context, not @sales)
- Check tags if using tag-based loading
- Reload your IDE if recently added

**Performance slow?**
- Don't load all presets at once
- Use specific preset for your task
- Clear context and reload if needed

## Version History

**v1.0.0** (2025-01-08)
- Initial release with 6 core presets
- Sales, Posting, API, Warehouse, Manufacturing, Performance
