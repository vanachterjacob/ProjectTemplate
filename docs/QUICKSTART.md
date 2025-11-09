# BC27 Template - Quick Start Guide

**Ultra-fast installation for BC27 AL projects with AI optimization**

## 🚀 One-Line Install

### Interactive Installation
```bash
curl -sSL https://raw.githubusercontent.com/vanachterjacob/ProjectTemplate/main/quick-install.sh | bash
```

The installer will ask you for:
1. **Project path** - Where your AL project is located
2. **Prefix** - Your 3-letter customer code (e.g., ABC, CON, FAB)
3. **Project type** - Sales, Warehouse, API, Manufacturing, Posting, or General
4. **ESC Strict Mode** - Enable maximum compliance enforcement (Y/n)

### Non-Interactive Installation
```bash
curl -sSL https://raw.githubusercontent.com/vanachterjacob/ProjectTemplate/main/quick-install.sh | bash -s -- /path/to/project ABC sales
```

Replace:
- `/path/to/project` - Your AL project directory
- `ABC` - Your 3-letter prefix
- `sales` - Project type (sales/warehouse/api/manufacturing/posting/general)

## 📦 What Gets Installed?

### Core Components
- ✅ **ESC Rules** - `.cursor/rules/` (11 files, 1335 lines)
- ✅ **Slash Commands** - `.claude/commands/` (7 workflow commands)
- ✅ **Context Presets** - `.claude/skills/` (6 domain presets)
- ✅ **Memory System** - `.claude/memories/` (7 templates) **⭐ NEW**
- ✅ **BC27 Docs** - `BC27/` (18 files, 360 KB reference)
- ✅ **Hooks** - `.cursor/hooks/` (Quality & security)
- ✅ **Ignores** - `.claudeignore`, `.cursorignore` (Token optimization)

### Project Memory
Automatically created based on your project type:
- **`.claude/CLAUDE.md`** - Project-specific memory (team-shared)
- Auto-loads correct context preset (`@sales-context`, etc.)
- Remembers ESC compliance level
- Persists across all sessions

## ⚡ First Steps After Install

### 1. Reload Your IDE
```bash
# Close and reopen VS Code/Cursor
# Or reload window (Ctrl/Cmd + Shift + P → "Reload Window")
```

### 2. Verify Installation
```bash
cd /path/to/your/project

# Check files installed
ls -la .cursor/rules/
ls -la .claude/commands/
ls -la .claude/memories/
ls -la BC27/

# View project memory
cat .claude/CLAUDE.md
```

### 3. Test Slash Commands
```bash
# In Claude Code or Cursor AI
/specify test-feature
```

Should create `.agent/specs/test-feature-spec.md`

### 4. Test Memory System
```bash
# In Claude Code
/memory
```

Should show:
- Project memory: `.claude/CLAUDE.md`
- User memory: `~/.claude/CLAUDE.md` (if created)

### 5. Test Context Presets
```bash
# In Claude Code or Cursor AI
@sales-context
```

Should load sales documentation, events, and patterns instantly.

## 🎯 Quick Workflow

### Standard Development Flow
```bash
1. /specify customer-validation
   → Creates user-focused specification

2. /plan customer-validation
   → Creates technical architecture plan

3. /tasks customer-validation
   → Breaks into small implementation tasks

4. /implement customer-validation next
   → Implements first task with ESC compliance

5. /review src/
   → Validates ESC standards compliance
```

### Memory-Powered Shortcuts

**During Development:**
```bash
# Add project-specific rule
# Always validate VAT numbers using EU VIES service

# Claude remembers and applies to all future code
```

**Load Domain Context:**
```bash
# For sales work
@sales-context

# For API work
@api-context

# For performance optimization
@performance-context
```

## 🧠 Memory System Quick Guide

### Project Memory (Team-Shared)
Located: `.claude/CLAUDE.md`

**Auto-configured during installation with:**
- Project type (sales/warehouse/api/etc.)
- Default context to load
- Common patterns and workflows
- ESC compliance level

**Edit:**
```bash
/memory
```

### User Memory (Personal)
Located: `~/.claude/CLAUDE.md`

**Create during installation or manually:**
```bash
mkdir -p ~/.claude
nano ~/.claude/CLAUDE.md
```

**Add personal preferences:**
```markdown
# My Claude Code Memory

## Preferences
- I prefer descriptive variable names
- Always add XML documentation to public procedures
- Use early exit pattern in all procedures

## Shortcuts
When I say "standard extension", create:
- Table extension
- Page extension
- Event subscriber
```

