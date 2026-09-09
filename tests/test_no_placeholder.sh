#!/bin/bash
set -euo pipefail
echo "== test_no_placeholder =="
fail=0
if grep -r -q "Replace this page\|Replace this\|Project Name\|example.org\|YOUR-REPOSITORY" content/ hugo.yaml data/home/ 2>/dev/null; then
  echo "FAIL: placeholder text still present:"
  grep -r -n "Replace this page\|Project Name\|example.org" content/ hugo.yaml data/home/ 2>/dev/null | head -n 20
  fail=1
fi
if [[ $fail -eq 1 ]]; then exit 1; fi
echo "PASS: no placeholder"
