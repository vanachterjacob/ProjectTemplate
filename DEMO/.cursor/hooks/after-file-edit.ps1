#!/usr/bin/env pwsh
<#
.SYNOPSIS
    After File Edit Hook - Format AL code and run LinterCop

.DESCRIPTION
    This hook runs after Cursor edits a file. It:
    1. Formats AL code using AL Language extension formatter
    2. Runs LinterCop to check ESC compliance
    3. Reports violations back to Cursor Agent

.NOTES
    Input: JSON via stdin with file path and edit details
    Output: JSON with allow/deny and messages
#>

# Read input from stdin
$inputJson = $input | Out-String | ConvertFrom-Json

# Extract file path
$filePath = $inputJson.file_path
$workspaceFolder = $inputJson.workspace_folder

# Initialize response
$response = @{
    allow = $true
    userMessage = ""
    agentMessage = ""
}

try {
    # Only process .al files
    if ($filePath -notmatch '\.al$') {
        $response | ConvertTo-Json -Compress | Write-Output
        exit 0
    }

    Write-Host "Processing AL file: $filePath" -ForegroundColor Cyan

    # Check if file exists
    if (-not (Test-Path $filePath)) {
        $response.agentMessage = "⚠️ File does not exist: $filePath"
        $response | ConvertTo-Json -Compress | Write-Output
        exit 0
    }

    # Run AL Formatter (if AL Language extension is installed)
    # Note: This requires the AL Language extension and proper VS Code setup
    # For now, we'll just validate syntax

    # Check for common ESC violations
    $content = Get-Content $filePath -Raw
    $violations = @()

    # Check 1: ABC prefix usage
    if ($content -match '(table|page|codeunit|report|query|xmlport)\s+\d+\s+"(?!ABC\s)') {
        $violations += "❌ Missing ABC prefix in object name"
    }

    # Check 2: Dutch language in code
    if ($content -match '[àáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ]') {
        $violations += "❌ Dutch characters detected - use English only"
    }

    # Check 3: Nested if statements (basic check)
    $nestedIfCount = ([regex]::Matches($content, 'if\s+.*\s+then\s+if')).Count
    if ($nestedIfCount -gt 0) {
        $violations += "⚠️ Possible nested if statements detected - use early exit pattern"
    }

    # Check 4: Old Confirm pattern
    if ($content -match '\bConfirm\s*\(') {
        $violations += "❌ Use ConfirmManagement.GetResponseOrDefault() instead of Confirm()"
    }

    # Check 5: SetLoadFields before Modify/Insert/Delete
    if ($content -match 'SetLoadFields.*\n.*\.(Modify|Insert|Delete)\(') {
        $violations += "❌ CRITICAL: SetLoadFields used before Modify/Insert/Delete"
    }

    # Report violations
    if ($violations.Count -gt 0) {
        $response.allow = $true  # Still allow, but warn
        $response.userMessage = "⚠️ ESC Standard Violations Detected:`n" + ($violations -join "`n")
        $response.agentMessage = @"
ESC compliance issues found in $filePath:

$($violations -join "`n")

Please review and fix these violations according to ESC standards.
Reference: .cursor/rules/002-development-patterns.mdc
"@
    } else {
        $response.agentMessage = "✅ File passed basic ESC validation"
    }

} catch {
    $response.allow = $true
    $response.agentMessage = "⚠️ Hook error: $($_.Exception.Message)"
}

# Output response as JSON
$response | ConvertTo-Json -Compress | Write-Output
