# Claude Code Slash Commands

Custom slash commands for [Claude Code](https://claude.ai/code) CLI.

## Installation

Copy or symlink to your home directory:

```powershell
# Option 1: Symlink (recommended - stays in sync)
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.claude\commands" -Target "P:\dev\config\claude-code\commands"

# Option 2: Copy
Copy-Item -Recurse "P:\dev\config\claude-code\commands" "$env:USERPROFILE\.claude\"
```

For project-specific commands, place in `.claude/commands/` within the project.

## Commands

| Command | Purpose | Model | MCP Integration |
|---------|---------|-------|-----------------|
| `/plan` | Spec-first implementation plan (no edits) | sonnet | context7 |
| `/implement` | Execute an approved plan | sonnet | context7 |
| `/debug` | Root-cause analysis + minimal fix | sonnet | context7 |
| `/review` | Deep code review | sonnet | context7 |
| `/test-gen` | Generate/upgrade tests | sonnet | context7 |
| `/update-docs` | Sync docs with code | sonnet | - |
| `/full-context` | Build repo mental model | sonnet | - |
| `/deep-review` | Pre-merge security/perf review | opus | context7 |
| `/pr-description` | Generate PR description | sonnet | - |
| `/research` | Deep research using MCP tools | sonnet | context7, web |

## Usage

```bash
# In Claude Code CLI
claude> /plan Add user authentication with JWT

claude> /debug TypeError: Cannot read property 'id' of undefined

claude> /review  # Reviews current git diff

claude> /research Next.js 14 App Router best practices
```

## Command Format

Claude Code commands use Markdown with YAML frontmatter:

```markdown
---
description: Brief description shown in /help
allowed-tools: Read, Write, Edit, Bash(git:*)
model: sonnet
argument-hint: <what user should provide>
---

# Command prompt content

Use $ARGUMENTS for user input.
Use @path/to/file for file references.
Use !`command` for inline bash execution.
```

## Frontmatter Options

| Field | Description |
|-------|-------------|
| `description` | Shown in `/help` and command palette |
| `allowed-tools` | Tools the command can use (overrides project settings) |
| `model` | `sonnet`, `opus`, or `haiku` |
| `argument-hint` | Placeholder shown to user |

## MCP Integration

Commands can invoke MCP tools by including phrases like:
- `use context7` - Fetches library documentation
- `use WebSearch` - Searches the web
- `use GitHub MCP` - Searches GitHub repos/issues

The AI interprets these and calls the appropriate MCP tools.

## Related

- [Cursor Commands](../cursor/README.md) - Same commands for Cursor IDE
- [Continue Commands](../continue/README.md) - JSON format for Continue extension
- [MCP Server Matrix](../../_dotfiles/MCP-SERVER-MATRIX.md) - Available MCP tools
