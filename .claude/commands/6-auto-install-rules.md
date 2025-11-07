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

2. **Validate Inputs**:
   - Ensure target directory exists and is an AL project (has app.json)
   - Validate prefix is exactly 3 uppercase letters (e.g., ABC, CON, FAB)
   - If git URL provided, verify it's a valid URL

3. **Run Installation**:
   - Detect OS (Linux/Mac or Windows)
   - Run the appropriate installation script:
     - Linux/Mac: `bash scripts/install-rules.sh <target_dir> <prefix> [repo_url]`
     - Windows: `powershell scripts/install-rules.ps1 -TargetDirectory <target_dir> -ProjectPrefix <prefix> [-RepoUrl <repo_url>]`

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
```

### Your Actions
1. Validate inputs
2. Run: `bash scripts/install-rules.sh /home/user/MyALProject CON`
3. Show output
4. Confirm success

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
- Copy `CLAUDE.md` (AI context)
- Copy `.cursorignore` (File exclusions)
- Copy `BC27/` (Business Central 27 base code comprehensive index - 7 documentation files)
- Replace ABC prefix with user's prefix throughout all files
- Install hooks to `~/.cursor/hooks.json`
- Create `.agent/` directory structure for documentation

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
2. **Review BC27 documentation**: Start with `BC27/BC27_INDEX_README.md` for architecture and module reference
3. **Test with**: `/specify test-feature`
4. **Review CLAUDE.md** for project guidelines
5. **Verify app.json** has correct idRanges for their prefix

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

Let's get started! What's the target directory?
```
