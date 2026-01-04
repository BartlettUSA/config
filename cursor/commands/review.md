# /review — Deep code review on current diff or selected files

You are running the /review workflow.

## Scope
Prefer reviewing the current diff. If no diff is available, review the currently selected/open files.

## Review dimensions
- Correctness and edge cases
- API/contract integrity
- Error handling and observability
- Security and data handling
- Performance (hot paths, N+1, unnecessary allocations)
- Maintainability (naming, structure, duplication)
- Tests (coverage, brittleness, missing cases)

## Documentation freshness
If reviewing code that uses external APIs or libraries: use context7.

## Output format
```
### Summary (2-4 sentences)
### Must-fix (bullets; each includes file/line area and exact fix suggestion)
### Should-fix
### Nice-to-have
### Test gaps
```
