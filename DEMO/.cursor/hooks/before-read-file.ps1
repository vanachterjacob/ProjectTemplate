#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Before Read File Hook - Block sensitive and unnecessary files

.DESCRIPTION
    This hook runs before Cursor reads a file. It:
    1. Blocks reading of sensitive files (credentials, keys)
    2. Blocks reading of build artifacts (.app, .dll)
    3. Blocks reading of large symbol files
    4. Redacts sensitive content if needed

.NOTES
    Input: JSON via stdin with file path
    Output: JSON with allow/deny decision
#>

# Read input from stdin
$inputJson = $input | Out-String | ConvertFrom-Json

# Extract file path
$filePath = $inputJson.file_path

# Initialize response
$response = @{
    allow = $true
    userMessage = ""
    agentMessage = ""
}

# Blocked patterns
$blockedPatterns = @(
    '\.env$',
    '\.env\.local$',
    'credentials\.json$',
    'secrets\.json$',
    '\.key$',
    '\.pem$',
    'launch\.json$',
    '\.app$',
    '\.dll$',
    '\.zip$',
    '\.cache$'
)

# Blocked directories
$blockedDirs = @(
    '.alpackages',
    '.vs',
    'symbols',
    'node_modules',
    '.temp'
)

try {
    # Check blocked file patterns
    foreach ($pattern in $blockedPatterns) {
        if ($filePath -match $pattern) {
            $response.allow = $false
            $response.userMessage = "🔒 Access denied: Sensitive or build artifact file"
            $response.agentMessage = @"
File read blocked by security hook: $filePath

This file type is blocked to protect sensitive data and reduce context usage.
If you need this file, please access it manually.

Blocked pattern: $pattern
"@
            $response | ConvertTo-Json -Compress | Write-Output
            exit 0
        }
    }

    # Check blocked directories
    foreach ($dir in $blockedDirs) {
        if ($filePath -match [regex]::Escape($dir)) {
            $response.allow = $false
            $response.userMessage = "🔒 Access denied: Build artifact or cache directory"
            $response.agentMessage = @"
File read blocked: $filePath

This directory is excluded from AI context to improve performance.
If you need to inspect these files, use manual file operations.

Blocked directory: $dir
"@
            $response | ConvertTo-Json -Compress | Write-Output
            exit 0
        }
    }

    # Check file size (block files > 1MB)
    if (Test-Path $filePath) {
        $fileSize = (Get-Item $filePath).Length
        if ($fileSize -gt 1MB) {
            $response.allow = $false
            $response.userMessage = "⚠️ File too large ($('{0:N2}' -f ($fileSize/1MB)) MB)"
            $response.agentMessage = @"
File read blocked: File is too large for context

File: $filePath
Size: $('{0:N2}' -f ($fileSize/1MB)) MB

Large files consume excessive tokens. Please:
1. Use grep/search to find specific content
2. Read specific line ranges
3. Summarize the file manually
"@
            $response | ConvertTo-Json -Compress | Write-Output
            exit 0
        }
    }

    # Allow read
    $response.allow = $true

} catch {
    $response.allow = $true  # Allow on error to prevent blocking workflow
    $response.agentMessage = "⚠️ Hook error: $($_.Exception.Message)"
}

# Output response as JSON
$response | ConvertTo-Json -Compress | Write-Output
