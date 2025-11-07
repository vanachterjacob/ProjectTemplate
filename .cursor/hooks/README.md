# Cursor Hooks for BC26 Development

This directory contains hook scripts that extend Cursor's Agent functionality with project-specific validation, security, and monitoring.

## 📋 Available Hooks

| Hook | Trigger | Purpose |
|------|---------|---------|
| `after-file-edit.ps1` | After AI edits file | ESC standard validation, format checking |
| `before-read-file.ps1` | Before AI reads file | Block sensitive files, reduce context |
| `before-shell-execution.ps1` | Before shell command | Prevent dangerous git operations |
| `after-agent-response.ps1` | After AI response | Usage analytics and cost tracking |

## 🚀 Installation

### Option 1: User-Level (Recommended)

**Windows:**
```powershell
# Copy hooks.example.json to your user directory
Copy-Item .cursor\hooks\hooks.example.json ~\.cursor\hooks.json

# Edit the file to use absolute paths
notepad ~\.cursor\hooks.json
```

**Linux/macOS:**
```bash
# Copy hooks.example.json to your user directory
cp .cursor/hooks/hooks.example.json ~/.cursor/hooks.json

# Make scripts executable
chmod +x .cursor/hooks/*.ps1
```

### Option 2: Team-Level (Enterprise)

**Windows:** `C:\ProgramData\Cursor\hooks.json`
**Linux:** `/etc/cursor/hooks.json`
**macOS:** `/Library/Application Support/Cursor/hooks.json`

### Option 3: Cloud Distribution (Enterprise with MDM)

Upload `hooks.json` via Cursor Enterprise Dashboard for automatic team synchronization.

## ⚙️ Configuration

Edit your `hooks.json` file to adjust paths:

```json
{
  "hooks": {
    "afterFileEdit": {
      "command": ["pwsh", "-File", "C:/Path/To/Project/.cursor/hooks/after-file-edit.ps1"],
      "description": "ESC validation after edits"
    }
  }
}
```

**Variable substitution available:**
- `${workspaceFolder}` - Current workspace path
- `${env:VARNAME}` - Environment variable
- `${userHome}` - User home directory

## 🧪 Testing Hooks

Test individual hooks before deployment:

```powershell
# Test after-file-edit hook
echo '{"file_path":"test.al","workspace_folder":"C:/Dev"}' | pwsh -File after-file-edit.ps1

# Test before-read-file hook
echo '{"file_path":"credentials.json"}' | pwsh -File before-read-file.ps1

# Test before-shell-execution hook
echo '{"command":"git push --force"}' | pwsh -File before-shell-execution.ps1
```

Expected output format:
```json
{"allow":true,"userMessage":"","agentMessage":""}
```

## 📊 Usage Analytics

The `after-agent-response.ps1` hook logs data to:
- **Log file:** `~/.cursor/logs/cursor-usage-YYYY-MM.jsonl`
- **Daily summary:** `~/.cursor/logs/daily-summary-YYYY-MM-DD.txt`

### Analyze Logs

```powershell
# View today's usage
Get-Content ~\.cursor\logs\daily-summary-$(Get-Date -Format 'yyyy-MM-dd').txt

# Total tokens this month
Get-Content ~\.cursor\logs\cursor-usage-$(Get-Date -Format 'yyyy-MM').jsonl |
    ForEach-Object { ($_ | ConvertFrom-Json).usage.totalTokens } |
    Measure-Object -Sum

# Most used models
Get-Content ~\.cursor\logs\cursor-usage-$(Get-Date -Format 'yyyy-MM').jsonl |
    ForEach-Object { ($_ | ConvertFrom-Json).model } |
    Group-Object |
    Sort-Object Count -Descending
```

## 🔒 Security Considerations

### Files Blocked by Default

- Credentials: `.env`, `credentials.json`, `*.key`, `*.pem`
- Build artifacts: `*.app`, `*.dll`, `.alpackages/`
- Large files: Files > 1MB
- Symbols: `symbols/`, `.alcache/`

