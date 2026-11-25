# Chrono Harness

**[项目路线图与进度](https://github.com/chrono-harness/chrono-harness-main/issues/15)** · 查看本轮目标、已验收场景、当前工作和下一步。

从这里为项目接入 Chrono Harness，或找到负责某项功能的开发仓库。

## 在自己的项目中使用

创建新仓库可以直接点击 [Use this template](https://github.com/chrono-harness/chrono-harness-template/generate)。新仓的根指南包含基础规则，首次检出按 README 运行安装。

已有项目可以直接使用 Copier。准备好 Git、uv 和 mise，在项目根目录执行以下命令。Copier 会询问 GitHub 仓库名并记录所选模板版本。默认安装各工具的已发布命令、Rust 和 Verus。按空格可以取消本项目用不到的选项，也可以全部取消。

```sh
uvx --from copier==9.19.1 copier copy --prereleases gh:chrono-harness/chrono-harness-copier .
mise trust
mise run harness-setup
```

绿色模板默认安装最新公开测试版。已有项目使用 Copier 的默认选项时安装配方固定的版本。安装通道适用于任意分支和直接检出的提交。要只在本次安装选择正式版，运行 `CHRONO_TOOL_CHANNEL=stable mise run harness-setup`。使用 `preview` 可选择最新测试版，也可指定完整发行标签。每个选中的组织工具都需要有对应的公开发行。默认工具正式版的发布进度见[项目路线图](https://github.com/chrono-harness/chrono-harness-main/issues/15)。

逐工具选版需要 Copier 模板 v0.1.34 或更新版。已采用旧模板的项目先更新模板。要混合使用多个版本，可在 Copier 中设置 `tool_install_channels=preview`，并为 `tool_versions` 填写 `{"chrono-pr":"stable","chrono-diagnostics":"v0.1.0"}`。这样 `chrono-pr` 跟随最新正式版，`chrono-diagnostics` 固定在指定标签，其余已选工具跟随最新测试版。本次命令的 `CHRONO_TOOL_CHANNEL` 优先于这些选择。运行 `mise current` 查看实际安装版本，再从根目录的 `AGENTS.md` 或 `CLAUDE.md` 开始工作。[绿色模板的完整命令](https://github.com/chrono-harness/chrono-harness-template/blob/dev/.chrono-harness/USAGE.md#保存各工具的版本选择) · [Copier 选装与更新](https://github.com/chrono-harness/chrono-harness-copier)

## 开发组件

按下表找到负责该功能的仓库，从其默认分支 `dev` 单独检出。根指南给出本仓的安装和验证命令，修改也向该仓的 `dev` 提 PR。各工具仓单独发布发行包，`main` 分支用于正式版。要查看业务项目怎样接入并运行 CI，可以从 Python 示例的工作流开始。[业务示例](https://github.com/chrono-harness/chrono-harness-example)

## 从 Issue 到正式版

新事项怎样分类、分支和 PR 怎样命名，以及何时关闭 Issue，见[组织协作规范](docs/contributing.md)。

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

### 在 GitHub 上识别参与工作的 agent

打开 Issue 或 PR，在事件署名行可以看到执行该动作的 agent、完整会话 UUID 和模型。同一项工作可以有多个会话。可在本组织的真实记录里对照[根会话](https://github.com/chrono-harness/chrono-harness-instructions/issues/48#issuecomment-7159796617)和[子会话](https://github.com/chrono-harness/chrono-harness-instructions/issues/48#issuecomment-7159782902)。

在采用模板的宿主中，可用已安装的命令从原始 PR 正文读取事件。

```sh
gh api "repos/$OWNER/$REPO/pulls/$NUMBER" |
  jq -j .body | mise exec -- chrono-instructions event-read
```

事件写法、字段、正则和历史版本由[指令库的 GitHub 工作事件规范](https://github.com/chrono-harness/chrono-harness-instructions/blob/dev/README.md#github-工作事件)维护。宿主在 `.chrono-harness/rules.json` 选用规则，运行 `mise run harness-setup` 后可从根指南直接阅读所选正文。

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

### 工具和证明的依赖在哪里改

Copier 的 `copier.yml` 按选装项登记需要安装的命令。更新上游安装依赖时改这一份表。宿主用 Copier 更新并提交自己的选项。在任意分支或直接检出提交时，`stable` 和 `preview` 都在每次安装时解析。要固定单个工具，在 `tool_versions` 中填写该工具的精确发行标签。Rust 和 Verus 使用依赖表中配套的版本。例如只选 `verus` 会装入配套的 Rust 和 Verus，同时选 `judge-ci` 会合并这两项所需的工具。新项目从绿色模板按钮取得已生成的文件。[上游依赖表](https://github.com/chrono-harness/chrono-harness-copier/blob/v0.1.34/copier.yml) · [独立示例的升级](https://github.com/chrono-harness/chrono-harness-example/pull/125)

产品仓负责本仓的包依赖和验证。runner 的六个包共用仓库根的 `Cargo.toml` 和 `Cargo.lock`。修改共用依赖时在 `[workspace.dependencies]` 改一次，原生构建、原生测试和 cargo-verus 使用同一解析结果。登记证明的包和目标后，bootstrap 收取各目标的原始报告、编译器依赖记录及库。其他仓经公开发行和协议调用 runner 与 bootstrap。[runner 的 Cargo workspace](https://github.com/chrono-harness/chrono-harness-runner/blob/98cbe243227e8cabb958d1dbebb207241972ea21/Cargo.toml) · [共享证明包验收](https://github.com/chrono-harness/chrono-harness-host-bootstrap/issues/20#issuecomment-7133353314) · [组织形式化覆盖](https://github.com/chrono-harness/chrono-harness-judge-projects/issues/23)

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

## 独立构建与发行

组织上轮审计核对了 25 个仓库、41 份 Cargo 清单，跨仓生产源码依赖从 50 条减至 0 条。工具通过各自的发行包、公开命令和版本化输入输出协作。[固定版本源码审计](https://github.com/chrono-harness/chrono-harness-runner/issues/1#issuecomment-7122055493) · [下游采用验收](https://github.com/chrono-harness/chrono-harness-runner/issues/1#issuecomment-7122569983)

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
               +-- 业务事件 --> worktree 独占维护 --> diagnostics 回收过期日志并报告结果
```

`chrono-pr` 每次远端查询都读取 GitHub。它在本地记录本工作树中由自己打开的 PR。查到关闭或合并时移除提醒，每次使用命令也会清除创建满 30 天的提醒。[PR 工具](https://github.com/chrono-harness/chrono-harness-pr#readme)

主仓的维护由业务事件唤醒。每个协调者只让一个进程执行维护，处理完队列就退出。到期只改变产物的删除资格。租约已释放、源码已保全的产物在下一次成功处理它的轮次回收。如果机器长期没有业务事件，也没有显式维护，实际占用可以超过保留窗口。[固定维护合同](https://github.com/ChronoAIProject/chrono-harness/blob/f619e1c48f332429e53f30cddc5ab77dff048bdb/SPEC.md#L1483)

拆仓后的工作树工具、事件发送端和示例宿主正在采用这个合同。示例之前在 macOS、Linux 上验证过用每小时任务清理闲置树和缓存。各宿主的迁移验收仍需核对实际触发者、独占租约、最后一个读者退出后的物理回收，以及有价值的原件在窗口内转存后可读回。[工作树服务](https://github.com/chrono-harness/chrono-harness-worktree/issues/62) · [事件发送端](https://github.com/chrono-harness/chrono-harness-runner/issues/109) · [示例宿主](https://github.com/chrono-harness/chrono-harness-example/issues/222)

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
