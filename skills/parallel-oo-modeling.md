---
name: parallel-oo-modeling
description: Launch parallel oo-modeler agents for each feature group with git worktree isolation. Use after story-dependency-analysis to enable parallel design work.
tools: Read, Bash, Task, Glob
---

# Skill: parallel-oo-modeling

## Purpose
为每个并行开发组启动独立的 oo-modeler agent，每个 agent 在独立的 git worktree 中工作，实现真正的并行设计。

## When to Use
- ✅ 在 story-dependency-analysis 完成之后
- ✅ 在需要并行进行对象设计时
- ✅ 当有多个 feature 分支需要同时开发时

## Prerequisites
- parallel-strategy.md 已创建
- parallel-groups/ 目录已创建
- Git 仓库已初始化
- 主分支（main/master）状态干净

## Workflow

### Step 1: 读取并行开发策略
```javascript
Read("requirements/current/parallel-strategy.md")
```

解析出所有的并行组和 feature 分支名称。

### Step 2: 验证 Git 状态
```bash
# 检查是否在 git 仓库中
git rev-parse --git-dir

# 检查工作区是否干净
git status --porcelain

# 如果有未提交的变更，提示用户先提交
```

### Step 3: 为每个组创建 Git Worktree
```bash
# 为每个 feature 分支创建 worktree
# 假设有 4 个并行组

# Group A: core-scheduler
git worktree add ../worktrees/feature-core-scheduler -b feature/core-scheduler

# Group B: executor-nodes
git worktree add ../worktrees/feature-executor-nodes -b feature/executor-nodes

# Group C: crawler-engine
git worktree add ../worktrees/feature-crawler-engine -b feature/crawler-engine

# Group D: monitoring
git worktree add ../worktrees/feature-monitoring -b feature/monitoring
```

**Worktree 目录结构**：
```
project-root/
├── .git/
├── src/
├── requirements/
└── ...

../worktrees/
├── feature-core-scheduler/      # Worktree for Group A
│   ├── .git -> project-root/.git/worktrees/feature-core-scheduler
│   ├── src/
│   ├── requirements/
│   └── design/
├── feature-executor-nodes/      # Worktree for Group B
├── feature-crawler-engine/      # Worktree for Group C
└── feature-monitoring/          # Worktree for Group D
```

### Step 4: 复制共享产出物到每个 Worktree
```bash
# 对于每个 worktree
for worktree in ../worktrees/feature-*; do
    # 复制共享的需求产出物
    cp -r requirements/current/shared "$worktree/requirements/current/"

    # 复制对应组的 User Stories
    feature_name=$(basename "$worktree")
    cp -r "requirements/current/parallel-groups/$feature_name" \
          "$worktree/requirements/current/group/"

    # 提交初始状态
    cd "$worktree"
    git add requirements/
    git commit -m "chore: initialize $feature_name with requirements artifacts"
    cd -
done
```

### Step 5: 为每个组启动 oo-modeler Agent
```javascript
// 并行启动多个 oo-modeler agents

// Group A
Task(
  subagent_type: "oo-modeler",
  description: "Design core scheduler",
  prompt: `
    工作目录: ../worktrees/feature-core-scheduler

    你的任务：
    1. 读取 requirements/current/shared/ 中的共享产出物
    2. 读取 requirements/current/group/ 中的本组 User Stories
    3. 进行面向对象分析和设计
    4. 产出物保存到 design/current/
    5. 完成后提交到 feature/core-scheduler 分支

    注意：
    - 你在独立的 worktree 中工作
    - 只关注本组的 User Stories
    - 与其他组的接口通过共享的领域模型定义
  `,
  run_in_background: true
)

// Group B
Task(
  subagent_type: "oo-modeler",
  description: "Design executor nodes",
  prompt: `...`,
  run_in_background: true
)

// Group C
Task(
  subagent_type: "oo-modeler",
  description: "Design crawler engine",
  prompt: `...`,
  run_in_background: true
)

// Group D
Task(
  subagent_type: "oo-modeler",
  description: "Design monitoring",
  prompt: `...`,
  run_in_background: true
)
```

### Step 6: 监控并行任务进度
```bash
# 列出所有后台任务
/tasks

# 查看特定任务的输出
TaskOutput(task_id: "task-123")

# 检查 worktree 的提交状态
for worktree in ../worktrees/feature-*; do
    echo "=== $(basename $worktree) ==="
    cd "$worktree"
    git log --oneline -5
    cd -
done
```

### Step 7: 等待所有任务完成
```javascript
// 阻塞等待所有任务完成
TaskOutput(task_id: "task-123", block: true)
TaskOutput(task_id: "task-124", block: true)
TaskOutput(task_id: "task-125", block: true)
TaskOutput(task_id: "task-126", block: true)
```

### Step 8: 集成检查
完成后，检查各个分支的产出物：

```bash
# 检查每个 worktree 的设计产出物
for worktree in ../worktrees/feature-*; do
    echo "=== $(basename $worktree) ==="
    ls -la "$worktree/design/current/"
done

# 检查接口一致性
# 验证各个组定义的接口是否与共享的领域模型一致
```

