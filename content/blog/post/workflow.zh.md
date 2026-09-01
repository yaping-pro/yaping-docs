---
title: 极客日常写作与 GitOps 自动化发布工作流
date: 2026-09-01
description: 基于 Hugo + OINK + GitHub Actions + FTPS + Cloudflare 边缘缓存的自动化知识库发布指南。
tags: [GitOps, 知识库, 自动化, Cloudflare]
---

本站点采用 **GitOps 现代自动化发布架构**：你只需要在本地使用纯 Markdown 写作，执行 `git push`，云端流水线将全自动完成静态编译、加密传输与全球 CDN 边缘分发。

---

## 1. 核心架构与部署链路

```
[ 本地 Markdown 写作 ]
          │
          ▼  (git push origin main)
[ GitHub 仓库 ] ──► [ GitHub Actions 自动化流水线 ]
                            │
                            ├──► 1. Hugo Extended 极速编译 (静态 HTML/CSS/JS)
                            └──► 2. 8 线程并发 FTPS 加密同步
                                          │
                                          ▼
                             [ MatrixIDC 虚拟主机源站 ]
                                          │
                                          ▼ (回源自动接管)
                             [ Cloudflare 边缘 Anycast CDN ]
                                          │
                                          ▼
                               [ 全球读者 20ms 秒开 ]
```

---

## 2. 本地写作与预览指令

在本地项目目录 `/Users/steven/Projects/yaping-docs` 下操作：

### 2.1 启动本地实时预览（可选）
如果你安装了 `hugo`，可在本地启动热重载开发服务器：
```bash
cd /Users/steven/Projects/yaping-docs
hugo server -D
# 浏览器访问 http://localhost:1313/ 即可实时查看改动
```

### 2.2 新建文章与文档
- **博客文章**：在 `content/blog/post/` 下新建 `.zh.md`（中文）或 `.md`（英文）文件。
- **技术文档**：在 `content/docs/` 对应的子分类目录（如 `introduction/`、`tutorial/`）下新建或修改文件。
- **完整书籍/小册**：在 `content/book/` 下按章节编号命名文件（如 `05-advanced.zh.md`）。

---

## 3. 一键发布到线上（Git 三部曲）

写作完成后，在终端运行以下三行标准 Git 命令即可完成全自动上线：

```bash
# 1. 进入项目根目录
cd /Users/steven/Projects/yaping-docs

# 2. 暂存所有更改并编写提交信息
git add .
git commit -m "docs: 发布新文章或更新文档内容"

# 3. 推送到 GitHub 远程仓库（触发云端自动化构建）
git push origin main
```

---

## 4. 查看云端发布状态

- **查看构建进度**：推送后，访问 [GitHub Actions 控制台](https://github.com/yaping-pro/yaping-docs/actions) 查看实时流水线。
- **线上验收**：构建完成后（通常约 40~50 秒），直接刷新 [https://docs.yaping.dpdns.org/](https://docs.yaping.dpdns.org/) 查看最新内容。
