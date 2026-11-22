# Chrono Harness

Chrono Harness 为项目提供按变更运行检查、协调工作树和安装工具的命令。这个主仓负责用户入口、兼容版本和组合安装。各组件负责自己的代码、测试和发布。

组织内的仓库统一使用 `chrono-harness-<业务名>`。本仓为 `chrono-harness-main`，执行检查的组件为 `chrono-harness-runner`。

## 组件归属

| 仓库 | 职责 |
| --- | --- |
| [chrono-harness-runner](https://github.com/chrono-harness/chrono-harness-runner) | 执行检查、管理子进程并发布检查报告 |
| [chrono-harness-identifiers](https://github.com/chrono-harness/chrono-harness-identifiers) | 校验标识符，供运行代码与形式证明共用 |
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

Python 业务和它的 CI 在独立的 [chrono-harness-example](https://github.com/chrono-harness/chrono-harness-example)。

本次拆分固定在原仓提交 `5f6892d`。20 个生产组件各自维护源码、专属测试和适用的 Verus 检查。基线登记的 38 个生产证明入口和 40 个测试证明入口均可在对应仓库的 `check.sh` 中找到。跨组件测试按业务选择断言；旧宿主的集成流程、运行记录和外部示例继续由原地址保管。[原仓固定版本](https://github.com/ChronoAIProject/chrono-harness/tree/5f6892dfa2f73675a84e4ebdc3b06eb83b824d6e)

## 运行产物

| 业务目录或产物 | 消费者 | 存放与回收 |
| --- | --- | --- |
| 组件检查与组合编译 | Rust 测试、Verus、打包命令 | 各检查在临时目录构建，正常退出时删除。主仓安装器每次单独创建编译目录。 |
| 工作树内的构建输出、工具链接、检查报告 | 正在运行的任务与汇总检查 | 示例的业务目录由 worktree 管理，删除窗口为 24 小时。需要长期保存的数据应在窗口内提交或转存。 |
| GitHub Actions 的检查证据和跨平台中间包 | 汇总作业、发行作业 | 上传时设置保留期 1 天。 |
| 已采用的平台二进制 | 安装器、示例宿主 | 带版本的制品和摘要保存在 GitHub Releases。工具安装到工作树外的共享目录。 |
| 日志与 PR 操作记录 | 诊断程序、PR 状态查询 | diagnostics 提供滚动日志。PR 记录受调用宿主的保留政策和维护执行约束。 |

工作树创建时刻为 T，删除窗口为 W。若工作树已经登记、所有临时目录均允许处置、占用者已退出，并且在 T + W 后完成清理所需的维护轮次，维护程序可以删除工作树并保全 Git 提交。若维护停止，或者仍有受保护文件，单有时间流逝不足以保证删除。macOS 的 launchd 定时验收使用已发布的 `chrono-worktree` 和示例政策，验收时将复用和删除门槛分别设为 1 秒和 2 秒。连续三轮维护均完成。第一轮已删除含 8 KiB 缓存的业务工作树，任务分支仍指向原提交。

长期使用该示例的机器可用操作系统调度维护。比如用户 crontab 的下列条目每小时运行一次，把路径替换为主检出的绝对路径。程序在已登记的目录内保存本轮报告，标准错误沿用 cron 的投递配置。

```cron
0 * * * * cd "/absolute/path/to/chrono-harness-example" && .chrono-harness/bin/chrono-worktree maintain >/dev/null
```

跨所有宿主、所有输出的最终删除仍缺少无条件证明。

## 安装

安装 Rust 1.95.0 后，从本仓运行 `./install.sh`。安装器从 [tools.lock](tools.lock) 的固定提交构建命令，默认放入 Cargo 安装目录。用 `CARGO_INSTALL_ROOT` 指定工作树以外的共享位置。验证旧组合时，检出相应的主仓版本，选一个独立的安装目录并运行同一脚本。将该目录的 bin 加入 PATH 即可使用相应版本。

## 平台包

主仓从同一份工具清单构建 macOS arm64 和 Linux x86_64 平台包。带 v 前缀的发布标签触发构建，两个平台都通过后才发布预览版。构建中间件保留 1 天，最终二进制和校验清单放在 GitHub Releases。在工作树以外创建共享安装目录，供各任务调用。

[双平台预览发行](https://github.com/chrono-harness/chrono-harness-main/releases/tag/v0.1.0-alpha.1)包含 18 个命令。[示例宿主的业务变更验收](https://github.com/chrono-harness/chrono-harness-example/actions/runs/45036350220)运行了 Python 单元与汇总作业。
