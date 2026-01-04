# Config Directory

**Purpose:** Portable IDE and tool configurations for cross-machine consistency.
**Parent:** [P:\dev](../README.md) | **Managed By:** Manual + Chezmoi hybrid

---

## Quick Start

```powershell
# Option 1: Path-agnostic installer (recommended for new machines)
cd installer
.\install.ps1

# Option 2: Chezmoi-managed configs (if chezmoi is set up)
chezmoi apply --force

# Option 3: Dry run to preview changes
.\installer\install.ps1 -DryRun
```

### Portable Installer

The `installer/` directory contains a **path-agnostic install package** that works on any machine:

```
installer/
├── install.ps1          # Windows installer
├── install.sh           # Linux/macOS installer
├── config.json          # Platform mappings
├── templates/           # Config templates (12 platforms)
├── lib/                 # Platform detection & utilities
└── hooks/               # Pre/post install & rollback
```

**Features:**
- Cross-platform (Windows/Linux/macOS)
- Auto-detects user home and paths
- Secrets from env vars, Infisical, or Docker MCP
- Backup and rollback support
- Dry-run mode for previews

See [installer/README.md](installer/README.md) for full documentation.

---

## Symlink Table

### Chezmoi-Managed (Source of Truth: `P:\dev\_dotfiles`)

| Platform | Source (dotfiles) | Target (User Profile) | Status |
|----------|-------------------|----------------------|--------|
| **Claude Code** | `dot_claude/settings.json.tmpl` | `C:\Users\lance\.claude\settings.json` | ✅ Chezmoi |
| **Claude Code** | `dot_claude/settings.local.json` | `C:\Users\lance\.claude\settings.local.json` | ✅ Chezmoi |
| **Cursor** | `dot_cursor/mcp.json.tmpl` | `C:\Users\lance\.cursor\mcp.json` | ✅ Chezmoi |
| **Windsurf** | `dot_codeium/windsurf/mcp_config.json.tmpl` | `C:\Users\lance\.codeium\windsurf\mcp_config.json` | ✅ Chezmoi |
| **VS Code** | `dot_vscode/mcp.json.tmpl` | `C:\Users\lance\.vscode\mcp.json` | ✅ Chezmoi |
| **Codex** | `dot_codex/config.toml.tmpl` | `C:\Users\lance\.codex\config.toml` | ✅ Chezmoi |
| **Gemini CLI** | `dot_gemini/settings.json.tmpl` | `C:\Users\lance\.gemini\settings.json` | ✅ Chezmoi |
| **Gemini CLI** | `dot_gemini/instructions.md` | `C:\Users\lance\.gemini\instructions.md` | ✅ Chezmoi |
| **Cline** | `dot_cline/cline_mcp_settings.json.tmpl` | `C:\Users\lance\.cline\cline_mcp_settings.json` | ✅ Chezmoi |
| **Continue** | `dot_continue/mcpServers/mcp-servers.json.tmpl` | `C:\Users\lance\.continue\mcpServers\mcp-servers.json` | ✅ Chezmoi |
| **Kiro** | `dot_kiro/mcp.json.tmpl` | `C:\Users\lance\.kiro\mcp.json` | ✅ Chezmoi |
| **LM Studio** | `dot_lmstudio/mcp.json.tmpl` | `C:\Users\lance\.lmstudio\mcp.json` | ✅ Chezmoi |
| **Zed** | `dot_config/zed/settings.json.tmpl` | `C:\Users\lance\.config\zed\settings.json` | ✅ Chezmoi |
| **Claude Desktop** | `AppData/Roaming/Claude/claude_desktop_config.json.tmpl` | `C:\Users\lance\AppData\Roaming\Claude\claude_desktop_config.json` | ✅ Chezmoi |

### Manual Configs (Source: `P:\dev\config`)

