#!/usr/bin/env pwsh
# Before Commit Hook - Secret scanning before git commit
# Scans for: API keys, passwords, connection strings, private keys

$inputJson = $input | Out-String | ConvertFrom-Json
$files = $inputJson.files

$response = @{
    allow = $true
    userMessage = ""
    agentMessage = ""
}

try {
    $secrets = @()

    foreach ($file in $files) {
        if (Test-Path $file) {
            $content = Get-Content $file -Raw

            # Check for API keys (long alphanumeric strings)
            if ($content -match '[A-Za-z0-9]{32,}') {
                $secrets += "⚠️ Possible API key in $file"
            }

            # Check for password literals
            if ($content -match '(password|pwd|passwd)\s*[:=]\s*[''"]([^''"]+)[''"]') {
                $secrets += "⚠️ Password literal in $file"
            }

            # Check for connection strings
            if ($content -match 'Server=|Data Source=|Initial Catalog=') {
                $secrets += "⚠️ Connection string in $file"
            }

            # Check for private keys
            if ($content -match 'BEGIN (RSA )?PRIVATE KEY') {
                $secrets += "❌ Private key in $file"
            }

            # Check for Bearer tokens
            if ($content -match 'Bearer [A-Za-z0-9\-._~+/]+=*') {
                $secrets += "⚠️ Bearer token in $file"
            }
        }
    }

    if ($secrets.Count -gt 0) {
        $response.allow = $false
        $response.userMessage = "🛑 Commit blocked: Possible secrets detected"
        $response.agentMessage = @"
Secret scanning detected possible sensitive data:

$($secrets -join "`n")

**Actions:**
1. Remove secrets from files
2. Use SecretText type for sensitive AL fields
3. Store secrets in Azure Key Vault
4. Add sensitive files to .gitignore

**If these are false positives:**
- Review each detection carefully
- Update patterns in before-commit.ps1
- Or temporarily disable hook
"@
    } else {
        $response.agentMessage = "✅ No secrets detected"
    }
} catch {
    $response.allow = $true
    $response.agentMessage = "⚠️ Hook error: $($_.Exception.Message)"
}

$response | ConvertTo-Json -Compress | Write-Output
