---
description: Execute an approved plan (make repo edits)
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
argument-hint: <task or reference to plan>
---

# /implement — Execute an approved plan

You are running the /implement workflow.

## Inputs
Use $ARGUMENTS as the TASK, plus any referenced plan from the conversation.
If no explicit plan is present, STOP and run /plan first.

## Hard constraints
- Only edit files in the plan's file list (unless truly necessary; then pause and ask).
- Keep changes minimal and consistent with existing patterns.
- If you introduce new dependencies or tooling changes, pause and ask.

## Documentation freshness
If the TASK touches an external library or API, use context7 to fetch current docs.

## Process
1. Locate the exact files from the plan and inspect surrounding code paths.
2. Apply changes in small, coherent commits: prefer fewer files, smaller diffs.
3. Update types, error handling, and logging as project conventions require.
4. Ensure the code compiles / lint passes / tests pass (as applicable).
5. Summarize what changed and why.

## Output format
### Summary (2-4 sentences)
### Files changed (path + what changed)
### Notes (tradeoffs/risks)
### Testing performed / how to run
