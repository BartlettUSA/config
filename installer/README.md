# AI Platform Config Installer

**Version:** 1.0.0
**Purpose:** Path-agnostic deployment of AI platform configurations across any machine.

---

## Quick Start

### Windows (PowerShell)

```powershell
# From installer directory
.\install.ps1

# Or with custom paths
.\install.ps1 -SourceRoot "D:\my\dotfiles" -DryRun
```

### Linux/macOS (Bash)

```bash
# From installer directory
./install.sh

# Or with custom paths
./install.sh --source-root /path/to/dotfiles --dry-run
```

---

## What It Does

1. **Detects platform** (Windows/Linux/macOS)
2. **Resolves paths** dynamically (no hardcoded paths)
3. **Deploys configs** to correct locations per platform
4. **Manages secrets** via environment variables or Infisical
5. **Creates symlinks** where needed
6. **Validates** deployment success

---

## Directory Structure

```
installer/
├── README.md              # This file
├── install.ps1            # Windows installer
├── install.sh             # Linux/macOS installer
├── config.json            # Platform mappings & settings
├── lib/
│   ├── detect-platform.ps1
│   ├── detect-platform.sh
│   ├── resolve-paths.ps1
│   ├── resolve-paths.sh
│   └── validate.ps1
├── templates/
│   ├── claude/
│   ├── cursor/
│   ├── vscode/
│   └── ... (all platforms)
└── hooks/
    ├── pre-install.ps1
    ├── post-install.ps1
    └── rollback.ps1
```

---

## Configuration

Edit `config.json` to customize:

- Platform-specific paths
- Which configs to deploy
- Secret sources (env vars, Infisical, manual)
- Symlink vs copy behavior

---

## Supported Platforms

| AI Platform | Windows | Linux | macOS |
|-------------|---------|-------|-------|
| Claude Code | ✅ | ✅ | ✅ |
| Claude Desktop | ✅ | ❌ | ✅ |
| Cursor | ✅ | ✅ | ✅ |
| Windsurf | ✅ | ✅ | ✅ |
| VS Code | ✅ | ✅ | ✅ |
| Codex | ✅ | ✅ | ✅ |
| Gemini CLI | ✅ | ✅ | ✅ |
| Cline | ✅ | ✅ | ✅ |
| Continue | ✅ | ✅ | ✅ |
| Kiro | ✅ | ✅ | ✅ |
| LM Studio | ✅ | ✅ | ✅ |
| Zed | ✅ | ✅ | ✅ |

---

## Requirements

- **Windows:** PowerShell 5.1+ (or PowerShell Core 7+)
- **Linux/macOS:** Bash 4+, jq (optional, for JSON parsing)
- **Optional:** Node.js 18+ (for MCP servers), Docker (for MCP Gateway)
