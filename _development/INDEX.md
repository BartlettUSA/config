---
title: "Development Index"
date: 2026-01-10
type: index
status: active
---

# Development Index

Navigation hub for all development planning documents, drafts, and workflow states.

> **AI Agents:** This folder contains working documents. Only `_drafts/` is writable.

---

## Folder Structure

```
_development/
├── INDEX.md       # This file
├── _drafts/       # Working documents (AI writable)
├── _active/       # Approved plans (executable)
└── _history/      # Completed plans (archive)
```

---

## Workflow States

| Folder | State | AI Access | Human Action Required |
|--------|-------|-----------|----------------------|
| `_drafts/` | Under Review | Read-Write | Review and approve/reject |
| `_active/` | Approved | Read-Only | Monitor execution |
| `_history/` | Completed | Read-Only | None (archive) |

---

## Naming Convention

**Pattern:** `_YY-MMDD-TYPE-Subject-Description.md`

**Types:** `PLAN`, `SPEC`, `RESEARCH`, `NOTES`, `DEBUG`, `REVIEW`

**Examples:**
- `_26-0110-PLAN-Feature-Implementation.md`
- `_26-0110-SPEC-API-Endpoints.md`
- `_26-0110-RESEARCH-Library-Comparison.md`

---

## Change Log

- 2026-01-10: Initial creation from Templates
