#!/usr/bin/env bash
# diff-stats.sh — Gather PR diff statistics for review context
# Usage: ./diff-stats.sh [base-branch] [feature-branch]
#   base-branch defaults to "main"
#   feature-branch defaults to current HEAD

set -euo pipefail

BASE="${1:-main}"
FEATURE="${2:-HEAD}"

echo "=== PR Diff Stats: ${BASE}..${FEATURE} ==="
echo ""

# Commit summary
COMMIT_COUNT=$(git rev-list --count "${BASE}..${FEATURE}" 2>/dev/null || echo "0")
echo "Commits: ${COMMIT_COUNT}"
echo ""

# File change summary
echo "--- Files Changed ---"
git diff --stat "${BASE}..${FEATURE}" 2>/dev/null || echo "(no diff available)"
echo ""

# Insertions / deletions
echo "--- Summary ---"
git diff --shortstat "${BASE}..${FEATURE}" 2>/dev/null || echo "(no diff available)"
echo ""

# List changed files by type
echo "--- Changed Files by Extension ---"
git diff --name-only "${BASE}..${FEATURE}" 2>/dev/null \
  | sed 's/.*\.//' | sort | uniq -c | sort -rn \
  || echo "(no diff available)"
echo ""

# Large files (>200 lines changed)
echo "--- Large Diffs (>200 lines) ---"
git diff --numstat "${BASE}..${FEATURE}" 2>/dev/null \
  | awk '{ added=$1; removed=$2; file=$3; total=added+removed; if (total > 200) printf "%s lines changed: %s\n", total, file }' \
  || echo "(none)"
echo ""

# Recent commits on the feature branch
echo "--- Recent Commits ---"
git log --oneline "${BASE}..${FEATURE}" -20 2>/dev/null || echo "(no commits)"
