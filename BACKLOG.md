# BACKLOG — Loop 模式任务队列（按 TDD 优先级）

> 规则：一次只做队首一项，做完跑 verify.sh 绿了才出队。禁止跳序。

## P0 — 构建与工具链（optimal-kits 固化）
- [x] 0.1 固化工具链：mise.toml 钉 go1.22 + hugo extended 0.165.0 + python3.12，与 CI 一致
- [x] 0.2 加固 CI 门禁：deploy.yml 加入 --panicOnWarning + --cleanDestinationDir + htmltest

## P1 — TDD 红灯测试（先写测试，再改实现）
- [ ] 1.1 tests/test_build.sh — 生产构建零警告
- [ ] 1.2 tests/test_i18n_parity.sh — 三语文件成对 + 三语首页可访问
- [ ] 1.3 tests/test_no_placeholder.sh — 无 "Replace this" / "Project Name" / example.org 残留
- [ ] 1.4 tests/test_links.sh — 内部断链检测（htmltest）
- [ ] 1.5 tests/test_frontmatter.sh — 所有 md 含 title/description/weight 或 date 合法

## P2 — 内容去模板化（实现）
- [ ] 2.1 重写 hugo.yaml：title/baseURL/params.description 为真实 Yaping 文案
- [ ] 2.2 重写 data/home/*.yaml 三语首页
- [ ] 2.3 重写 content/docs/introduction/overview 三语（问题/产出 2 段式）
- [ ] 2.4 重写 content/blog/post/welcome 三语首篇
- [ ] 2.5 替换 assets/icons/logo.svg + static/favicon.svg（如无真实素材则用占位几何）

## P3 — Edgecases 加固（由测试驱动）
- [ ] 3.1 heading ID 三语对齐检查
- [ ] 3.2 baseURL 尾斜杠与 canonical 去重
- [ ] 3.3 draft/future 日期隔离（production 环境不泄露）
- [ ] 3.4 search 索引与 sitemap 非空
- [ ] 3.5 FTPS 部署幂等（重跑不丢文件，失败重试 3 次）

## P4 — 发布
- [ ] 4.1 本地 verify.sh 全绿 → git commit → push main → 观察 Actions 绿
- [ ] 4.2 人工抽检：`/`, `/zh/`, `/fr/`, 一篇 blog/docs/book 在桌面+移动端渲染正常

> Edgecases 来源：同类 Hugo/OOINK 开源项目常见失效模式（见 GOAL 注释与 tests/）。
