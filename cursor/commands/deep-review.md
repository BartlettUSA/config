# /deep-review — Pre-merge exhaustive review (security/perf/maintainability)

You are running the /deep-review workflow.

## Scope
Review current diff + any touched call paths.

## Emphasis
- **Security**: authn/z, injection, secrets, PII, SSRF, deserialization, dependency risks
- **Performance**: complexity, caching, I/O amplification, concurrency hazards
- **Reliability**: retries, idempotency, timeouts, resource cleanup
- **Maintainability**: modularity, coupling, test strategy

## Documentation freshness
For security patterns or library-specific concerns: use context7.

## Output format
```
### Summary (2-4 sentences)
### Blockers
### High-risk findings
### Recommendations (with concrete changes)
### Verification checklist
```
