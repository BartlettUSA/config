# Cursor IDE Configuration

Portable Cursor slash commands and rules for cross-project consistency.

## Installation

Copy or symlink to your project's `.cursor/` directory:

```powershell
# Option 1: Symlink (recommended - stays in sync)
New-Item -ItemType SymbolicLink -Path ".cursor\commands" -Target "P:\dev\config\cursor\commands"
New-Item -ItemType SymbolicLink -Path ".cursor\rules" -Target "P:\dev\config\cursor\rules"

# Option 2: Copy (one-time)
Copy-Item -Recurse "P:\dev\config\cursor\commands" ".cursor\"
Copy-Item -Recurse "P:\dev\config\cursor\rules" ".cursor\"
```

Or for user-level (all projects):
```powershell
# Global Cursor config
Copy-Item -Recurse "P:\dev\config\cursor\commands" "$env:USERPROFILE\.cursor\"
```

## Commands

| Command | Purpose | MCP Integration |
|---------|---------|-----------------|
| `/plan` | Spec-first implementation plan (no edits) | Context7 |
| `/implement` | Execute approved plan | Context7 |
| `/debug` | Root-cause analysis + minimal fix | Context7 |
| `/review` | Deep code review | Context7 |
| `/test-gen` | Generate/upgrade tests | Context7 |
| `/update-docs` | Sync docs with code | - |
| `/full-context` | Build repo mental model | - |
| `/deep-review` | Pre-merge security/perf review | Context7 |
| `/pr-description` | Generate PR description | - |
| `/browser-test` | Automated browser testing | Kapture, Playwright |
| `/research` | Deep research on topics | Context7, Perplexity, GitHub |

## Rules

| Rule | Scope | Purpose |
|------|-------|---------|
| `context7-usage.mdc` | Code files | Context7 integration patterns |
| `plan-before-edit.mdc` | All files | Enforce planning for major changes |

## MCP Dependencies

These commands integrate with MCP servers configured in `~/.cursor/mcp.json`:

- **Context7** - Documentation lookup (`npx -y @upstash/context7-mcp`)
- **Kapture** - Browser DevTools (`npx -y kapture-mcp bridge`)
- **Playwright** - Browser automation (`npx -y @playwright/mcp@latest`)
- **GitHub** - Repo/issue search (`@modelcontextprotocol/server-github`)
- **Perplexity** - Web research (via Docker MCP Gateway)

## Workflow

```
User Request
    ↓
/plan (no edits, get approval)
    ↓
/implement (make changes)
    ↓
/review or /deep-review
    ↓
/test-gen (add tests)
    ↓
/pr-description (document)
```

## Related

- [MCP Server Matrix](../../_dotfiles/MCP-SERVER-MATRIX.md) - Full MCP inventory
- [Cursor MCP Config](../../_dotfiles/dot_cursor/mcp.json.tmpl) - Chezmoi template
