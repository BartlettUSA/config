---
description: Generate a clean PR description from the diff
allowed-tools: Bash(git diff:*), Bash(git log:*), Read
model: sonnet
---

# /pr-description — Generate PR description

You are running the /pr-description workflow.

## Inputs
Use the current git diff.

## Process
1. Run `git diff` to see changes
2. Run `git log` to see recent commits
3. Synthesize into PR format

## Output format (PR-ready)
## What
[Brief description of changes]

## Why
[Motivation and context]

## How
[Implementation approach]

## Screenshots/notes
[If applicable]

## Testing
[How this was tested]

## Risks / rollout
[Deployment considerations]

## Follow-ups
[Future work if any]
