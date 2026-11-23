# Chrono Harness

从这里为项目接入 Chrono Harness，或找到负责某项功能的开发仓库。

## 在自己的项目中使用

准备好 Git、uv 和 mise，在项目根目录执行以下命令。Copier 会询问 GitHub 仓库名并记录所选模板版本。保留默认选择会安装 20 个 Chrono 命令、Rust 和 Verus。按空格可以取消本项目用不到的选项，也可以全部取消。

```sh
uvx --from copier==9.19.1 copier copy --prereleases gh:chrono-harness/chrono-harness-template .
mise trust
mise run harness-setup
```

安装后，从根目录的 `AGENTS.md` 或 `CLAUDE.md` 开始工作。项目自己的工具选择保存在 `.chrono-harness/template-answers.yml`，mise 按项目记录的版本和 SHA-256 安装各工具。调整选项或升级已有项目时，使用模板的 Copier 更新命令。[模板与更新说明](https://github.com/chrono-harness/chrono-harness-template)

## 开发组件

按下表找到负责该功能的仓库，从其默认分支 `dev` 单独检出。根指南给出本仓的安装和验证命令，修改也向该仓的 `dev` 提 PR。各工具仓单独发布发行包，`main` 分支用于正式版。要查看业务项目怎样接入并运行 CI，可以从 Python 示例的工作流开始。[业务示例](https://github.com/chrono-harness/chrono-harness-example)

部分组件的 Cargo 构建仍会拉取组织内其他仓库的源码。修改组件前，可以在拆分计划中查到它的使用方、当前源码依赖和已验收的独立发行。[组件拆分进度与验收记录](https://github.com/chrono-harness/chrono-harness-runner/issues/1)

## 组件归属

| 仓库 | 职责 |
| --- | --- |
| [chrono-harness-runner](https://github.com/chrono-harness/chrono-harness-runner) | 执行检查、管理子进程、发布检查报告，维护标识符校验及其证明 |
| [chrono-harness-diagnostics](https://github.com/chrono-harness/chrono-harness-diagnostics) | 结构化错误和滚动日志 |
| [chrono-harness-test-git](https://github.com/chrono-harness/chrono-harness-test-git) | 供组件测试使用的 Git 命令替身 |
| [chrono-harness-pr](https://github.com/chrono-harness/chrono-harness-pr) | 读取及操作绑定指定提交的 GitHub PR |
| [chrono-harness-cache](https://github.com/chrono-harness/chrono-harness-cache) | 计划、恢复和封存缓存 |
| [chrono-harness-instructions](https://github.com/chrono-harness/chrono-harness-instructions) | 生成宿主指南并提供默认规则和许可 |
| [chrono-harness-distribution](https://github.com/chrono-harness/chrono-harness-distribution) | 打包、组合、校验及安装平台发布物 |
| [chrono-harness-judge-registration](https://github.com/chrono-harness/chrono-harness-judge-registration) | 验证登记、执行方法和消费合同 |
| [chrono-harness-judge-mixed](https://github.com/chrono-harness/chrono-harness-judge-mixed) | 识别规则和产品的混合变更 |
| [chrono-harness-judge-filemap](https://github.com/chrono-harness/chrono-harness-judge-filemap) | 根据登记图计算变更影响和必须运行的测试 |
| [chrono-harness-judge-routes](https://github.com/chrono-harness/chrono-harness-judge-routes) | 将测试义务解析为已登记的方法与工具 |
| [chrono-harness-judge-cost](https://github.com/chrono-harness/chrono-harness-judge-cost) | 比较变更前后的声明成本 |
| [chrono-harness-judge-projects](https://github.com/chrono-harness/chrono-harness-judge-projects) | 执行选定项目的构建和测试并核验回执 |
| [chrono-harness-judge-workflow](https://github.com/chrono-harness/chrono-harness-judge-workflow) | 判断分支、集成证据与退役条件 |
| [chrono-harness-inputs](https://github.com/chrono-harness/chrono-harness-inputs) | 从固定版本读取检查输入 |
| [chrono-harness-judge-ci](https://github.com/chrono-harness/chrono-harness-judge-ci) | 核对执行单元的原始结果并汇总 CI 状态 |
| [chrono-harness-ci](https://github.com/chrono-harness/chrono-harness-ci) | 生成宿主 CI 工作流并计算执行范围 |
| [chrono-harness-worktree](https://github.com/chrono-harness/chrono-harness-worktree) | 创建、管理与清理任务工作树 |
| [chrono-harness-host-bootstrap](https://github.com/chrono-harness/chrono-harness-host-bootstrap) | 按配方准备宿主工具 |
| [chrono-harness-host-release](https://github.com/chrono-harness/chrono-harness-host-release) | 构建和发布宿主平台包 |

标识符的现役实现、测试和证明归 runner 维护。需要复现旧版本时，可以读取 identifiers 仓库保留的固定提交。[标识符迁移说明](https://github.com/chrono-harness/chrono-harness-identifiers)

本次拆分固定在原仓提交 `5f6892d`。20 个生产组件各自维护源码、专属测试和适用的 Verus 检查。基线登记的 38 个生产证明入口和 40 个测试证明入口均可在对应仓库的 `check.sh` 中找到。跨组件测试按业务选择断言；旧宿主的集成流程、运行记录和外部示例继续由原地址保管。[原仓固定版本](https://github.com/ChronoAIProject/chrono-harness/tree/5f6892dfa2f73675a84e4ebdc3b06eb83b824d6e)

## 历史发行

[组合预览版 v0.1.0-alpha.1](https://github.com/chrono-harness/chrono-harness-main/releases/tag/v0.1.0-alpha.1) 保有原来的两平台二进制、清单与校验值。新项目和现有项目都可以采用仓库模板。
