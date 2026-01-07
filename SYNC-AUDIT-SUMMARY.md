# Config Sync Audit: Complete Summary

**Audit Date**: 2026-01-06  
**Status**: ✅ Complete  
**Direction**: C:\Users\lance (canonical runtime) → P:\dev\config (portable templates)

---

## Executive Summary

**Finding**: `P:\dev\config` and `C:\Users\lance` are **NOT in sync**. All evaluated config pairs show hash differences.

**Root Cause**:
1. **Schema drift**: Templates use outdated schemas (Claude Code `allow/deny` vs runtime `allowedTools/deniedTools`, Zed `mcpServers` vs `context_servers`)
2. **Feature additions**: Runtime configs include 8-12 MCP servers; templates have 3-7
3. **Template gaps**: 2 runtime files have no corresponding templates (`cursor-cli-config`, `gemini-instructions`)
4. **Deployment approach**: Your working configs use Infisical + hardcoded paths; templates use placeholders

**Recommendation**: Update P:\dev\config templates to match runtime structure while preserving portability via placeholders.

---

## Deliverables Created

All reports saved to `P:\dev\config\`:

| File | Purpose |
|------|---------|
| `config-manifest.json` | SHA256 hashes + metadata for all runtime/template pairs |
| `semantic-diff-report.md` | Human-readable differences for each mismatched pair |
| `path-mapping-table.md` | Reference mapping (no symlink terminology) with portability categories |
| `update-recommendations.md` | Prioritized P-drive update checklist |
| `merge-procedure.md` | Safe, reversible merge procedure with validation |
| `SYNC-AUDIT-SUMMARY.md` | This summary document |

---

## Key Findings

### Sync Status: 0 of 15 files match
- **15 evaluated pairs**: 0 identical, 12 different (both exist), 2 missing templates, 1 missing runtime

### Schema Mismatches (Breaking)
- **Claude Code**: Template uses `permissions.allow/deny`, runtime uses `permissions.allowedTools/deniedTools`
- **Zed**: Template uses `mcpServers`, runtime uses `context_servers`

### Missing Templates
1. `installer/templates/cursor/cli-config.json` (runtime exists: 871 bytes)
2. `installer/templates/gemini/instructions.md` (runtime exists: 637 bytes)

### Missing Runtime
1. `C:\Users\lance\.continue\config.json` (template exists but not deployed)

### Feature Gaps (MCP Servers)
Runtime includes these servers not in templates:
- auth0
- figma (Infisical-wrapped)
- ms-learn-docs
- hugging-face
- skills (local server)
- obsidian (varies by platform)
- firecrawl (Infisical-wrapped)
- github (Infisical or Docker, varies by platform)

---

## Path Mapping Reference

**Portable (safe to deploy identically)**:
- `cursor/commands/` → `.cursor/commands/` (currently not deployed)
- `cursor/rules/` → `.cursor/rules/` (currently not deployed)
- `workspaces/*.code-workspace` → Open from P: or copy with path adjustments

**Machine-Specific (requires templating)**:
- All MCP configs (12 files)
- Claude Code settings
- Codex config
- Gemini settings
- Zed settings
- Claude Desktop config

**Vendor-Managed (do not version control)**:
- `.vscode/extensions/**` (installed binaries)
- `.cursor/extensions/**` (installed binaries)

---

## Recommended Actions (P-drive updates only)

### Must Fix (Breaking Issues)
1. ✅ **Identified**: Claude Code schema incompatibility
2. ✅ **Identified**: Zed schema incompatibility
3. 🔄 **Next**: Apply schema fixes per `update-recommendations.md`

### Should Add (Missing Coverage)
1. 🔄 **Next**: Copy `cursor-cli-config` from runtime to template
2. 🔄 **Next**: Copy `gemini-instructions` from runtime to template
3. 🔄 **Next**: Add missing MCP servers to all platform templates

### Documentation
1. 🔄 **Next**: Update `README.md` with audit findings
2. 🔄 **Next**: Update `installer/config.json` to include new templates
3. ✅ **Complete**: Validation reports created

---

## Guardrails Honored

✅ **No C-drive modifications**: All runtime configs in `C:\Users\lance` remain untouched  
✅ **No schema changes to runtime**: Recommendations only propose P-drive template updates  
✅ **Platform protection**: Claude/Cursor/Codex/ChatGPT working configs preserved  
✅ **Safety first**: Git branching + backups documented in merge procedure

---

## Next Steps

### Immediate (Safe to Execute)
1. Review all generated reports in `P:\dev\config\`
2. Follow `merge-procedure.md` Phase 1 (git snapshot)
3. Execute Phase 2 (fill template gaps: cursor-cli-config, gemini-instructions)

### Manual Work Required
1. Update templates to match runtime schemas (Claude Code, Zed)
2. Add missing MCP servers to templates with placeholder syntax
3. Update documentation files per recommendations
4. Run validation checks (JSON syntax, placeholder verification)

### Final Validation
1. Re-run manifest generation to confirm coverage
2. Test installer in dry-run mode
3. Commit to work branch with descriptive message

---

## Supporting Evidence

### Manifest Highlights
```
Name                  RuntimeExists TemplateExists Match
----                  ------------- -------------- -----
claude-settings                True           True False
cursor-mcp                     True           True False
cursor-cli-config              True          False   n/a
gemini-instructions            True          False   n/a
continue-config               False           True   n/a
[... all others: True/True/False ...]
```

### Hash Evidence (Example)
```
claude-settings:
  Runtime SHA256:  6740FBE673CB5E69B45D3F97776172E23F83C938389DB7A4547170B69BECE335
  Template SHA256: 9654E6D916CFB7447352E3642FEB03DFD74815A4E7C38AB76D1777D413FEF2F3
  Status: DIFFERENT (schema + feature differences)
```

---

## Questions for Follow-Up

1. **Template update strategy**: Manual edit with placeholders (recommended) or direct copy with post-processing?
2. **Continue deployment**: Should we deploy the Continue template to runtime, or keep it as future-use only?
3. **Cursor commands/rules**: Deploy globally to `.cursor/` or keep as per-project reference only?
4. **Documentation priority**: Which README updates are most critical for your workflow?

---

## Conclusion

The audit is complete with zero C-drive modifications. All runtime configs remain functional and protected. 

**`P:\dev\config` is now fully documented** with:
- Exact state capture (manifest with SHA256 hashes)
- Semantic difference analysis
- Path mapping reference
- Prioritized update recommendations
- Safe merge procedure with rollback plan

You can proceed with P-drive updates at your discretion using the provided procedures.

