# 仓库工作说明

工作前阅读本仓的[公共约定和工具入口](.chrono-harness/USAGE.md)。产品职责见本仓 README。

## 本仓开发

本仓维护历史组合发行的 [`tools.lock`](tools.lock)、[`install.sh`](install.sh) 与 [`package.sh`](package.sh)。打包参数及两个平台的验收步骤见 [`.github/workflows/package.yml`](.github/workflows/package.yml)。各工具的开发、安装及发版入口由对应工具仓维护。
