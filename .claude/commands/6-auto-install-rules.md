---
description: Auto-install BC26 template (rules, hooks, commands) to AL project
globs: []
---

# Auto-Install BC26 Development Template

You are an automated installer for the BC26 Development Template. Your job is to help users install the template configuration into their AL projects.

## Your Task

1. **Gather Information** - Ask the user for:
   - Target directory (path to their AL project)
   - Project prefix (3-letter customer code, e.g., CON, FAB, ABC)
   - Optional: Git repository URL (if they want to pull latest from a repo)
   - Optional: Setup MCP servers? (GitHub + Filesystem for enhanced Claude capabilities)

2. **Validate Inputs**:
   - Ensure target directory exists and is an AL project (has app.json)
   - Validate prefix is exactly 3 uppercase letters (e.g., ABC, CON, FAB)
   - If git URL provided, verify it's a valid URL

3. **Run Installation**:
   - Detect OS (Linux/Mac or Windows)
   - Run the appropriate installation script:
     - Linux/Mac: `bash scripts/install-rules.sh <target_dir> <prefix> [repo_url] [--with-mcp]`
     - Windows: `powershell scripts/install-rules.ps1 -TargetDirectory <target_dir> -ProjectPrefix <prefix> [-RepoUrl <repo_url>] [-SetupMCP]`

4. **Handle Results**:
   - Show the installation output to the user
   - Confirm success or report any errors
   - Remind user to reload VS Code/Cursor

## Example Flow

### User Input
```
Target Directory: /home/user/MyALProject
Project Prefix: CON
Git Repo URL: (leave empty for local template)
Setup MCP Servers? (optional): yes/no
```

### Your Actions
1. Validate inputs
2. Run: `bash scripts/install-rules.sh /home/user/MyALProject CON [--with-mcp]`
3. Show output
4. Confirm success
5. If MCP requested, remind user to set GITHUB_TOKEN environment variable

## Important Notes

- **Always ask for information** - Don't assume or guess paths or prefixes
- **Validate before running** - Check directory exists and prefix is valid
- **Show full output** - Let user see what's happening
- **Handle errors gracefully** - If script fails, explain why and suggest fixes
- **Security** - Warn user before overwriting existing files (script handles this)

## What Gets Installed

The installation script will:
- Copy `.cursor/rules/` (ESC standard rules)
- Copy `.cursor/hooks/` (Quality & security hooks)
- Copy `.claude/commands/` (Workflow slash commands)
- Copy `.claude/skills/` (Context presets for fast domain loading)
- Copy `CLAUDE.md` (AI context)
- Copy `.cursorignore` and `.claudeignore` (File exclusions)
- Copy `BC27/` (Business Central 27 base code comprehensive index - 18 files including events/)
- Copy `LLM_OPTIMIZATION_GUIDE.md` (Token efficiency guide)
- Copy `.claude/MCP_CONFIGURATION.md` and `RECOMMENDED_MCP_SERVERS.md` (Plugin setup guides)
- Replace ABC prefix with user's prefix throughout all files
- Install hooks to `~/.cursor/hooks.json`
- Create `.agent/` directory structure for documentation
- **If --with-mcp flag:** Setup `.claude/mcp_settings.json` with GitHub and Filesystem MCP servers

## Git Repository Option

If user provides a git URL:
- Script will clone the latest template from that repo
- Uses cloned version instead of local files
- Cleans up after installation

Example public repo URL:
```
https://github.com/yourorg/ProjectTemplate.git
```

## After Installation

Remind user to:
1. **Reload VS Code/Cursor** to activate configuration
2. **Review BC27 documentation**: Start with `BC27/BC27_LLM_QUICKREF.md` for token-optimized quick reference
3. **Test with**: `/specify test-feature`
4. **Review CLAUDE.md** for project guidelines
5. **Verify app.json** has correct idRanges for their prefix
6. **If MCP installed**:
   - Set `export GITHUB_TOKEN="ghp_..."` in ~/.bashrc or ~/.zshrc
   - Reload shell: `source ~/.bashrc`
   - Reload VS Code/Cursor again
   - See `.claude/MCP_CONFIGURATION.md` for full setup

## Error Handling

Common errors and solutions:
- **Directory not found**: Ask user to verify path
- **Not an AL project**: Warn and ask if they want to continue anyway
- **Invalid prefix**: Must be exactly 3 uppercase letters (A-Z)
- **Git clone failed**: Fall back to local template
- **Permission denied**: Check file permissions or run with appropriate privileges

## Start the Conversation

Greet the user and ask for the required information:

```
I'll help you install the BC26 Development Template into your AL project.

Please provide the following information:

1. **Target Directory**: Full path to your AL project (e.g., /home/user/MyProject or C:\Projects\MyProject)
2. **Project Prefix**: Your 3-letter customer code (e.g., CON for Contoso, FAB for Fabrikam)
3. **Git Repository URL** (optional): Leave empty to use local template, or provide URL to pull latest
4. **Setup MCP Servers?** (optional): yes/no - Adds GitHub + Filesystem MCP for PR automation & ESC validation

Let's get started! What's the target directory?
```
