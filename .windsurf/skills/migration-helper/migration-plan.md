# Migration Plan Template

Copy and fill out this template when planning a migration.

---

## Migration: [FROM] → [TO]

**Date**: YYYY-MM-DD
**Risk Level**: Low / Medium / High
**Estimated Effort**: X hours

---

### Pre-Migration Checklist

- [ ] All tests passing on current version
- [ ] Working on a dedicated branch (`migration/<name>`)
- [ ] Reviewed official migration guide
- [ ] Identified all breaking changes that affect this codebase
- [ ] Notified team (if applicable)

### Dependency Changes

| Package | Current Version | Target Version | Notes |
|---------|----------------|----------------|-------|
| example | 1.2.3 | 2.0.0 | Major version bump |

### Code Changes

#### High Confidence (safe to auto-apply)
These are mechanical renames, import path changes, or simple API updates.

| File | Change | Reason |
|------|--------|--------|
| `src/foo.js` | Rename `oldAPI()` → `newAPI()` | Deprecated in v2 |

#### Needs Review (manual verification required)
These involve behavior changes, removed features, or ambiguous migrations.

| File | Change | Reason |
|------|--------|--------|
| `src/bar.js` | Rewrite callback to async/await | API no longer supports callbacks |

### Post-Migration Verification

- [ ] All existing tests pass
- [ ] No deprecated pattern matches remain (re-run scan)
- [ ] Manual smoke test of key user flows
- [ ] Performance check (no regressions)
- [ ] Build succeeds with no warnings related to the migration

### Rollback Plan

If issues are found after migration:
1. `git revert` the migration branch merge
2. Pin the old dependency version
3. Document what went wrong for the next attempt