## Worktree Management

### 创建 Worktree
```bash
# 基本语法
git worktree add <path> -b <branch-name>

# 示例
git worktree add ../worktrees/feature-core-scheduler -b feature/core-scheduler
```

### 列出 Worktrees
```bash
git worktree list
```

### 删除 Worktree
```bash
# 先删除目录
rm -rf ../worktrees/feature-core-scheduler

# 再清理 git 记录
git worktree prune
```

### 切换到 Worktree
```bash
cd ../worktrees/feature-core-scheduler
# 现在在 feature/core-scheduler 分支上工作
```

## Agent Prompt Template

每个 oo-modeler agent 的 prompt 应该包含：

```markdown
# 工作上下文

**工作目录**: ../worktrees/feature-{name}
**分支**: feature/{name}
**并行组**: Group {X}

# 输入产出物

**共享产出物**（所有组依赖）:
- requirements/current/shared/ubiquitous-language.md
- requirements/current/shared/domain-model.md
- requirements/current/shared/problem-statement.md
- requirements/current/shared/business-rules.md

**本组产出物**:
- requirements/current/group/user-stories.md
- requirements/current/group/use-cases.md
- requirements/current/group/acceptance-criteria.md

# 任务

1. 阅读共享产出物，理解整体领域模型
2. 阅读本组的 User Stories 和用例
3. 进行面向对象分析：
   - 识别对象和职责
   - 创建 CRC 卡片
   - 设计对象交互
   - 应用 GRASP 模式
4. 进行领域建模：
   - 应用 DDD 战术模式
   - 识别聚合边界
   - 创建类图
5. 产出物保存到 design/current/
6. 提交到当前分支

# 约束

- 只关注本组的 User Stories
- 与其他组的接口通过共享的领域模型定义
- 如果需要跨组协作，在设计决策中记录
- 使用 artifact-* skills 管理产出物

# 输出产出物

- design/current/object-catalog.md
- design/current/crc-cards.md
- design/current/responsibility-matrix.md
- design/current/interaction-sequences.md
- design/current/aggregates.md
- design/current/class-diagram.puml
- design/current/design-decisions.md
```

## Integration Strategy

### 接口契约
各个组之间通过共享的领域模型进行协作：

```markdown
## 接口契约示例

### Group A (core-scheduler) 提供的接口
- `BatchService.createBatch(BatchDefinition): Batch`
- `ExecutionService.triggerExecution(batchId): Execution`

### Group B (executor-nodes) 提供的接口
- `ExecutorRegistry.registerNode(NodeInfo): void`
- `TaskDispatcher.dispatchTask(TaskExecution): void`

### Group C (crawler-engine) 提供的接口
- `CrawlerPlugin.execute(TaskContext): Result`

### Group D (monitoring) 提供的接口
- `MetricsCollector.recordMetric(Metric): void`
- `AlertService.sendAlert(Alert): void`
```

### Mock 策略
在并行开发期间，各组可以使用 Mock 实现：

```java
// Group A 使用 Mock Executor
public class MockExecutorRegistry implements ExecutorRegistry {
    @Override
    public void registerNode(NodeInfo info) {
        // Mock implementation
    }
}
```

## Quality Gates

### Worktree 创建门控
- [ ] Git 仓库状态干净
- [ ] 所有 feature 分支已创建
- [ ] Worktree 目录结构正确
- [ ] 共享产出物已复制到每个 worktree

### Agent 启动门控
- [ ] 每个组都有对应的 agent
- [ ] Agent prompt 包含完整的上下文
- [ ] Agent 工作目录正确
- [ ] Agent 可以访问所需的产出物

### 集成门控
- [ ] 所有 agent 都已完成
- [ ] 每个分支都有设计产出物
- [ ] 接口定义一致
- [ ] 没有循环依赖

## Output Structure

```
project-root/
├── requirements/current/
│   ├── shared/                    # 共享产出物
│   ├── parallel-groups/           # 各组的 User Stories
│   ├── dependency-graph.md
│   └── parallel-strategy.md

../worktrees/
├── feature-core-scheduler/
│   ├── requirements/current/
│   │   ├── shared/               # 复制的共享产出物
│   │   └── group/                # 本组的 User Stories
│   └── design/current/           # 本组的设计产出物
│       ├── object-catalog.md
│       ├── crc-cards.md
│       └── ...
├── feature-executor-nodes/
│   └── ...
├── feature-crawler-engine/
│   └── ...
└── feature-monitoring/
    └── ...
```

## Example Usage

```javascript
// 1. 完成需求分析和依赖分析
Skill("story-dependency-analysis")

// 2. 启动并行的面向对象建模
Skill("parallel-oo-modeling")

// 输出：
// - 为每个组创建了 git worktree
// - 启动了多个并行的 oo-modeler agents
// - 每个 agent 在独立的分支上工作
```

## Notes
- Git worktree 允许同时在多个分支上工作，而不需要频繁切换分支
- 每个 agent 在独立的 worktree 中工作，互不干扰
- 共享的领域模型确保各组之间的一致性
- 使用 Mock 策略解决组间依赖
- 最终需要将各个分支合并回主分支
