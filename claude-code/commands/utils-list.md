---
description: List all available utilities in P:/dev/repos/Utilities
allowed-tools: Read, Grep, Glob, Bash
model: haiku
---

# /utils-list — Discover available utilities

You are running the /utils-list workflow.

## Purpose
Scan the Utilities repository and present all available scripts grouped by category.

## Repository location
`P:/dev/repos/Utilities`

## Hard constraints
- Do NOT edit files.
- Do NOT execute utilities, only list them.
- Extract descriptions from file headers, docstrings, or README files.

## Process
1. Scan `P:/dev/repos/Utilities` for all scripts (*.ps1, *.py, *.sh, *.bat, *.cmd)
2. Group by directory/category (e.g., cleanup/, deploy/, validation/, backup/)
3. Extract one-line description from each script:
   - PowerShell: Look for `.SYNOPSIS` or first `#` comment
   - Python: Look for module docstring or first `#` comment
   - Shell: Look for first `#` comment after shebang
4. If category READMEs exist, use them to describe the category

## Output format

### Utilities Index

**Total:** {count} utilities across {category_count} categories

#### {Category Name}
| Utility | Description | Type |
|---------|-------------|------|
| `script-name.ps1` | One-line description | PowerShell |
| `another.py` | One-line description | Python |

#### {Another Category}
...

### Usage
To search for a specific utility: `/utils-search <term>`
To check before creating a new script: `/utils-check <purpose>`

---

**Note:** If the repository is empty or a category has no scripts, indicate that clearly.
