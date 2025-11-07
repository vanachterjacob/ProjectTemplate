#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Before Shell Execution Hook - Prevent dangerous operations

.DESCRIPTION
    This hook runs before Cursor executes shell commands. It:
    1. Blocks dangerous git operations (force push, hard reset)
    2. Warns about destructive operations
    3. Validates git branch operations
    4. Prevents accidental data loss

.NOTES
    Input: JSON via stdin with command details
    Output: JSON with allow/deny decision
#>

# Read input from stdin
$inputJson = $input | Out-String | ConvertFrom-Json

# Extract command
$command = $inputJson.command

# Initialize response
$response = @{
    allow = $true
    userMessage = ""
    agentMessage = ""
}

try {
    # Dangerous git commands
    $dangerousPatterns = @(
        @{
            pattern = 'git\s+push\s+.*--force'
            message = "🚫 Blocked: git push --force"
            reason = "Force push can overwrite remote history and cause data loss."
        },
        @{
            pattern = 'git\s+reset\s+--hard'
            message = "🚫 Blocked: git reset --hard"
            reason = "Hard reset permanently deletes uncommitted changes."
        },
        @{
            pattern = 'git\s+clean\s+-[dfx]'
            message = "⚠️ Warning: git clean"
            reason = "This will delete untracked files permanently."
            allowWithWarning = $true
        },
        @{
            pattern = 'rm\s+-rf\s+/'
            message = "🚫 Blocked: rm -rf /"
            reason = "This would delete the entire filesystem."
        },
        @{
            pattern = 'git\s+push\s+.*main|master'
            message = "⚠️ Warning: Pushing to main/master"
            reason = "Direct push to main branch. Consider using pull request."
            allowWithWarning = $true
        }
    )

    foreach ($pattern in $dangerousPatterns) {
        if ($command -match $pattern.pattern) {
            if ($pattern.allowWithWarning) {
                $response.allow = $true
                $response.userMessage = $pattern.message
                $response.agentMessage = @"
$($pattern.message)

Command: $command
Reason: $($pattern.reason)

This operation is allowed but requires caution.
"@
            } else {
                $response.allow = $false
                $response.userMessage = $pattern.message
                $response.agentMessage = @"
$($pattern.message)

Command: $command
Reason: $($pattern.reason)

If you really need to run this command, execute it manually.
"@
            }
            $response | ConvertTo-Json -Compress | Write-Output
            exit 0
        }
    }

    # Validate git branch operations
    if ($command -match 'git\s+push' -and $command -notmatch 'claude/') {
        $response.allow = $true
        $response.userMessage = "⚠️ Pushing to non-claude branch"
        $response.agentMessage = @"
Warning: Git push detected

Command: $command

ESC standard: Feature branches should start with 'claude/'
Current command doesn't match this pattern.
"@
        $response | ConvertTo-Json -Compress | Write-Output
        exit 0
    }

    # Allow command
    $response.allow = $true

} catch {
    $response.allow = $true  # Allow on error
    $response.agentMessage = "⚠️ Hook error: $($_.Exception.Message)"
}

# Output response as JSON
$response | ConvertTo-Json -Compress | Write-Output
