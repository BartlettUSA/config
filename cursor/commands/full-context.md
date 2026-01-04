# /full-context — Build a working mental model of the repo

You are running the /full-context workflow.

## Hard constraints
- Do not edit files.
- Prefer a map that helps later commands find the right code quickly.

## Process
1. Scan project structure (package.json, pyproject.toml, go.mod, etc.)
2. Identify entry points and major modules
3. Map configuration surfaces (build, lint, test, CI)
4. Document runtime dependencies (DB, queues, external APIs)

## Output format
```
### Summary (2-4 sentences)
### Repo map
- Entry points
- Major modules/packages
- Config surfaces (build, lint, test, CI)
- Runtime services (DB, queues, external APIs)
### "Where to change X" index (common tasks)
```
