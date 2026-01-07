---
description: Check if a utility exists before creating a new script
allowed-tools: Read, Grep, Glob, Bash
model: haiku
argument-hint: <intended script purpose>
---

# /utils-check — Check before creating a new script

You are running the /utils-check workflow.

## Inputs
Use $ARGUMENTS as the PURPOSE (description of what the new script would do).

## Repository location
`P:/dev/repos/Utilities`

## Purpose
**Are you about to create a script?** Let me check if a similar utility already exists in the shared Utilities repository first.

This prevents:
- Duplicate scripts across projects
- Reinventing existing solutions
- Inconsistent implementations of common tasks

## Hard constraints
- Do NOT edit files.
- Do NOT create new utilities (only check for existing ones).
- Be thorough — search by purpose, keywords, and related terms.

## Process
1. Parse the PURPOSE into keywords and concepts
2. Search the Utilities repository for:
   - Scripts with similar names
   - Scripts with similar descriptions/synopses
   - Scripts that perform related functions
3. Also check common patterns:
   - cleanup/clear/purge → cleanup utilities
   - deploy/publish/release → deployment scripts
   - validate/check/verify → validation tools
   - backup/snapshot/export → backup utilities
   - convert/transform/migrate → transformation scripts
4. Report findings with confidence levels

## Output format

### Pre-Creation Check: "{PURPOSE}"

#### Existing Utilities Found

**High Match:**
- `utilities/cleanup/clear-temp-files.ps1` — Clears temporary files from common locations
  - **Why it matches:** {explanation}
  - **Consider using this instead**

**Partial Match:**
- `utilities/validation/check-config.py` — Validates configuration files
  - **Why it matches:** {explanation}
  - **Could be extended for your use case**

#### Recommendation

One of:
1. **Use existing utility:** `path/to/script.ext` does what you need
2. **Extend existing:** `path/to/script.ext` could be modified to cover your case
3. **Create new utility:** No existing utility covers this; proceed with creation in `P:/dev/repos/Utilities/{suggested-category}/`

#### If Creating New

Suggested location: `P:/dev/repos/Utilities/{category}/{suggested-name}.{ext}`
Suggested template:
```powershell
<#
.SYNOPSIS
    {One-line description}
.DESCRIPTION
    {Detailed description}
.PARAMETER Param1
    {Parameter description}
.EXAMPLE
    ./script.ps1 -Param1 value
.NOTES
    Author: {author}
    Created: {date}
#>
```

---

### No matches
If no related utilities exist, I'll confirm:
- "No existing utilities match your purpose"
- Suggest the best category and naming convention
- Provide a starter template
