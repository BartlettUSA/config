#!/usr/bin/env bash
#
# install.sh - Path-agnostic AI Platform Configuration Installer
#
# Usage:
#   ./install.sh [options]
#
# Options:
#   --dry-run         Preview changes without applying
#   --force           Overwrite existing files
#   --platforms LIST  Comma-separated list of platforms (default: all enabled)
#   --skip-secrets    Use placeholders instead of real secrets
#   --help            Show this help
#

set -euo pipefail

# Script directory (works even when symlinked)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/install.log"

# Default options
DRY_RUN=false
FORCE=false
SKIP_SECRETS=false
PLATFORMS=""

#region Logging
log() {
    local level="${2:-INFO}"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $1" >> "$LOG_FILE"

    case "$level" in
        ERROR)   echo -e "\033[31m$1\033[0m" ;;
        WARN)    echo -e "\033[33m$1\033[0m" ;;
        SUCCESS) echo -e "\033[32m$1\033[0m" ;;
        *)       echo "$1" ;;
    esac
}
#endregion

#region Platform Detection
source "$SCRIPT_DIR/lib/detect-platform.sh"
#endregion

#region Secret Resolution
resolve_secret() {
    local secret_name=$1

    if [[ "$SKIP_SECRETS" == "true" ]]; then
        echo "{{SECRET:$secret_name}}"
        return
    fi

    # Try environment variable
    local env_value="${!secret_name:-}"
    if [[ -n "$env_value" ]]; then
        log "  Secret '$secret_name' resolved from environment" "INFO"
        echo "$env_value"
        return
    fi

    # Try Infisical
    if command -v infisical &>/dev/null; then
        local value
        value=$(infisical secrets get "$secret_name" --path=/ --plain --silent 2>/dev/null || true)
        if [[ -n "$value" ]]; then
            log "  Secret '$secret_name' resolved from Infisical" "INFO"
            echo "$value"
            return
        fi
    fi

    # Try Docker MCP
    if command -v docker &>/dev/null; then
        local value
        value=$(docker mcp secret get "$secret_name" 2>/dev/null || true)
        if [[ -n "$value" ]]; then
            log "  Secret '$secret_name' resolved from Docker MCP" "INFO"
            echo "$value"
            return
        fi
    fi

    log "  Secret '$secret_name' not found - using placeholder" "WARN"
    echo "{{SECRET:$secret_name}}"
}
#endregion

#region Template Processing
expand_template() {
    local content=$1
    local result=$content

    # Get platform info
    local user_home
    user_home=$(get_home)

    # Replace environment variables: {{ENV:VAR_NAME}}
    while [[ "$result" =~ \{\{ENV:([^}]+)\}\} ]]; do
        local var_name="${BASH_REMATCH[1]}"
        local var_value="${!var_name:-}"
        result="${result//\{\{ENV:$var_name\}\}/$var_value}"
    done

    # Replace secrets: {{SECRET:SECRET_NAME}}
    while [[ "$result" =~ \{\{SECRET:([^}]+)\}\} ]]; do
        local secret_name="${BASH_REMATCH[1]}"
        local secret_value
        secret_value=$(resolve_secret "$secret_name")
        # Escape special characters for sed
        secret_value=$(printf '%s\n' "$secret_value" | sed 's/[&/\]/\\&/g')
        result="${result//\{\{SECRET:$secret_name\}\}/$secret_value}"
    done

    # Replace config values: {{CONFIG:key:default}}
    while [[ "$result" =~ \{\{CONFIG:([^:}]+):?([^}]*)\}\} ]]; do
        local key="${BASH_REMATCH[1]}"
        local default="${BASH_REMATCH[2]}"
        result="${result//\{\{CONFIG:$key:$default\}\}/$default}"
    done

    # Replace platform paths
    result="${result//\{\{USER_HOME\}\}/$user_home}"

    echo "$result"
}
#endregion

