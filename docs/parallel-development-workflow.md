# 并行开发工作流

**版本**: v1.0.0
**创建日期**: 2026-03-03
**作者**: Project Aletheia

---

## 概述

Project Aletheia 支持基于依赖关系的并行开发工作流，允许多个团队同时进行需求分析、对象设计和实现工作，大幅缩短交付周期。

## 工作流阶段

### 阶段 1: 需求分析（requirements-analyst）

**目标**: 分析需求，产出共享和可拆分的产出物

**产出物分类**:

1. **共享产出物**（所有后续任务依赖）:
   - `ubiquitous-language.md` - 统一语言词汇表
   - `domain-model.md` - 领域概念模型
   - `problem-statement.md` - 问题陈述
   - `business-rules.md` - 业务规则

2. **可拆分产出物**（按功能模块划分）:
   - `user-stories.md` - 用户故事
   - `use-cases.md` - 用例场景
   - `acceptance-criteria.md` - 验收标准

**工作流**:
```
用户输入
  ↓
requirements-analyst 启动
  ↓
问题澄清 + 需求分析
  ↓
产出共享产出物（保存到 requirements/current/shared/）
  ↓
产出 User Story Map（保存到 requirements/current/story-map.md）
  ↓
artifact-validate（验证完整性）
  ↓
artifact-handoff（生成交接清单）
  ↓
story-dependency-analysis（自动触发）
```

---

### 阶段 2: 依赖分析（story-dependency-analysis）

**目标**: 分析 User Story 依赖关系，划分并行开发组

**输入**:
- `requirements/current/story-map.md`
- `requirements/current/use-cases.md`

**输出**:
- `requirements/current/dependency-graph.md` - 依赖关系图
- `requirements/current/parallel-strategy.md` - 并行开发策略
- `requirements/current/parallel-groups/` - 按 feature 组织的目录

**依赖分析规则**:

1. **强依赖**（Must）: Story B 必须等待 Story A 完成
   - 数据依赖: B 需要 A 创建的数据模型
   - 功能依赖: B 需要 A 实现的功能
   - 接口依赖: B 需要 A 定义的接口
   - 基础设施依赖: B 需要 A 搭建的基础设施

2. **弱依赖**（Should）: B 最好在 A 之后，但可以并行（通过 Mock）

3. **无依赖**（Independent）: 完全独立开发

**并行组划分原则**:
- 同一组内的 Stories 必须顺序执行（有强依赖）
- 不同组之间可以并行执行（无依赖或弱依赖）
- 每个组是一个完整的功能模块
- 每个组的工作量相对均衡

**输出目录结构**:
```
requirements/current/
├── shared/                          # 共享产出物
│   ├── ubiquitous-language.md
│   ├── domain-model.md
│   ├── problem-statement.md
│   └── business-rules.md
├── parallel-groups/                 # 并行组
│   ├── feature-core-scheduler/      # Group A
│   │   ├── user-stories.md
│   │   ├── use-cases.md
│   │   └── acceptance-criteria.md
│   ├── feature-executor-nodes/      # Group B
│   │   └── ...
│   ├── feature-crawler-engine/      # Group C
│   │   └── ...
│   └── feature-monitoring/          # Group D
│       └── ...
├── dependency-graph.md              # 依赖关系图
├── parallel-strategy.md             # 并行开发策略
└── story-map.md                     # 原始 Story Map
```

**并行策略示例**:
```markdown
## 并行开发组

### Group A: 核心调度引擎
**Feature Branch**: `feature/core-scheduler`
**Stories**: US-1.1, US-1.2, US-1.3, US-2.1, US-2.2, US-3.1
**依赖**: 无（基础组）
**工作量**: 4-5 周

### Group B: 执行节点管理
**Feature Branch**: `feature/executor-nodes`
**Stories**: US-6.1, US-6.2, US-6.3
**依赖**: 无（基础组）
**工作量**: 2-3 周

### Group C: 爬虫引擎
**Feature Branch**: `feature/crawler-engine`
**Stories**: US-7.1, US-7.2, US-8.1, US-8.2
**依赖**: 无（基础组）
**工作量**: 3-4 周

### Group D: 监控告警
**Feature Branch**: `feature/monitoring`
**Stories**: US-4.1, US-4.2, US-5.1, US-5.2
**依赖**: Group A（弱依赖，可用 Mock）
**工作量**: 3-4 周
```

