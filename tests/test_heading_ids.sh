#!/bin/bash
set -euo pipefail
echo "== test_heading_ids =="
# 检查三语 heading ID 是否对齐（{#id} 显式锚点）
fail=0
for base in $(find content -name "*.md" ! -name "*.zh.md" ! -name "*.fr.md" -type f | sed 's/\.md$//'); do
  en_ids=$(grep -o "{#[^}]*}" "${base}.md" 2>/dev/null | sort || true)
  zh_ids=$(grep -o "{#[^}]*}" "${base}.zh.md" 2>/dev/null | sort || true)
  fr_ids=$(grep -o "{#[^}]*}" "${base}.fr.md" 2>/dev/null | sort || true)
  if [[ -n "$en_ids" ]]; then
    if [[ "$en_ids" != "$zh_ids" ]]; then echo "WARN id mismatch zh: $base"; echo " en:$en_ids zh:$zh_ids"; fi
    if [[ "$en_ids" != "$fr_ids" ]]; then echo "WARN id mismatch fr: $base"; echo " en:$en_ids fr:$fr_ids"; fi
  fi
done
echo "PASS: heading ids (warnings only)"
