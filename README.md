# BC26 Development Template

Centralized configuration template voor Business Central 26 (SaaS) extensie ontwikkeling met Cursor en Claude Code.

## 🎯 Doel

Dit template helpt bij het schrijven van BC26 extensies door:
- **Compacte context** voor LLM's (alle rules <100 regels)
- **Gestandaardiseerde workflows** via Claude Code slash commands
- **ESC development standards** compliance
- **Lokale BC26 symbols** referentie (geen MCP afhankelijkheid)
- **Geautomatiseerde kwaliteitscontrole** via hooks en subagents
- **Intelligente context loading** via skills

## 🤖 Tool Strategy

**Cursor Rules** (`.cursor/rules/`) - Voor AI context
- MDC format met metadata
- Always applied tijdens Agent/Inline Edit
- Zorgt voor consistente code quality

**Claude Code Commands** (`.claude/commands/`) - Voor workflows
- Gestructureerde development workflows
- Frontmatter met `$ARGUMENTS` support
- Krachtigere features dan Cursor commands
- Focus op één tool = minder onderhoud

> **Note:** Cursor heeft ook custom commands (`.cursor/commands/`), maar we gebruiken alleen Claude Code commands om overlap te vermijden en te focussen op de krachtigere features.

## 📁 Structuur

```
ProjectTemplate/
├── CLAUDE.md                      # AI context file (NEW! 🆕)
├── install-to-project.ps1         # Easy installation wrapper (Windows) (NEW! 🆕)
├── install-to-project.sh          # Easy installation wrapper (Linux/Mac) (NEW! 🆕)
│
├── scripts/                       # Installation scripts (NEW! 🆕)
│   ├── install-rules.ps1         # Main installer (PowerShell)
│   ├── install-rules.sh          # Main installer (Bash)
│   └── README.md                 # Installation documentation
│
├── BC27/                          # BC27 Comprehensive Base Code Index (NEW! 🆕)
│   ├── BC27_INDEX_README.md      # Navigation guide for BC27 documentation
│   ├── BC27_ARCHITECTURE.md      # System design, layering, patterns
│   ├── BC27_MODULES_OVERVIEW.md  # Complete inventory of all 73 modules
│   ├── BC27_MODULES_BY_CATEGORY.md  # Organized by functional category
│   ├── BC27_DEPENDENCY_REFERENCE.md # Module relationships & chains
│   ├── BC27_FEATURES_INDEX.md    # Complete feature reference matrix
│   └── BC27_INTEGRATION_GUIDE.md # External integrations & cloud services
│
├── .cursor/rules/                 # Cursor AI rules (MDC format)
│   ├── 000-project-overview.mdc
│   ├── 001-naming-conventions.mdc
│   ├── 002-development-patterns.mdc
│   ├── 003-document-extensions.mdc
│   ├── 004-performance.mdc
│   ├── 005-bc26-symbols.mdc
│   ├── 006-tools-review.mdc
│   ├── 007-deployment-security.mdc
│   └── 008-bc27-base-index.mdc   # BC27 base code reference (NEW! 🆕)
│
└── .claude/                       # Claude Code configuration
    ├── commands/                  # Slash commands (ENHANCED! ✨)
    │   ├── 0-specify.md          # /specify - Create user spec
    │   ├── 1-plan.md             # /plan - Create technical plan
    │   ├── 2-tasks.md            # /tasks - Break into tasks
    │   ├── 3-implement.md        # /implement - Write code
    │   ├── 4-review.md           # /review - ESC compliance check
    │   └── 5-update_doc.md       # /update_doc - Maintain docs
    │
    ├── subagents/                 # Specialized AI agents (NEW! 🆕)
    │   ├── bc26-reviewer.md      # ESC standards compliance reviewer
    │   └── bc26-architect.md     # Architecture and design specialist
    │
    ├── skills/                    # Auto-invoked capabilities (NEW! 🆕)
    │   └── bc26-context-loader/  # Automatic project context loading
    │       └── skill.md
    │
    ├── settings.json              # Team-shared settings (ENHANCED! ✨)
    └── settings.local.json        # Personal overrides (ENHANCED! ✨)
```