---

### 阶段 3: 并行对象设计（parallel-oo-modeling）

**目标**: 为每个并行组启动独立的 oo-modeler agent

**前置条件**:
- `parallel-strategy.md` 已创建
- `parallel-groups/` 目录已创建
- Git 仓库状态干净

**工作流**:

#### Step 1: 创建 Git Worktrees
```bash
# 为每个 feature 分支创建独立的 worktree
git worktree add ../worktrees/feature-core-scheduler -b feature/core-scheduler
git worktree add ../worktrees/feature-executor-nodes -b feature/executor-nodes
git worktree add ../worktrees/feature-crawler-engine -b feature/crawler-engine
git worktree add ../worktrees/feature-monitoring -b feature/monitoring
```

**Worktree 目录结构**:
```
project-root/                        # 主工作区（main 分支）
├── .git/
├── requirements/
└── ...

../worktrees/                        # Worktree 目录
├── feature-core-scheduler/          # Group A 的独立工作区
│   ├── .git -> project-root/.git/worktrees/feature-core-scheduler
│   ├── requirements/current/
│   │   ├── shared/                 # 复制的共享产出物
│   │   └── group/                  # 本组的 User Stories
│   └── design/current/             # 本组的设计产出物
├── feature-executor-nodes/          # Group B 的独立工作区
├── feature-crawler-engine/          # Group C 的独立工作区
└── feature-monitoring/              # Group D 的独立工作区
```

#### Step 2: 复制产出物到 Worktrees
```bash
for worktree in ../worktrees/feature-*; do
    # 复制共享产出物
    cp -r requirements/current/shared "$worktree/requirements/current/"

    # 复制本组的 User Stories
    feature_name=$(basename "$worktree")
    cp -r "requirements/current/parallel-groups/$feature_name" \
          "$worktree/requirements/current/group/"

    # 提交初始状态
    cd "$worktree"
    git add requirements/
    git commit -m "chore: initialize $feature_name with requirements"
    cd -
done
```

#### Step 3: 启动并行 Agents
```javascript
// 并行启动多个 oo-modeler agents

Task(
  subagent_type: "oo-modeler",
  description: "Design core scheduler",
  prompt: `
    工作目录: ../worktrees/feature-core-scheduler
    分支: feature/core-scheduler

    输入产出物:
    - requirements/current/shared/ (共享)
    - requirements/current/group/ (本组)

    任务:
    1. 读取共享的领域模型和统一语言
    2. 读取本组的 User Stories 和用例
    3. 进行面向对象分析和设计
    4. 产出物保存到 design/current/
    5. 提交到 feature/core-scheduler 分支
  `,
  run_in_background: true
)

// 同时启动 Group B, C, D 的 agents...
```

#### Step 4: 监控并行任务
```bash
# 列出所有后台任务
/tasks

# 查看任务输出
TaskOutput(task_id: "task-123")

# 检查各个 worktree 的进度
for worktree in ../worktrees/feature-*; do
    echo "=== $(basename $worktree) ==="
    cd "$worktree"
    git log --oneline -5
    ls -la design/current/
    cd -
done
```

#### Step 5: 等待所有任务完成
```javascript
// 阻塞等待所有任务完成
TaskOutput(task_id: "task-123", block: true)  // Group A
TaskOutput(task_id: "task-124", block: true)  // Group B
TaskOutput(task_id: "task-125", block: true)  // Group C
TaskOutput(task_id: "task-126", block: true)  // Group D
```

---

### 阶段 4: 集成和合并

**目标**: 将各个 feature 分支的设计产出物集成到主分支

