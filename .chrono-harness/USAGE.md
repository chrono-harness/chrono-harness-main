# chrono-harness-main 使用说明

本仓是 Chrono Harness 用户与开发者的入口，维护项目接入步骤、组件索引和历史发行链接。

开发分支为 `dev`，正式分支为 `main`。本仓选装 `cache`、`ci`、`distribution`、`harness`、`host-bootstrap`、`host-release`、`inputs`、`instructions`、`judge-ci`、`judge-cost`、`judge-filemap`、`judge-mixed`、`judge-projects`、`registration`、`judge-routes`、`judge-workflow`、`pr`、`test-git`、`worktree`、`verus`。

[组织协作规范](https://github.com/chrono-harness/chrono-harness-instructions/blob/dev/docs/contributing.md)

首次检出运行 `mise trust` 和 `mise run harness-setup`。工具版本见 [.config/mise/conf.d/chrono-harness.toml](../.config/mise/conf.d/chrono-harness.toml)。

刷新根指南使用 `mise run harness-setup`。`.chrono-harness/rules.json` 可用 `all` 配合 `exclude`，或 `only` 配合 `include` 逐项选择规则 ID，`off` 关闭继承。

业务检查使用 `mise run harness-check`。

用 `mise exec -- chrono-pr pr-reminders` 查看本地提醒，再运行 `mise exec -- chrono-pr pr-status --pr NUMBER --head-sha SHA` 查询 GitHub。

## 本仓验证

[README.md](../README.md) 提供项目接入步骤、组件开发入口和历史发行链接。运行 `mise run harness-check` 读取本仓接纳的上游规则。工具实现及发布在对应工具仓进行。
