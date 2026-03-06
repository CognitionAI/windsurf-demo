#!/usr/bin/env bash
# analyze-structure.sh — Gather project structure and metadata for onboarding
# Usage: bash analyze-structure.sh [project-root]
#   project-root defaults to current directory

set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

echo "=== Project Structure Analysis ==="
echo "Directory: $(pwd)"
echo "Generated: $(date)"
echo ""

# Top-level directory tree (2 levels deep, excluding common noise)
echo "--- Directory Layout ---"
find . -maxdepth 2 -type d \
  ! -path './.git*' \
  ! -path './node_modules*' \
  ! -path './.venv*' \
  ! -path './venv*' \
  ! -path './__pycache__*' \
  ! -path './dist*' \
  ! -path './build*' \
  ! -path './.next*' \
  | sort \
  | head -50
echo ""

# File count by extension
echo "--- Files by Extension (top 15) ---"
find . -type f \
  ! -path './.git/*' \
  ! -path './node_modules/*' \
  ! -path './.venv/*' \
  ! -path './venv/*' \
  ! -path './__pycache__/*' \
  | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -15
echo ""

# Total file and line counts
echo "--- Size ---"
FILE_COUNT=$(find . -type f ! -path './.git/*' ! -path './node_modules/*' ! -path './.venv/*' | wc -l | tr -d ' ')
echo "Total files: ${FILE_COUNT}"
if command -v wc &>/dev/null; then
  LINE_COUNT=$(find . -type f -name '*.py' -o -name '*.js' -o -name '*.ts' -o -name '*.jsx' -o -name '*.tsx' -o -name '*.java' -o -name '*.go' -o -name '*.rs' -o -name '*.rb' -o -name '*.html' -o -name '*.css' \
    | grep -v node_modules | grep -v .git | grep -v .venv \
    | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}')
  echo "Lines of code (approx): ${LINE_COUNT:-0}"
fi
echo ""

# Dependency / framework detection
echo "--- Detected Stack ---"
[ -f package.json ]       && echo "- Node.js (package.json found)"
[ -f requirements.txt ]   && echo "- Python (requirements.txt found)"
[ -f Pipfile ]            && echo "- Python/Pipenv (Pipfile found)"
[ -f pyproject.toml ]     && echo "- Python (pyproject.toml found)"
[ -f Cargo.toml ]         && echo "- Rust (Cargo.toml found)"
[ -f go.mod ]             && echo "- Go (go.mod found)"
[ -f pom.xml ]            && echo "- Java/Maven (pom.xml found)"
[ -f build.gradle ]       && echo "- Java/Gradle (build.gradle found)"
[ -f Gemfile ]            && echo "- Ruby (Gemfile found)"
[ -f composer.json ]      && echo "- PHP (composer.json found)"
[ -f Dockerfile ]         && echo "- Docker (Dockerfile found)"
[ -f docker-compose.yml ] || [ -f docker-compose.yaml ] && echo "- Docker Compose found"
[ -f .env.example ]       && echo "- .env.example found (environment config)"
[ -f tsconfig.json ]      && echo "- TypeScript (tsconfig.json found)"
echo ""

# Key dependency highlights
if [ -f package.json ]; then
  echo "--- Node Dependencies (top-level) ---"
  cat package.json | python3 -c "
import sys, json
try:
    pkg = json.load(sys.stdin)
    deps = list(pkg.get('dependencies', {}).keys())
    dev = list(pkg.get('devDependencies', {}).keys())
    if deps: print('Dependencies:', ', '.join(deps))
    if dev: print('Dev dependencies:', ', '.join(dev))
except: print('(could not parse package.json)')
" 2>/dev/null || echo "(could not parse package.json)"
  echo ""
fi

if [ -f requirements.txt ]; then
  echo "--- Python Dependencies ---"
  cat requirements.txt | head -20
  TOTAL=$(wc -l < requirements.txt | tr -d ' ')
  [ "$TOTAL" -gt 20 ] && echo "... and $((TOTAL - 20)) more"
  echo ""
fi

# Entry point detection
echo "--- Likely Entry Points ---"
for f in app.py main.py manage.py server.py index.js index.ts src/index.js src/index.ts src/main.js src/main.ts main.go cmd/main.go src/main.rs; do
  [ -f "$f" ] && echo "- $f"
done
echo ""

echo "=== End of Analysis ==="