#### Step 1: 验证各分支的产出物
```bash
# 检查每个分支的设计产出物
for worktree in ../worktrees/feature-*; do
    echo "=== $(basename $worktree) ==="
    cd "$worktree"

    # 验证必需的产出物
    ls -la design/current/object-catalog.md
    ls -la design/current/crc-cards.md
    ls -la design/current/aggregates.md

    cd -
done
```

#### Step 2: 检查接口一致性
```bash
# 验证各组定义的接口是否与共享的领域模型一致
# 检查是否有循环依赖
# 检查接口契约是否完整
```

#### Step 3: 合并到主分支
```bash
# 切换到主分支
git checkout main

# 依次合并各个 feature 分支
git merge feature/core-scheduler
git merge feature/executor-nodes
git merge feature/crawler-engine
git merge feature/monitoring

# 解决冲突（如果有）
# 运行集成测试
```

#### Step 4: 清理 Worktrees
```bash
# 删除 worktree 目录
rm -rf ../worktrees/feature-*

# 清理 git 记录
git worktree prune

# 删除 feature 分支（可选）
git branch -d feature/core-scheduler
git branch -d feature/executor-nodes
git branch -d feature/crawler-engine
git branch -d feature/monitoring
```

---

## 接口契约管理

### 接口定义
各个组之间通过共享的领域模型进行协作：

```markdown
## 接口契约

### Group A (core-scheduler) 提供
- `BatchService.createBatch(BatchDefinition): Batch`
- `ExecutionService.triggerExecution(batchId): Execution`

### Group B (executor-nodes) 提供
- `ExecutorRegistry.registerNode(NodeInfo): void`
- `TaskDispatcher.dispatchTask(TaskExecution): void`

### Group C (crawler-engine) 提供
- `CrawlerPlugin.execute(TaskContext): Result`

### Group D (monitoring) 提供
- `MetricsCollector.recordMetric(Metric): void`
- `AlertService.sendAlert(Alert): void`
```

### Mock 策略
在并行开发期间，各组使用 Mock 实现解决依赖：

```java
// Group D 依赖 Group A 的 ExecutionService
// 在 Group A 未完成前，使用 Mock
public class MockExecutionService implements ExecutionService {
    @Override
    public Execution triggerExecution(String batchId) {
        return new Execution(batchId, ExecutionStatus.RUNNING);
    }
}
```

---

## 质量门控

### 依赖分析门控
- [ ] 所有 User Story 都已分析依赖关系
- [ ] 依赖类型明确（强依赖/弱依赖/无依赖）
- [ ] 没有循环依赖
- [ ] 并行组划分合理

### Worktree 创建门控
- [ ] Git 仓库状态干净
- [ ] 所有 feature 分支已创建
- [ ] 共享产出物已复制到每个 worktree
- [ ] 本组产出物已复制到每个 worktree

### 并行设计门控
- [ ] 每个组都有对应的 oo-modeler agent
- [ ] 所有 agents 都已完成
- [ ] 每个分支都有完整的设计产出物
- [ ] 接口定义一致

### 集成门控
- [ ] 所有分支的产出物都已验证
- [ ] 接口契约一致
- [ ] 没有冲突
- [ ] 集成测试通过

---

## 完整示例

### 示例项目：爬虫调度框架

#### 1. 需求分析阶段
```javascript
// 用户启动 requirements-analyst
Task(subagent_type: "requirements-analyst", prompt: "...")

// requirements-analyst 完成后自动触发
Skill("story-dependency-analysis")
```

**产出**:
```
requirements/current/
├── shared/
│   ├── ubiquitous-language.md      # 20 个术语
│   ├── domain-model.md             # 8 个核心概念
│   ├── problem-statement.md
│   └── business-rules.md
├── parallel-groups/
│   ├── feature-core-scheduler/     # 8 个 Stories
│   ├── feature-executor-nodes/     # 3 个 Stories
│   ├── feature-crawler-engine/     # 6 个 Stories
│   └── feature-monitoring/         # 7 个 Stories
├── dependency-graph.md
└── parallel-strategy.md
```

