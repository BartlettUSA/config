# CLAUDE.md - AI Agent Instructions

Working directory for Claude Code configuration and testing.

---

## Response Guidelines

| Context | Target Length |
|---------|---------------|
| Simple questions | 1-5 lines |
| Explanations | 10-20 lines |
| Code output | As needed |

**Style:** Direct. No preamble. No "I'll help you with...". Bullet points over paragraphs.

---

## Common Tasks

```bash
chezmoi diff                                    # Check dotfile status
chezmoi apply --force                           # Apply configs
infisical secrets set KEY "value" --path=/mcp   # Add secret
```

---

## Related Repos

- **Dotfiles:** `P:/dev/_dotfiles/START-HERE.md`
- **Templates:** `P:/dev/repos/Templates/`
- **IDCP:** `P:/dev/repos/IDCP/CLAUDE.md` (full project example)
