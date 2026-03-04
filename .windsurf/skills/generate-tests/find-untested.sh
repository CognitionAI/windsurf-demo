#!/usr/bin/env bash
# find-untested.sh — Run tests with coverage and report uncovered code
# Usage: bash find-untested.sh [project-root]
#   project-root defaults to current directory

set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

echo "=== Test Coverage Analysis ==="
echo "Directory: $(pwd)"
echo "Generated: $(date)"
echo ""

# Detect test framework and run coverage
if [ -f package.json ]; then
  echo "--- Detected: Node.js project ---"
  echo ""

  # Check which test runner is configured
  if grep -q '"jest"' package.json 2>/dev/null || grep -q '"test".*jest' package.json 2>/dev/null; then
    RUNNER="jest"
  elif grep -q '"vitest"' package.json 2>/dev/null; then
    RUNNER="vitest"
  elif grep -q '"mocha"' package.json 2>/dev/null; then
    RUNNER="mocha"
  else
    RUNNER="jest"  # default assumption
  fi
  echo "Test runner: ${RUNNER}"
  echo ""

  # Run with coverage
  echo "--- Running tests with coverage ---"
  if [ "$RUNNER" = "jest" ]; then
    npx jest --coverage --coverageReporters=text --watchAll=false 2>&1 || true
  elif [ "$RUNNER" = "vitest" ]; then
    npx vitest run --coverage 2>&1 || true
  elif [ "$RUNNER" = "mocha" ]; then
    npx nyc mocha 2>&1 || true
  fi
  echo ""

  # Parse coverage for low-coverage files
  echo "--- Files Below 80% Coverage ---"
  if [ "$RUNNER" = "jest" ]; then
    npx jest --coverage --coverageReporters=json-summary --watchAll=false 2>/dev/null || true
    if [ -f coverage/coverage-summary.json ]; then
      python3 -c "
import json, sys
try:
    with open('coverage/coverage-summary.json') as f:
        data = json.load(f)
    for path, metrics in sorted(data.items()):
        if path == 'total': continue
        line_pct = metrics.get('lines', {}).get('pct', 100)
        branch_pct = metrics.get('branches', {}).get('pct', 100)
        if line_pct < 80 or branch_pct < 80:
            print(f'  {path}: lines={line_pct}% branches={branch_pct}%')
except Exception as e:
    print(f'(could not parse coverage: {e})')
" 2>/dev/null || echo "(could not parse coverage report)"
    fi
  fi

elif [ -f requirements.txt ] || [ -f pyproject.toml ] || [ -f setup.cfg ] || [ -f Pipfile ]; then
  echo "--- Detected: Python project ---"
  echo ""

  # Check for pytest
  if command -v pytest &>/dev/null || pip show pytest &>/dev/null 2>&1; then
    RUNNER="pytest"
  else
    RUNNER="unittest"
  fi
  echo "Test runner: ${RUNNER}"
  echo ""

  echo "--- Running tests with coverage ---"
  if [ "$RUNNER" = "pytest" ]; then
    python3 -m pytest --cov=. --cov-report=term-missing 2>&1 || true
  else
    python3 -m coverage run -m unittest discover 2>&1 || true
    python3 -m coverage report --show-missing 2>&1 || true
  fi

else
  echo "Could not detect project type. Supported: Node.js (package.json), Python (requirements.txt/pyproject.toml)"
  exit 1
fi

echo ""

# List source files with no corresponding test file
echo "--- Source Files Without Test Files ---"
find_test_file() {
  local src="$1"
  local base
  base=$(basename "$src" | sed 's/\.[^.]*$//')
  local ext="${src##*.}"

  # Common test file patterns
  for pattern in \
    "**/${base}.test.${ext}" \
    "**/${base}.spec.${ext}" \
    "**/test_${base}.${ext}" \
    "**/${base}_test.${ext}"; do
    if compgen -G "$pattern" >/dev/null 2>&1; then
      return 0
    fi
  done
  return 1
}

# Check JS files
find . -name '*.js' -not -path './node_modules/*' -not -path './.git/*' \
  -not -name '*.test.js' -not -name '*.spec.js' -not -path './*test*/*' \
  -not -path './coverage/*' -not -path './dist/*' -not -path './build/*' \
  | while read -r file; do
    if ! find_test_file "$file"; then
      echo "  $file (no test file found)"
    fi
  done 2>/dev/null

# Check Python files
find . -name '*.py' -not -path './.venv/*' -not -path './venv/*' -not -path './.git/*' \
  -not -name 'test_*.py' -not -name '*_test.py' -not -path './*test*/*' \
  | while read -r file; do
    if ! find_test_file "$file"; then
      echo "  $file (no test file found)"
    fi
  done 2>/dev/null

echo ""
echo "=== End of Coverage Analysis ==="
