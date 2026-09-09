#!/bin/bash
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$DIR/.." && pwd)"
cd "$ROOT"
echo "=== TDD Suite: $(date -Iseconds) ==="
for t in tests/test_*.sh; do
  [[ "$t" == "tests/run_all.sh" ]] && continue
  echo ""
  bash "$t" || { echo ">> FAIL: $t"; exit 1; }
done
echo ""
echo "=== ALL TESTS PASS ==="
