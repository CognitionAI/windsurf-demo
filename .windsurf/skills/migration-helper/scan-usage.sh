#!/usr/bin/env bash
# scan-usage.sh — Scan codebase for deprecated patterns or check for outdated dependencies
# Usage:
#   bash scan-usage.sh outdated                          — list outdated dependencies
#   bash scan-usage.sh scan "pattern1" "pattern2" ...    — search for usage patterns
#   bash scan-usage.sh scan-file patterns.txt            — search for patterns listed in a file (one per line)

set -euo pipefail

MODE="${1:-help}"
shift || true

# Directories to exclude from scanning
EXCLUDES="--exclude-dir=node_modules --exclude-dir=.git --exclude-dir=.venv --exclude-dir=venv --exclude-dir=dist --exclude-dir=build --exclude-dir=coverage --exclude-dir=__pycache__"

case "$MODE" in

  outdated)
    echo "=== Outdated Dependencies ==="
    echo ""

    if [ -f package.json ]; then
      echo "--- npm outdated ---"
      npm outdated 2>/dev/null || echo "(all up to date or npm not available)"
      echo ""

      echo "--- Security audit ---"
      npm audit --summary 2>/dev/null || echo "(npm audit not available)"
      echo ""
    fi

    if [ -f requirements.txt ]; then
      echo "--- pip outdated ---"
      if command -v pip &>/dev/null; then
        pip list --outdated 2>/dev/null | head -30 || echo "(could not check)"
      else
        echo "(pip not available)"
      fi
      echo ""

      echo "--- Safety check (known vulnerabilities) ---"
      if command -v safety &>/dev/null; then
        safety check -r requirements.txt 2>/dev/null || echo "(no issues or safety not available)"
      else
        echo "(install 'safety' for vulnerability scanning: pip install safety)"
      fi
      echo ""
    fi

    if [ -f Cargo.toml ]; then
      echo "--- cargo outdated ---"
      cargo outdated 2>/dev/null || echo "(cargo-outdated not installed)"
      echo ""
    fi

    if [ -f go.mod ]; then
      echo "--- go module updates ---"
      go list -m -u all 2>/dev/null | grep '\[' | head -20 || echo "(all up to date)"
      echo ""
    fi
    ;;

  scan)
    if [ $# -eq 0 ]; then
      echo "Usage: bash scan-usage.sh scan \"pattern1\" \"pattern2\" ..."
      exit 1
    fi

    echo "=== Pattern Scan Results ==="
    echo ""

    TOTAL_MATCHES=0
    for pattern in "$@"; do
      echo "--- Pattern: ${pattern} ---"
      MATCHES=$(grep -rn $EXCLUDES --include='*.js' --include='*.ts' --include='*.jsx' --include='*.tsx' \
        --include='*.py' --include='*.java' --include='*.go' --include='*.rs' --include='*.rb' \
        --include='*.html' --include='*.css' --include='*.yml' --include='*.yaml' --include='*.json' \
        "$pattern" . 2>/dev/null || true)

      if [ -n "$MATCHES" ]; then
        COUNT=$(echo "$MATCHES" | wc -l | tr -d ' ')
        TOTAL_MATCHES=$((TOTAL_MATCHES + COUNT))
        echo "Found ${COUNT} occurrence(s):"
        echo "$MATCHES" | head -25
        [ "$COUNT" -gt 25 ] && echo "  ... and $((COUNT - 25)) more"
      else
        echo "  (no matches)"
      fi
      echo ""
    done

    echo "=== Total: ${TOTAL_MATCHES} match(es) across all patterns ==="
    ;;

  scan-file)
    PATTERN_FILE="${1:-}"
    if [ -z "$PATTERN_FILE" ] || [ ! -f "$PATTERN_FILE" ]; then
      echo "Usage: bash scan-usage.sh scan-file <patterns.txt>"
      echo "  patterns.txt should have one pattern per line"
      exit 1
    fi

    echo "=== Pattern Scan from File: ${PATTERN_FILE} ==="
    echo ""

    TOTAL_MATCHES=0
    while IFS= read -r pattern; do
      [ -z "$pattern" ] && continue
      [[ "$pattern" == \#* ]] && continue  # skip comments

      echo "--- Pattern: ${pattern} ---"
      MATCHES=$(grep -rn $EXCLUDES --include='*.js' --include='*.ts' --include='*.jsx' --include='*.tsx' \
        --include='*.py' --include='*.java' --include='*.go' --include='*.rs' --include='*.rb' \
        "$pattern" . 2>/dev/null || true)

      if [ -n "$MATCHES" ]; then
        COUNT=$(echo "$MATCHES" | wc -l | tr -d ' ')
        TOTAL_MATCHES=$((TOTAL_MATCHES + COUNT))
        echo "Found ${COUNT} occurrence(s):"
        echo "$MATCHES" | head -15
        [ "$COUNT" -gt 15 ] && echo "  ... and $((COUNT - 15)) more"
      else
        echo "  (no matches)"
      fi
      echo ""
    done < "$PATTERN_FILE"

    echo "=== Total: ${TOTAL_MATCHES} match(es) across all patterns ==="
    ;;

  *)
    echo "Usage:"
    echo "  bash scan-usage.sh outdated                        — check for outdated dependencies"
    echo "  bash scan-usage.sh scan \"pattern1\" \"pattern2\"      — search for patterns in code"
    echo "  bash scan-usage.sh scan-file patterns.txt          — search patterns from a file"
    ;;
esac
