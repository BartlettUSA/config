#Requires -Version 5.1
<#
.SYNOPSIS
    Pre-installation hook - runs before config deployment

.DESCRIPTION
    Validates environment and prepares for installation.
    Returns $true if installation should proceed, $false to abort.
#>

[CmdletBinding()]
param(
    [hashtable]$PlatformInfo,
    [hashtable]$Config
)

Write-Host "Running pre-installation checks..." -ForegroundColor Cyan

$issues = @()

# Check Node.js version
if ($PlatformInfo.HasNode) {
    $nodeVersion = & node --version 2>$null
    if ($nodeVersion -match 'v(\d+)') {
        $major = [int]$Matches[1]
        if ($major -lt 18) {
            $issues += "Node.js version $nodeVersion is too old (requires 18+)"
        } else {
            Write-Host "  [OK] Node.js $nodeVersion" -ForegroundColor Green
        }
    }
} else {
    Write-Host "  [WARN] Node.js not found - npx-based MCP servers won't work" -ForegroundColor Yellow
}

# Check Docker
if ($PlatformInfo.HasDocker) {
    $dockerRunning = & docker info 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [OK] Docker is running" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] Docker installed but not running - MCP Gateway won't work" -ForegroundColor Yellow
    }
} else {
    Write-Host "  [WARN] Docker not found - MCP Gateway won't be available" -ForegroundColor Yellow
}

# Check for required secrets
$requiredSecrets = @("GITHUB_PERSONAL_ACCESS_TOKEN")
foreach ($secret in $requiredSecrets) {
    $value = [Environment]::GetEnvironmentVariable($secret)
    if ($value) {
        Write-Host "  [OK] Secret '$secret' available" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] Secret '$secret' not set - some features may not work" -ForegroundColor Yellow
    }
}

# Check write permissions to home directory
$testFile = Join-Path $PlatformInfo.UserHome ".installer-test-$(Get-Random)"
try {
    "test" | Out-File $testFile -ErrorAction Stop
    Remove-Item $testFile -Force
    Write-Host "  [OK] Write permission to home directory" -ForegroundColor Green
} catch {
    $issues += "Cannot write to home directory: $($PlatformInfo.UserHome)"
}

# Report issues
if ($issues.Count -gt 0) {
    Write-Host "`nPre-installation issues found:" -ForegroundColor Red
    foreach ($issue in $issues) {
        Write-Host "  - $issue" -ForegroundColor Red
    }
    return $false
}

Write-Host "`nPre-installation checks passed" -ForegroundColor Green
return $true
