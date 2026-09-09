#!/bin/bash
set -euo pipefail
echo "== test_frontmatter =="
fail=0
for f in $(find content -name "*.md" -type f); do
  if ! head -n 20 "$f" | grep -q "^title:"; then
    echo "FAIL: $f missing title"
    fail=1
  fi
  # 检查 date 合法性（如有）
  if grep -q "^date:" "$f"; then
    d=$(grep "^date:" "$f" | head -1 | sed 's/date:[ ]*//')
    if ! date -d "$d" "+%Y-%m-%d" &>/dev/null 2>&1 && ! date -j -f "%Y-%m-%d" "$d" "+%Y-%m-%d" &>/dev/null 2>&1; then
      echo "WARN: $f has unusual date: $d"
    fi
  fi
done
if [[ $fail -eq 1 ]]; then exit 1; fi
echo "PASS: frontmatter"