### Commands Blocked by Default

- `git push --force`
- `git reset --hard`
- `rm -rf /`

### Commands with Warnings

- `git clean -fd` (warns but allows)
- `git push origin main` (warns about direct main push)

## 🎯 Customization

### Add ESC Standard Checks

Edit `after-file-edit.ps1` to add custom validation:

```powershell
# Example: Check for TODO comments
if ($content -match '//\s*TODO:') {
    $violations += "⚠️ TODO comment found - resolve before commit"
}

# Example: Check object ID range
if ($content -match 'table\s+(\d+)') {
    $objectId = [int]$Matches[1]
    if ($objectId -lt 77100 -or $objectId -gt 77200) {
        $violations += "❌ Object ID $objectId outside dummy range 77100-77200"
    }
}
```

### Block Additional File Types

Edit `before-read-file.ps1`:

```powershell
$blockedPatterns = @(
    # ... existing patterns
    '\.xlf$',           # Translation files
    '\.csv$',           # Data files
    'rad\.json$'        # RAD tool configuration
)
```

### Add Git Branch Validation

Edit `before-shell-execution.ps1`:

```powershell
# Require issue number in branch name
if ($command -match 'git\s+checkout\s+-b\s+(\S+)') {
    $branchName = $Matches[1]
    if ($branchName -notmatch 'claude/.*-\d+') {
        $response.userMessage = "⚠️ Branch should include issue number (e.g., claude/feature-123)"
    }
}
```

## 🐛 Troubleshooting

### Hooks Not Running

1. **Verify file location:**
   ```powershell
   Test-Path ~\.cursor\hooks.json
   ```

2. **Check JSON syntax:**
   ```powershell
   Get-Content ~\.cursor\hooks.json | ConvertFrom-Json
   ```

3. **Verify script permissions (Linux/macOS):**
   ```bash
   ls -l .cursor/hooks/*.ps1
   chmod +x .cursor/hooks/*.ps1
   ```

4. **Check Cursor logs:**
   - Windows: `%APPDATA%\Cursor\logs`
   - Linux: `~/.config/Cursor/logs`
   - macOS: `~/Library/Application Support/Cursor/logs`

### PowerShell Not Found

Ensure PowerShell Core (pwsh) is installed:
```bash
# Linux/macOS
which pwsh

# Windows
where.exe pwsh
```

Install if missing:
- **Linux:** `sudo snap install powershell --classic`
- **macOS:** `brew install powershell`
- **Windows:** PowerShell 7+ from Microsoft Store

### Hook Errors

Hooks that error default to `allow: true` to prevent workflow blocking. Check logs:

```powershell
Get-Content ~\.cursor\logs\cursor-usage-$(Get-Date -Format 'yyyy-MM').jsonl |
    ForEach-Object { $_ | ConvertFrom-Json } |
    Where-Object { $_.agentMessage -match 'Hook error' }
```

## 📚 Additional Resources

- **Cursor Hooks Documentation:** https://cursor.com/docs/agent/hooks
- **Hook Input/Output Schema:** See `hooks.example.json`
- **ESC Standards:** See `.cursor/rules/*.mdc` files
- **Team Setup Guide:** Contact DevOps for enterprise deployment

## 🔄 Maintenance

### Weekly Tasks
- Review `daily-summary-*.txt` for usage patterns
- Check for hook errors in logs
- Update blocked patterns based on incidents

### Monthly Tasks
- Archive old log files (`cursor-usage-*.jsonl`)
- Review and optimize hook performance
- Update validation rules based on ESC changes

### Quarterly Tasks
- Team training on hook features
- Review blocked operations for false positives
- Update scripts for new BC versions

---

**Version:** 2.0.0
**Last Updated:** 2025-11-07
**Maintainer:** BC26 DevOps Team