## 🚀 Quick Start

### 🎯 Automatische Installatie (Nieuw!)

**3 Simpele Stappen:**

1. **Edit het installatiescript:**
   - Open `install-to-project.ps1` (Windows) of `install-to-project.sh` (Linux/Mac)
   - Pas aan:
     ```powershell
     $TargetProject = "C:\Projects\MijnProject"  # Pad naar je AL project
     $ProjectPrefix = "ABC"                       # Je 3-letter prefix
     ```

2. **Run het script:**
   ```powershell
   # Windows
   .\install-to-project.ps1

   # Linux/Mac
   bash install-to-project.sh
   ```

3. **Reload Cursor/VS Code** en je bent klaar! ✅

**Wat gebeurt er?**
- ✅ Pulled automatisch laatste versie van GitHub (main branch)
- ✅ Kopieert `.cursor/rules/`, `.claude/commands/`, `CLAUDE.md`
- ✅ Kopieert `BC27/` documentatie (7 comprehensive reference files)
- ✅ Vervangt `ABC` met jouw prefix in alle bestanden
- ✅ Installeert hooks naar `~/.cursor/hooks.json`
- ✅ Maakt `.agent/` directory structuur aan

**Voor bestaande projecten:**
- Je `app.json` blijft ongewijzigd (idRanges, dependencies, publisher)
- Alleen AI tooling wordt toegevoegd
- 100% klaar na Cursor reload - geen verdere configuratie nodig!

### 🔄 Alternatieve Installatie Opties

**Via Claude Code slash command:**
```bash
/auto-install-rules
# Interactieve installer, vraagt naar directory & prefix
```

**Direct via command line:**
```bash
# Windows PowerShell
.\scripts\install-rules.ps1 -TargetDirectory "C:\Projects\MijnProject" -ProjectPrefix "ABC"

# Linux/Mac Bash
bash scripts/install-rules.sh /pad/naar/project ABC
```

**Met custom git branch:**
```bash
# Pull van andere branch (bijv. develop)
.\scripts\install-rules.ps1 -TargetDirectory "C:\Projects\MijnProject" -ProjectPrefix "ABC" -RepoBranch "develop"
```

### 3. Gebruik Claude workflow

```bash
# 1. Specificatie maken
/specify feature-name

# 2. Technisch plan
/plan feature-name

# 3. Tasks breakdown
/tasks feature-name

# 4. Implementeren
/implement feature-name next

# 5. Code review (manual or use subagent)
/review src/
# OR use subagent for detailed review:
# "Use bc26-reviewer to review my code in src/"

# 6. Get architecture guidance (when needed)
# "Use bc26-architect to help design the customer credit limit feature"
```

### 4. Automated Features (NEW! 🆕)

**Hooks worden automatisch uitgevoerd:**
- **SessionStart**: Toont project context bij opstarten
- **PreToolUse**: Waarschuwt bij wijzigingen aan app.json
- **PostToolUse**: Bevestigt AL file wijzigingen
- **Stop**: Controleert ESC standards voor afsluiten

**Skills worden automatisch geactiveerd:**
- Vraag over BC26? → Context wordt automatisch geladen
- Begin met feature? → Relevante informatie wordt getoond

## 📖 Cursor Rules Overzicht

### Naming & Organization (200 regels)
- **001-naming-conventions.mdc** (90 regels) - Object/variable naming, file patterns
- **002-development-patterns.mdc** (90 regels) - Early exit, TryFunction, Confirm
- **003-document-extensions.mdc** (75 regels) - Sales/Purchase checklist

### Performance & Symbols (110 regels)
- **004-performance.mdc** (70 regels) - Thresholds, background jobs
- **005-bc26-symbols.mdc** (40 regels) - Lokale symbols `C:\Temp\BC26Objects`

### Tools & Quality (175 regels)
- **006-tools-review.mdc** (85 regels) - Extensions, Object Ninja, review
- **007-deployment-security.mdc** (90 regels) - Upgrade paths, security

