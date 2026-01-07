# Path Mapping Reference Table

Generated: 2026-01-06

This table maps `P:\dev\repos\Config` files to their corresponding runtime locations in `C:\Users\lance`.

**Purpose**: Reference documentation for understanding config deployment relationships.  
**Note**: This compares **installer templates** (portable reference) to runtime. The actual deployment mechanism is **P:\dev\repos\Dotfiles** via Chezmoi.

---

## Configuration File Mappings

| Name | Config Repo Source | Runtime Target | Category | Status |
|------|-------------------|----------------|----------|--------|
| **Claude Code Settings** | `installer/templates/claude/settings.json` | `.claude/settings.json` | Machine-Specific | Different |
| **Claude Code Local** | `claude/settings.local.json` | `.claude/settings.local.json` | Machine-Specific | Different |
| **Cursor MCP** | `installer/templates/cursor/mcp.json` | `.cursor/mcp.json` | Machine-Specific | Different |
| **Cursor CLI Config** | (none) | `.cursor/cli-config.json` | Machine-Specific | Missing Template |
| **Cursor Commands** | `cursor/commands/` | `.cursor/commands/` | Portable | Not Deployed |
| **Cursor Rules** | `cursor/rules/` | `.cursor/rules/` | Portable | Not Deployed |
| **Windsurf MCP** | `installer/templates/windsurf/mcp_config.json` | `.codeium/windsurf/mcp_config.json` | Machine-Specific | Different |
| **VS Code MCP** | `installer/templates/vscode/mcp.json` | `.vscode/mcp.json` | Machine-Specific | Different |
| **VS Code Extensions** | `vscode/extensions.json` | `.vscode/extensions/**` | Vendor-Managed | Reference Only |
| **Codex Config** | `installer/templates/codex/config.toml` | `.codex/config.toml` | Machine-Specific | Different |
| **Gemini Settings** | `installer/templates/gemini/settings.json` | `.gemini/settings.json` | Machine-Specific | Different |
| **Gemini Instructions** | (none) | `.gemini/instructions.md` | Portable | Missing Template |
| **Cline MCP** | `installer/templates/cline/cline_mcp_settings.json` | `.cline/cline_mcp_settings.json` | Machine-Specific | Different |
| **Continue Config** | `installer/templates/continue/config.json` | `.continue/config.json` | Machine-Specific | Missing Runtime |
| **Kiro MCP** | `installer/templates/kiro/mcp.json` | `.kiro/mcp.json` | Machine-Specific | Different |
| **LM Studio MCP** | `installer/templates/lmstudio/mcp.json` | `.lmstudio/mcp.json` | Machine-Specific | Different |
| **Zed Settings** | `installer/templates/zed/settings.json` | `.config/zed/settings.json` | Machine-Specific | Different |
| **Claude Desktop** | `installer/templates/claude-desktop/claude_desktop_config.json` | `AppData/Roaming/Claude/claude_desktop_config.json` | Machine-Specific | Different |
| **Claude Desktop Local** | `claude-desktop/settings.local.json` | (none) | Portable | Template Only |
| **VS Code Workspaces** | `workspaces/*.code-workspace` | (open from Config repo) | Portable | Active |

---

## Category Definitions

### Portable
**Definition**: Safe to keep identical across machines (no machine-specific paths, secrets, or environment dependencies).

**Examples**:
- Slash command files (`.md` markdown commands)
- Project rules (`.mdc` rule files)
- Workspace files (`.code-workspace` with relative paths)
- Documentation/instructions (`.md` guides)

**Deployment Strategy**: Copy or reference directly from Config repo.

---

### Machine-Specific
**Definition**: Contains local paths, Infisical project IDs, hardcoded environment variables, or platform-specific configurations.

**Examples**:
- All MCP configuration files (contain server paths, env vars, secrets)
- Claude Code settings (permission rules, MCP servers)
- Codex config (TOML with model preferences, server configs)
- Gemini settings (tool exclusions, MCP servers)

**Deployment Strategy**: 
- **Reference design**: Config/installer/templates (with `{{PLACEHOLDERS}}`)
- **Active deployment**: Dotfiles/dot_*/ (Chezmoi templates with Infisical injection)
- **Runtime**: Deployed to `C:\Users\lance` via `chezmoi apply`

---

### Vendor-Managed
**Definition**: Managed by the platform itself; should not be treated as portable configuration or version-controlled.

**Examples**:
- `.vscode/extensions/**` (installed VS Code extension binaries)
- `.cursor/extensions/**` (installed Cursor extension binaries)
- IDE state files (IDE-specific databases, caches)

