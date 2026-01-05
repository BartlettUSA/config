---
description: Root-cause analysis + minimal fix + tests
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
argument-hint: <error message or symptom>
---

# /debug — Root-cause analysis + minimal fix

You are running the /debug workflow.

## Inputs
Use $ARGUMENTS as the failing symptom: stack trace, failing test output, log excerpt, or repro steps.

## Hard constraints
- Do not propose broad refactors.
- Prefer the smallest fix that addresses root cause.
- Add/adjust tests to prevent regression.

## Documentation freshness
If the bug involves a third-party library, use context7 to fetch current docs.

## Process
1. Triage: classify failure type (test, runtime, build, CI, typecheck).
2. Identify the failing component and the call path that produces the symptom.
3. Reconstruct the most likely root cause from the code, not guesses.
4. Propose 1-2 minimal fixes and recommend one.
5. Implement the fix and add/update tests.
6. Provide a verification checklist.

## Output format
### Summary (2-4 sentences)
### Root cause
### Fix (what/where)
### Tests added/updated
### How to verify
