#Requires -Version 5.1
<#
.SYNOPSIS
    Validates deployed AI platform configurations

.DESCRIPTION
    Checks that all expected config files exist and contain valid JSON/TOML.
    Optionally tests MCP server connectivity.

.PARAMETER TestConnectivity
    Also test MCP server endpoints
#>

[CmdletBinding()]
param(
    [switch]$TestConnectivity,
    [string[]]$Platforms
)

. (Join-Path $PSScriptRoot "detect-platform.ps1")
$PlatformInfo = Get-PlatformInfo

$results = @{
    Passed  = @()
    Failed  = @()
    Skipped = @()
}

# Define expected files per platform
$expectedFiles = @{
    "claude-code" = @{
        Path  = Join-Path $PlatformInfo.UserHome ".claude"
        Files = @("settings.json")
    }
    "cursor" = @{
        Path  = Join-Path $PlatformInfo.UserHome ".cursor"
        Files = @("mcp.json")
    }
    "windsurf" = @{
        Path  = Join-Path $PlatformInfo.UserHome ".codeium\windsurf"
        Files = @("mcp_config.json")
    }
    "vscode" = @{
        Path  = Join-Path $PlatformInfo.UserHome ".vscode"
        Files = @("mcp.json")
    }
    "codex" = @{
        Path  = Join-Path $PlatformInfo.UserHome ".codex"
        Files = @("config.toml")
    }
    "gemini" = @{
        Path  = Join-Path $PlatformInfo.UserHome ".gemini"
        Files = @("settings.json")
    }
    "zed" = @{
        Path  = Join-Path $PlatformInfo.UserHome ".config\zed"
        Files = @("settings.json")
    }
}

# Platform-specific additions
if ($PlatformInfo.OS -eq "windows") {
    $expectedFiles["claude-desktop"] = @{
        Path  = Join-Path $PlatformInfo.UserHome "AppData\Roaming\Claude"
        Files = @("claude_desktop_config.json")
    }
} elseif ($PlatformInfo.OS -eq "darwin") {
    $expectedFiles["claude-desktop"] = @{
        Path  = Join-Path $PlatformInfo.UserHome "Library/Application Support/Claude"
        Files = @("claude_desktop_config.json")
    }
}

# Filter platforms if specified
if ($Platforms) {
    $filteredFiles = @{}
    foreach ($p in $Platforms) {
        if ($expectedFiles.ContainsKey($p)) {
            $filteredFiles[$p] = $expectedFiles[$p]
        }
    }
    $expectedFiles = $filteredFiles
}

Write-Host "Validating AI Platform Configurations" -ForegroundColor Cyan
Write-Host "=" * 50

foreach ($platform in $expectedFiles.Keys) {
    $config = $expectedFiles[$platform]
    Write-Host "`n[$platform]" -ForegroundColor White

    if (-not (Test-Path $config.Path)) {
        Write-Host "  Directory not found: $($config.Path)" -ForegroundColor Yellow
        $results.Skipped += "$platform (directory missing)"
        continue
    }

    foreach ($file in $config.Files) {
        $filePath = Join-Path $config.Path $file

        if (-not (Test-Path $filePath)) {
            Write-Host "  [FAIL] $file - Not found" -ForegroundColor Red
            $results.Failed += "$platform/$file"
            continue
        }

        # Validate file content
        $isValid = $true
        $content = Get-Content $filePath -Raw -ErrorAction SilentlyContinue

        if ($file -match '\.json$') {
            try {
                $null = $content | ConvertFrom-Json
            } catch {
                Write-Host "  [FAIL] $file - Invalid JSON: $_" -ForegroundColor Red
                $isValid = $false
            }
        } elseif ($file -match '\.toml$') {
            # Basic TOML validation (check for obvious errors)
            if ($content -match '^\s*\[' -or $content -match '^\s*\w+\s*=') {
                # Looks like valid TOML structure
            } else {
                Write-Host "  [WARN] $file - May not be valid TOML" -ForegroundColor Yellow
            }
        }

        # Check for unresolved placeholders
        if ($content -match '\{\{(SECRET|ENV|CONFIG):') {
            Write-Host "  [WARN] $file - Contains unresolved placeholders" -ForegroundColor Yellow
            $isValid = $false
        }

        if ($isValid) {
            Write-Host "  [OK] $file" -ForegroundColor Green
            $results.Passed += "$platform/$file"
        } else {
            $results.Failed += "$platform/$file"
        }
    }
}

# Test MCP connectivity if requested
if ($TestConnectivity) {
    Write-Host "`nTesting MCP Connectivity" -ForegroundColor Cyan
    Write-Host "=" * 50

    # Test Docker MCP Gateway
    if ($PlatformInfo.HasDocker) {
        Write-Host "`n[Docker MCP Gateway]" -ForegroundColor White
        try {
            $status = & docker mcp gateway status 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  [OK] Gateway responding" -ForegroundColor Green
            } else {
                Write-Host "  [WARN] Gateway not running" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "  [FAIL] Cannot connect to Docker" -ForegroundColor Red
        }
    }

    # Test Context7 (HTTP endpoint)
    Write-Host "`n[Context7]" -ForegroundColor White
    try {
        $response = Invoke-WebRequest -Uri "https://mcp.context7.com/health" -TimeoutSec 5 -ErrorAction Stop
        Write-Host "  [OK] HTTP endpoint reachable" -ForegroundColor Green
    } catch {
        Write-Host "  [WARN] HTTP endpoint unreachable: $_" -ForegroundColor Yellow
    }
}

# Summary
Write-Host "`n" + ("=" * 50)
Write-Host "Validation Summary" -ForegroundColor Cyan
Write-Host "  Passed:  $($results.Passed.Count)" -ForegroundColor Green
Write-Host "  Failed:  $($results.Failed.Count)" -ForegroundColor $(if ($results.Failed.Count -gt 0) { "Red" } else { "Gray" })
Write-Host "  Skipped: $($results.Skipped.Count)" -ForegroundColor Gray

# Return success/failure
if ($results.Failed.Count -gt 0) {
    exit 1
} else {
    exit 0
}
