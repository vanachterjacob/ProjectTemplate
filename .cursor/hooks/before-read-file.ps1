#!/usr/bin/env pwsh
# Before Read File Hook - Block reading sensitive files
# Blocks: .env, credentials, secrets, keys, binaries, large data files

$inputJson = $input | Out-String | ConvertFrom-Json
$filePath = $inputJson.file_path
$fileName = Split-Path $filePath -Leaf

$response = @{
    allow = $true
    userMessage = ""
    agentMessage = ""
}

try {
    $blockedPatterns = @(
        '\.env$', '\.env\.local$', 'credentials\.json$', 'secrets\.json$',
        '\.key$', '\.pem$', '\.pfx$', 'launch\.json$',
        '\.app$', '\.dll$', '\.exe$',
        '\.csv$', '\.xlsx$', '\.xls$', '\.db$',
        '\.bak$', '\.backup$'
    )

    $isBlocked = $false
    foreach ($pattern in $blockedPatterns) {
        if ($fileName -match $pattern -or $filePath -match $pattern) {
            $isBlocked = $true
            $response.allow = $false
            $response.userMessage = "🛑 Blocked: Cannot read sensitive file '$fileName'"
            $response.agentMessage = "Access to sensitive file blocked. Pattern: $pattern"
            break
        }
    }

    if (-not $isBlocked) {
        $response.agentMessage = "✅ File read allowed"
    }
} catch {
    $response.allow = $true
    $response.agentMessage = "⚠️ Hook error: $($_.Exception.Message)"
}

$response | ConvertTo-Json -Compress | Write-Output