### Base Code Reference (NEW! 🆕) (200+ regels)
- **008-bc27-base-index.mdc** - BC27 architecture, module index, design patterns
  - ✅ All 73 BC27 modules documented
  - ✅ 22 functional categories
  - ✅ Architecture layering & dependency model
  - ✅ Feature combinations by company type
  - ✅ Integration points (15+ external systems)
  - ✅ Design principles & patterns
  - ✅ Auto-loads for AL files

**Totaal: ~850-900 regels** (erweiterd von 575 regels met BC27 index)

## 📚 BC27 Base Code Comprehensive Index (NEW! 🆕)

Complete reference documentation for Business Central 27 with all 73 modules documented:

### What's Included
- **73 Modules** - Complete inventory of core + extensions
- **22 Categories** - Organized by functional domain (Financial, Manufacturing, APIs, etc.)
- **Architecture** - System layering, design patterns, extension model
- **Dependencies** - Module relationships with no circular dependencies
- **Features** - 200+ capabilities organized by area
- **Integrations** - 15+ external systems (Azure, M365, Shopify, etc.)

### Quick Navigation
```
BC27/BC27_INDEX_README.md         ← Start here (navigation guide)
  ↓
BC27/BC27_ARCHITECTURE.md         ← System design & patterns
  ↓
BC27/BC27_MODULES_OVERVIEW.md     ← Find modules
  OR
BC27/BC27_MODULES_BY_CATEGORY.md  ← Browse by function
  ↓
BC27/BC27_DEPENDENCY_REFERENCE.md ← Understand relationships
BC27/BC27_FEATURES_INDEX.md       ← Feature matrix
BC27/BC27_INTEGRATION_GUIDE.md    ← External integrations
```

### Automatic Integration
- ✅ Cursor rule `008-bc27-base-index.mdc` auto-loads for AL files
- ✅ Installation scripts copy BC27 folder automatically
- ✅ Cursor highlights module & feature references
- ✅ Quick lookup during development

### Use Cases
- **Planning**: Which modules do I need? → See BC27_MODULES_BY_CATEGORY.md
- **Architecture**: How should I design this? → See BC27_ARCHITECTURE.md
- **Dependencies**: What depends on what? → See BC27_DEPENDENCY_REFERENCE.md
- **Integration**: How do I integrate with X? → See BC27_INTEGRATION_GUIDE.md
- **Features**: What can BC27 do? → See BC27_FEATURES_INDEX.md

**Source:** Stefan Maron's Code History Repository (be-27 branch, BC v27)

---

## 🔧 BC26 Symbols Configuratie

**Lokaal pad:** `C:\Temp\BC26Objects\BaseApp`

Bevat:
- Microsoft BaseApp (26.3.36158.37931)
- ALAppExtensions
- BCIntrastatCore
- Continia modules

Zie `005-bc26-symbols.mdc` voor complete lijst.

## 📋 Claude Commands (ENHANCED! ✨)

### Development Workflow

| Command | Argument | Beschrijving | Nieuw |
|---------|----------|-------------|-------|
| `/specify` | `[feature-name]` | Create user-focused spec | ✨ Enhanced frontmatter |
| `/plan` | `[spec-name]` | Create technical plan | ✨ Enhanced frontmatter |
| `/tasks` | `[plan-name] [phase]` | Break into code tasks | ✨ Enhanced frontmatter |
| `/implement` | `[task-file] [task-id]` | Write code | ✨ Enhanced frontmatter |
| `/review` | `[file-or-folder]` | ESC compliance check | ✨ Enhanced frontmatter |
| `/update_doc` | `[init\|update]` | Maintain docs | ✨ Enhanced frontmatter |

**Command Enhancements:**
- ✅ `allowed-tools` - Beperkte tool toegang voor security
- ✅ `model` - Optimale model selectie (haiku/sonnet)
- ✅ `disable-model-invocation` - Voorkom ongewenste auto-execution
- ✅ `@CLAUDE.md` - Automatische context loading
- ✅ `$ARGUMENTS` - Verbeterde argument handling

### Voorbeelden

