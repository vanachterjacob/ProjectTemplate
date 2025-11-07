# BC26 Development Template

Centralized configuration template voor Business Central 26 (SaaS) extensie ontwikkeling met Cursor en Claude Code.

## 🎯 Doel

Dit template helpt bij het schrijven van BC26 extensies door:
- **Compacte context** voor LLM's (alle rules <100 regels)
- **Gestandaardiseerde workflows** via Claude Code slash commands
- **ESC development standards** compliance
- **Lokale BC26 symbols** referentie (geen MCP afhankelijkheid)

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
├── .cursor/rules/          # Cursor AI rules (MDC format)
│   ├── 000-project-overview.mdc
│   ├── 001-naming-conventions.mdc
│   ├── 002-development-patterns.mdc
│   ├── 003-document-extensions.mdc
│   ├── 004-performance.mdc
│   ├── 005-bc26-symbols.mdc
│   ├── 006-tools-review.mdc
│   └── 007-deployment-security.mdc
│
└── .claude/commands/       # Claude Code slash commands
    ├── 0-specify.md        # /specify - Create user spec
    ├── 1-plan.md           # /plan - Create technical plan
    ├── 2-tasks.md          # /tasks - Break into tasks
    ├── 3-implement.md      # /implement - Write code
    ├── 4-review.md         # /review - ESC compliance check
    └── 5-update_doc.md     # /update_doc - Maintain docs
```

## 🚀 Quick Start

### 1. Kopieer template naar je project

```bash
cp -r ProjectTemplate/.cursor your-bc-project/.cursor
cp -r ProjectTemplate/.claude your-bc-project/.claude
```

### 2. Configureer project specifics

Open `.cursor/rules/000-project-overview.mdc` en vervang:
- `ABC` → Je 3-letter customer prefix (bijv. `CTM` voor Contoso)
- `[Your Publisher Name]` → Je publisher naam

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

# 5. Code review
/review src/
```

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

**Totaal: ~575 regels** (was 1330+ regels)

## 🔧 BC26 Symbols Configuratie

**Lokaal pad:** `C:\Temp\BC26Objects\BaseApp`

Bevat:
- Microsoft BaseApp (26.3.36158.37931)
- ALAppExtensions
- BCIntrastatCore
- Continia modules

Zie `005-bc26-symbols.mdc` voor complete lijst.

## 📋 Claude Commands

### Development Workflow

| Command | Argument | Beschrijving |
|---------|----------|-------------|
| `/specify` | `[feature-name]` | Create user-focused spec |
| `/plan` | `[spec-name]` | Create technical plan |
| `/tasks` | `[plan-name] [phase]` | Break into code tasks |
| `/implement` | `[task-file] [task-id]` | Write code |
| `/review` | `[file-or-folder]` | ESC compliance check |
| `/update_doc` | `[init\|update]` | Maintain docs |

### Voorbeelden

```bash
# Start nieuwe feature
/specify customer-credit-limit

# Plan architectuur
/plan customer-credit-limit

# Maak tasks voor UI fase
/tasks customer-credit-limit UI

# Implementeer volgende task
/implement customer-credit-limit next

# Review code
/review src/CustomerCredit/
```

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

## 📚 Resources

- **Cursor Rules:** https://cursor.com/docs/context/rules
- **Claude Commands:** https://code.claude.com/docs/en/slash-commands
- **BC26 Documentation:** Microsoft Learn

## 🤝 Contributing

Template verbeteren:
1. Houd files <100 regels
2. Test met LLM's (Cursor/Claude)
3. Gebruik concrete voorbeelden
4. Update deze README

## 📄 License

Dit template is vrij te gebruiken voor ESC BC26 projecten.

---

**Versie:** 1.0.0
**BC Version:** 26 (SaaS)
**Laatst bijgewerkt:** 2025-11-07