#region Configuration
get_platform_path() {
    local platform=$1
    local os=$2

    # Read from config.json using jq if available, otherwise use simple grep
    if command -v jq &>/dev/null; then
        jq -r ".platforms.\"$platform\".paths.$os // empty" "$SCRIPT_DIR/config.json"
    else
        # Fallback: hardcoded paths
        case "$platform:$os" in
            "claude-code:linux"|"claude-code:darwin") echo "~/.claude" ;;
            "cursor:linux"|"cursor:darwin") echo "~/.cursor" ;;
            "windsurf:linux"|"windsurf:darwin") echo "~/.codeium/windsurf" ;;
            "vscode:linux"|"vscode:darwin") echo "~/.vscode" ;;
            "codex:linux"|"codex:darwin") echo "~/.codex" ;;
            "gemini:linux"|"gemini:darwin") echo "~/.gemini" ;;
            "cline:linux"|"cline:darwin") echo "~/.cline" ;;
            "continue:linux"|"continue:darwin") echo "~/.continue" ;;
            "kiro:linux"|"kiro:darwin") echo "~/.kiro" ;;
            "lmstudio:linux"|"lmstudio:darwin") echo "~/.lmstudio" ;;
            "zed:linux"|"zed:darwin") echo "~/.config/zed" ;;
            "claude-desktop:darwin") echo "~/Library/Application Support/Claude" ;;
            *) echo "" ;;
        esac
    fi
}

get_platform_files() {
    local platform=$1

    if command -v jq &>/dev/null; then
        jq -r ".platforms.\"$platform\".files[]? | \"\(.source)|\(.target)|\(.optional // false)\"" "$SCRIPT_DIR/config.json"
    else
        # Fallback: hardcoded mappings
        case "$platform" in
            "claude-code") echo "templates/claude/settings.json|settings.json|false" ;;
            "cursor") echo "templates/cursor/mcp.json|mcp.json|false" ;;
            "windsurf") echo "templates/windsurf/mcp_config.json|mcp_config.json|false" ;;
            "vscode") echo "templates/vscode/mcp.json|mcp.json|false" ;;
            "gemini") echo "templates/gemini/settings.json|settings.json|false" ;;
            "zed") echo "templates/zed/settings.json|settings.json|false" ;;
        esac
    fi
}

get_enabled_platforms() {
    if command -v jq &>/dev/null; then
        jq -r '.platforms | to_entries[] | select(.value.enabled == true) | .key' "$SCRIPT_DIR/config.json"
    else
        # Fallback list
        echo -e "claude-code\ncursor\nwindsurf\nvscode\ngemini\nzed"
    fi
}
#endregion

#region File Operations
copy_config_file() {
    local source_path=$1
    local target_path=$2
    local optional=${3:-false}

    local full_source="$SCRIPT_DIR/$source_path"

    # Check source exists
    if [[ ! -f "$full_source" ]]; then
        if [[ "$optional" == "true" ]]; then
            log "  Optional source not found: $source_path" "INFO"
            return 0
        fi
        log "  Source not found: $full_source" "WARN"
        return 1
    fi

    # Resolve target path
    local resolved_target
    resolved_target=$(resolve_path "$target_path")

    # Read and process template
    local content
    content=$(cat "$full_source")
    local processed_content
    processed_content=$(expand_template "$content")

    if [[ "$DRY_RUN" == "true" ]]; then
        log "  [DRY RUN] Would write to: $resolved_target" "INFO"
        return 0
    fi

    # Create directory if needed
    local target_dir
    target_dir=$(dirname "$resolved_target")
    if [[ ! -d "$target_dir" ]]; then
        mkdir -p "$target_dir"
        log "  Created directory: $target_dir" "INFO"
    fi

    # Check for existing file
    if [[ -f "$resolved_target" ]] && [[ "$FORCE" != "true" ]]; then
        log "  File exists: $resolved_target (use --force to overwrite)" "WARN"
        return 1
    fi

    # Backup existing file
    if [[ -f "$resolved_target" ]]; then
        local backup_path="${resolved_target}.backup.$(date '+%Y%m%d-%H%M%S')"
        cp "$resolved_target" "$backup_path"
        log "  Backed up to: $backup_path" "INFO"
    fi

    # Write file
    echo "$processed_content" > "$resolved_target"
    log "  Deployed: $resolved_target" "SUCCESS"
    return 0
}
#endregion