#### 2. 并行对象设计阶段
```javascript
// 自动触发并行建模
Skill("parallel-oo-modeling")
```

**创建 4 个 worktrees**:
```bash
../worktrees/
├── feature-core-scheduler/
├── feature-executor-nodes/
├── feature-crawler-engine/
└── feature-monitoring/
```

**启动 4 个并行 agents**:
- Agent A: 设计核心调度引擎（4-5 周工作量）
- Agent B: 设计执行节点管理（2-3 周工作量）
- Agent C: 设计爬虫引擎（3-4 周工作量）
- Agent D: 设计监控告警（3-4 周工作量）

#### 3. 并行工作
```
Week 1-2: 所有 agents 并行工作
  Agent A: 识别对象 → CRC 卡片 → 对象交互
  Agent B: 识别对象 → CRC 卡片 → 对象交互
  Agent C: 识别对象 → CRC 卡片 → 对象交互
  Agent D: 识别对象 → CRC 卡片 → 对象交互

Week 3-4: 所有 agents 并行工作
  Agent A: 聚合设计 → 类图 → 设计决策
  Agent B: 聚合设计 → 类图 → 设计决策
  Agent C: 聚合设计 → 类图 → 设计决策
  Agent D: 聚合设计 → 类图 → 设计决策
```

#### 4. 集成
```bash
# 所有 agents 完成后
git checkout main
git merge feature/core-scheduler
git merge feature/executor-nodes
git merge feature/crawler-engine
git merge feature/monitoring

# 验证集成
# 运行测试
```

**时间对比**:
- 串行开发: 4-5 + 2-3 + 3-4 + 3-4 = 12-16 周
- 并行开发: max(4-5, 2-3, 3-4, 3-4) = 4-5 周
- **提升**: 约 70% 时间节省

---

## 最佳实践

### 1. 共享产出物要完整
- 统一语言词汇表至少 10 个术语
- 领域概念模型至少 5 个核心概念
- 业务规则要明确

### 2. 依赖分析要准确
- 优先识别强依赖
- 弱依赖可以通过 Mock 解决
- 避免循环依赖

### 3. 并行组要均衡
- 工作量差异 < 50%
- 每个组是完整的功能模块
- 组间接口要清晰

### 4. 接口契约要明确
- 在并行开发前定义接口
- 使用 Mock 实现解决依赖
- 定期同步接口变更

### 5. 频繁集成
- 每周至少集成一次
- 早期发现集成问题
- 使用自动化测试

---

## 工具支持

### Skills
- `story-dependency-analysis` - 依赖分析和分组
- `parallel-oo-modeling` - 并行对象建模
- `artifact-*` - 产出物管理

### Git Worktree
```bash
# 创建 worktree
git worktree add <path> -b <branch>

# 列出 worktrees
git worktree list

# 删除 worktree
rm -rf <path>
git worktree prune
```

### Task 工具
```javascript
// 并行启动多个 agents
Task(..., run_in_background: true)

// 监控任务
/tasks
TaskOutput(task_id: "...")
```

---

## 故障排查

### 问题 1: Worktree 创建失败
**原因**: Git 仓库状态不干净
**解决**: 先提交或暂存所有变更

### 问题 2: Agent 无法访问产出物
**原因**: 产出物未复制到 worktree
**解决**: 检查复制脚本，确保共享和本组产出物都已复制

### 问题 3: 接口不一致
**原因**: 各组独立定义接口，未同步
**解决**: 在共享的领域模型中定义接口契约

### 问题 4: 合并冲突
**原因**: 多个组修改了相同的文件
**解决**: 使用目录隔离，每个组只修改自己的目录

---

## 总结

并行开发工作流通过以下机制实现高效协作：

1. **依赖分析** - 识别可以并行的工作
2. **产出物分类** - 共享 vs 可拆分
3. **Git Worktree** - 独立的工作空间
4. **并行 Agents** - 同时进行设计工作
5. **接口契约** - 确保集成一致性

**收益**:
- 缩短交付周期 60-70%
- 提高团队并行度
- 早期发现集成问题
- 提升整体效率
