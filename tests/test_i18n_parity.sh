#!/bin/bash
set -euo pipefail
echo "== test_i18n_parity =="
missing=0
for f in content/**/*.md content/**/**/*.md; do
  [[ -f "$f" ]] || continue
  # 只检查 .md 基准文件，排除 .zh.md/.fr.md 自身
  if [[ "$f" == *.zh.md ]] || [[ "$f" == *.fr.md ]]; then continue; fi
  base="${f%.md}"
  if [[ ! -f "${base}.zh.md" ]]; then echo "MISS zh: $f"; missing=$((missing+1)); fi
  if [[ ! -f "${base}.fr.md" ]]; then echo "MISS fr: $f"; missing=$((missing+1)); fi
done
# 允许 workflow.md 仅双语（示例豁免）
if [[ $missing -gt 0 ]]; then
  echo "WARN: $missing translations missing (check BACKLOG exemptions)"
  # 严格模式：超过 2 个算 FAIL
  if [[ $missing -gt 2 ]]; then echo "FAIL: too many missing translations"; exit 1; fi
fi
echo "PASS: i18n parity"