```bash
# Start nieuwe feature
/specify customer-credit-limit

# Plan architectuur (met context loading)
/plan customer-credit-limit

# Maak tasks voor UI fase
/tasks customer-credit-limit UI

# Implementeer volgende task
/implement customer-credit-limit next

# Review code (manual)
/review src/CustomerCredit/

# Review code (with subagent for detailed analysis)
"Use bc26-reviewer to review src/CustomerCredit/"

# Get architecture guidance
"Use bc26-architect to help design the integration pattern for external API"
```

## 🤖 Subagents (NEW! 🆕)

Gespecialiseerde AI agents voor specifieke taken:

### bc26-reviewer
**Purpose:** Detailed ESC standards compliance review
**When to use:**
- Final code review before commit
- Checking ESC standards compliance
- Getting detailed feedback with file:line references

**Example:**
```
"Use bc26-reviewer to review my changes in src/Sales/"
```

**Output:** Comprehensive review report with:
- Overall score and ESC compliance %
- Critical issues, warnings, informational items
- Standards compliance matrix
- Concrete fixes with code examples
- Recommendations and next steps

### bc26-architect
**Purpose:** Architecture and design pattern guidance
**When to use:**
- Designing new features
- Choosing between architectural approaches
- Complex integration patterns
- Performance optimization decisions

**Example:**
```
"Use bc26-architect to help design the customer credit limit feature"
"Use bc26-architect: should I extend Sales Header or create new table?"
```

**Output:** Architecture decision framework with:
- Context and requirements analysis
- Multiple options with pros/cons
- Recommended approach with rationale
- Implementation steps and object structure
- ESC compliance considerations
- Performance and security aspects

## 🎯 Skills (NEW! 🆕)

Auto-invoked capabilities (Claude decides when to use):

### bc26-context-loader
**Purpose:** Automatically load project context when needed
**Activates when you:**
- Ask about BC26 or Business Central
- Mention AL development or features
- Start working on a feature
- Ask "what's our prefix?" or similar

**What it provides:**
- Current PREFIX configuration
- Object ID ranges
- BC26 symbols location
- Development workflow reminder
- ESC standards summary
- Available tools (subagents, hooks)

**Example:**
```
You: "Let's work on customer credit limit"
Skill: [Automatically loads context]
      "BC26 Project Context Loaded
      Prefix: ABC (verify before use)
      ID Range: 77100-77200
      Workflow: /specify → /plan → /tasks → /implement → /review"
```

## 🔗 Hooks (NEW! 🆕)

Automatische acties bij bepaalde events:

### SessionStart Hook
**Triggers:** Bij start van Claude Code sessie
**Action:** Toont welkomstbericht met project info
```
🚀 BC26 Development Environment Active
📋 Prefix: ABC (verify in .cursor/rules/000-project-overview.mdc)
📖 Workflow: /specify → /plan → /tasks → /implement → /review
💡 Check CLAUDE.md for complete context
```

### PreToolUse Hook
**Triggers:** Voor Write/Edit operaties
**Action:** Waarschuwt bij wijzigingen aan kritieke bestanden
```
⚠️ WARNING: Modifying critical BC26 file: app.json
✅ Verify customer ID ranges and permissions!
```

### PostToolUse Hook
**Triggers:** Na Write/Edit operaties
**Action:** Bevestigt AL file wijzigingen
```
✅ AL file modified: src/CustomerCredit/Tab77100.CustomerCredit.al
💡 Remember: ESC standards - Prefix, English-only, Early exit, TryFunction
```

### Stop Hook (LLM-based)
**Triggers:** Bij afsluiten van Claude agent
**Action:** Controleert ESC standards compliance
- ✅ Approve als alle standards gevolgd zijn
- 🛑 Block als er violations zijn, vraagt om fixes

## ✅ ESC Standards Checklist

