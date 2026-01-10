# Contributing Guidelines

Thank you for considering contributing! This document provides guidelines and instructions for contributing.

---

## Quick Start

### 1. Fork and Clone

```bash
git clone https://github.com/BartlettUSA/repo-name.git
cd repo-name
git remote add upstream https://github.com/BartlettUSA/repo-name.git
```

### 2. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/issue-number-description
```

### 3. Make Changes

- Follow existing code style and patterns
- Write tests for new features
- Update documentation as needed

### 4. Commit

```bash
git add .
git commit -m "feat: add new feature"
```

### 5. Push and Create PR

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub.

---

## Commit Messages

We use [Conventional Commits](https://www.conventionalcommits.org/):

| Type | Purpose |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Code style (formatting) |
| `refactor` | Code refactoring |
| `test` | Adding or updating tests |
| `chore` | Maintenance tasks |

**Examples:**
```bash
git commit -m "feat(auth): add OAuth2 support"
git commit -m "fix(api): handle null response"
git commit -m "docs(readme): update installation steps"
```

---

## Pull Request Process

### Before Creating PR

- [ ] Code follows project style guidelines
- [ ] Tests pass locally
- [ ] Documentation updated if needed
- [ ] Commits follow conventional format
- [ ] Branch is up to date with main

### PR Requirements

1. **Automated Checks** — CI/CD must pass
2. **Code Review** — At least one approval required
3. **Address Feedback** — Make requested changes
4. **Squash & Merge** — Maintainer merges when ready

---

## Code Style

### General Principles

- Write clear, readable code
- Keep functions small and focused
- Test your changes
- Document public APIs

### Language-Specific

**Python:**
- Follow PEP 8
- Use type hints
- Format with `black`, lint with `ruff`

**TypeScript/JavaScript:**
- Use TypeScript for new code
- Format with Prettier, lint with ESLint

---

## Security

For security vulnerabilities, see [SECURITY.md](SECURITY.md).

**Do NOT open public issues for security vulnerabilities.**

---

## Questions?

- **General:** GitHub Discussions
- **Security:** security@bartlettusa.com

---

**Thank you for contributing!**
