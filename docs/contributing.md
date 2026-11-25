# 在 chrono-harness 组织贡献

各仓采用指令库的 Issue 分类、分支命名、PR 标题与关联约定。完整规则、分支正则和示例在[指令库的贡献指南](https://github.com/chrono-harness/chrono-harness-instructions/blob/dev/docs/contributing.md)。开始工作时，从负责仓的 `AGENTS.md` 读取该仓选用的规则与检查命令。

## 事项归属和排期

产品事项在负责仓建立。跨仓目标在入口仓的路线图关联各产品的事项，由各仓交付和验收。网页表单带入所选类别的主标签，CLI 和 API 使用同一套标签。排期使用 GitHub Milestone。路线图用 P0 表示当前故障或交付阻塞，P1 表示缺少的能力，P2 表示依赖上游交付的验收。正文给出阻塞关系。

发布工作流按运行 ID 管理 `release-failure` 事项。同次运行重试成功由工作流关闭，后续版本修复时引用原故障单和成功运行。正文首个运行标记供工作流定位该事项。

## 开发与发行分支

各产品独立维护 `dev` 和 `main`。日常 PR 进入 `dev`。需要集成验收的变更先合入短期 `integration/` 分支，再向 `dev` 提 PR。已验收的正式版本按各仓发布流程晋升到 `main`。各仓分支保护决定必需检查和可用的合并方式。示例仓的长期配置分支各自承担登记的验收用途。

## 更新组织路线图

跨仓工作优先复用[置顶路线图](https://github.com/chrono-harness/chrono-harness-main/issues/15)中链接的负责事项。子事项开关由 GitHub 自动展示。某个 SPEC 场景取得验收、原有验收失效，或当前优先工作改变时，在同次交付中更新置顶 Issue 正文的进度、日期、当前工作和下一步，并链接负责仓的原始结果。验收数字取自 93 项逐行矩阵。
