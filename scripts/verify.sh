#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
echo "=== VERIFY GATE $(date -Iseconds) ==="
echo "PWD: $ROOT"
echo ""

# 1. yaml 语法
echo "[1/5] hugo.yaml 语法"
python3 -c "import yaml; yaml.safe_load(open('hugo.yaml'))" && echo "  OK"

# 2. TDD 套件
echo "[2/5] TDD 套件"
bash tests/run_all.sh

# 3. Hugo 构建（若有 hugo）
echo "[3/5] 生产构建"
if command -v hugo &>/dev/null; then
  hugo --cleanDestinationDir --gc --minify --environment production --printPathWarnings --panicOnWarning
  echo "  OK: hugo build pass"
  test -f public/sitemap.xml && echo "  OK: sitemap.xml"
  test -f public/index.html && echo "  OK: index.html"
else
  echo "  SKIP: hugo not installed locally (CI 强制)"
fi

# 4. Workflow 门禁
echo "[4/5] CI 工作流门禁"
grep -q "panicOnWarning" .github/workflows/deploy.yml && echo "  OK: panicOnWarning" || echo "  WARN: missing panicOnWarning"
grep -q "cleanDestinationDir" .github/workflows/deploy.yml && echo "  OK: cleanDestinationDir" || echo "  WARN: missing flag"
grep -q "timeout-minutes" .github/workflows/deploy.yml && echo "  OK: timeout" || echo "  WARN: missing timeout"

# 5. 产物检查
echo "[5/5] 产物与去模板化抽检"
if grep -r -q "example.org" hugo.yaml 2>/dev/null; then echo "  FAIL: baseURL 仍为 example.org"; exit 1; else echo "  OK: baseURL"; fi

echo ""
echo "=== VERIFY PASS ==="
