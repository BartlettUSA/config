# CLAUDE.md

Project instructions for Claude Code.

See @README for project overview.

---

## Project Overview

Portable IDE and tool configurations for cross-machine consistency. Includes configurations for Claude, Cursor, Continue, and other AI development tools.

- **Type**: Configuration Repository
- **Managed By**: Manual + Chezmoi hybrid
- **Purpose**: Cross-platform config distribution

**Key Directories:**

- `claude/` — Claude Desktop configurations
- `claude-code/` — Claude Code configurations
- `cursor/` — Cursor IDE configurations
- `continue/` — Continue plugin configurations
- `installer/` — Path-agnostic install package

---

## Commands

| Command | Purpose |
|---------|---------|
| `.\installer\install.ps1` | Install configs (Windows) |
| `./installer/install.sh` | Install configs (Linux/macOS) |
| `.\installer\install.ps1 -DryRun` | Preview changes |
| `chezmoi apply --force` | Apply via Chezmoi |

---

## Project Structure

```text
Config/
├── claude/              # Claude Desktop config
├── claude-code/         # Claude Code config
├── claude-desktop/      # Claude Desktop legacy
├── continue/            # Continue plugin
├── cursor/              # Cursor IDE
├── docker-gordon-profiles/ # Docker Gordon AI profiles
├── installer/           # Cross-platform installer
│   ├── install.ps1      # Windows installer
│   ├── install.sh       # Linux/macOS installer
│   ├── config.json      # Platform mappings
│   ├── templates/       # Config templates
│   ├── lib/             # Platform detection
│   └── hooks/           # Install hooks
├── _development/        # Development planning
├── CLAUDE.md            # This file
└── README.md            # Project overview
```

---

## Boundaries

### Always

- Test configs on target platforms before committing
- Keep installer path-agnostic
- Document platform-specific behavior

### Ask First

- Adding new platform configurations
- Changing installer behavior
- Modifying Chezmoi templates

### Never

- Commit secrets or API keys (use Infisical/env vars)
- Hardcode user-specific paths
- Break cross-platform compatibility

---

## Write Permissions

| Path Pattern | Access | Purpose |
|--------------|--------|---------|
| `_development/_drafts/` | read-write | AI working directory |
| `_development/` | read | Development planning |
| `*/` configs | ask-to-write | Configuration files |
| `installer/` | ask-to-write | Installer scripts |

---

## Change Log

- 2026-01-10: Initial CLAUDE.md from Templates