**Voor elke commit:**
- [ ] Prefix consistent gebruikt (bijv. ABC)
- [ ] English-only code (geen Dutch)
- [ ] Early exit pattern toegepast
- [ ] ConfirmManagement i.p.v. Confirm()
- [ ] TryFunction voor error handling
- [ ] SetLoadFields alleen bij read-only
- [ ] Document extensions volledig (ALL tables/pages)
- [ ] Performance tested (production-scale data)
- [ ] LinterCop compliant
- [ ] Object Ninja voor final IDs

**Automatische controle (NEW! 🆕):**
- ✅ Stop Hook controleert automatisch bij afsluiten
- ✅ PreToolUse Hook waarschuwt bij kritieke bestanden
- ✅ PostToolUse Hook bevestigt AL wijzigingen
- ✅ bc26-reviewer subagent voor gedetailleerde review

## 🏗️ Project Aanpassen

### Nieuwe rule toevoegen

```bash
# Maak nieuw .mdc bestand
touch .cursor/rules/008-my-rule.mdc
```

```markdown
---
alwaysApply: true
description: Short description
---
# My Rule

Content here (keep < 100 lines)
```

### Nieuwe command toevoegen

```bash
# Maak nieuw .md bestand
touch .claude/commands/6-my-command.md
```

```markdown
---
description: What this command does
argument-hint: [arg1] [arg2]
---
Command role/context

Action: ${1:-default}

## Ask User
Questions...

## Do
Steps...
```

## 📊 Context Optimalisatie

**Voor LLM's:**
- Alle rules <100 regels
- Totaal ~575 regels cursor rules
- Commands 20-30 regels each
- Modulair & gefocust

**Best practices:**
- Verwijs naar andere rules i.p.v. dupliceren
- Gebruik tabellen voor quick reference
- Code examples kort houden
- Checklists voor workflows

## 🔒 Geen MCP Afhankelijkheden

Template gebruikt **alleen lokale resources:**
- BC26 symbols: `C:\Temp\BC26Objects`
- Geen cloud MCP servers
- Geen externe API calls
- Volledig offline werkend

## 🔧 Configuration Details

### Permissions (Enhanced)

**Team-shared (settings.json):**
- ✅ Allow: Read BC26 symbols, dotnet build, WebFetch trusted domains
- 🛑 Deny: Write .git/**, app.json, .alpackages/**
- ❓ Ask: Edit app.json, git push, git reset --hard, permissions.xml

**Personal (settings.local.json):**
- ✅ Allow: Git commands, file operations, development tools
- Fully customizable per developer

### Environment Variables

```json
{
  "BC_SYMBOLS_PATH": "C:\\Temp\\BC26Objects\\BaseApp",
  "ESC_PREFIX": "ABC"
}
```

### Memory

Project-scoped memory enabled for context persistence across sessions.

## 📚 Resources

- **CLAUDE.md:** Complete AI context reference
- **Cursor Rules:** https://cursor.com/docs/context/rules
- **Claude Commands:** https://code.claude.com/docs/en/slash-commands
- **Claude Hooks:** https://code.claude.com/docs/en/hooks
- **Claude Subagents:** https://code.claude.com/docs/en/sub-agents
- **Claude Skills:** https://code.claude.com/docs/en/skills
- **BC26 Documentation:** Microsoft Learn

## 🎯 What's New in v2.2.0

### 🆕 Major Addition: BC27 Comprehensive Base Code Index
1. **BC27/ directory** - 7 comprehensive documentation files (161 KB)
   - BC27_INDEX_README.md - Navigation guide
   - BC27_ARCHITECTURE.md - System design & patterns
   - BC27_MODULES_OVERVIEW.md - All 73 modules detailed
   - BC27_MODULES_BY_CATEGORY.md - Organized by function
   - BC27_DEPENDENCY_REFERENCE.md - Module relationships
   - BC27_FEATURES_INDEX.md - Complete feature matrix
   - BC27_INTEGRATION_GUIDE.md - External integrations

2. **008-bc27-base-index.mdc** - Cursor rule for instant BC27 reference
   - Auto-loads for AL files
   - 200+ lines of architecture & pattern reference
   - Module statistics, feature combinations
   - Integration points documentation

3. **Enhanced Installation Scripts** - Copy BC27 automatically
   - install-rules.sh & install-rules.ps1 updated
   - BC27 folder created during setup
   - Success messages highlight BC27 documentation

4. **Updated Documentation**
   - Project overview rule references BC27
   - Auto-install command mentions BC27 docs
   - README enhanced with BC27 section

**BC27 in Development:**
- Cursor rule auto-loads module & architecture info
- Quick lookup for any BC27 question
- Reference during feature planning & design
- Integration patterns & best practices

---

## 🎯 What's New in v2.1.0

### 🚀 Major Addition: Automated Installation
1. **install-to-project.ps1/.sh** - Easy wrapper scripts with editable variables
2. **scripts/install-rules.ps1/.sh** - Full-featured installers with git integration
3. **scripts/README.md** - Complete installation documentation
4. **/auto-install-rules** - Interactive Claude Code slash command
5. **Git Integration** - Always pulls latest template from main branch
6. **Automatic Prefix Replacement** - ABC → your prefix in all files
7. **Hooks Installation** - Automatic setup to ~/.cursor/hooks.json
8. **Zero Manual Config** - 100% ready after reload for existing projects

