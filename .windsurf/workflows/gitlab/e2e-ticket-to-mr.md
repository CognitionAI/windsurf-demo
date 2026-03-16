---
description: End-to-End Ticket-to-MR Workflow - Pull a Jira/Atlassian ticket, plan in Plan Mode, implement in Code Mode, push via GitLab MCP
---

# End-to-End: Ticket → Plan → Code → Merge Request

This workflow demonstrates a real-life development workstream from ticket to deployed code, using Atlassian MCP, Cascade modes, and GitLab MCP.

## Prerequisites

- **Atlassian (Jira) MCP server** configured and connected
- **GitLab MCP server** configured and connected
- **GitLab Project ID**: Use full path (e.g., `user/repo`)
- Valid Jira issue key (e.g., `PROJ-123`)
- Write access to the GitLab repository

---

## Phase 1: Pull the Ticket (Atlassian MCP)

### Step 1 — Get the Jira Issue Key

Ask the user:

> **What is the Jira ticket key you'd like to work on?** (e.g., `GAME-42`)

Wait for the user to respond before continuing.

### Step 2 — Retrieve Ticket Details from Jira

Use the Atlassian/Jira MCP tools to pull the ticket:

- **Summary / Title**
- **Description** (full spec, user story, or bug report)
- **Acceptance Criteria** (from description or subtasks)
- **Priority & Status**
- **Assignee & Reporter**
- **Labels / Components**
- **Linked issues or blockers**

Present a clean summary to the user:

```
## Ticket: [KEY] — [Title]
**Priority**: [Priority]  |  **Status**: [Status]  |  **Assignee**: [Name]

### Description
[Ticket description]

### Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
```

### Step 3 — Confirm Understanding

Ask the user:

> **Does this summary look correct? Any additional context I should know before planning?**

Wait for confirmation before proceeding.

---

## Phase 2: Plan the Work (Plan Mode)

> **💡 Tip for the presenter**: Switch to **Plan Mode** in Cascade for this phase. Plan Mode will reason about the approach without making code changes.

### Step 4 — Analyze the Codebase

Based on the ticket requirements, search the codebase to understand:

- **Which files** need to change
- **What patterns** the codebase already uses
- **Dependencies** between components
- **Existing tests** that may need updating

### Step 5 — Generate a Task Breakdown

Create a structured plan with tasks:

| Task | Description | Files | Complexity | Dependencies |
|------|-------------|-------|------------|--------------|
| T1   | [What to do] | [files] | Low/Med/High | None |
| T2   | [What to do] | [files] | Low/Med/High | T1 |
| ...  | ...         | ...   | ...        | ... |

Include:
- **Implementation order** (respecting dependencies)
- **Testing strategy** for each task
- **Risk areas** or edge cases to watch for

### Step 6 — Present Plan & Get Approval

Show the full plan and ask:

> **Here's my proposed plan. Should I proceed, or would you like to adjust anything?**

**⚠️ STOP — Do not proceed to implementation without explicit user approval.**

Wait for the user to approve or request changes. Iterate on the plan if needed.

---

## Phase 3: Implement the Changes (Code Mode)

> **💡 Tip for the presenter**: Switch to **Code Mode** in Cascade for this phase. Code Mode will make actual file edits.

### Step 7 — Create a Feature Branch (Git)

Create a local feature branch for the work:

```bash
git checkout -b feature/[TICKET-KEY]-[short-description]
```

Use a descriptive branch name that includes the ticket key, e.g., `feature/GAME-42-score-decay`.

### Step 8 — Implement Tasks Sequentially

For each task in the plan:

1. **Implement** the code changes
2. **Verify** the changes work (run the app, check behavior)
3. **Mark the task as done** in your mental checklist

Follow existing code patterns and style. Reference the ticket key in comments only where it adds clarity.

### Step 9 — Test the Changes

- Run the application and verify all acceptance criteria are met
- Run any existing test suites to check for regressions
- Manually verify edge cases identified during planning

```bash
# Example: start the Flask app to test
python app.py
```

### Step 10 — Commit Locally

Stage and commit the changes with a clear message referencing the ticket:

```bash
git add -A
git commit -m "[TICKET-KEY] Brief description of changes

- Detail 1
- Detail 2

Resolves: TICKET-KEY"
```

---

## Phase 4: Push & Create Merge Request (GitLab MCP)

### Step 11 — Push the Branch to GitLab

First, try using GitLab MCP to push the changes (e.g., `mcp4_push_files` or `mcp4_create_or_update_file`).

**If GitLab MCP push fails**, fall back to pushing via local git. Check for a `gitlab` remote first:

```bash
git remote -v
```

Then push the branch:

```bash
git push gitlab feature/[TICKET-KEY]-[short-description]
```

If no `gitlab` remote exists, add one first:

```bash
git remote add gitlab https://gitlab.com/[USER]/[REPO].git
git push gitlab feature/[TICKET-KEY]-[short-description]
```

### Step 12 — Create the Merge Request

Use `mcp4_create_merge_request` with:

- **Title**: `[TICKET-KEY] [Ticket Title]`
- **Description**: Include:
  - Link to the Jira ticket
  - Summary of changes
  - Testing performed
  - Acceptance criteria checklist
- **Source branch**: `feature/[TICKET-KEY]-[short-description]`
- **Target branch**: `main`

Example MR description:

```markdown
## Summary
Implements [TICKET-KEY]: [Title]

**Jira Ticket**: [Link to ticket]

## Changes
- [Change 1]
- [Change 2]

## Testing
- [x] Manual testing performed
- [x] Acceptance criteria verified
- [ ] Code review pending

## Acceptance Criteria
- [x] Criterion 1
- [x] Criterion 2
```

### Step 13 — Share the MR Link

Present the merge request URL to the user:

> **✅ Merge request created!**
> **MR Link**: [URL]
> 
> The MR is ready for review. Would you like to do anything else?

---

## Quick Reference: Tool Mapping

| Phase | Tool / Mode | Purpose |
|-------|-------------|---------|
| Pull ticket | Atlassian/Jira MCP | Retrieve ticket details |
| Plan | **Plan Mode** | Analyze & design without editing |
| Implement | **Code Mode** | Make actual code changes |
| Branch | `git` (local) | Create feature branch |
| Push | GitLab MCP / `git push` | Push code to remote |
| Merge Request | `mcp4_create_merge_request` | Open MR for review |

## Example Walkthrough

**User**: "/e2e-ticket-to-mr"

**Cascade**: "What Jira ticket would you like to work on?"

**User**: "GAME-42"

**Cascade** (Phase 1): Pulls GAME-42, shows summary, asks for confirmation and for user to switch to plan mode.

**User**: "Looks good, let's plan it."

**Cascade** (Phase 2 — Plan Mode): Analyzes codebase, creates 4-task breakdown, presents plan.

**User**: "Approved."

**Cascade** (Phase 3 — Code Mode): Creates branch, implements tasks, tests, commits.

**Cascade** (Phase 4): Pushes to GitLab, creates MR with full description, shares link.

**User**: "Perfect, thanks!"

---

## Tips for Presenters / Demo

1. **Show the mode switches** — Toggle between Plan Mode and Code Mode visibly
2. **Narrate each phase** — "Now I'm pulling the ticket... Now switching to Plan Mode..."
3. **Use a real-looking ticket** — Pre-create a Jira ticket with clear acceptance criteria
4. **Keep the feature small** — A config change + one logic file is ideal for a demo
5. **Highlight the MR description** — Show how context flows from ticket → plan → MR
