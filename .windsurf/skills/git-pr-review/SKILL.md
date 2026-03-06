---
name: git-pr-review
description: Review a Git pull request or branch diff, providing feedback on code quality, bugs, security, and style
---

# Git PR Review Skill

Use this skill when the user asks you to review a PR, review a branch, review changes, or do a code review.

## Steps

### 1. Identify the branches to compare

Ask the user which branch they want reviewed if not already specified. Determine the **base branch** (e.g. `main`) and the **feature branch** (the branch with changes). If the user only names one branch, assume `main` as the base.

### 2. Get the diff

Run the helper script to get a quick statistical overview:
```bash
bash .windsurf/skills/git-pr-review/diff-stats.sh <base-branch> <feature-branch>
```

Then use the git MCP tools for detailed context:
- `git_status` — check for uncommitted changes
- `git_log` — review recent commits on the feature branch for context
- `git_diff` — get the diff between the base and feature branch (e.g., target = `main..feature-branch`)

### 3. Read the changed files

For each file in the diff, use the `read_file` tool to read the full file so you have surrounding context beyond just the diff hunks. This is critical for understanding how changes fit into the broader codebase.

### 4. Analyze and provide feedback

Review the changes across these dimensions, reporting only issues you actually find. Refer to [checklist.md](checklist.md) for the full review checklist:

- **Bugs & Logic Errors** — Off-by-one errors, null/undefined access, race conditions, incorrect conditionals, missing edge cases
- **Security** — Injection vulnerabilities, hardcoded secrets, missing input validation, improper auth checks, XSS/CSRF risks
- **Performance** — Unnecessary loops, missing indexes, N+1 queries, large allocations, blocking calls in async contexts
- **Code Quality** — Dead code, duplicated logic, overly complex functions, poor naming, missing error handling
- **Style & Consistency** — Deviations from the existing codebase style, inconsistent naming conventions, formatting issues
- **Testing** — Missing test coverage for new behavior, weakened or deleted existing tests without justification

### 5. Format the review

Present findings in this structure:

```
## PR Review: `<branch-name>`

### Summary
<1-2 sentence overview of what the changes do>

### Critical Issues
<Issues that must be fixed before merging — bugs, security, data loss risks>

### Suggestions
<Non-blocking improvements — refactors, performance, style>

### Looks Good
<Brief note on what was done well, if applicable>
```

Use code citations (e.g. `@/path/to/file.js:10-15`) when referencing specific lines. Keep feedback actionable — say what to change, not just what's wrong.

### 6. Offer to help fix

After presenting the review, ask the user if they'd like you to implement any of the suggested fixes.
