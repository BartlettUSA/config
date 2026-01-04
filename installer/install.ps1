#Requires -Version 5.1
<#
.SYNOPSIS
    Path-agnostic AI Platform Configuration Installer

.DESCRIPTION
    Deploys AI platform configurations (Claude, Cursor, VS Code, etc.) to any machine.
    Supports Windows, Linux (via PowerShell Core), and macOS.

.PARAMETER DryRun
    Preview changes without applying them

.PARAMETER Force
    Overwrite existing files without prompting

.PARAMETER Platforms
    Specific platforms to install (comma-separated). Default: all enabled in config.json

.PARAMETER SkipSecrets
    Skip secret injection (use placeholders)

.PARAMETER Verbose
    Show detailed output

.EXAMPLE
    .\install.ps1
    # Install all enabled platforms

.EXAMPLE
    .\install.ps1 -DryRun -Platforms "claude,cursor"
    # Preview installation for Claude and Cursor only

.EXAMPLE
    .\install.ps1 -Force -SkipSecrets
    # Force install without secrets
#>

[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$Force,
    [string[]]$Platforms,
    [switch]$SkipSecrets,
    [string]$ConfigFile = "config.json"
)

$ErrorActionPreference = "Stop"
$script:InstallerRoot = $PSScriptRoot
$script:LogFile = Join-Path $InstallerRoot "install.log"

#region Logging
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine = "[$timestamp] [$Level] $Message"
    Add-Content -Path $script:LogFile -Value $logLine -ErrorAction SilentlyContinue

    switch ($Level) {
        "ERROR"   { Write-Host $Message -ForegroundColor Red }
        "WARN"    { Write-Host $Message -ForegroundColor Yellow }
        "SUCCESS" { Write-Host $Message -ForegroundColor Green }
        default   { Write-Host $Message }
    }
}
#endregion

#region Platform Detection
. (Join-Path $InstallerRoot "lib/detect-platform.ps1")
#endregion

#region Configuration Loading
function Get-InstallerConfig {
    param([string]$ConfigPath)

    $fullPath = Join-Path $InstallerRoot $ConfigPath
    if (-not (Test-Path $fullPath)) {
        throw "Config file not found: $fullPath"
    }

    $config = Get-Content $fullPath -Raw | ConvertFrom-Json -AsHashtable
    return $config
}
#endregion

#region Secret Resolution
function Resolve-Secret {
    param(
        [string]$SecretName,
        [hashtable]$Config
    )

    if ($SkipSecrets) {
        return "{{SECRET:$SecretName}}"
    }

    # Try environment variable first
    $envValue = [Environment]::GetEnvironmentVariable($SecretName)
    if ($envValue) {
        Write-Log "  Secret '$SecretName' resolved from environment" -Level "INFO"
        return $envValue
    }

    # Try Infisical
    if (Get-Command infisical -ErrorAction SilentlyContinue) {
        try {
            $value = & infisical secrets get $SecretName --path=/ --plain --silent 2>$null
            if ($value) {
                Write-Log "  Secret '$SecretName' resolved from Infisical" -Level "INFO"
                return $value
            }
        } catch { }
    }

    # Try Docker MCP secret store
    if (Get-Command docker -ErrorAction SilentlyContinue) {
        try {
            $value = & docker mcp secret get $SecretName 2>$null
            if ($value) {
                Write-Log "  Secret '$SecretName' resolved from Docker MCP" -Level "INFO"
                return $value
            }
        } catch { }
    }

    Write-Log "  Secret '$SecretName' not found - using placeholder" -Level "WARN"
    return "{{SECRET:$SecretName}}"
}
#endregion

#region Template Processing
function Invoke-TemplateExpansion {
    param(
        [string]$Content,
        [hashtable]$PlatformInfo,
        [hashtable]$Config
    )

    $result = $Content

    # Replace environment variables: {{ENV:VAR_NAME}}
    $envPattern = '\{\{ENV:([^}]+)\}\}'
    $result = [regex]::Replace($result, $envPattern, {
        param($match)
        $varName = $match.Groups[1].Value
        $value = [Environment]::GetEnvironmentVariable($varName)
        if ($value) { return $value }
        return $match.Value
    })

    # Replace secrets: {{SECRET:SECRET_NAME}}
    $secretPattern = '\{\{SECRET:([^}]+)\}\}'
    $result = [regex]::Replace($result, $secretPattern, {
        param($match)
        $secretName = $match.Groups[1].Value
        return Resolve-Secret -SecretName $secretName -Config $Config
    })

    # Replace config values: {{CONFIG:key:default}}
    $configPattern = '\{\{CONFIG:([^:}]+):?([^}]*)\}\}'
    $result = [regex]::Replace($result, $configPattern, {
        param($match)
        $key = $match.Groups[1].Value
        $default = $match.Groups[2].Value
        # Could extend to read from config file
        if ($default) { return $default }
        return $match.Value
    })

    # Replace platform paths
    $result = $result -replace '\{\{USER_HOME\}\}', $PlatformInfo.UserHome

    return $result
}
#endregion

