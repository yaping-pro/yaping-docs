---
title: Geek Daily Writing and GitOps Deployment Workflow
date: 2026-09-01
description: Automated knowledge publishing guide based on Hugo, OINK, GitHub Actions, FTPS, and Cloudflare edge caching.
tags: [GitOps, Documentation, Automation, Cloudflare]
---

This site adopts a modern **GitOps automated publishing architecture**: write locally in pure Markdown and run `git push`. The cloud pipeline automatically handles Hugo compilation, FTPS sync, and Cloudflare edge distribution.

---

## 1. Architecture Flow

```
[ Local Markdown Writing ]
          │
          ▼  (git push origin main)
[ GitHub Repository ] ──► [ GitHub Actions CI/CD ]
                                │
                                ├──► 1. Hugo Extended Fast Build
                                └──► 2. 8-thread Parallel FTPS Sync
                                              │
                                              ▼
                                 [ MatrixIDC Web Hosting ]
                                              │
                                              ▼
                                 [ Cloudflare Edge CDN ]
```

---

## 2. Standard Publishing Commands

```bash
cd /Users/steven/Projects/yaping-docs
git add .
git commit -m "docs: add new article"
git push origin main
```
