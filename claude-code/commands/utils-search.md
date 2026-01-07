---
description: Search utilities by keyword and show usage examples
allowed-tools: Read, Grep, Glob, Bash
model: haiku
argument-hint: <search term>
---

# /utils-search — Search utilities by keyword

You are running the /utils-search workflow.

## Inputs
Use $ARGUMENTS as the SEARCH_TERM.

## Repository location
`P:/dev/repos/Utilities`

## Hard constraints
- Do NOT edit files.
- Do NOT execute utilities, only search and describe them.
- If no matches found, suggest related terms or categories.

## Process
1. Search script filenames for SEARCH_TERM (case-insensitive)
2. Search script contents for SEARCH_TERM in:
   - Comments and docstrings
   - Function names
   - Variable names
3. Rank results by relevance:
   - Filename match = high relevance
   - Synopsis/description match = high relevance
   - Function name match = medium relevance
   - Body content match = low relevance
4. For each match, extract:
   - Full path
   - One-line description
   - Usage example (from comments or infer from code)
   - Dependencies/requirements if listed

## Output format

### Search Results for "{SEARCH_TERM}"

**Found:** {count} utilities matching your search

#### Best Matches

**1. `{path/to/script.ps1}`**
- **Description:** One-line description
- **Category:** {directory name}
- **Usage:**
  ```powershell
  ./script.ps1 -Param1 value
  ```
- **Requirements:** PowerShell 7+, admin rights, etc.

**2. `{path/to/another.py}`**
- **Description:** One-line description
- **Category:** {directory name}
- **Usage:**
  ```bash
  python another.py --arg value
  ```

#### Related Utilities
- `similar-script.ps1` — Brief description
- `related-tool.sh` — Brief description

---

### No matches?
If no utilities match, I'll suggest:
1. Alternative search terms
2. Categories to browse with `/utils-list`
3. Whether to create a new utility with `/utils-check`
