---
name: story-dependency-analysis
description: Analyze User Story dependencies and create parallel development groups. Use after story-map creation to enable parallel implementation.
tools: Read, Write, Edit, Grep, Glob, AskUserQuestion
---

# Skill: story-dependency-analysis

## Purpose
分析 User Story 之间的依赖关系，识别可以并行开发的组，为每个组分配 feature 分支名称。

## When to Use
- ✅ 在 requirements-analyst 完成 User Story Map 之后
- ✅ 在开始 oo-modeler 阶段之前
- ✅ 当团队需要并行开发时

## Prerequisites
- User Story Map 已完成（story-map.md）
- 用例场景已定义（use-cases.md）

## Workflow

### Step 1: 读取 User Story Map
```javascript
Read("requirements/current/story-map.md")
```

### Step 2: 识别依赖关系
分析每个 User Story 的依赖：

**依赖类型**：
- **强依赖**（Must）: Story B 必须等待 Story A 完成
- **弱依赖**（Should）: Story B 最好在 Story A 之后，但可以并行
- **无依赖**（Independent）: 可以完全独立开发

**依赖识别规则**：
1. **数据依赖**: 如果 Story B 需要 Story A 创建的数据模型
2. **功能依赖**: 如果 Story B 需要 Story A 实现的功能
3. **接口依赖**: 如果 Story B 需要 Story A 定义的接口
4. **基础设施依赖**: 如果 Story B 需要 Story A 搭建的基础设施

### Step 3: 创建依赖关系图
```markdown
# User Story 依赖关系图

## 依赖矩阵

| Story ID | Story | 依赖 Story | 依赖类型 | 理由 |
|----------|-------|-----------|---------|------|
| US-1.1 | YAML 定义 Batch | - | - | 基础功能 |
| US-1.2 | 定义 Task 依赖 | US-1.1 | 强依赖 | 需要 Batch 模型 |
| US-2.1 | 动态获取参数 | US-1.1 | 强依赖 | 需要 Batch 配置 |
| US-3.1 | 手动触发执行 | US-1.1, US-1.2 | 强依赖 | 需要完整的 Batch 定义 |

## 依赖层次

```
Layer 0 (基础层):
  US-1.1 (Batch 定义)
  US-6.1 (节点管理)
  US-7.1 (插件框架)
  US-8.1 (代理池)

Layer 1 (核心层):
  US-1.2 (Task 依赖) → 依赖 US-1.1
  US-2.1 (参数获取) → 依赖 US-1.1
  US-6.2 (添加节点) → 依赖 US-6.1

Layer 2 (执行层):
  US-3.1 (手动触发) → 依赖 US-1.1, US-1.2
  US-3.2 (查看状态) → 依赖 US-3.1
```
```

### Step 4: 划分并行组
根据依赖关系，将 User Stories 划分为可以并行开发的组：

**划分原则**：
1. 同一组内的 Stories 必须顺序执行（有依赖关系）
2. 不同组之间可以并行执行（无依赖或弱依赖）
3. 每个组应该是一个完整的功能模块
4. 每个组的工作量应该相对均衡

**输出格式**：
```markdown
## 并行开发组

### Group A: 核心调度引擎
**Feature Branch**: `feature/core-scheduler`
**Stories**: US-1.1, US-1.2, US-1.3, US-1.4, US-2.1, US-2.2, US-3.1, US-3.2
**依赖**: 无（基础组）
**工作量**: 4-5 周

### Group B: 执行节点管理
**Feature Branch**: `feature/executor-nodes`
**Stories**: US-6.1, US-6.2, US-6.3
**依赖**: 无（基础组）
**工作量**: 2-3 周

### Group C: 爬虫引擎
**Feature Branch**: `feature/crawler-engine`
**Stories**: US-7.1, US-7.2, US-7.3, US-8.1, US-8.2, US-8.3
**依赖**: 无（基础组）
**工作量**: 3-4 周

### Group D: 监控告警
**Feature Branch**: `feature/monitoring`
**Stories**: US-4.1, US-4.2, US-4.3, US-4.4, US-5.1, US-5.2, US-5.3
**依赖**: Group A（弱依赖，可以用 Mock）
**工作量**: 3-4 周
```

### Step 5: 创建并行开发策略文档
```javascript
Write("requirements/current/parallel-strategy.md", content)
```

### Step 6: 组织 User Story 文件结构
为每个并行组创建独立的目录：

```
requirements/current/
├── shared/                          # 共享产出物（所有组依赖）
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
│   │   ├── user-stories.md
│   │   ├── use-cases.md
│   │   └── acceptance-criteria.md
│   ├── feature-crawler-engine/      # Group C
│   │   └── ...
│   └── feature-monitoring/          # Group D
│       └── ...
├── dependency-graph.md              # 依赖关系图
└── parallel-strategy.md             # 并行开发策略
```

## Output Files

### 必需产出物
1. **dependency-graph.md** - 依赖关系图和依赖矩阵
2. **parallel-strategy.md** - 并行开发策略和分组方案
3. **parallel-groups/** - 按 feature 分支组织的 User Story 目录

### 文件模板

#### dependency-graph.md
```markdown
# User Story 依赖关系图

**版本**: v1.0.0
**创建日期**: YYYY-MM-DD
**项目**: [项目名称]

## 依赖矩阵
[表格]

## 依赖层次
[层次图]

## 关键路径
[识别关键路径]

## 风险分析
[依赖风险]
```

#### parallel-strategy.md
```markdown
# 并行开发策略

**版本**: v1.0.0
**创建日期**: YYYY-MM-DD
**项目**: [项目名称]

## 并行开发组
[分组详情]

## 集成策略
[如何集成各个组的工作]

## 接口契约
[各组之间的接口定义]

## 时间线
[并行开发时间线]
```

## Quality Gates

### 依赖分析质量门控
- [ ] 所有 User Story 都已分析依赖关系
- [ ] 依赖类型明确（强依赖/弱依赖/无依赖）
- [ ] 依赖理由清晰
- [ ] 识别了循环依赖（如果有）

### 分组质量门控
- [ ] 每个组都有明确的 feature 分支名
- [ ] 组内 Stories 有明确的顺序
- [ ] 组间依赖关系清晰
- [ ] 工作量相对均衡（差异 < 50%）
- [ ] 每个组都是完整的功能模块

### 完整性门控
- [ ] 所有 User Story 都已分配到组
- [ ] 没有遗漏的依赖关系
- [ ] 接口契约已定义
- [ ] 集成策略已明确

## Integration with Other Skills

**前置 Skill**:
- `artifact-validate` - 验证 story-map.md 存在

**后续 Skill**:
- `artifact-save` - 保存依赖关系图和并行策略
- `parallel-oo-modeling` - 为每个组启动独立的 oo-modeler

## Example Usage

```javascript
// 在 requirements-analyst 完成后调用
Skill("story-dependency-analysis")

// 输出：
// - requirements/current/dependency-graph.md
// - requirements/current/parallel-strategy.md
// - requirements/current/parallel-groups/feature-*/
```

## Notes
- 依赖分析是一个迭代过程，可能需要多次调整
- 优先识别强依赖，弱依赖可以通过 Mock 解决
- 避免过度拆分，保持每个组的完整性
- 考虑团队规模和能力，合理分配工作量
