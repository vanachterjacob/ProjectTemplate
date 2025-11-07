#!/usr/bin/env pwsh
<#
.SYNOPSIS
    After Agent Response Hook - Log AI usage analytics

.DESCRIPTION
    This hook runs after Cursor Agent responds. It:
    1. Logs token usage for cost tracking
    2. Tracks which features are used most
    3. Collects team usage statistics
    4. Exports data for analysis

.NOTES
    Input: JSON via stdin with response details
    Output: JSON (always allow)
#>

# Read input from stdin
$inputJson = $input | Out-String | ConvertFrom-Json

# Initialize response (always allow)
$response = @{
    allow = $true
    userMessage = ""
    agentMessage = ""
}

try {
    # Create logs directory if it doesn't exist
    $logsDir = Join-Path $HOME ".cursor" "logs"
    if (-not (Test-Path $logsDir)) {
        New-Item -ItemType Directory -Path $logsDir -Force | Out-Null
    }

    # Prepare log entry
    $logEntry = @{
        timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ss"
        user = $env:USERNAME
        conversationId = $inputJson.conversation_id
        generationId = $inputJson.generation_id
        model = $inputJson.model
        workspaceFolder = $inputJson.workspace_folder
        usage = @{
            promptTokens = $inputJson.usage.prompt_tokens
            completionTokens = $inputJson.usage.completion_tokens
            totalTokens = $inputJson.usage.total_tokens
        }
        tools = $inputJson.tools_used
    }

    # Append to log file (JSONL format - one JSON object per line)
    $logFile = Join-Path $logsDir "cursor-usage-$(Get-Date -Format 'yyyy-MM').jsonl"
    $logEntry | ConvertTo-Json -Compress | Add-Content -Path $logFile

    # Optional: Create daily summary
    $summaryFile = Join-Path $logsDir "daily-summary-$(Get-Date -Format 'yyyy-MM-dd').txt"

    # Read today's logs
    $todayLogs = Get-Content $logFile -ErrorAction SilentlyContinue |
        ForEach-Object { $_ | ConvertFrom-Json } |
        Where-Object { $_.timestamp -match (Get-Date -Format 'yyyy-MM-dd') }

    if ($todayLogs) {
        $totalTokens = ($todayLogs | Measure-Object -Property usage.totalTokens -Sum).Sum
        $conversationCount = ($todayLogs | Select-Object -ExpandProperty conversationId -Unique).Count

        $summary = @"
Cursor Usage Summary - $(Get-Date -Format 'yyyy-MM-dd')
User: $env:USERNAME
===========================================
Total Conversations: $conversationCount
Total Tokens Used: $totalTokens
Average Tokens/Conversation: $(if($conversationCount -gt 0) { [math]::Round($totalTokens / $conversationCount, 0) } else { 0 })

Top Models Used:
$($todayLogs | Group-Object -Property model | Sort-Object Count -Descending | Select-Object -First 3 | ForEach-Object { "  - $($_.Name): $($_.Count) times" } | Out-String)

Tools Used:
$($todayLogs | Where-Object { $_.tools } | ForEach-Object { $_.tools } | Group-Object | Sort-Object Count -Descending | Select-Object -First 5 | ForEach-Object { "  - $($_.Name): $($_.Count) times" } | Out-String)
"@

        $summary | Set-Content -Path $summaryFile
    }

    # Silent success (no messages to avoid clutter)
    $response.allow = $true

} catch {
    # Silently fail - don't interrupt workflow
    $response.allow = $true
}

# Output response as JSON
$response | ConvertTo-Json -Compress | Write-Output
