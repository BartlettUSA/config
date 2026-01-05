---
description: Spec-first implementation plan (no edits)
allowed-tools: Read, Grep, Glob, Task
model: sonnet
argument-hint: <task description>
---

# /plan — Spec-first implementation plan

You are running the /plan workflow.

## Inputs
Use $ARGUMENTS as the TASK (feature/bug request).

## Hard constraints
- Do NOT edit files.
- If requirements are ambiguous, ask exactly 1 clarifying question; otherwise proceed with explicit assumptions.
- Optimize for minimal change set and lowest risk.

## Documentation freshness
If the TASK involves external libraries or APIs, use context7 to fetch current docs.

## Process
1. Restate TASK in one sentence.
2. Identify relevant areas of the repo (files/modules) and why.
3. Produce an implementation plan with discrete steps.
4. Produce a file edit list (exact paths) and what will change in each.
5. Identify risks/edge cases and how you'll test them.
6. Define acceptance criteria.

## Output format
### Summary (2-4 sentences)
### Assumptions
### Plan (numbered)
### Files to change (with purpose)
### Tests to add/update
### Risks / edge cases
### Acceptance criteria
