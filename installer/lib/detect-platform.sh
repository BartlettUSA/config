#!/usr/bin/env bash
#
# detect-platform.sh - Cross-platform detection for Linux/macOS
# Returns JSON with platform details
#

set -euo pipefail

# Detect OS
detect_os() {
    local os="unknown"
    case "$(uname -s)" in
        Linux*)  os="linux" ;;
        Darwin*) os="darwin" ;;
        MINGW*|MSYS*|CYGWIN*) os="windows" ;;
    esac
    echo "$os"
}

# Detect architecture
detect_arch() {
    local arch
    arch=$(uname -m)
    case "$arch" in
        x86_64|amd64) echo "x64" ;;
        aarch64|arm64) echo "arm64" ;;
        armv7l) echo "arm" ;;
        *) echo "$arch" ;;
    esac
}

# Get OS version
get_os_version() {
    local os=$1
    case "$os" in
        linux)
            if [[ -f /etc/os-release ]]; then
                grep "^VERSION=" /etc/os-release | cut -d= -f2 | tr -d '"'
            else
                uname -r
            fi
            ;;
        darwin)
            sw_vers -productVersion 2>/dev/null || echo "unknown"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Check if running as root/admin
is_admin() {
    [[ $(id -u) -eq 0 ]] && echo "true" || echo "false"
}

# Check if command exists
has_command() {
    command -v "$1" &>/dev/null && echo "true" || echo "false"
}

# Get user home directory
get_home() {
    echo "${HOME:-$(eval echo ~)}"
}

# Main detection function - outputs JSON
get_platform_info() {
    local os arch os_version user_home user_name is_root
    local has_docker has_node has_git shell_name

    os=$(detect_os)
    arch=$(detect_arch)
    os_version=$(get_os_version "$os")
    user_home=$(get_home)
    user_name="${USER:-$(whoami)}"
    is_root=$(is_admin)
    has_docker=$(has_command docker)
    has_node=$(has_command node)
    has_git=$(has_command git)
    shell_name=$(basename "${SHELL:-/bin/bash}")

    cat <<EOF
{
  "os": "$os",
  "osVersion": "$os_version",
  "architecture": "$arch",
  "userHome": "$user_home",
  "userName": "$user_name",
  "isAdmin": $is_root,
  "shell": "$shell_name",
  "hasDocker": $has_docker,
  "hasNode": $has_node,
  "hasGit": $has_git,
  "timestamp": "$(date '+%Y-%m-%d %H:%M:%S')"
}
EOF
}

# Resolve path template to actual path
resolve_path() {
    local template=$1
    local resolved=$template

    # Replace common variables
    resolved="${resolved//\~/$HOME}"
    resolved="${resolved//\$HOME/$HOME}"
    resolved="${resolved//\$USER/${USER:-$(whoami)}}"
    resolved="${resolved//%USERPROFILE%/$HOME}"
    resolved="${resolved//%HOME%/$HOME}"

    # XDG directories
    resolved="${resolved//\$XDG_CONFIG_HOME/${XDG_CONFIG_HOME:-$HOME/.config}}"
    resolved="${resolved//\$XDG_DATA_HOME/${XDG_DATA_HOME:-$HOME/.local/share}}"

    echo "$resolved"
}

# Check platform requirements
check_requirements() {
    local require_docker=${1:-false}
    local require_node=${2:-false}
    local require_admin=${3:-false}

    local issues=()

    if [[ "$require_docker" == "true" ]] && ! command -v docker &>/dev/null; then
        issues+=("Docker is required but not found in PATH")
    fi

    if [[ "$require_node" == "true" ]] && ! command -v node &>/dev/null; then
        issues+=("Node.js is required but not found in PATH")
    fi

    if [[ "$require_admin" == "true" ]] && [[ $(id -u) -ne 0 ]]; then
        issues+=("Root/administrator privileges required")
    fi

    if [[ ${#issues[@]} -eq 0 ]]; then
        echo '{"success": true, "issues": []}'
    else
        printf '{"success": false, "issues": ['
        local first=true
        for issue in "${issues[@]}"; do
            [[ "$first" == "true" ]] || printf ','
            printf '"%s"' "$issue"
            first=false
        done
        printf ']}'
    fi
}

# If sourced, export functions; if executed, run detection
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-info}" in
        info|--info)
            get_platform_info
            ;;
        resolve|--resolve)
            resolve_path "${2:-}"
            ;;
        check|--check)
            check_requirements "${2:-false}" "${3:-false}" "${4:-false}"
            ;;
        *)
            echo "Usage: $0 [info|resolve <path>|check <docker> <node> <admin>]"
            exit 1
            ;;
    esac
fi
