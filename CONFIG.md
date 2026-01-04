---
title: "Config"
date: 2024-12-29
type: ref
slug: config
status: active
tags:
  - config
  - ide
  - settings
---

# Config

IDE and tool configurations not managed by Chezmoi.

**Parent:** [P:\dev](../README.md)

---

## Purpose

- Store portable/version-controlled IDE configurations
- Centralize tool settings outside of AppData
- Enable consistent dev environment across machines

---

## Structure

```
config/
├── claude/           # Claude Code settings (copy from .claude/)
├── claude-desktop/   # Claude Desktop app config
├── cursor/           # Cursor IDE config
├── vscode/           # VS Code settings (copy from .vscode/)
├── vscode-portable/  # Portable VS Code installation
└── workspaces/       # VS Code workspace files
```

---

## Migration Status

The following are copies - originals remain at root until redirected:
- `.claude/` → `config/claude/`
- `.vscode/` → `config/vscode/`
- `_workspaces/` → `config/workspaces/`

After pointing apps to new locations, delete the originals.

---

## Guidelines

- Keep portable/version-controlled configs here
- Configs in AppData don't need to be duplicated here
- Use symlinks if apps require specific locations

---

## Security

> [!WARNING]
> IDE configs may contain API keys, tokens, or sensitive settings.

- [ ] Review configs before committing to version control
- [ ] Use environment variables for secrets instead of hardcoding
- [ ] Check for MCP server credentials in Claude configs
- [ ] Audit extension settings for sensitive data

---

## Related

- [_dotfiles/DOTFILES.md](../_dotfiles/DOTFILES.md) — Chezmoi-managed configs
- [_workspaces/WORKSPACES.md](../_workspaces/WORKSPACES.md) — IDE workspace files
- [templates/ai-development/platforms/](../templates/ai-development/platforms/) — AI platform config templates
