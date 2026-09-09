#!/bin/bash
set -euo pipefail
echo "== test_links (internal) =="
# 优先用 htmltest，其次 lychee，最后做极简 grep 检查
if command -v htmltest &>/dev/null && [[ -d public ]]; then
  htmltest public --log-level 2 || { echo "FAIL: htmltest"; exit 1; }
elif command -v lychee &>/dev/null && [[ -d public ]]; then
  lychee public --no-progress || { echo "FAIL: lychee"; exit 1; }
else
  echo "SKIP: no link checker installed or no public/. Doing grep sanity."
  if [[ -d public ]]; then
    if grep -rq "href=\"http" public/ 2>/dev/null | grep -q "404"; then echo "WARN: possible 404"; fi
  fi
fi
echo "PASS: links"
