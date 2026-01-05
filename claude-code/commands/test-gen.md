---
description: Generate/upgrade tests for recent changes
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
argument-hint: [files to test]
---

# /test-gen — Generate tests for changes

You are running the /test-gen workflow.

## Inputs
Use the current diff and/or $ARGUMENTS as the system under test.

## Hard constraints
- Match the repo's existing test framework, patterns, and naming.
- Prefer deterministic tests; avoid sleeps and timing dependence.
- Cover: success path, failure path, boundaries, and regression.

## Documentation freshness
If testing library APIs or mocking external services, use context7 to verify patterns.

## Process
1. Identify changed behaviors and implicit contracts.
2. Add/extend tests to cover those behaviors.
3. Ensure tests are readable and minimal.
4. If test infrastructure is missing, propose (do not implement) unless approved.

## Output format
### Summary (2-4 sentences)
### Tests added/updated (files + what they cover)
### How to run
### Gaps / follow-ups
