# Safe Merge Procedure: C:\Users\lance → P:\dev\repos\Config

Generated: 2026-01-06

## Overview
This procedure updates P:\dev\repos\Config templates to match the working C:\Users\lance runtime configs.

**Direction**: C-drive (source of truth) → P-drive (portable templates)  
**Safety**: No C-drive files will be modified  
**Reversibility**: Git version control + pre-merge snapshot

---

## Prerequisites

### 1. Verify Current State
```powershell
# Confirm manifest exists and is recent
Get-Item P:\dev\repos\Config\config-manifest.json

# Review the recommendations
Get-Content P:\dev\repos\Config\update-recommendations.md | more
```

### 2. Create Safety Snapshot
```powershell
# Navigate to P:\dev\repos\Config
cd P:\dev\repos\Config

# Verify Git status
git status

# Create a pre-merge branch
git checkout -b "pre-merge-snapshot-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

# Commit current state
git add -A
git commit -m "Pre-merge snapshot: templates before runtime sync"

# Return to main branch
git checkout main

# Create merge work branch
git checkout -b "sync-runtime-configs-$(Get-Date -Format 'yyyyMMdd')"
```

---

## Phase 1: Fill Template Gaps (New Files)

### 1.1 Add Cursor CLI Config
```powershell
# Copy from runtime to template location
Copy-Item `
  -LiteralPath "$env:USERPROFILE\.cursor\cli-config.json" `
  -Destination "P:\dev\repos\Config\installer\templates\cursor\cli-config.json" `
  -Force

# Verify
Get-FileHash -Algorithm SHA256 "P:\dev\repos\Config\installer\templates\cursor\cli-config.json"
```

### 1.2 Add Gemini Instructions
```powershell
# Create directory if needed
New-Item -ItemType Directory -Force -Path "P:\dev\repos\Config\installer\templates\gemini"

# Copy from runtime
Copy-Item `
  -LiteralPath "$env:USERPROFILE\.gemini\instructions.md" `
  -Destination "P:\dev\repos\Config\installer\templates\gemini\instructions.md" `
  -Force

# Verify
Get-FileHash -Algorithm SHA256 "P:\dev\repos\Config\installer\templates\gemini\instructions.md"
```

---

## Phase 2: Update Existing Templates (Schema + Feature Parity)

### 2.1 Backup Current Templates
```powershell
# Create backup directory
$backupDir = "P:\dev\repos\Config\installer\templates-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
New-Item -ItemType Directory -Force -Path $backupDir

# Backup all current templates
Copy-Item -Recurse `
  "P:\dev\repos\Config\installer\templates\*" `
  $backupDir

Write-Host "Templates backed up to: $backupDir"
```

### 2.2 Update Templates from Runtime (RECOMMENDED: Manual with Placeholders)

For each template file identified in update-recommendations.md:
1. Open runtime file (C:\Users\lance\...)
2. Open template file (P:\dev\repos\Config\installer\templates\...)
3. Copy structure/content from runtime
4. Replace machine-specific values with placeholders:
   - Replace `"C:\\Users\\lance\\AppData\\Local"` → `"{{ENV:LOCALAPPDATA}}"`
   - Replace `"C:\\ProgramData"` → `"{{ENV:ProgramData}}"`
   - Replace `"C:\\Program Files"` → `"{{ENV:ProgramFiles}}"`
   - Replace Infisical project ID → `"{{INFISICAL_PROJECT_ID}}"`
   - Replace local paths → `"{{SKILLS_SERVER_PATH}}"`, etc.

**Critical Schema Fixes** (must be done manually):
- **Claude Code**: Change `permissions.allow/deny` → `permissions.allowedTools/deniedTools`
- **Zed**: Change `mcpServers` → `context_servers`, update nested structure

---

## Phase 3: Validation (Dry Run)

### 3.1 Re-run Manifest
```powershell
# Navigate to config directory
cd P:\dev\repos\Config

# Re-generate manifest to see new matches
# (Use the manifest generation script from earlier)
```