| Folder | Source (config/) | Target (User Profile) | Status |
|--------|------------------|----------------------|--------|
| **claude/** | `config/claude/settings.local.json` | Reference copy | 📋 Manual |
| **claude-desktop/** | `config/claude-desktop/` | Reference copy | 📋 Manual |
| **cursor/** | `config/cursor/` | `C:\Users\lance\.cursor\` | ⚠️ Empty |
| **vscode/** | `config/vscode/extensions.json` | Reference only | 📋 Manual |
| **vscode-portable/** | `config/vscode-portable/` | Portable install location | ⚠️ Empty |
| **workspaces/** | `config/workspaces/*.code-workspace` | VS Code workspace files | ✅ Active |
| **obsidian/** | `config/obsidian/` | Placeholder | ⚠️ Empty |

---

## Platform Config Locations

### Windows (`C:\Users\lance\`)

| Platform | Config Path | Config Type |
|----------|-------------|-------------|
| Claude Code | `.claude\` | JSON |
| Claude Desktop | `AppData\Roaming\Claude\` | JSON |
| Cursor | `.cursor\` | JSON |
| Windsurf | `.codeium\windsurf\` | JSON |
| VS Code | `.vscode\` + `AppData\Roaming\Code\` | JSON |
| Codex | `.codex\` | TOML |
| Gemini CLI | `.gemini\` | JSON + MD |
| Cline | `.cline\` | JSON |
| Continue | `.continue\` | JSON |
| Kiro | `.kiro\` | JSON |
| LM Studio | `.lmstudio\` | JSON |
| Zed | `.config\zed\` | JSON |

### Linux/macOS (`~/.config/` XDG compliant)

| Platform | Config Path |
|----------|-------------|
| Claude Code | `~/.claude/` |
| Cursor | `~/.cursor/` |
| Windsurf | `~/.codeium/windsurf/` |
| VS Code | `~/.vscode/` |
| Codex | `~/.codex/` |
| Gemini CLI | `~/.gemini/` |
| Zed | `~/.config/zed/` |

---

## MCP Server Commands (Optimized 2025)

Based on latest best practices from Perplexity research (Jan 2025):

### Docker MCP Gateway (Primary)

```powershell
# Start gateway
docker mcp gateway run

# List connected clients
docker mcp client list

# Connect a client globally
docker mcp client connect cursor --global

# Manage secrets
docker mcp gateway list secrets
docker mcp secret set github.personal_access_token <token>
```

### NPX Servers (Recommended)

| Server | Command | Notes |
|--------|---------|-------|
| Context7 | `npx -y @upstash/context7-mcp` | Documentation lookup |
| Kapture | `npx -y kapture-mcp bridge` | Browser DevTools |
| Playwright | `npx -y @playwright/mcp@latest` | Web automation |
| Auth0 | `npx -y @auth0/auth0-mcp-server run` | OAuth flows |
| Figma | `npx -y figma-mcp` | Design integration |
| MS Learn | `npx -y mcp-remote https://learn.microsoft.com/api/mcp` | Microsoft docs |
| Hugging Face | `npx -y @llmindset/mcp-hfspace` | ML models |
| GitHub | `npx -y @modelcontextprotocol/server-github` | Repository access |
| Obsidian | `npx -y obsidian-mcp` | Vault access |
| Firecrawl | `npx -y firecrawl-mcp` | Web scraping |

### Chezmoi Operations

```powershell
# Preview changes
chezmoi diff

# Apply all configs
chezmoi apply --force

# Add new file to management
chezmoi add ~/.some/config

# Edit source template
chezmoi edit ~/.cursor/mcp.json

# View managed files
chezmoi managed

# Check health
chezmoi doctor
```

### Infisical Secrets

```powershell
# List secrets
infisical secrets list --path=/

# Get specific secret
infisical secrets get GITHUB_PERSONAL_ACCESS_TOKEN --path=/

# Set secret
infisical secrets set NEW_KEY "value" --path=/mcp
```

---

## Directory Structure

```
P:\dev\config\
├── README.md                  # This file
├── installer\                 # ⭐ Path-agnostic installer package
│   ├── install.ps1           # Windows installer
│   ├── install.sh            # Linux/macOS installer
│   ├── config.json           # Platform mappings
│   ├── templates\            # Config templates (12 platforms)
│   ├── lib\                  # Platform detection utilities
│   └── hooks\                # Pre/post install & rollback
├── claude\                    # Claude Code reference configs
│   ├── CLAUDE.md             # Project instructions
│   ├── settings.local.json   # Permission overrides
│   └── .claude\              # Nested config structure
├── claude-desktop\           # Claude Desktop configs
├── cursor\                   # Cursor IDE (empty - use chezmoi)
├── vscode\                   # VS Code settings
│   └── extensions.json       # Extension list
├── vscode-portable\          # Portable VS Code location
├── workspaces\               # VS Code workspace files
│   ├── Dev.code-workspace
│   ├── IDCP.code-workspace
│   └── Archive\              # Deprecated workspaces
└── obsidian\                 # Obsidian vault placeholder
```

---

## Setup Script

Create `P:\dev\config\scripts\setup-symlinks.ps1`:

```powershell
#Requires -RunAsAdministrator
# Setup symlinks for configs that need specific locations

$configRoot = "P:\dev\config"
$userProfile = $env:USERPROFILE

# Define symlink mappings (source -> target)
$symlinks = @{
    # Workspaces accessible from VS Code
    "$configRoot\workspaces" = "$userProfile\_workspaces"
}

foreach ($source in $symlinks.Keys) {
    $target = $symlinks[$source]

    if (Test-Path $target) {
        Write-Host "Target exists: $target (skipping)" -ForegroundColor Yellow
        continue
    }

    if (Test-Path $source) {
        New-Item -ItemType SymbolicLink -Path $target -Target $source -Force
        Write-Host "Created symlink: $target -> $source" -ForegroundColor Green
    } else {
        Write-Host "Source missing: $source" -ForegroundColor Red
    }
}

Write-Host "`nDone. Run 'chezmoi apply --force' for managed configs."
```

---

## Migration Status

| Item | From | To | Status |
|------|------|-----|--------|
| Claude settings | `.claude/` | `_dotfiles/dot_claude/` | ✅ Chezmoi |
| Cursor MCP | `.cursor/` | `_dotfiles/dot_cursor/` | ✅ Chezmoi |
| VS Code MCP | `.vscode/` | `_dotfiles/dot_vscode/` | ✅ Chezmoi |
| Workspaces | `_workspaces/` | `config/workspaces/` | ✅ Moved |
| VS Code portable | AppData | `config/vscode-portable/` | 🔄 Pending |

---

## Security Notes

> ⚠️ **Never commit API keys or secrets to version control**

- Secrets are managed via Infisical (see `_dotfiles/.infisical.json`)
- Templates use `{{ secret ... }}` syntax for dynamic injection
- Docker MCP uses its own credential store: `docker mcp secret set`
- Personal overrides go in `settings.local.json` (not tracked)

---

## Related

- [P:\dev\_dotfiles\DOTFILES-SPEC.md](../_dotfiles/DOTFILES-SPEC.md) — Full specification
- [P:\dev\_dotfiles\MCP-SERVER-MATRIX.md](../_dotfiles/MCP-SERVER-MATRIX.md) — All 27 MCP capabilities
- [P:\dev\_dotfiles\START-HERE.md](../_dotfiles/START-HERE.md) — 5-minute setup guide
