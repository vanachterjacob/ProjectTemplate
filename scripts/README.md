# BC26 Development Template - Installation Scripts

Automated installation scripts for deploying the BC26 Development Template to AL projects.

## Overview

These scripts automate the setup process for BC26 AL projects by:
- Copying configuration files (rules, hooks, commands)
- Replacing the ABC placeholder prefix with your project-specific prefix
- Installing Cursor hooks for quality and security
- Optionally pulling the latest template from a git repository

## Files

- **install-rules.sh** - Bash script for Linux/Mac
- **install-rules.ps1** - PowerShell script for Windows
- **README.md** - This file

## Quick Start

### Option 1: Interactive (Recommended)

Use the Claude Code slash command from within the template directory:

```bash
/auto-install-rules
```

The assistant will guide you through the installation process.

### Option 2: Direct Execution

#### Linux/Mac

```bash
cd ProjectTemplate
bash scripts/install-rules.sh /path/to/YourALProject CON
```

#### Windows

```powershell
cd ProjectTemplate
.\scripts\install-rules.ps1 -TargetDirectory "C:\Path\To\YourALProject" -ProjectPrefix "CON"
```

### Option 3: With Git Repository

Pull the latest template from a git repository during installation:

#### Linux/Mac

```bash
bash scripts/install-rules.sh /path/to/YourALProject CON https://github.com/yourorg/ProjectTemplate.git
```

#### Windows

```powershell
.\scripts\install-rules.ps1 -TargetDirectory "C:\Path\To\YourALProject" -ProjectPrefix "CON" -RepoUrl "https://github.com/yourorg/ProjectTemplate.git"
```

## Parameters

### Bash Script (install-rules.sh)

| Parameter | Required | Description | Example |
|-----------|----------|-------------|---------|
| target_directory | Yes | Path to AL project | `/home/user/MyProject` |
| project_prefix | Yes | 3-letter customer code | `CON`, `ABC`, `FAB` |
| repo_url | No | Git repository URL | `https://github.com/...` |

### PowerShell Script (install-rules.ps1)

| Parameter | Required | Description | Example |
|-----------|----------|-------------|---------|
| -TargetDirectory | Yes | Path to AL project | `C:\Projects\MyProject` |
| -ProjectPrefix | Yes | 3-letter customer code | `CON`, `ABC`, `FAB` |
| -RepoUrl | No | Git repository URL | `https://github.com/...` |

## What Gets Installed

### Directory Structure

```
YourALProject/
├── .cursor/
│   ├── rules/                     # ESC standard rules (8 files)
│   └── hooks/                     # Quality & security hooks (5 files)
├── .claude/
│   ├── commands/                  # Workflow slash commands (6+ files)
│   ├── subagents/                 # (empty, for future use)
│   ├── skills/                    # (empty, for future use)
│   └── settings.json              # Claude Code settings
├── .agent/
│   ├── specs/                     # (empty, created by /specify)
│   ├── plans/                     # (empty, created by /plan)
│   ├── tasks/                     # (empty, created by /tasks)
│   └── README.md                  # Documentation index
├── CLAUDE.md                      # AI context documentation
├── .cursorignore                  # File exclusions
└── src/
    └── AGENTS.md                  # Module-specific context (if src/ exists)
```

### Global Installation

- **~/.cursor/hooks.json** - Hooks configuration (on Linux/Mac/Windows)

### Prefix Replacement

All occurrences of `ABC` are replaced with your project prefix in:
- All `.mdc` files in `.cursor/rules/`
- All `.md` files in `.claude/commands/`
- `CLAUDE.md`
- `src/AGENTS.md` (if exists)
- `.claude/settings.json`

## Installation Process

1. **Validation** - Checks target directory exists and is an AL project (has app.json)
2. **Git Clone** (optional) - Pulls latest template from repository
3. **Confirmation** - Warns if files already exist and prompts for overwrite
4. **Directory Creation** - Creates `.cursor/`, `.claude/`, `.agent/` structure
5. **File Copying** - Copies all configuration files
6. **Prefix Replacement** - Replaces ABC with your project prefix
7. **Hooks Installation** - Configures hooks in `~/.cursor/hooks.json`
8. **Cleanup** - Removes temporary files

## Safety Features

### Overwrite Protection

The script warns before overwriting existing files:

```
[WARNING] The following files/folders already exist and will be OVERWRITTEN:
  - .cursor/rules
  - CLAUDE.md
Continue? (y/N)
```

### Validation

- Project prefix must be exactly 3 uppercase letters (A-Z)
- Target directory must exist
- Warns if app.json is not found (not an AL project)

### Error Handling

