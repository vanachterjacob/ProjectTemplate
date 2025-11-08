# Memory Templates

Pre-configured memory files for different BC27 project types.

## What Are Memories?

Claude Code's #memory feature allows you to store preferences and instructions that persist across sessions. Think of it as "teaching Claude" about your specific project.

## Available Templates

### Project Type Memories

| Template | File | Use When |
|----------|------|----------|
| **Sales** | `sales-project.md` | Building sales/customer extensions |
| **Warehouse** | `warehouse-project.md` | WMS, inventory, bins |
| **API** | `api-project.md` | REST APIs, integrations |
| **Manufacturing** | `manufacturing-project.md` | Production, BOMs, routing |
| **Posting** | `posting-project.md` | G/L, ledgers, posting routines |

### Configuration Memories

| Template | File | Use When |
|----------|------|----------|
| **ESC Strict** | `esc-strict-mode.md` | Maximum ESC compliance required |
| **Customer** | `customer-template.md` | Customer-specific configuration |

## How They Work

During installation, the `setup-memories.sh` script:

1. **Asks project type** - Sales? Warehouse? API? etc.
2. **Creates `.claude/CLAUDE.md`** - Project-level memory (shared with team)
3. **Optionally creates `~/.claude/CLAUDE.md`** - Personal preferences (your machine only)
4. **Loads relevant template** - Auto-includes context for your project type

## Memory Hierarchy

Claude Code loads memories in this order:

```
1. Enterprise Policy (~/Library/Application Support/Claude/...)
   ↓
2. Project Memory (.claude/CLAUDE.md) ← Created by this template
   ↓
3. User Memory (~/.claude/CLAUDE.md) ← Personal preferences
   ↓
4. Session Context (# commands during chat)
```

## Quick Usage

### During Development

```bash
# Add quick memory
# Always validate customer email before creating records

# Claude remembers and will validate emails automatically
```

### Edit Memories

```bash
# Open memory editor
/memory
```

### Load Context Presets

```bash
# For sales project
@sales-context

# For API project
@api-context
```

## What Gets Remembered?

### Project Memory (.claude/CLAUDE.md)
- Project type (sales, warehouse, etc.)
- ESC compliance level
- Default context to load
- Common workflows
- Project-specific patterns

### User Memory (~/.claude/CLAUDE.md)
- Personal coding style
- Preferred shortcuts
- Custom workflows
- Favorite tools

## Example: Sales Project Memory

After installation with project type "sales", `.claude/CLAUDE.md` contains:

```markdown
# Sales Extension Project Memory

This project is a **Sales & Customer Management** extension.

## Default Context to Load
When I ask about sales features, automatically use:
- @sales-context skill for complete sales documentation
- BC27 sales events from BC27/BC27_EVENT_CATALOG.md

## Common Tasks
- Extending sales documents (header/lines)
- Subscribing to sales posting events
- Creating sales-specific validation

## Quick Commands
- /specify [feature] → Start with user spec
- /plan [spec] → Create technical design
```

Now when you ask Claude "Add a field to sales orders", it:
- ✅ Knows this is a sales project
- ✅ Loads `@sales-context` automatically
- ✅ Applies sales document patterns
- ✅ Uses correct ESC rules
- ✅ References BC27 sales events

## Benefits

**Without Memory:**
```
You: Add a field to sales orders
Claude: Let me search for documentation...
*searches, loads docs, finds patterns*
*takes 2-3 minutes to get context*
```

**With Memory:**
```
You: Add a field to sales orders
Claude: I'll add a field to sales orders using the
document extension pattern from 003-document-extensions.mdc
*starts coding immediately - 5 seconds*
```

**Time Saved:** 10-15 minutes per coding session

## Customization

You can edit templates before installation:

1. Navigate to `.claude/memories/templates/`
2. Edit the template for your project type
3. Run installation - your changes will be used

## Best Practices

### DO ✅
- Set project type during installation
- Enable ESC Strict for production projects
- Add project-specific rules with `#` during development
- Use `/memory` to review and clean up periodically

### DON'T ❌
- Don't store secrets in memories (no passwords, tokens)
- Don't over-specify (let Claude use judgment)
- Don't contradict ESC rules
- Don't put personal preferences in project memory

## Troubleshooting

**Memory not loading?**
- Check file exists: `.claude/CLAUDE.md`
- Verify valid markdown format
- Reload VS Code/Cursor
- Use `/memory` to view loaded memories

**Wrong context loaded?**
- Edit `.claude/CLAUDE.md`
- Change project type section
- Save and reload

**Conflicts with other memories?**
- Higher-level memories take precedence
- Enterprise > Project > User > Session
- Use `/memory` to see what's loaded

## Migration

Already have a project without memories?

```bash
# Run setup script manually
cd /path/to/ProjectTemplate
bash scripts/setup-memories.sh /path/to/your/project ABC sales
```

## See Also

- [Context Presets](../skills/context-presets/README.md) - Quick context loading
- [Claude Code Memory Docs](https://code.claude.com/docs/en/memory.md)
- [CLAUDE.md Main File](../../CLAUDE.md) - Project instructions
