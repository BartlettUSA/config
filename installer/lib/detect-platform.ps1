#Requires -Version 5.1
<#
.SYNOPSIS
    Detects the current platform and returns standardized information.

.DESCRIPTION
    Cross-platform detection for Windows, Linux, and macOS.
    Returns a hashtable with platform details.

.OUTPUTS
    Hashtable with: OS, Architecture, UserHome, IsAdmin, Shell
#>

function Get-PlatformInfo {
    [CmdletBinding()]
    param()

    $info = @{
        OS           = "unknown"
        OSVersion    = ""
        Architecture = ""
        UserHome     = ""
        UserName     = ""
        IsAdmin      = $false
        Shell        = "powershell"
        HasDocker    = $false
        HasNode      = $false
        HasGit       = $false
        Timestamp    = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    }

    # Detect OS
    if ($IsWindows -or $env:OS -eq "Windows_NT") {
        $info.OS = "windows"
        $info.OSVersion = [System.Environment]::OSVersion.Version.ToString()
        $info.UserHome = $env:USERPROFILE
        $info.UserName = $env:USERNAME
        $info.Architecture = if ([Environment]::Is64BitOperatingSystem) { "x64" } else { "x86" }

        # Check admin
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal($identity)
        $info.IsAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    } elseif ($IsLinux) {
        $info.OS = "linux"
        $info.OSVersion = if (Test-Path /etc/os-release) {
            (Get-Content /etc/os-release | Where-Object { $_ -match "^VERSION=" }) -replace 'VERSION=|"', ''
        } else { "unknown" }
        $info.UserHome = $env:HOME
        $info.UserName = $env:USER
        $info.Architecture = (uname -m)
        $info.IsAdmin = (id -u) -eq 0
        $info.Shell = if ($env:SHELL) { Split-Path $env:SHELL -Leaf } else { "bash" }

    } elseif ($IsMacOS) {
        $info.OS = "darwin"
        $info.OSVersion = (sw_vers -productVersion)
        $info.UserHome = $env:HOME
        $info.UserName = $env:USER
        $info.Architecture = (uname -m)
        $info.IsAdmin = (id -u) -eq 0
        $info.Shell = if ($env:SHELL) { Split-Path $env:SHELL -Leaf } else { "zsh" }
    }

    # Check for common tools
    $info.HasDocker = $null -ne (Get-Command docker -ErrorAction SilentlyContinue)
    $info.HasNode = $null -ne (Get-Command node -ErrorAction SilentlyContinue)
    $info.HasGit = $null -ne (Get-Command git -ErrorAction SilentlyContinue)

    return $info
}

function Resolve-PlatformPath {
    <#
    .SYNOPSIS
        Resolves a path template to the actual path for the current platform.

    .PARAMETER PathTemplate
        Path with variables like %USERPROFILE%, ~, or $HOME

    .PARAMETER PlatformInfo
        Optional platform info hashtable (uses Get-PlatformInfo if not provided)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$PathTemplate,

        [hashtable]$PlatformInfo
    )

    if (-not $PlatformInfo) {
        $PlatformInfo = Get-PlatformInfo
    }

    $resolved = $PathTemplate

    # Windows-style variables
    $resolved = $resolved -replace '%USERPROFILE%', $PlatformInfo.UserHome
    $resolved = $resolved -replace '%APPDATA%', "$($PlatformInfo.UserHome)\AppData\Roaming"
    $resolved = $resolved -replace '%LOCALAPPDATA%', "$($PlatformInfo.UserHome)\AppData\Local"
    $resolved = $resolved -replace '%HOME%', $PlatformInfo.UserHome

    # Unix-style variables
    $resolved = $resolved -replace '^\~', $PlatformInfo.UserHome
    $resolved = $resolved -replace '\$HOME', $PlatformInfo.UserHome
    $resolved = $resolved -replace '\$USER', $PlatformInfo.UserName

    # Normalize path separators
    if ($PlatformInfo.OS -eq "windows") {
        $resolved = $resolved -replace '/', '\'
    } else {
        $resolved = $resolved -replace '\\', '/'
    }

    return $resolved
}

function Test-PlatformRequirements {
    <#
    .SYNOPSIS
        Checks if the current platform meets installation requirements.
    #>
    [CmdletBinding()]
    param(
        [hashtable]$PlatformInfo,
        [switch]$RequireDocker,
        [switch]$RequireNode,
        [switch]$RequireAdmin
    )

    if (-not $PlatformInfo) {
        $PlatformInfo = Get-PlatformInfo
    }

    $issues = @()

    if ($RequireDocker -and -not $PlatformInfo.HasDocker) {
        $issues += "Docker is required but not found in PATH"
    }

    if ($RequireNode -and -not $PlatformInfo.HasNode) {
        $issues += "Node.js is required but not found in PATH"
    }

    if ($RequireAdmin -and -not $PlatformInfo.IsAdmin) {
        $issues += "Administrator/root privileges required"
    }

    return @{
        Success = $issues.Count -eq 0
        Issues  = $issues
    }
}

# Export functions if running as module
if ($MyInvocation.InvocationName -ne '.') {
    Export-ModuleMember -Function Get-PlatformInfo, Resolve-PlatformPath, Test-PlatformRequirements
}
