#Requires -Version 5.1
<#
.SYNOPSIS
    Rollback hook - restores previous configuration from backups

.DESCRIPTION
    Finds and restores the most recent backup files for each platform.

.PARAMETER Platform
    Specific platform to rollback (optional, default: all)

.PARAMETER ListOnly
    Only list available backups without restoring
#>

[CmdletBinding()]
param(
    [string]$Platform,
    [switch]$ListOnly,
    [hashtable]$PlatformInfo
)

if (-not $PlatformInfo) {
    . (Join-Path $PSScriptRoot "..\lib\detect-platform.ps1")
    $PlatformInfo = Get-PlatformInfo
}

$backupPattern = "*.backup.*"

# Define config locations
$platformPaths = @{
    "claude"         = Join-Path $PlatformInfo.UserHome ".claude"
    "claude-desktop" = Join-Path $PlatformInfo.UserHome "AppData\Roaming\Claude"
    "cursor"         = Join-Path $PlatformInfo.UserHome ".cursor"
    "windsurf"       = Join-Path $PlatformInfo.UserHome ".codeium\windsurf"
    "vscode"         = Join-Path $PlatformInfo.UserHome ".vscode"
    "codex"          = Join-Path $PlatformInfo.UserHome ".codex"
    "gemini"         = Join-Path $PlatformInfo.UserHome ".gemini"
    "cline"          = Join-Path $PlatformInfo.UserHome ".cline"
    "continue"       = Join-Path $PlatformInfo.UserHome ".continue"
    "kiro"           = Join-Path $PlatformInfo.UserHome ".kiro"
    "lmstudio"       = Join-Path $PlatformInfo.UserHome ".lmstudio"
    "zed"            = Join-Path $PlatformInfo.UserHome ".config\zed"
}

# Filter to specific platform if requested
if ($Platform) {
    if ($platformPaths.ContainsKey($Platform)) {
        $platformPaths = @{ $Platform = $platformPaths[$Platform] }
    } else {
        Write-Host "Unknown platform: $Platform" -ForegroundColor Red
        Write-Host "Available platforms: $($platformPaths.Keys -join ', ')"
        exit 1
    }
}

Write-Host "Scanning for backups..." -ForegroundColor Cyan

$allBackups = @()

foreach ($name in $platformPaths.Keys) {
    $path = $platformPaths[$name]
    if (-not (Test-Path $path)) { continue }

    $backups = Get-ChildItem -Path $path -Filter $backupPattern -ErrorAction SilentlyContinue
    foreach ($backup in $backups) {
        # Parse backup timestamp from filename
        if ($backup.Name -match '\.backup\.(\d{8}-\d{6})$') {
            $timestamp = $Matches[1]
            $originalName = $backup.Name -replace '\.backup\.\d{8}-\d{6}$', ''

            $allBackups += [PSCustomObject]@{
                Platform     = $name
                OriginalName = $originalName
                BackupPath   = $backup.FullName
                Timestamp    = $timestamp
                Date         = [DateTime]::ParseExact($timestamp, "yyyyMMdd-HHmmss", $null)
            }
        }
    }
}

if ($allBackups.Count -eq 0) {
    Write-Host "No backups found" -ForegroundColor Yellow
    exit 0
}

# Sort by date descending
$allBackups = $allBackups | Sort-Object Date -Descending

if ($ListOnly) {
    Write-Host "`nAvailable backups:" -ForegroundColor Cyan
    $allBackups | Format-Table Platform, OriginalName, Timestamp -AutoSize
    exit 0
}

# Group by platform and original file, keep most recent
$latestBackups = $allBackups |
    Group-Object { "$($_.Platform)|$($_.OriginalName)" } |
    ForEach-Object { $_.Group | Select-Object -First 1 }

Write-Host "`nRestoring from most recent backups:" -ForegroundColor Cyan

foreach ($backup in $latestBackups) {
    $targetPath = Join-Path (Split-Path $backup.BackupPath) $backup.OriginalName

    Write-Host "  $($backup.Platform): $($backup.OriginalName)" -ForegroundColor Gray
    Write-Host "    From: $($backup.BackupPath)" -ForegroundColor Gray
    Write-Host "    To:   $targetPath" -ForegroundColor Gray

    try {
        Copy-Item $backup.BackupPath $targetPath -Force
        Write-Host "    [OK] Restored" -ForegroundColor Green
    } catch {
        Write-Host "    [ERROR] Failed: $_" -ForegroundColor Red
    }
}

Write-Host "`nRollback complete" -ForegroundColor Green
Write-Host "Restart your AI tools to apply restored configurations"
