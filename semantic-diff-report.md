# Semantic Diff Report: Config Installer Templates vs Runtime Configs

Generated: 2026-01-06

## Summary

All evaluated config pairs show DIFFERENT hashes. This report documents semantic differences for each mismatched pair.

**Important Context**: This compares `P:\dev\repos\Config\installer\templates\` (portable reference designs) against `C:\Users\lance` (working runtime configs). The actual deployment mechanism is `P:\dev\repos\Dotfiles` via Chezmoi.

---

## Key Findings

### Schema Differences (Breaking if applied to runtime)
- **Claude Code**: Template uses `permissions.allow/deny`, Runtime uses `permissions.allowedTools/deniedTools`
- **Zed**: Template uses `mcpServers`, Runtime uses `context_servers`

### Feature Additions (Runtime has more than templates)
- **MCP configs**: Runtime includes many additional servers (auth0, figma, ms-learn-docs, hugging-face, skills, obsidian, firecrawl, github)
- **Secret management**: Runtime uses Infisical-wrapped commands for secure servers
- **Environment variables**: Runtime has hardcoded Windows paths; templates use placeholders

### Missing Templates (Runtime files without corresponding templates)
- `cursor-cli-config` (C:\Users\lance\.cursor\cli-config.json) - exists in runtime, no template
- `gemini-instructions` (C:\Users\lance\.gemini\instructions.md) - exists in runtime, no template

### Missing Runtime (Templates without corresponding runtime files)
- `continue-config` (C:\Users\lance\.continue\config.json) - template exists, runtime missing

---

## Detailed Analysis by Platform

### claude-settings
**Runtime**: `C:\Users\lance\.claude\settings.json`  
**Template**: `P:\dev\repos\Config\installer\templates\claude\settings.json`  
**Status**: DIFFERENT (SHA256 mismatch)

**Key Differences**:
- **Schema**: Runtime uses `permissions.allowedTools/deniedTools`, Template uses `permissions.allow/deny`
- **Permission scope**: Runtime has extensive Bash command allowlist (60+ specific commands including chezmoi, docker, git, gh CLI)
- **MCP servers**: Runtime includes 12 servers (MCP_DOCKER, context7, kapture, auth0, playwright, figma, ms-learn-docs, hugging-face, skills, obsidian, firecrawl, github)
- **Secret injection**: Runtime uses Infisical wrappers for secure servers (figma, obsidian, firecrawl, github)
- **Environment paths**: Runtime has hardcoded Windows paths; Template uses minimal/placeholder config

**Recommendation**: Update template to match runtime schema (`allowedTools/deniedTools`), expand MCP server list, preserve Infisical commands as template placeholders.

---

### claude-settings-local
**Runtime**: `C:\Users\lance\.claude\settings.local.json`  
**Template**: `P:\dev\repos\Config\claude\settings.local.json`  
**Status**: DIFFERENT

**Key Differences**:
- Runtime has extensive allow/deny/ask permission rules
- Runtime includes specific allowlist for chezmoi binary paths
- Template has minimal structure
- Both use same schema (allow/deny/ask)

**Recommendation**: Template should represent a "reference" local override; current runtime is machine-specific and correctly configured.

---

### cursor-mcp, windsurf-mcp, vscode-mcp, cline-mcp
**Runtime**: Various `.*/mcp.json` files  
**Template**: `P:\dev\repos\Config\installer\templates\{platform}\mcp*.json`  
**Status**: ALL DIFFERENT

**Common Differences**:
- **Server count**: Runtime has 12 servers, templates have 3-7
- **Infisical integration**: Runtime uses Infisical-wrapped commands for servers requiring secrets
- **Environment variables**: Runtime has hardcoded Windows paths (LOCALAPPDATA, ProgramData, ProgramFiles), templates use placeholders like `{{ENV:...}}`
- **Skills server**: Runtime points to actual local path (`P:/dev/mcp-servers/...`), templates would need placeholder

**Additional servers in runtime**:
- auth0 (with `--tools *` and `capabilities` array)
- figma (Infisical-wrapped)
- ms-learn-docs (via mcp-remote)
- hugging-face
- skills (local Node.js server)
- obsidian (varies: direct npx vs Infisical-wrapped)
- firecrawl (Infisical-wrapped)
- github (varies: Infisical-wrapped npx vs Docker image)

**Recommendation**: Update all MCP config templates to include full server list from runtime, preserve placeholder syntax (`{{ENV:...}}`, `{{SECRET:...}}`) for portability.

---

### codex-config
**Runtime**: `C:\Users\lance\.codex\config.toml`  
**Template**: `P:\dev\repos\Config\installer\templates\codex\config.toml`  
**Status**: DIFFERENT

**Key Differences**:
- **Model config**: Runtime includes `model = "gpt-5.2-codex"` and `model_reasoning_effort = "medium"`
- **Server count**: Runtime has 10+ MCP servers, template is minimal
- **Infisical integration**: Runtime uses Infisical for figma/obsidian/firecrawl/github
- **HTTP endpoints**: Runtime uses `mcp-remote` bridges for HTTP-only services (context7, figma, ms-learn-docs, hugging-face)
- **Notice section**: Runtime includes model migration notices

**Recommendation**: Update template to include full server list and model config, preserve HTTP-endpoint approach note for Codex cloud environment.

---

### gemini-settings
**Runtime**: `C:\Users\lance\.gemini\settings.json`  
**Template**: `P:\dev\repos\Config\installer\templates\gemini\settings.json`  
**Status**: DIFFERENT

**Key Differences**:
- **Code execution**: Runtime has `"codeExecution": {"enabled": true}`
- **Tool exclusions**: Runtime has `tools.exclude` array with destructive commands (format, diskpart, bcdedit, reg, sc, net, shutdown, rm -rf, mkfs, dd)
- **MCP servers**: Runtime includes MCP_DOCKER, context7, github (with secret placeholder)
- Template is minimal with basic tool exclusions only

**Recommendation**: Update template to match runtime structure (codeExecution, tools.exclude, mcpServers sections).

---

### kiro-mcp
**Runtime**: `C:\Users\lance\.kiro\mcp.json`  
**Template**: `P:\dev\repos\Config\installer\templates\kiro\mcp.json`  
**Status**: DIFFERENT

**Key Differences**:
- Runtime has 8 servers with skills/obsidian local paths
- Runtime uses `context_servers` key instead of `mcpServers`
- Template is minimal (MCP_DOCKER + context7 only)

**Recommendation**: Update template to match runtime server list and schema.

---

### lmstudio-mcp
**Runtime**: `C:\Users\lance\.lmstudio\mcp.json`  
**Template**: `P:\dev\repos\Config\installer\templates\lmstudio\mcp.json`  
**Status**: DIFFERENT

**Key Differences**:
- Runtime uses HTTP URL endpoints (`url` property instead of `command/args`)
- Runtime has context7, ms-learn-docs, hugging-face as HTTP endpoints
- Runtime includes MCP_DOCKER with env vars
- Template structure uses `command/args` pattern

**Recommendation**: Update template to use `url` property for HTTP endpoints (LM Studio HTTP-only requirement).

---

### zed-settings
**Runtime**: `C:\Users\lance\.config\zed\settings.json`  
**Template**: `P:\dev\repos\Config\installer\templates\zed\settings.json`  
**Status**: DIFFERENT

**CRITICAL SCHEMA ISSUE**:
- **Runtime uses**: `context_servers` key (Zed-specific schema)
- **Runtime structure**: `{ "command": { "path": "docker", "args": [...] } }`
- **Template uses**: `mcpServers` key (wrong for Zed)
- **Template structure**: `{ "command": "docker", "args": [...] }` (wrong nesting)

**Additional differences**:
- Runtime includes `assistant.version` and `assistant.provider` keys
- Runtime has skills server with local path

**Recommendation**: **CRITICAL FIX REQUIRED** - Template must use Zed's `context_servers` schema with nested command structure, or it will not work when deployed.

---

### claude-desktop-config
**Runtime**: `C:\Users\lance\AppData\Roaming\Claude\claude_desktop_config.json`  
**Template**: `P:\dev\repos\Config\installer\templates\claude-desktop\claude_desktop_config.json`  
**Status**: DIFFERENT

**Key Differences**:
- **Hooks**: Runtime includes `hooks.PostToolUse` with auto-lint command (`pnpm lint:fix --quiet 2>/dev/null || true`)
- **Auth0**: Runtime has additional `--tools *` arg and `capabilities: ["tools"]`
- **GitHub MCP**: Runtime uses **Docker image** (`docker run -i --rm ... ghcr.io/github/github-mcp-server`), template uses npx
- **Skills server**: Runtime path points to `mcp-servers/` directory (vs template's `mcp/servers/`)

**Recommendation**: Update template to include hooks section, Auth0 capabilities, document platform-specific GitHub MCP approaches (Docker for Claude Desktop, npx for others).

---

## Summary Table

| Config | Schema Issue | Server Count Gap | Secret Management | Priority |
|--------|--------------|------------------|-------------------|----------|
| claude-settings | ✅ Yes (allow → allowedTools) | +9 servers | Infisical | 🔴 Critical |
| cursor-mcp | ❌ No | +5 servers | Infisical | 🟡 Medium |
| windsurf-mcp | ❌ No | +5 servers | Infisical | 🟡 Medium |
| vscode-mcp | ❌ No | +5 servers | Infisical | 🟡 Medium |
| codex-config | ❌ No | +7 servers | Infisical + HTTP | 🟡 Medium |
| gemini-settings | ❌ No | +2 servers | Placeholder | 🟡 Medium |
| cline-mcp | ❌ No | +9 servers | Infisical | 🟡 Medium |
| kiro-mcp | ❌ No (context_servers) | +6 servers | Local paths | 🟡 Medium |
| lmstudio-mcp | ✅ Yes (command → url) | +2 servers | HTTP only | 🟡 Medium |
| zed-settings | ✅ Yes (mcpServers → context_servers) | +4 servers | Local paths | 🔴 Critical |
| claude-desktop | ❌ No | +1 approach | Docker + hooks | 🟢 Low |

---

## Recommendations Priority

### 🔴 Critical (Breaking Issues)
1. Fix Claude Code schema: `allow/deny` → `allowedTools/deniedTools`
2. Fix Zed schema: `mcpServers` → `context_servers` with nested command structure

### 🟡 Medium (Feature Parity)
1. Add missing MCP servers to all templates
2. Add Infisical wrapper pattern with placeholders
3. Document platform-specific variations (GitHub Docker vs npx)

### 🟢 Low (Enhancements)
1. Add hooks to Claude Desktop template
2. Add Auth0 capabilities
3. Add cursor-cli-config and gemini-instructions templates

