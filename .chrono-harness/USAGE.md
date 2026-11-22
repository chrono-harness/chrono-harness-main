# chrono-harness-main 使用说明

本仓维护组织组件索引和历史发行链接。

开发分支为 `dev`。日常 PR 合入开发分支，正式版从 `main` 发布。

首次检出运行 `mise trust` 和 `mise run harness-setup`。工具版本见 [.config/mise/conf.d/chrono-harness.toml](../.config/mise/conf.d/chrono-harness.toml)。

开始每项任务时运行 `mise exec -- chrono-instructions rules --host-root .`，读取并遵循标准输出中的上游规则。完整规则和本仓开发步骤见根 [CLAUDE.md](../CLAUDE.md)。

业务检查使用 `mise run harness-check`。

用 `mise exec -- chrono-pr pr-reminders` 查看本地提醒，再运行 `mise exec -- chrono-pr pr-status --pr NUMBER --head-sha SHA` 查询 GitHub。

## 本仓验证

[README.md](../README.md) 维护组件索引与历史发行链接。运行 `mise run harness-check` 读取本仓接纳的上游规则。工具实现及发布在对应工具仓进行。
