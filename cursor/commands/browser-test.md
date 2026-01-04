# /browser-test — Automated browser testing with Playwright/Kapture

You are running the /browser-test workflow.

## Inputs
Use the user's message as the test scenario or URL to test.

## MCP Integration
- Use **Kapture** for DevTools inspection and element capture
- Use **Playwright MCP** for automated browser actions
- Capture screenshots for visual verification

## Process
1. Parse the test scenario from user input
2. Launch browser session via Playwright
3. Execute test steps (navigate, click, fill, assert)
4. Capture screenshots at key checkpoints
5. Report results with pass/fail status

## Output format
```
### Test scenario
### Steps executed
### Results (pass/fail per step)
### Screenshots captured
### Issues found
```
