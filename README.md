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

## 运行产物

共享工具安装一次。宿主应将每项任务的构建输出、PR 状态、报告和临时文件放在调用工作树中。业务目录的目标保留窗口为 24 小时。各组件迁入时保留了自己的输出合同，定时回收需要宿主配置与实际运行验证。日志按配置滚动。跨任务需要的发布物由发布仓保存，并由使用方核验固定版本。

## 安装

安装 Rust 1.95.0 后，从本仓运行 `./install.sh`。安装器从 [tools.lock](tools.lock) 的固定提交构建命令，默认放入 Cargo 安装目录。用 `CARGO_INSTALL_ROOT` 指定工作树以外的共享位置。验证旧组合时，检出相应的主仓版本，选一个独立的安装目录并运行同一脚本。将该目录的 bin 加入 PATH 即可使用相应版本。

## 平台包

主仓从同一份工具清单构建 macOS arm64 和 Linux x86_64 平台包。带 v 前缀的发布标签触发构建，两个平台都通过后才发布预览版。构建中间件保留 1 天，最终二进制和校验清单放在 GitHub Releases。在工作树以外创建共享安装目录，供各任务调用。
