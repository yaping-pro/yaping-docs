---
title: Guide d’écriture geek et flux de déploiement GitOps
date: 2026-09-01
description: Guide de publication automatisée basé sur Hugo, OINK, GitHub Actions, FTPS et cache périphérique Cloudflare.
tags: [GitOps, Documentation, Automatisation, Cloudflare]
---

Ce site utilise une **architecture de publication automatisée GitOps moderne** : rédigez simplement en Markdown localement et exécutez `git push`. Le pipeline cloud prend en charge la compilation Hugo, la synchronisation FTPS et la distribution sur le réseau CDN Cloudflare.

---

## 1. Architecture et flux de déploiement

```
[ Rédaction Markdown locale ]
              │
              ▼  (git push origin main)
[ Dépôt GitHub ] ──► [ Pipeline GitHub Actions ]
                            │
                            ├──► 1. Compilation rapide Hugo Extended
                            └──► 2. Synchronisation FTPS sécurisée (8 threads)
                                          │
                                          ▼
                             [ Hébergement Web MatrixIDC ]
                                          │
                                          ▼
                             [ CDN Anycast Cloudflare ]
                                          │
                                          ▼
                             [ Accès global ultra-rapide ]
```

---

## 2. Commandes de publication standard

```bash
cd /Users/steven/Projects/yaping-docs
git add .
git commit -m "docs: ajouter un nouvel article"
git push origin main
```
