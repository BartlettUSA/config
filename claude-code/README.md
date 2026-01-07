# Claude Code Slash Commands

Custom slash commands for [Claude Code](https://claude.ai/code) CLI.

**Commands:** 37 | **Format:** Markdown + YAML frontmatter

## Installation

```powershell
# Option 1: Symlink (recommended - stays in sync)
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.claude\commands" -Target "P:\dev\repos\Config\claude-code\commands"

# Option 2: Copy
Copy-Item -Recurse "P:\dev\repos\Config\claude-code\commands" "$env:USERPROFILE\.claude\"
```

For project-specific commands, place in `.claude/commands/` within the project.

## Commands

### Core Workflows
| Command | Purpose | Model |
|---------|---------|-------|
| `/plan` | Spec-first implementation plan (no edits) | sonnet |
| `/implement` | Execute an approved plan | sonnet |
| `/debug` | Root-cause analysis + minimal fix | sonnet |
| `/review` | Deep code review | sonnet |
| `/refactor` | Restructure code preserving behavior | sonnet |
| `/test-gen` | Generate/upgrade tests | sonnet |
| `/update-docs` | Sync docs with code | sonnet |

### Git & Workflow
| Command | Purpose | Model |
|---------|---------|-------|
| `/commit` | Conventional commit with semantic message | haiku |
| `/create-pr` | Full PR workflow (branch, commit, submit) | sonnet |
| `/fix-github-issue` | Analyze and fix GitHub issue with tests | sonnet |
| `/git-workflow` | Manage branching, merges, and sync | sonnet |

### Security
| Command | Purpose | Model |
|---------|---------|-------|
| `/security-scan` | OWASP vulnerability assessment | sonnet |
| `/deps-audit` | Dependency security and license check | sonnet |
| `/compliance-check` | Regulatory compliance (GDPR, HIPAA, SOC2, PCI) | sonnet |
| `/check` | Comprehensive code quality check | sonnet |

### Testing
| Command | Purpose | Model |
|---------|---------|-------|
| `/tdd` | Test-driven development workflow | sonnet |
| `/tdd-cycle` | Full red-green-refactor cycle | sonnet |
| `/test-harness` | Generate comprehensive test suite | sonnet |

### DevOps
| Command | Purpose | Model |
|---------|---------|-------|
| `/deploy-checklist` | Pre-deployment verification | sonnet |
| `/docker-optimize` | Container optimization | sonnet |
| `/k8s-manifest` | Kubernetes manifest generation | sonnet |
| `/release` | Version bump, changelog, and release | sonnet |

### Context Management
| Command | Purpose | Model |
|---------|---------|-------|
| `/context-prime` | Prime Claude with project understanding | sonnet |
| `/context-save` | Persist project state and decisions | sonnet |
| `/context-restore` | Restore saved project state | sonnet |
| `/doc-generate` | Generate API docs, JSDoc, TypeDoc | sonnet |

### Advanced
| Command | Purpose | Model |
|---------|---------|-------|
| `/full-context` | Build repo mental model | sonnet |
| `/full-review` | Multi-perspective code review | sonnet |
| `/smart-fix` | Dynamic problem-solving | sonnet |
| `/incident-response` | Production issue resolution | sonnet |
| `/tech-debt` | Technical debt assessment | sonnet |
| `/deep-review` | Pre-merge security/perf review | opus |
| `/arch-explain` | Architecture overview | sonnet |
| `/summarize` | Condense files/issues | sonnet |
| `/write-spec` | Turn description into tech spec | sonnet |
| `/pr-description` | Generate PR description | sonnet |
| `/research` | Deep research using MCP tools | sonnet |

## Usage

```bash
# In Claude Code CLI
claude> /plan Add user authentication with JWT
claude> /commit
claude> /security-scan --full
claude> /tdd implement rate limiting
claude> /debug TypeError: Cannot read property 'id' of undefined
```

## Command Format

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
```

## MCP Integration

Commands can invoke MCP tools by including phrases like:
- `use context7` - Fetches library documentation
- `use WebSearch` - Searches the web
- `use GitHub MCP` - Searches GitHub repos/issues

## Related

- [Cursor Commands](../cursor/README.md) - Same commands for Cursor IDE
- [Continue Commands](../continue/README.md) - JSON format for Continue extension
- [MCP Server Matrix](../../Dotfiles/MCP-SERVER-MATRIX.md) - Available MCP tools