#region File Operations
function Copy-ConfigFile {
    param(
        [string]$SourcePath,
        [string]$TargetPath,
        [hashtable]$PlatformInfo,
        [hashtable]$Config,
        [switch]$DryRun
    )

    # Ensure source exists
    $fullSource = Join-Path $InstallerRoot $SourcePath
    if (-not (Test-Path $fullSource)) {
        Write-Log "  Source not found: $fullSource" -Level "WARN"
        return $false
    }

    # Resolve target path
    $resolvedTarget = Resolve-PlatformPath -PathTemplate $TargetPath -PlatformInfo $PlatformInfo

    # Read and process template
    $content = Get-Content $fullSource -Raw
    $processedContent = Invoke-TemplateExpansion -Content $content -PlatformInfo $PlatformInfo -Config $Config

    if ($DryRun) {
        Write-Log "  [DRY RUN] Would write to: $resolvedTarget" -Level "INFO"
        return $true
    }

    # Create directory if needed
    $targetDir = Split-Path $resolvedTarget -Parent
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Write-Log "  Created directory: $targetDir" -Level "INFO"
    }

    # Check for existing file
    if ((Test-Path $resolvedTarget) -and -not $Force) {
        Write-Log "  File exists: $resolvedTarget (use -Force to overwrite)" -Level "WARN"
        return $false
    }

    # Backup existing file
    if (Test-Path $resolvedTarget) {
        $backupPath = "$resolvedTarget.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Copy-Item $resolvedTarget $backupPath
        Write-Log "  Backed up to: $backupPath" -Level "INFO"
    }

    # Write file
    Set-Content -Path $resolvedTarget -Value $processedContent -Encoding UTF8
    Write-Log "  Deployed: $resolvedTarget" -Level "SUCCESS"
    return $true
}
#endregion

#region Main Installation
function Install-Platform {
    param(
        [string]$PlatformName,
        [hashtable]$PlatformConfig,
        [hashtable]$PlatformInfo,
        [hashtable]$Config
    )

    Write-Log "`nInstalling $PlatformName..." -Level "INFO"

    # Get target path for this OS
    $osKey = $PlatformInfo.OS
    $targetBase = $PlatformConfig.paths[$osKey]

    if (-not $targetBase) {
        Write-Log "  Platform '$PlatformName' not supported on $osKey" -Level "WARN"
        return
    }

    # Process each file
    foreach ($file in $PlatformConfig.files) {
        $sourcePath = $file.source
        $targetFile = $file.target
        $targetPath = Join-Path $targetBase $targetFile

        $success = Copy-ConfigFile `
            -SourcePath $sourcePath `
            -TargetPath $targetPath `
            -PlatformInfo $PlatformInfo `
            -Config $Config `
            -DryRun:$DryRun

        if (-not $success -and -not $file.optional) {
            Write-Log "  Failed to deploy required file: $targetFile" -Level "ERROR"
        }
    }
}

function Start-Installation {
    Write-Log "=" * 60
    Write-Log "AI Platform Configuration Installer"
    Write-Log "=" * 60

    # Detect platform
    $platformInfo = Get-PlatformInfo
    Write-Log "`nDetected Platform:"
    Write-Log "  OS: $($platformInfo.OS)"
    Write-Log "  Architecture: $($platformInfo.Architecture)"
    Write-Log "  User: $($platformInfo.UserName)"
    Write-Log "  Home: $($platformInfo.UserHome)"
    Write-Log "  Docker: $($platformInfo.HasDocker)"
    Write-Log "  Node.js: $($platformInfo.HasNode)"

    # Load config
    $config = Get-InstallerConfig -ConfigPath $ConfigFile
    Write-Log "`nLoaded configuration: $($config.version)"

    # Determine platforms to install
    $platformsToInstall = if ($Platforms) {
        $Platforms
    } else {
        $config.platforms.Keys | Where-Object { $config.platforms[$_].enabled }
    }

    Write-Log "`nPlatforms to install: $($platformsToInstall -join ', ')"

    if ($DryRun) {
        Write-Log "`n*** DRY RUN MODE - No changes will be made ***" -Level "WARN"
    }

    # Install each platform
    foreach ($platformName in $platformsToInstall) {
        if ($config.platforms.ContainsKey($platformName)) {
            Install-Platform `
                -PlatformName $platformName `
                -PlatformConfig $config.platforms[$platformName] `
                -PlatformInfo $platformInfo `
                -Config $config
        } else {
            Write-Log "Unknown platform: $platformName" -Level "WARN"
        }
    }

    Write-Log "`n" + ("=" * 60)
    Write-Log "Installation complete!"
    Write-Log "Log file: $script:LogFile"

    if (-not $DryRun) {
        Write-Log "`nNext steps:"
        Write-Log "  1. Restart your AI tools to load new configs"
        Write-Log "  2. Verify MCP servers are connecting"
        Write-Log "  3. Run 'docker mcp gateway run' if using Docker MCP"
    }
}
#endregion

# Run installer
try {
    Start-Installation
} catch {
    Write-Log "Installation failed: $_" -Level "ERROR"
    exit 1
}