#region Installation
install_platform() {
    local platform_name=$1
    local os=$2

    log ""
    log "Installing $platform_name..."

    # Get target path
    local target_base
    target_base=$(get_platform_path "$platform_name" "$os")

    if [[ -z "$target_base" ]]; then
        log "  Platform '$platform_name' not supported on $os" "WARN"
        return
    fi

    # Process each file
    while IFS='|' read -r source target optional; do
        [[ -z "$source" ]] && continue
        local target_path="$target_base/$target"
        copy_config_file "$source" "$target_path" "$optional"
    done < <(get_platform_files "$platform_name")
}

show_help() {
    cat << 'EOF'
AI Platform Configuration Installer

Usage: ./install.sh [options]

Options:
  --dry-run         Preview changes without applying
  --force           Overwrite existing files without prompting
  --platforms LIST  Comma-separated platforms (default: all enabled)
  --skip-secrets    Use placeholders instead of real secrets
  --help            Show this help

Examples:
  ./install.sh                          # Install all enabled platforms
  ./install.sh --dry-run                # Preview what would be installed
  ./install.sh --platforms cursor,vscode  # Install only Cursor and VS Code
  ./install.sh --force --skip-secrets   # Force install without secrets

Supported Platforms:
  claude-code, claude-desktop, cursor, windsurf, vscode, codex,
  gemini, cline, continue, kiro, lmstudio, zed
EOF
}

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run) DRY_RUN=true; shift ;;
            --force) FORCE=true; shift ;;
            --skip-secrets) SKIP_SECRETS=true; shift ;;
            --platforms) PLATFORMS="$2"; shift 2 ;;
            --help) show_help; exit 0 ;;
            *) log "Unknown option: $1" "ERROR"; exit 1 ;;
        esac
    done

    log "$(printf '=%.0s' {1..60})"
    log "AI Platform Configuration Installer"
    log "$(printf '=%.0s' {1..60})"

    # Detect platform
    local platform_json
    platform_json=$(get_platform_info)
    local os arch user_home has_docker has_node
    os=$(echo "$platform_json" | grep -o '"os": *"[^"]*"' | cut -d'"' -f4)
    arch=$(echo "$platform_json" | grep -o '"architecture": *"[^"]*"' | cut -d'"' -f4)
    user_home=$(echo "$platform_json" | grep -o '"userHome": *"[^"]*"' | cut -d'"' -f4)
    has_docker=$(echo "$platform_json" | grep -o '"hasDocker": *[^,}]*' | cut -d: -f2 | tr -d ' ')
    has_node=$(echo "$platform_json" | grep -o '"hasNode": *[^,}]*' | cut -d: -f2 | tr -d ' ')

    log ""
    log "Detected Platform:"
    log "  OS: $os"
    log "  Architecture: $arch"
    log "  Home: $user_home"
    log "  Docker: $has_docker"
    log "  Node.js: $has_node"

    # Determine platforms to install
    local platforms_to_install
    if [[ -n "$PLATFORMS" ]]; then
        platforms_to_install=$(echo "$PLATFORMS" | tr ',' '\n')
    else
        platforms_to_install=$(get_enabled_platforms)
    fi

    log ""
    log "Platforms to install: $(echo "$platforms_to_install" | tr '\n' ', ' | sed 's/,$//')"

    if [[ "$DRY_RUN" == "true" ]]; then
        log ""
        log "*** DRY RUN MODE - No changes will be made ***" "WARN"
    fi

    # Install each platform
    while IFS= read -r platform_name; do
        [[ -z "$platform_name" ]] && continue
        install_platform "$platform_name" "$os"
    done <<< "$platforms_to_install"

    log ""
    log "$(printf '=%.0s' {1..60})"
    log "Installation complete!"
    log "Log file: $LOG_FILE"

    if [[ "$DRY_RUN" != "true" ]]; then
        log ""
        log "Next steps:"
        log "  1. Restart your AI tools to load new configs"
        log "  2. Verify MCP servers are connecting"
        log "  3. Run 'docker mcp gateway run' if using Docker MCP"
    fi
}

main "$@"
