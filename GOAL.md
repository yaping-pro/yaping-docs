# GOAL — Yaping 知识库全自动交付

> 过程完全自动化。循环结束时，人只验收产品。

## 产品定义
基于 OINK Starter 的 `yaping-docs` 站点，域名 https://docs.yaping.dpdns.org/，三语（zh/en/fr），内容已去模板化，可对外发布。

## Done 的 7 条可检查标准（全部绿才算完）
1. **构建门禁**：`hugo --cleanDestinationDir --gc --minify --environment production --printPathWarnings --panicOnWarning` 零警告零错误
2. **三语等价**：`/` `/zh/` `/fr/` 均 200；每个 `content/**/*.md` 都有对应 `.zh.md` / `.fr.md` 或在 BACKLOG 中显式豁免
3. **去模板化**：`hugo.yaml` 的 title/baseURL 已改为真实值；`data/home/*.yaml` 非默认文案；`content/` 下无 "Replace this page" 占位
4. **产物体积**：`public/` 产出含 sitemap.xml、RSS、LLMS.txt、offline search 索引；首屏无 404 资源
5. **链路健康**：内部链接检查（htmltest/lychee）零断链；所有 heading ID 在三语间对齐
6. **部署就绪**：`.github/workflows/deploy.yml` 在 push main 时自动构建并 FTPS 同步到 `/` 与 `/public_html`，并发控制与 10 分钟超时齐全
7. **可回滚**：每次 loop 迭代为单一原子 commit，`git log --oneline` 可追溯，任意一步可 `git revert`

## 非目标
- 不接 Giscus/GA（保持注释块，待真实 ID 再开）
- 不引入 Node/npm 工具链（OINK 无需）
- 不改 OINK 主题源码（仅通过 hugo.yaml params 覆盖）

## 验收命令（一键）
```bash
bash scripts/verify.sh
```
全绿即交付。

## 时间盒
- 单次 loop 迭代 ≤15 分钟
- 全自动化总时长 ≤2 小时（不含人工验收浏览）
