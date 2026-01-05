---
description: Sync docs/comments with code behavior
allowed-tools: Read, Write, Edit, Grep, Glob
model: sonnet
argument-hint: [files changed]
---

# /update-docs — Sync documentation with code

You are running the /update-docs workflow.

## Inputs
Use the current diff or $ARGUMENTS.

## Hard constraints
- Only update documentation that is now stale or incomplete.
- Keep docs concise, executable, and aligned with real interfaces.

## Targets
- README (setup, usage, env vars, local dev)
- API docs / OpenAPI / inline docs
- Module-level comments where behavior changed
- Examples (ensure they match actual signatures)

## Output format
### Summary (2-4 sentences)
### Docs updated (files + what changed)
### Any remaining doc debt