### 3.2 Validate Template Syntax
```powershell
# Test JSON validity for all JSON templates
Get-ChildItem -Recurse -Filter "*.json" "P:\dev\repos\Config\installer\templates" | ForEach-Object {
  try {
    $content = Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json
    Write-Host "✓ Valid JSON: $($_.Name)" -ForegroundColor Green
  } catch {
    Write-Host "✗ Invalid JSON: $($_.Name)" -ForegroundColor Red
    Write-Host $_.Exception.Message
  }
}
```

### 3.3 Verify Placeholder Patterns
```powershell
# Check that no hardcoded paths remain
Get-ChildItem -Recurse -Filter "*.json" "P:\dev\repos\Config\installer\templates" | ForEach-Object {
  $content = Get-Content -Raw -LiteralPath $_.FullName
  if ($content -match 'C:\\Users\\lance') {
    Write-Host "⚠ Hardcoded user path in: $($_.Name)" -ForegroundColor Yellow
  }
  if ($content -match 'projectId=3d1ecf69') {
    Write-Host "⚠ Hardcoded Infisical project ID in: $($_.Name)" -ForegroundColor Yellow
  }
}
```

---

## Phase 4: Documentation Updates

### 4.1 Update installer/config.json
Edit `P:\dev\repos\Config\installer\config.json` to add entries for:
- cursor-cli-config
- gemini-instructions

### 4.2 Update README Files
Update `P:\dev\repos\Config\README.md`:
- Reference manifest/diff/mapping reports
- Update migration status table
- Note schema alignment status

Update `P:\dev\repos\Config\installer\README.md`:
- Document placeholder patterns
- Add schema compatibility notes

---

## Phase 5: Commit and Review

### 5.1 Review All Changes
```powershell
cd P:\dev\repos\Config
git status
git diff
```

### 5.2 Commit to Work Branch
```powershell
git add -A
git commit -m "Sync templates with runtime configs

- Add missing templates: cursor-cli-config, gemini-instructions
- Update MCP server coverage (auth0, figma, ms-learn-docs, etc.)
- Fix schema: Claude Code (allowedTools), Zed (context_servers)
- Preserve portability with placeholders (ENV, SECRET)
- Add validation reports: manifest, diff, mapping, recommendations

Guardrail: No C-drive runtime configs were modified."
```

---

## Rollback Procedure

If issues are discovered:

### Quick Rollback (Git)
```powershell
cd P:\dev\repos\Config
git checkout main
git branch -D sync-runtime-configs-YYYYMMDD
```

### Full Restore from Backup
```powershell
# Restore templates from backup
$backupDir = "P:\dev\repos\Config\installer\templates-backup-YYYYMMDD-HHMMSS"
Remove-Item -Recurse -Force "P:\dev\repos\Config\installer\templates"
Copy-Item -Recurse $backupDir "P:\dev\repos\Config\installer\templates"
```

---

## Post-Merge Validation Checklist

- [ ] All template JSON files are valid syntax
- [ ] No hardcoded C:\Users\lance paths in templates
- [ ] Infisical project IDs use placeholders
- [ ] Claude Code uses allowedTools/deniedTools schema
- [ ] Zed uses context_servers schema
- [ ] cursor-cli-config template exists
- [ ] gemini-instructions template exists
- [ ] Git commit created on work branch
- [ ] Backup directory preserved
- [ ] Manifest shows expected template coverage
- [ ] README files updated
- [ ] installer/config.json updated

---

## Success Criteria

After merge completion:
1. **Template coverage**: All runtime files have corresponding templates (or documented exceptions)
2. **Schema compatibility**: Templates use same schema as runtime platforms
3. **Portability**: Templates use placeholders, not hardcoded machine-specific values
4. **C-drive unchanged**: Runtime configs remain untouched and functional
5. **Git history**: Clear commit showing what was synced and why

