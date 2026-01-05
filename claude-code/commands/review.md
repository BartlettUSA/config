---
description: Deep code review on current diff or selected files
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git log:*)
model: sonnet
argument-hint: [files or git ref]
---

# /review — Deep code review

You are running the /review workflow.

## Scope
Review the current diff (`git diff`). If no diff, review files specified in $ARGUMENTS.

## Review dimensions
- Correctness and edge cases
- API/contract integrity
- Error handling and observability
- Security and data handling
- Performance (hot paths, N+1, unnecessary allocations)
- Maintainability (naming, structure, duplication)
- Tests (coverage, brittleness, missing cases)

## Documentation freshness
If reviewing code that uses external APIs, use context7 to verify patterns.

## Output format
### Summary (2-4 sentences)
### Must-fix (file/line + exact fix suggestion)
### Should-fix
### Nice-to-have
### Test gaps
