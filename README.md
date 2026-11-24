# Chrono Harness

从这里为项目接入 Chrono Harness，或找到负责某项功能的开发仓库。

## 在自己的项目中使用

创建新仓库可以直接点击 [Use this template](https://github.com/chrono-harness/chrono-harness-template/generate)。新仓的根指南包含基础规则，首次检出按 README 运行安装。

已有项目可以直接使用 Copier。准备好 Git、uv 和 mise，在项目根目录执行以下命令。Copier 会询问 GitHub 仓库名并记录所选模板版本。默认安装各工具的已发布命令、Rust 和 Verus。按空格可以取消本项目用不到的选项，也可以全部取消。

```sh
uvx --from copier==9.19.1 copier copy --prereleases gh:chrono-harness/chrono-harness-copier .
mise trust
mise run harness-setup
```

安装后，从根目录的 `AGENTS.md` 或 `CLAUDE.md` 开始工作。项目自己的工具选择保存在 `.chrono-harness/template-answers.yml`，mise 按项目记录的版本和 SHA-256 安装各工具。调整选项或升级已有项目时，使用模板的 Copier 更新命令。[Copier 选装与更新](https://github.com/chrono-harness/chrono-harness-copier)

## 开发组件

按下表找到负责该功能的仓库，从其默认分支 `dev` 单独检出。根指南给出本仓的安装和验证命令，修改也向该仓的 `dev` 提 PR。各工具仓单独发布发行包，`main` 分支用于正式版。要查看业务项目怎样接入并运行 CI，可以从 Python 示例的工作流开始。[业务示例](https://github.com/chrono-harness/chrono-harness-example)

## 从 Issue 到正式版

在负责产品的仓库开 Issue。仓库的 **Issues → Milestones** 显示目标版本和仍开放的事项。跨仓目标可以将各产品自己的 Issue 登记为子事项，GitHub 会从它们的实际开关状态计算进度。[Copier 路线图](https://github.com/chrono-harness/chrono-harness-copier/issues/6) · [chrono-pr 发行试点](https://github.com/chrono-harness/chrono-harness-pr/issues/5)

```text
Issue --> 本仓版本里程碑 --> PR 合入 dev --> 本仓检查通过
                                                |
                                                v
                                       本产品的测试版 Release
                                                |
                              两平台安装和校验 + 真实下游使用
                                                |
                                                v
                                同一候选晋升 main --> 正式版
                                                |
                              正式版已公开且事项完成 --> 关闭里程碑
```

模板的路线图工作流从本仓版本计划和 GitHub Releases 更新里程碑。每个产品单独采用发布自动化；chrono-pr 试点跟踪从 dev 自动创建预览、验证真实下游和晋升 main 的实施情况。

## 仓库如何配合

图中仓库名省略了 `chrono-harness-` 前缀。业务仓和工具仓都可以独立采用模板。

```text
main
  +-- 新项目 ----> template (Use this template) --+
  +-- 已有项目 --> copier (选择工具、更新) --------+--> 宿主仓库
  |                                      +-- AGENTS.md -> CLAUDE.md
  |                                      |                ^ 本仓选择的上游规则
  |                                      +-- mise 工具版本和 SHA-256
  |                                      |       |
  |                                      |       +--> 从各工具的 Release 安装
  |                                      +-- 项目源码、登记和本仓检查
  |
  +-- 开发组件 --> 工具仓 dev --> 本仓 PR、测试和证明 --> 本仓 Release
```

模板的根指南和使用说明都链接回本入口。默认选装全部工具，宿主可以关闭某些工具、按 ID 选择基础规则并追加本地指令。`instructions` 在宿主执行 `harness-setup` 时同步被选中的上游规则。

在 Python 示例仓，`chrono-ci detect` 根据固定 Git 提交和宿主登记选择执行单元。单元调用 runner 的 `chrono-harness check`。CI 判官从各工具的公开命令读取所需数据。下图中的连线表示一次 PR 的实际调用或产物交接。[示例工作流](https://github.com/chrono-harness/chrono-harness-example/blob/1c5f98e72f964b9fd2a19bad18de55ecaadc6a74/.github/workflows/chrono-ci.yml) · [CI 判官的已安装工具接口](https://github.com/chrono-harness/chrono-harness-judge-ci/blob/2611c5f34b261b783c56d837a6d2d7a1a335136f/README.md)

```text
PR
 +--> chrono-ci detect --> 选中 example 或 harness 单元，也可同时选中
                              |
                              v
                     chrono-harness check --unit
                              |
                              v
                           judge-ci
                              +--> judge-filemap        根据登记计算影响范围
                              +--> judge-registration   读取两端的测试绑定
                              +--> judge-routes         准备执行计划
                              +--> judge-projects       核对配对、执行、返回回执
                                                        |
      GitHub 汇总作业 <--- 单元原件（保留 1 天） <---------+
             |
             +--> chrono-harness check --collect --> PR 检查结果
```

需要核对变更成本和规则变更的宿主还可以采用下列命令。FILEMAP 的影响报告和 cost 的成本报告都绑定固定的 Git 端点。mixed 在求值前检查两个报告的来源，任一缺失或绑定不匹配时报告错误。示例已逐项安装、升级和回退这些工具。[成本消费](https://github.com/chrono-harness/chrono-harness-example/pull/41) · [mixed 消费](https://github.com/chrono-harness/chrono-harness-example/pull/42)

```text
宿主变更 --> FILEMAP --> 影响报告 --+--> cost --> 成本报告 --+
                                    |                       |
                                    +-----------------------+--> mixed
```

在执行计划中，routes 负责校验并发上限、优先顺序及计划身份。projects 从已安装的 routes 查询计划，按上限并行运行操作，避开共享资源与重叠的输出路径。宿主分别固定这两个工具的发行。[示例执行与回退](https://github.com/chrono-harness/chrono-harness-example/pull/43)

## 独立化方向

部分工具构建时仍从 runner、judge-registration 或 diagnostics 拉取 Rust 源码。按真实使用方逐条迁移。有独立用途的工具保留公开命令和版本化输入输出。只服务于一个产品的实现、测试和证明归入该产品。[当前依赖清单与迁移验收](https://github.com/chrono-harness/chrono-harness-runner/issues/1)

```text
工具 A 单独检出 + 第三方依赖
    --> 构建、原生测试和适用证明
    --> A 的版本及各平台校验值
    --> 宿主仅升级 A --> 真实业务调用 --> 单独回退 A
```

每条迁移以实际下游验收。固定其他工具版本且 main 缺席时，维护者仍须能交付 A，用户仍须能安装、使用及回退 A。

## 产物放在哪里

工具通过 mise 安装在工作树外。项目的源码、工具选择和规则选择提交至 Git。任务中断后，从 Git 重新检出即可开始新任务。下图是各宿主迁移临时产物时的目标布局。

```text
发布作业 --> 工具仓 Release --> 校验下载 --> 工作树外的工具安装目录

业务仓 Git --> 任务 worktree
                 +-- 构建目录 --> 测试或发布作业 --> 到期随 worktree 回收
                 +-- 检查报告 --> CI 汇总    --> 到期随 worktree 回收
                 |                |
                 |                +-- 需要长期查阅 --> 窗口内转存到指定存储
                 +-- PR 提醒 --> agent 查看 --> 终态、过期或 worktree 回收

运行日志 --> 宿主选择的日志目录
               ^
               +-- worktree 定时维护 --> diagnostics 回收过期日志并报告结果
```

`chrono-pr` 每次远端查询都读取 GitHub。它在本地记录本工作树中由自己打开的 PR。查到关闭或合并时移除提醒，每次使用命令也会清除创建满 30 天的提醒。[PR 工具](https://github.com/chrono-harness/chrono-harness-pr#readme)

示例的开发机按主检出安装一个用户定时器。macOS 用 launchd，Linux 用 systemd，均按小时运行 `chrono-worktree maintain`。示例的工作树删除窗口为 24 小时；两个平台都已用缩短的窗口验证定时任务能回收闲置树及缓存。Linux 验收还核对了持久启用链接。清理仍取决于机器与用户服务运行、租约释放、源码保全及文件系统操作成功。[示例部署与卸载](https://github.com/chrono-harness/chrono-harness-example/blob/1c5f98e72f964b9fd2a19bad18de55ecaadc6a74/README.md#为开发机的主检出启用定时清理) · [工作树期限的证明范围](https://github.com/chrono-harness/chrono-harness-worktree/pull/7)

每个业务目录仍需核对写入程序、实际读取者、保留时长和负责删除的程序。宿主验收应覆盖最后一次写入后工具再也没有启动的情形。要给出最晚清理时间，还需要验证到期工作树最终释放、清理程序按期运行并成功删除，以及长期产物在窗口内已由接收方读回。各宿主的全量回收证明仍待完成。

示例启用文件日志时，worktree 调用宿主安装的 `chrono-diagnostics expire-logs-v1`。该命令按日志策略回收过期文件，并向维护进程返回删除数量、占用或具体的失败路径。macOS 和 Ubuntu 均用已发布的 runner 写入日志、用独立发行完成了回收与错误验收。[双平台运行](https://github.com/chrono-harness/chrono-harness-example/actions/runs/45243841345) · [示例采用](https://github.com/chrono-harness/chrono-harness-example/pull/38)

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
| [chrono-harness-judge-registration](https://github.com/chrono-harness/chrono-harness-judge-registration) | 验证登记、执行方法和输入合同 |
| [chrono-harness-judge-mixed](https://github.com/chrono-harness/chrono-harness-judge-mixed) | 识别规则和产品的混合变更 |
| [chrono-harness-judge-filemap](https://github.com/chrono-harness/chrono-harness-judge-filemap) | 根据登记图计算变更影响和必须运行的测试 |
| [chrono-harness-judge-routes](https://github.com/chrono-harness/chrono-harness-judge-routes) | 将测试义务解析为已登记的方法与工具 |
| [chrono-harness-judge-cost](https://github.com/chrono-harness/chrono-harness-judge-cost) | 比较变更前后的声明成本 |
| [chrono-harness-judge-projects](https://github.com/chrono-harness/chrono-harness-judge-projects) | 执行选定项目的构建和测试并核验回执 |
| [chrono-harness-judge-workflow](https://github.com/chrono-harness/chrono-harness-judge-workflow) | 判断分支、集成证据与退役条件 |
| [chrono-harness-inputs](https://github.com/chrono-harness/chrono-harness-inputs) | 从固定版本读取检查输入 |
| [chrono-harness-judge-ci](https://github.com/chrono-harness/chrono-harness-judge-ci) | 核对启动产物的消费关系、执行单元的原始结果并汇总 CI 状态 |
| [chrono-harness-ci](https://github.com/chrono-harness/chrono-harness-ci) | 生成宿主 CI 工作流并计算执行范围 |
| [chrono-harness-worktree](https://github.com/chrono-harness/chrono-harness-worktree) | 创建、管理与清理任务工作树 |
| [chrono-harness-host-bootstrap](https://github.com/chrono-harness/chrono-harness-host-bootstrap) | 按配方准备宿主工具 |
| [chrono-harness-host-release](https://github.com/chrono-harness/chrono-harness-host-release) | 构建和发布宿主平台包 |

标识符的现役实现、测试和证明归 runner 维护。需要复现旧版本时，可以读取 identifiers 仓库保留的固定提交。[标识符迁移说明](https://github.com/chrono-harness/chrono-harness-identifiers)

本次拆分固定在原仓提交 `5f6892d`。20 个生产组件各自维护源码、专属测试和适用的 Verus 检查。基线登记的 38 个生产证明入口和 40 个测试证明入口均可在对应仓库的 `check.sh` 中找到。跨组件测试按业务选择断言；旧宿主的集成流程、运行记录和外部示例继续由原地址保管。[原仓固定版本](https://github.com/ChronoAIProject/chrono-harness/tree/5f6892dfa2f73675a84e4ebdc3b06eb83b824d6e)

## 历史发行

[组合预览版 v0.1.0-alpha.1](https://github.com/chrono-harness/chrono-harness-main/releases/tag/v0.1.0-alpha.1) 保有原来的两平台二进制、清单与校验值。新项目和现有项目都可以采用仓库模板。
