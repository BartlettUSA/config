# Continue Extension Commands

Slash commands for the [Continue](https://continue.dev) VS Code/JetBrains extension.

**Commands:** 30 | **Format:** JSON

## Installation

Merge commands into your Continue config:

```powershell
# Location: ~/.continue/config.json
# Add the slashCommands array from slash-commands.json
```

Or copy the entire file:
```powershell
Copy-Item "P:\dev\repos\Config\continue\slash-commands.json" "$env:USERPROFILE\.continue\config.json"
```

## Commands

### Core Workflows
| Command | Purpose |
|---------|---------|
| `/plan` | Spec-first implementation plan (no edits) |
| `/implement` | Execute an approved plan |
| `/debug` | Root-cause analysis + minimal fix |
| `/review` | Deep code review |
| `/refactor` | Restructure code preserving behavior |
| `/test-gen` | Generate tests for changes |
| `/docs` | Sync documentation with code |

### Git & Workflow
| Command | Purpose |
|---------|---------|
| `/commit` | Conventional commit with semantic message |
| `/create-pr` | Full PR workflow |
| `/fix-github-issue` | Analyze and fix GitHub issue |
| `/git-workflow` | Branching and merge guidance |

### Security
| Command | Purpose |
|---------|---------|
| `/security-scan` | OWASP vulnerability assessment |
| `/deps-audit` | Dependency security check |
| `/compliance-check` | Regulatory compliance |
| `/check` | Code quality check |

### Testing
| Command | Purpose |
|---------|---------|
| `/tdd` | Test-driven development |
| `/tdd-cycle` | Red-green-refactor cycle |
| `/test-harness` | Generate test suite |

### DevOps
| Command | Purpose |
|---------|---------|
| `/deploy-checklist` | Pre-deployment verification |
| `/docker-optimize` | Container optimization |
| `/k8s-manifest` | Kubernetes manifests |
| `/release` | Version and changelog |

### Context & Advanced
| Command | Purpose |
|---------|---------|
| `/context-prime` | Project understanding |
| `/context-save` | Persist state |
| `/context-restore` | Restore state |
| `/doc-generate` | Generate docs |
| `/full-review` | Multi-perspective review |
| `/smart-fix` | Dynamic problem-solving |
| `/tech-debt` | Debt assessment |

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

## Related

- [Claude Code Commands](../claude-code/README.md) - Markdown format
- [Cursor Commands](../cursor/README.md) - Markdown format