### Quick Memory Add
```bash
# During any conversation
# instruction text here

# Examples:
# Always log errors to Application Insights
# Use SetLoadFields on all customer queries
# Validate email format before saving
```

## 📚 Key Documentation

### For AI Context
- `CLAUDE.md` - Complete AI instructions (this file auto-loaded)
- `.claude/CLAUDE.md` - Project memory (auto-loaded)
- `BC27/BC27_LLM_QUICKREF.md` - Token-optimized BC27 reference
- `.cursor/rules/` - ESC standards (auto-loaded by file pattern)

### For Developers
- `../README.md` - Human-readable project guide
- `../.claude/memories/README.md` - Memory system guide
- `../.claude/skills/context-presets/README.md` - Context preset guide
- `LLM_OPTIMIZATION_GUIDE.md` - Token efficiency best practices (this directory)

## ⚡ Performance Benefits

### Token Savings
| Feature | Old Approach | New Approach | Savings |
|---------|--------------|--------------|---------|
| BC27 docs | Load all (50k tokens) | Quick ref (2k) | **96%** |
| Event discovery | All catalogs (20k) | Specific (6k) | **70%** |
| Domain context | Manual load (8k) | Preset (3k) | **62%** |
| Project type | Explain each time (5k) | Memory (500) | **90%** |

### Time Savings
- **Context loading**: 2-5 min → 5 sec = **95% faster**
- **Project setup**: 30-60 min → 5 min = **90% faster**
- **Each session**: 10-15 min saved (memory auto-loads)

## 🔧 Advanced: Manual Installation

If you prefer manual installation or the one-liner doesn't work:

```bash
# 1. Clone repository
git clone https://github.com/vanachterjacob/ProjectTemplate.git
cd ProjectTemplate

# 2. Run installation script directly
bash scripts/install-rules.sh /path/to/your-project ABC

# Or use the slash command
# /auto-install-rules
```

Alternative - use the install script directly:

```bash
bash scripts/install-rules.sh /path/to/project ABC
```

## 🐛 Troubleshooting

### Installation fails
**Problem:** `git clone` fails
**Solution:** Check internet connection, try manual install

**Problem:** Permission denied
**Solution:** `chmod +x quick-install.sh`, run with proper permissions

### Memory not loading
**Problem:** `.claude/CLAUDE.md` not found
**Solution:** Run `bash scripts/setup-memories.sh /path/to/project ABC sales`

**Problem:** Memory not auto-loading
**Solution:** Reload IDE, check file exists, verify markdown format

### Context presets not found
**Problem:** `@sales-context` not recognized
**Solution:**
- **Cursor AI:** Use `@` symbol, autocomplete should show presets
- **Claude Code:** Use skill invocation syntax
- Verify `.claude/skills/context-presets/` directory exists

### Slash commands not working
**Problem:** `/specify` not recognized
**Solution:**
- Reload IDE
- Check `.claude/commands/` directory exists
- Verify you're in project root

## 📖 Next Steps

1. **Read CLAUDE.md** - Complete AI context and workflows
2. **Review `.claude/CLAUDE.md`** - Your project memory
3. **Explore BC27 docs** - Start with `BC27/BC27_LLM_QUICKREF.md`
4. **Test workflows** - Try `/specify`, `/plan`, `/tasks`, `/implement`
5. **Customize memory** - Add project-specific rules with `#`

## 🎓 Learning Resources

### Essential Reading (in order)
1. `QUICKSTART.md` (this file) - Get started fast
2. `../CLAUDE.md` - Complete AI context
3. `../.claude/memories/README.md` - Memory system
4. `../BC27/BC27_INDEX_README.md` - BC27 documentation guide
5. `LLM_OPTIMIZATION_GUIDE.md` - Token efficiency (this directory)

### Best Practices
- Use memory for project-specific patterns
- Load context presets before asking questions
- Start BC27 queries with quick ref
- Use `/review` before committing code
- Enable ESC Strict Mode for production

## 💬 Support

- **Issues:** https://github.com/vanachterjacob/ProjectTemplate/issues
- **Discussions:** https://github.com/vanachterjacob/ProjectTemplate/discussions
- **Documentation:** See README.md and CLAUDE.md

---

**Ready to build BC27 extensions with AI? Start with:**
```bash
curl -sSL https://raw.githubusercontent.com/vanachterjacob/ProjectTemplate/main/quick-install.sh | bash
```
