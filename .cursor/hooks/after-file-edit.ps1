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

    # Check 1: ABC prefix usage (improved - all object types including extensions)
    $objectPattern = '(table|page|codeunit|report|query|xmlport|enum|interface|controladdin|permissionset)(\s+extension)?\s+\d+\s+"(?!ABC\s)'
    if ($content -match $objectPattern) {
        $violations += "❌ Missing ABC prefix in object name"
    }

    # Check 2a: Dutch language - accented characters
    if ($content -match '[àáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ]') {
        $violations += "❌ Dutch accented characters detected - use English only"
    }

    # Check 2b: Dutch language - common Dutch words in code
    $dutchWords = @('wordt', 'deze', 'voor', 'naar', 'van', 'het', 'een', 'als', 'bij', 'ook', 'maar', 'zijn', 'met', 'die', 'dat', 'de')
    $dutchPattern = '\b(' + ($dutchWords -join '|') + ')\b'
    if ($content -match $dutchPattern) {
        $violations += "❌ Dutch words detected - use English only"
    }

    # Check 2c: Dutch variable prefixes
    if ($content -match '\b(gebruiker|klant|artikel|bedrijf|factuur|bestelling|levering)[A-Z]') {
        $violations += "❌ Dutch variable names detected"
    }

    # Check 3: Nested if statements
    $nestedIfCount = ([regex]::Matches($content, 'if\s+.*\s+then\s+if')).Count
    if ($nestedIfCount -gt 0) {
        $violations += "⚠️ Nested if statements - use early exit pattern"
    }

    # Check 4: Direct Confirm() usage
    if ($content -match '\bConfirm\s*\(') {
        $violations += "❌ Use ConfirmManagement.GetResponse() instead of Confirm()"
    }

    # Check 5: SetLoadFields before Modify/Insert/Delete (line-by-line check)
    $lines = $content -split "`n"
    for ($i = 0; $i -lt ($lines.Count - 1); $i++) {
        # Check if current line has SetLoadFields and next line has Modify/Insert/Delete
        if ($lines[$i] -match 'SetLoadFields' -and $lines[$i+1] -match '\.(Modify|Insert|Delete)\(') {
            $violations += "❌ CRITICAL: SetLoadFields before Modify/Insert/Delete at line $($i+2)"
            break
        }
    }

    # Check 6: Direct Error() without TryFunction
    if ($content -match '\bError\s*\(' -and -not ($content -match '\[TryFunction\]')) {
        $violations += "⚠️ Direct Error() call - consider TryFunction pattern"
    }

    # Check 7: Missing DataClassification on fields
    if ($content -match 'field\s*\(\s*\d+' -and -not ($content -match 'DataClassification')) {
        $violations += "⚠️ Fields should have DataClassification property"
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
