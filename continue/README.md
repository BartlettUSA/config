# Continue Extension Commands

Slash commands for the [Continue](https://continue.dev) VS Code/JetBrains extension.

## Installation

Merge commands into your Continue config:

```powershell
# Location: ~/.continue/config.json
# Add the slashCommands array from slash-commands.json
```

Or copy the entire file:
```powershell
Copy-Item "P:\dev\config\continue\slash-commands.json" "$env:USERPROFILE\.continue\config.json"
```

## Commands

| Command | Purpose |
|---------|---------|
| `/plan` | Spec-first implementation plan (no edits) |
| `/implement` | Execute an approved plan |
| `/debug` | Root-cause analysis + minimal fix |
| `/review` | Deep code review |
| `/test-gen` | Generate tests for changes |
| `/docs` | Sync documentation with code |

## Usage

In Continue chat, type `/` to see available commands:
```
/plan Add user authentication with OAuth
/debug TypeError: Cannot read property 'id' of undefined
/review @src/auth/login.ts
```

## Notes

- Continue uses `{{{ input }}}` for argument interpolation
- Commands are defined in JSON format in `config.json`
- No MCP integration (Continue has its own context system)
