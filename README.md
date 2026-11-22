# Chrono Harness

Chrono Harness 为项目提供按变更运行检查、协调工作树和安装工具的命令。这个主仓负责用户入口、兼容版本和组合安装。各组件负责自己的代码、测试和发布。

组织内的仓库统一使用 `chrono-harness-<业务名>`。本仓为 `chrono-harness-main`，执行检查的组件为 `chrono-harness-runner`。

## 迁移顺序

| 批次 | 组件与使用方 | 验收 |
| --- | --- | --- |
| 1 | diagnostics 提供结构化错误和滚动日志。identifiers 提供运行代码和形式证明共用的标识符判定。 | 分别独立构建，运行完整专属测试和证明，接入 runner。 |
| 2 | runner 提供进程执行与 check 入口，多个工具依赖其库。 | 固定第一批库的版本，运行实际 check，核对退出和报告。 |
| 3 | pr、cache、distribution、instructions 各有独立命令。安装脚本归 distribution，默认规则、生成资产及来源许可归 instructions。 | 各工具从干净检出构建，验证打开或查看 PR、缓存计划、包安装及指令生成。 |
| 4 | registration、mixed、filemap、routes、projects、cost、workflow 分别负责登记、混合变更、影响、路由、执行、成本与流程。inputs 读取其中的登记、影响和路由结果。 | 按依赖顺序固定接口，迁入各自测试及证明，验证上下游对成功和失败的处理。 |
| 5 | ci 和 judge-ci 负责 CI 生成与汇总。worktree 负责工作树生命周期。 | 在真实宿主运行生成的 CI；验证独立工作树创建、使用、删除及到期清理。 |
| 6 | host-bootstrap、host-release 负责本组织的工具准备及版本发布。 | 验证平台包安装、发布和固定版本回退，迁移外部示例的下载入口。 |

## 运行产物

共享工具安装一次。每项任务的构建输出、PR 状态、报告和临时文件归调用它的工作树，随工作树清理；仍存在的工作树按创建时配置的窗口清理，初始采用 24 小时。日志按配置滚动。跨任务需要的发布物由发布仓保存，并由使用方核验固定版本。

## 安装当前组合

安装 Rust 1.95.0 后，在本仓检出中运行 `./install.sh`。Cargo 将命令安装在自身的安装目录中，可用 `CARGO_INSTALL_ROOT` 指定其他目录。工具仓库及源码提交由 [tools.lock](tools.lock) 固定。检出上一组合版本并重新运行安装命令即可切回相应版本。

| 仓库 | 提供的内容 |
| --- | --- |
| [chrono-harness-runner](https://github.com/chrono-harness/chrono-harness-runner) | `chrono-harness` 检查命令和 Rust 库 |
| [chrono-harness-pr](https://github.com/chrono-harness/chrono-harness-pr) | `chrono-pr` |
| [chrono-harness-cache](https://github.com/chrono-harness/chrono-harness-cache) | `chrono-cache` |
| [chrono-harness-instructions](https://github.com/chrono-harness/chrono-harness-instructions) | `chrono-instructions` 与生成资产的来源、许可 |
| [chrono-harness-distribution](https://github.com/chrono-harness/chrono-harness-distribution) | `chrono-distribution` |
| [chrono-harness-diagnostics](https://github.com/chrono-harness/chrono-harness-diagnostics) | 结构化错误与滚动日志库 |
| [chrono-harness-identifiers](https://github.com/chrono-harness/chrono-harness-identifiers) | 标识符校验库及形式证明 |

判官、CI、工作树和正式平台安装包仍在迁移。
