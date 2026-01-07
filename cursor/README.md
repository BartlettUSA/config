# Cursor IDE Configuration

Portable Cursor slash commands and rules for cross-project consistency.

**Commands:** 38 | **Format:** Markdown

## Installation

```powershell
# Option 1: Symlink (recommended - stays in sync)
New-Item -ItemType SymbolicLink -Path ".cursor\commands" -Target "P:\dev\repos\Config\cursor\commands"
New-Item -ItemType SymbolicLink -Path ".cursor\rules" -Target "P:\dev\repos\Config\cursor\rules"

# Option 2: Copy (one-time)
Copy-Item -Recurse "P:\dev\repos\Config\cursor\commands" ".cursor\"
Copy-Item -Recurse "P:\dev\repos\Config\cursor\rules" ".cursor\"
```

Or for user-level (all projects):
```powershell
Copy-Item -Recurse "P:\dev\repos\Config\cursor\commands" "$env:USERPROFILE\.cursor\"
```

## Commands

### Core Workflows
| Command | Purpose |
|---------|---------|
| `/plan` | Spec-first implementation plan (no edits) |
| `/implement` | Execute approved plan |
| `/debug` | Root-cause analysis + minimal fix |
| `/review` | Deep code review |
| `/refactor` | Restructure code preserving behavior |
| `/test-gen` | Generate/upgrade tests |
| `/update-docs` | Sync docs with code |

### Git & Workflow
| Command | Purpose |
|---------|---------|
| `/commit` | Conventional commit with semantic message |
| `/create-pr` | Full PR workflow (branch, commit, submit) |
| `/fix-github-issue` | Analyze and fix GitHub issue with tests |
| `/git-workflow` | Manage branching, merges, and sync |

### Security
| Command | Purpose |
|---------|---------|
| `/security-scan` | OWASP vulnerability assessment |
| `/deps-audit` | Dependency security and license check |
| `/compliance-check` | Regulatory compliance (GDPR, HIPAA, SOC2, PCI) |
| `/check` | Comprehensive code quality check |

### Testing
| Command | Purpose |
|---------|---------|
| `/tdd` | Test-driven development workflow |
| `/tdd-cycle` | Full red-green-refactor cycle |
| `/test-harness` | Generate comprehensive test suite |

### DevOps
| Command | Purpose |
|---------|---------|
| `/deploy-checklist` | Pre-deployment verification |
| `/docker-optimize` | Container optimization |
| `/k8s-manifest` | Kubernetes manifest generation |
| `/release` | Version bump, changelog, and release |

### Context Management
| Command | Purpose |
|---------|---------|
| `/context-prime` | Prime Claude with project understanding |
| `/context-save` | Persist project state and decisions |
| `/context-restore` | Restore saved project state |
| `/doc-generate` | Generate API docs, JSDoc, TypeDoc |

### Advanced
| Command | Purpose |
|---------|---------|
| `/full-context` | Build repo mental model |
| `/full-review` | Multi-perspective code review |
| `/smart-fix` | Dynamic problem-solving |
| `/incident-response` | Production issue resolution |
| `/tech-debt` | Technical debt assessment |
| `/deep-review` | Pre-merge security/perf review |
| `/arch-explain` | Architecture overview |
| `/summarize` | Condense files/issues |
| `/write-spec` | Turn description into tech spec |
| `/pr-description` | Generate PR description |
| `/browser-test` | Automated browser testing |
| `/research` | Deep research on topics |

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

- [MCP Server Matrix](../../Dotfiles/MCP-SERVER-MATRIX.md) - Full MCP inventory
- [Cursor MCP Config](../../Dotfiles/dot_cursor/mcp.json.tmpl) - Chezmoi template
