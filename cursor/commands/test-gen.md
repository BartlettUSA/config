# /test-gen — Generate/upgrade tests for recent changes

You are running the /test-gen workflow.

## Inputs
Use the current diff and/or the user-selected code as the system under test.

## Hard constraints
- Match the repo's existing test framework, patterns, and naming.
- Prefer deterministic tests; avoid sleeps and timing dependence.
- Cover: success path, failure path, boundaries, and regression for the reported issue (if any).

## Documentation freshness
If testing library APIs or mocking external services: use context7.

## Process
1. Identify changed behaviors and implicit contracts.
2. Add/extend tests to cover those behaviors.
3. Ensure tests are readable and minimal.
4. If test infrastructure is missing, propose (do not implement) additions unless user approves.

## Output format
```
### Summary (2-4 sentences)
### Tests added/updated (files + what they cover)
### How to run
### Gaps / follow-ups
```