**Deployment Strategy**: Do not copy, symlink, or version-control. Let the platform manage these.

---

## Current Deployment Gaps

### Not Deployed Globally (Portable payloads available but not installed)

1. **Cursor slash commands**
   - Source: `P:\dev\repos\Config\cursor\commands\` (38 commands)
   - Target: `C:\Users\lance\.cursor\commands\` (currently missing)
   - Options: Add to Chezmoi, include in installer, or use per-project

2. **Cursor project rules**
   - Source: `P:\dev\repos\Config\cursor\rules\` (2 rules)
   - Target: `C:\Users\lance\.cursor\rules\` (currently missing)
   - Options: Add to Chezmoi, include in installer, or use per-project

3. **Claude Code slash commands**
   - Source: `P:\dev\repos\Config\claude-code\commands\` (38 commands)
   - Target: `C:\Users\lance\.claude\commands\` (status unknown)
   - Options: Verify if deployed via Chezmoi, deploy if missing

### Missing Templates (Runtime exists, no installer template)

1. **Cursor CLI config** (871 bytes)
   - Runtime: `C:\Users\lance\.cursor\cli-config.json`
   - Template: Should create at `installer/templates/cursor/cli-config.json`
   - Purpose: Hard-deny list for destructive shell commands

2. **Gemini instructions** (637 bytes)
   - Runtime: `C:\Users\lance\.gemini\instructions.md`
   - Template: Should create at `installer/templates/gemini/instructions.md`
   - Purpose: Agent instruction markdown

### Missing Runtime (Template exists, not deployed)

1. **Continue config**
   - Template: `P:\dev\repos\Config\installer\templates\continue\config.json`
   - Runtime: `C:\Users\lance\.continue\config.json` (missing)
   - Action: Deploy if Continue extension is being used, or mark template as "future use"

---

## Architecture Tiers (Three-Layer Model)

### Tier 1: Reference Design (Config Repo)
- **Location**: `P:\dev\repos\Config\installer\templates\`
- **Format**: Portable templates with `{{PLACEHOLDERS}}`
- **Purpose**: New machine setup, cross-platform portability reference
- **Deployment**: Manual or via installer script
- **Version control**: Yes (Git repo, 10 commits)

### Tier 2: Active Deployment (Dotfiles Repo)
- **Location**: `P:\dev\repos\Dotfiles\dot_*/`
- **Format**: Chezmoi templates (`.tmpl`) with Infisical secret injection
- **Purpose**: Source of truth for this machine's runtime configs
- **Deployment**: `chezmoi apply --force`
- **Version control**: Yes (Git repo, 42 commits)
- **Symlink**: May be symlinked to OneDrive for cross-machine sync

### Tier 3: Runtime Configs (Protected)
- **Location**: `C:\Users\lance\.*`, `AppData\Roaming\Claude\`
- **Format**: Expanded configs with actual secrets, hardcoded paths
- **Purpose**: Working configs used by AI platforms daily
- **Modification**: **PROTECTED — do not modify**
- **Version control**: No (gitignored, managed by Chezmoi)

---

## Deployment Options (Reference)

This section documents available deployment methods. Choose based on your workflow.

### Option A: Chezmoi (Recommended for consistency)
Add portable files to Dotfiles repo as non-templated copies. Deployed alongside machine-specific configs via `chezmoi apply`.

### Option B: Installer Script
Include portable payloads in `P:\dev\repos\Config\installer\install.ps1`. Copies files during initial setup.

### Option C: Reference Only
Don't deploy globally. Open files directly from Config repo when needed, or use per-project `.cursor/` folders.

### Option D: Per-Project
Cursor and Claude Code both support project-level commands/rules. Place in each project's `.cursor/` or `.claude/` folder.

---

### Summary by Category

| Category | Deployment Method |
|----------|-------------------|
| **Portable** | Choose Option A-D above |
| **Machine-Specific** | Dotfiles/Chezmoi (Tier 2 → Tier 3) |
| **Vendor-Managed** | Do not manage; let platform handle |

---

## Related Documentation

- **[P:\dev\repos\Dotfiles\DOTFILES-SPEC.md](../Dotfiles/DOTFILES-SPEC.md)** - Chezmoi deployment specification
- **[P:\dev\repos\Dotfiles\README.md](../Dotfiles/README.md)** - Dotfiles quick start
- **[P:\dev\repos\Config\installer\README.md](installer/README.md)** - Installer documentation
- **[P:\dev\repos\Templates\README.md](../Templates/README.md)** - Template library

