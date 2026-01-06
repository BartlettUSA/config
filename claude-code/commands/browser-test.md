---
description: Automated browser testing with Playwright/Kapture
allowed-tools: Bash, Read, Write, mcp__kapture__*, mcp__playwright__*
model: sonnet
argument-hint: <test scenario or URL>
---

# /browser-test — Automated browser testing

You are running the /browser-test workflow.

## Inputs
- $ARGUMENTS: Test scenario description or URL to test

## Hard constraints
- Use Kapture MCP for DevTools inspection and element capture
- Use Playwright MCP for automated browser actions
- Capture screenshots at key checkpoints
- Report clear pass/fail status per step

## MCP tools
- **Kapture**: `mcp__kapture__screenshot`, `mcp__kapture__click`, `mcp__kapture__fill`, `mcp__kapture__elements`
- **Playwright**: Navigation, assertions, form interactions

## Process

### Phase 1: Setup
1. Parse the test scenario from $ARGUMENTS
2. Identify target URL and test steps
3. Launch browser session

### Phase 2: Execution
1. Navigate to target URL
2. Wait for page load
3. Execute test steps (click, fill, assert)
4. Capture screenshots at checkpoints

### Phase 3: Reporting
1. Compile results per step
2. Attach captured screenshots
3. Summarize pass/fail status

## Output format
```
### Test Scenario
[Description of what was tested]

### Steps Executed
| # | Action | Selector | Result |
|---|--------|----------|--------|
| 1 | Navigate | URL | ✅ Pass |
| 2 | Click | #login-btn | ✅ Pass |
| 3 | Fill | #email | ✅ Pass |
| 4 | Assert | .welcome | ❌ Fail |

### Screenshots
- [checkpoint_1.png] - After login
- [checkpoint_2.png] - Error state

### Issues Found
- Element `.welcome` not found after 5s timeout

### Summary
3/4 steps passed (75%)
```
