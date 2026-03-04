---
name: migration-helper
description: Assist with dependency upgrades and framework migrations by scanning for deprecated usage, cross-referencing breaking changes, and proposing file-by-file migration steps
---

# Migration Helper Skill

Use this skill when the user wants to upgrade a dependency, migrate to a new framework version, replace a library, or modernize their codebase.

## Steps

### 1. Identify the migration scope

Ask the user (if not already specified):
- **What** is being migrated? (e.g., React 17→18, Express 4→5, Python 2→3, jQuery→vanilla JS)
- **Why?** (end-of-life, new features, security, performance)

If the user is unsure what needs upgrading, run the scan script to check for outdated dependencies:
```bash
bash .windsurf/skills/migration-helper/scan-usage.sh outdated
```

### 2. Research breaking changes

Check [breaking-changes.md](breaking-changes.md) for documented migration notes on common upgrades.

For upgrades not covered there, use web search or DeepWiki to look up:
- Official migration guides
- Changelog / release notes for the target version
- Known breaking changes and deprecations

### 3. Scan the codebase for affected patterns

Run the usage scanner to find code that may need changes:
```bash
bash .windsurf/skills/migration-helper/scan-usage.sh scan "<pattern1>" "<pattern2>" ...
```

For example, migrating from `componentWillMount` in React:
```bash
bash .windsurf/skills/migration-helper/scan-usage.sh scan "componentWillMount" "componentWillReceiveProps" "componentWillUpdate"
```

### 4. Build a migration plan

Using [migration-plan.md](migration-plan.md) as a template, create a concrete plan:

1. **Pre-migration checklist** — backup, branch, tests passing
2. **Dependency updates** — exact version changes in package.json / requirements.txt
3. **File-by-file changes** — grouped by risk level (safe automatic → needs manual review)
4. **Post-migration verification** — tests to run, manual checks

Present the plan to the user for approval before making changes.

### 5. Execute the migration

For each file:
- Read the full file for context
- Apply the necessary changes (API renames, pattern updates, import changes)
- Keep changes minimal — only modify what the migration requires, don't refactor unrelated code

### 6. Verify

After all changes are applied:
- Run the test suite
- Run the scan script again to confirm no deprecated patterns remain:
```bash
bash .windsurf/skills/migration-helper/scan-usage.sh scan "<pattern1>" "<pattern2>" ...
```
- Highlight any remaining items that need manual review
- Suggest the user do a manual smoke test