- Continues with local template if git clone fails
- Provides clear error messages for common issues
- Non-destructive operation (can be safely cancelled)

## After Installation

1. **Reload VS Code/Cursor** - Close and reopen to activate configuration
2. **Test Installation** - Run `/specify test-feature` to verify setup
3. **Review Documentation** - Read `CLAUDE.md` for project guidelines
4. **Verify app.json** - Ensure idRanges match your project prefix

## Available Commands After Installation

| Command | Description |
|---------|-------------|
| `/specify [feature-name]` | Create user-focused specification |
| `/plan [spec-name]` | Create technical architecture plan |
| `/tasks [plan-name] [phase]` | Break plan into code tasks |
| `/implement [task-file] [task-id\|next]` | Implement code sequentially |
| `/review [file-or-folder]` | ESC compliance check |
| `/update_doc [init\|update]` | Maintain .agent/ documentation |

## Hooks Installed

| Hook | Purpose | When It Runs |
|------|---------|--------------|
| after-file-edit.ps1 | ESC validation | After AI edits any file |
| before-read-file.ps1 | Security (blocks sensitive files) | Before AI reads files |
| before-shell-execution.ps1 | Safety (prevents dangerous commands) | Before running shell commands |
| after-agent-response.ps1 | Usage analytics | After AI generates response |

## Troubleshooting

### Permission Denied

**Linux/Mac:**
```bash
chmod +x scripts/install-rules.sh
bash scripts/install-rules.sh /path/to/project ABC
```

**Windows:**
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
.\scripts\install-rules.ps1 -TargetDirectory "C:\path" -ProjectPrefix "ABC"
```

### Git Clone Failed

If git clone fails, the script automatically falls back to using the local template. No action required.

### Directory Not Found

Ensure the target directory path is correct:
- Use absolute paths: `/home/user/MyProject` or `C:\Projects\MyProject`
- Avoid relative paths like `../MyProject`

### Invalid Prefix

Project prefix must be:
- Exactly 3 characters
- Uppercase letters only (A-Z)
- Examples: `CON`, `ABC`, `FAB`
- Invalid: `con`, `ABCD`, `AB`, `12C`

## Git Integration

### Making the Repository Public

To enable git-based installation:

1. Make your ProjectTemplate repository public on GitHub
2. Share the repository URL: `https://github.com/yourorg/ProjectTemplate.git`
3. Users can install with:

```bash
bash scripts/install-rules.sh /path/to/project ABC https://github.com/yourorg/ProjectTemplate.git
```

### Benefits

- Always get the latest template version
- No need to manually download template
- Automatic updates when template changes
- Team consistency (everyone uses same version)

## Examples

### Basic Installation (Local Template)

```bash
# Linux/Mac
cd /home/user/ProjectTemplate
bash scripts/install-rules.sh /home/user/ContosoALProject CON

# Windows
cd C:\Templates\ProjectTemplate
.\scripts\install-rules.ps1 -TargetDirectory "C:\Projects\ContosoALProject" -ProjectPrefix "CON"
```

### Installation with Git Repository

```bash
# Linux/Mac
bash scripts/install-rules.sh ~/MyProject FAB https://github.com/yourorg/ProjectTemplate.git

# Windows
.\scripts\install-rules.ps1 -TargetDirectory "$HOME\MyProject" -ProjectPrefix "FAB" -RepoUrl "https://github.com/yourorg/ProjectTemplate.git"
```

### Installation from Any Directory

You don't need to be in the ProjectTemplate directory if you use a git URL:

```bash
# Linux/Mac - Install from anywhere
cd ~
bash <(curl -s https://raw.githubusercontent.com/yourorg/ProjectTemplate/main/scripts/install-rules.sh) \
    /path/to/project ABC https://github.com/yourorg/ProjectTemplate.git

# Windows - Download and run
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yourorg/ProjectTemplate/main/scripts/install-rules.ps1" -OutFile "$env:TEMP\install-rules.ps1"
& "$env:TEMP\install-rules.ps1" -TargetDirectory "C:\Projects\MyProject" -ProjectPrefix "ABC" -RepoUrl "https://github.com/yourorg/ProjectTemplate.git"
```

## Version History

- **v2.1.0** (2025-11-07) - Initial release of auto-install scripts
  - Bash and PowerShell support
  - Git integration
  - Interactive slash command
  - Safety checks and validation

## Support

For issues or questions:
1. Check troubleshooting section above
2. Review installation output for error messages
3. Verify all prerequisites are met (git, bash/PowerShell)
4. Consult CLAUDE.md in the template for project guidelines

## License

Same license as the BC26 Development Template.
