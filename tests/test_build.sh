#!/bin/bash
set -euo pipefail
echo "== test_build: hugo production build =="
if ! command -v hugo &>/dev/null; then
  echo "SKIP: hugo not installed locally (CI will enforce). Checking hugo.yaml syntax instead."
  python3 -c "import yaml,sys; yaml.safe_load(open('hugo.yaml'))" 2>&1 && echo "PASS: hugo.yaml valid" || { echo "FAIL: hugo.yaml invalid"; exit 1; }
  exit 0
fi
hugo --cleanDestinationDir --gc --minify --environment production --printPathWarnings --panicOnWarning
test -f public/sitemap.xml || { echo "FAIL: sitemap.xml missing"; exit 1; }
test -f public/index.html || { echo "FAIL: public/index.html missing"; exit 1; }
echo "PASS: build"