**Installation in 3 steps:**
1. Edit `install-to-project.ps1` (target directory + prefix)
2. Run `.\install-to-project.ps1`
3. Reload Cursor/VS Code ✅

### What's in v2.0.0
1. **CLAUDE.md** - Comprehensive AI context file
2. **Hooks System** - Automated quality control and warnings
3. **Subagents** - bc26-reviewer and bc26-architect specialists
4. **Skills** - bc26-context-loader for automatic context loading
5. **Enhanced Commands** - Better frontmatter with allowed-tools and model selection
6. **Enhanced Permissions** - Team-shared settings with deny/ask lists
7. **Environment Variables** - BC_SYMBOLS_PATH and ESC_PREFIX
8. **Memory** - Project-scoped context persistence

### Breaking Changes
None - fully backward compatible with all previous versions

### Migration from v2.1.0 to v2.2.0
**Automatic (Recommended)** - Run installation script again:
```powershell
.\install-to-project.ps1
```

This will add:
- ✅ BC27/ documentation folder
- ✅ New 008-bc27-base-index.mdc cursor rule
- ✅ Updated installation scripts
- ✅ Updated project overview rule

**Manual** - If you prefer:
1. Copy `BC27/` directory to your template
2. Copy `.cursor/rules/008-bc27-base-index.mdc`
3. Update `.cursor/rules/000-project-overview.mdc` to reference BC27
4. Update `.claude/commands/6-auto-install-rules.md` to list BC27

### Migration from v2.0.0 to v2.1.0
**Option 1: Automated (Recommended)**
```powershell
# Edit variables in install-to-project.ps1 and run
.\install-to-project.ps1
```

**Option 2: Manual**
1. Copy `scripts/` directory to your template
2. Copy `install-to-project.ps1` and `install-to-project.sh` to root
3. Copy `.claude/commands/6-auto-install-rules.md`

### Migration from v1.0.0
Use the automated installer - it handles everything:
```powershell
.\install-to-project.ps1
```

## 🤝 Contributing

Template verbeteren:
1. Houd files <100 regels waar mogelijk
2. Test met LLM's (Cursor/Claude)
3. Gebruik concrete voorbeelden
4. Update deze README
5. Test hooks en subagents thoroughly
6. Documenteer nieuwe features in CLAUDE.md

## 📄 License

Dit template is vrij te gebruiken voor ESC BC26 projecten.

---

**Versie:** 2.2.0 🎉
**BC Version:** 26 (SaaS) + BC27 Base Code Reference
**Laatst bijgewerkt:** 2025-11-07

### Version History
- **v2.2.0** (2025-11-07): BC27 comprehensive base code index with 73 modules, cursor rule, integration
- **v2.1.0** (2025-11-07): Automated installation system with git integration, zero manual config
- **v2.0.0** (2025-11-07): Added hooks, subagents, skills, enhanced commands, CLAUDE.md
- **v1.0.0** (2025-11-07): Initial release with basic commands and rules
