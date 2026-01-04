#Requires -Version 5.1
<#
.SYNOPSIS
    Post-installation hook - runs after config deployment

.DESCRIPTION
    Validates deployment and performs cleanup tasks.
#>

[CmdletBinding()]
param(
    [hashtable]$PlatformInfo,
    [hashtable]$Config,
    [hashtable]$DeploymentResults
)

Write-Host "`nRunning post-installation tasks..." -ForegroundColor Cyan

$warnings = @()
$successes = @()

# Verify deployed files exist
foreach ($platform in $DeploymentResults.Keys) {
    foreach ($file in $DeploymentResults[$platform]) {
        if (Test-Path $file.Target) {
            $successes += "$platform : $($file.Target)"
        } else {
            $warnings += "$platform : $($file.Target) not found"
        }
    }
}

# Check MCP server connectivity (if Docker available)
if ($PlatformInfo.HasDocker) {
    Write-Host "  Checking Docker MCP Gateway..." -ForegroundColor Gray
    try {
        $gatewayStatus = & docker mcp gateway status 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [OK] Docker MCP Gateway accessible" -ForegroundColor Green
        }
    } catch {
        Write-Host "  [INFO] Docker MCP Gateway not running (start with: docker mcp gateway run)" -ForegroundColor Gray
    }
}

# Connect Docker MCP clients if available
if ($PlatformInfo.HasDocker) {
    $clients = @("claude", "cursor", "windsurf", "vscode")
    Write-Host "  Connecting Docker MCP clients..." -ForegroundColor Gray
    foreach ($client in $clients) {
        try {
            & docker mcp client connect $client --global 2>$null
        } catch { }
    }
}

# Summary
Write-Host "`nDeployment Summary:" -ForegroundColor Cyan
Write-Host "  Successful: $($successes.Count) files" -ForegroundColor Green

if ($warnings.Count -gt 0) {
    Write-Host "  Warnings: $($warnings.Count)" -ForegroundColor Yellow
    foreach ($warn in $warnings) {
        Write-Host "    - $warn" -ForegroundColor Yellow
    }
}

# Cleanup old backups (keep last 3)
$backupPattern = "*.backup.*"
$configDirs = @(
    (Join-Path $PlatformInfo.UserHome ".claude"),
    (Join-Path $PlatformInfo.UserHome ".cursor"),
    (Join-Path $PlatformInfo.UserHome ".vscode")
)

foreach ($dir in $configDirs) {
    if (Test-Path $dir) {
        $backups = Get-ChildItem -Path $dir -Filter $backupPattern -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending |
            Select-Object -Skip 3
        foreach ($backup in $backups) {
            Remove-Item $backup.FullName -Force
            Write-Host "  Cleaned old backup: $($backup.Name)" -ForegroundColor Gray
        }
    }
}

Write-Host "`nPost-installation complete" -ForegroundColor Green
