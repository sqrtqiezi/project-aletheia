---
title: Agent 串行约束设计说明
date: 2025-03-XX
---

# Agent 串行约束设计说明

## 问题背景

用户提出：agents 应该是串行工作的，例如需求分析结束之后，它的产出物交给 oo 建模，建模 agent 才应该开始工作。

原有的 agent 定义中，虽然在 Integration 章节描述了协作关系，但**串行约束不够明确**，容易导致：
1. 用户不清楚何时应该启动哪个 agent
2. Agent 不知道需要等待哪些前置条件
3. 缺少明确的交付物清单

## 解决方案

### 1. 新增 "Workflow Position" 章节

在每个 agent 定义中明确其在工作流中的位置：

```markdown
## Workflow Position
**阶段**: 需求分析阶段（第 1 阶段）
**前置依赖**: 无（工作流起点）
**后续 Agent**: oo-modeler（必须等待本 agent 完成）
```

```markdown
## Workflow Position
**阶段**: 对象设计阶段（第 2 阶段）
**前置依赖**: requirements-analyst（必须完成）
**后续 Agent**: 实现阶段（代码编写）
```

### 2. 新增 "Preconditions" 章节（仅 oo-modeler）

在 oo-modeler 中明确列出必须满足的前置条件：

```markdown
## Preconditions (前置条件)

### 必须满足 ⚠️
1. ✅ requirements-analyst 已完成
2. ✅ 统一语言词汇表已交付（至少 5 个核心术语）
3. ✅ 领域概念模型已交付（至少 3 个核心概念）
4. ✅ 用例场景已交付（至少 1 个完整场景）

### 推荐满足
- ⚠️ 用户故事地图（识别系统边界）
- ⚠️ 验收标准（验证对象行为）

**检查**: 如果必需条件未满足，**不应启动** oo-modeler，应返回 requirements-analyst 补充。
```

### 3. 增强 "Integration" 章节

#### requirements-analyst 的 Integration

新增"串行约束"小节，明确交付物清单：

```markdown
### 串行约束 ⚠️
**关键规则**: oo-modeler **必须等待** requirements-analyst 完成并产出以下制品后才能开始工作

**必需的交付物**（Handoff Artifacts）:
1. ✅ **统一语言词汇表** - 必需，用于对象命名
2. ✅ **领域概念模型** - 必需，用于识别 Entity/Value Object
3. ✅ **用例场景** - 必需，用于识别对象交互
4. ⚠️ **用户故事地图** - 推荐，用于识别系统边界
5. ⚠️ **验收标准** - 推荐，用于验证对象行为

**工作流**:
```
[requirements-analyst 完成]
    ↓ 产出交付物
    ↓ 检查：统一语言词汇表 + 领域概念模型 + 用例场景
    ↓ ✅ 交付物齐全
[oo-modeler 开始]
```
```

#### oo-modeler 的 Integration

新增"串行约束"小节，明确等待规则：

```markdown
### 串行约束 ⚠️
**关键规则**: 本 agent **必须等待** requirements-analyst 完成后才能开始工作

**工作流**:
```
[requirements-analyst 完成]
    ↓ 产出交付物
    ↓ 检查前置条件
    ↓ ✅ 前置条件满足
[oo-modeler 开始]
    ↓ 产出对象模型
    ↓ 可能触发反馈循环
[requirements-analyst 调整需求]（可选）
```
```

## 设计原则

### 1. 明确性（Explicitness）
- 使用 ⚠️ 符号标记关键约束
- 使用 ✅ 符号标记必需条件
- 使用清晰的工作流图示

### 2. 可检查性（Checkability）
- 提供具体的检查标准（如"至少 5 个核心术语"）
- 提供明确的交付物清单
- 提供前置条件检查清单

### 3. 可操作性（Actionability）
- 明确告知"如果条件未满足，应该做什么"
- 提供补救措施（"返回 requirements-analyst 补充"）
- 提供反馈循环机制

## 工作流示意图

### 正常流程（串行）

```
┌─────────────────────────┐
│ requirements-analyst    │
│ (需求分析阶段)          │
└───────────┬─────────────┘
            │
            │ 产出交付物：
            │ - 统一语言词汇表
            │ - 领域概念模型
            │ - 用例场景
            │ - 用户故事地图（推荐）
            │ - 验收标准（推荐）
            ↓
      ┌─────────────┐
      │ 检查前置条件 │
      └─────┬───────┘
            │
            ↓ ✅ 满足
┌─────────────────────────┐
│ oo-modeler              │
│ (对象设计阶段)          │
└───────────┬─────────────┘
            │
            │ 产出：
            │ - 对象模型
            │ - CRC 卡片
            │ - 聚合设计
            │ - UML 图
            ↓
┌─────────────────────────┐
│ 实现阶段                │
│ (代码编写)              │
└─────────────────────────┘
```

### 反馈循环（可选）

```
┌─────────────────────────┐
│ requirements-analyst    │
└───────────┬─────────────┘
            ↓
┌─────────────────────────┐
│ oo-modeler              │
└───────────┬─────────────┘
            │
            │ 发现问题：
            │ - 设计复杂度过高
            │ - 技术约束冲突
            │ - 概念不清晰
            ↓
┌─────────────────────────┐
│ requirements-analyst    │
│ (调整需求)              │
└───────────┬─────────────┘
            ↓
┌─────────────────────────┐
│ oo-modeler              │
│ (重新设计)              │
└─────────────────────────┘
```

## 用户使用指南

### 步骤 1: 启动需求分析

```javascript
Task(subagent_type="requirements-analyst",
     prompt="分析这个功能需求，产出统一语言词汇表和领域概念模型")
```

### 步骤 2: 检查交付物

在启动 oo-modeler 之前，确认以下文件存在：
- [ ] `requirements/ubiquitous-language.md` - 统一语言词汇表
- [ ] `requirements/domain-model.md` - 领域概念模型
- [ ] `requirements/use-cases.md` - 用例场景

### 步骤 3: 启动对象建模

```javascript
Task(subagent_type="oo-modeler",
     prompt="基于需求分析的输出，创建对象模型")
```

### 步骤 4: 处理反馈（如需要）

如果 oo-modeler 发现需求问题：

```javascript
Task(subagent_type="requirements-analyst",
     prompt="根据设计反馈，调整需求：[具体问题]")
```

## 未来改进方向

### 1. 自动化检查

创建一个 `/workflow-check` skill，自动检查前置条件是否满足：

```yaml
---
name: workflow-check
description: Check if preconditions are met before starting an agent. Verify required artifacts exist and meet quality standards.
tools: Read, Grep, Glob
---
```

### 2. YAML 依赖声明

在 YAML front matter 中声明依赖关系：

```yaml
---
name: oo-modeler
requires: requirements-analyst
requires_artifacts:
  - ubiquitous-language.md
  - domain-model.md
  - use-cases.md
---
```

### 3. 工作流编排工具

创建一个 workflow orchestrator，自动管理 agent 的启动顺序和交付物传递。

## 总结

通过新增 "Workflow Position"、"Preconditions" 和增强 "Integration" 章节，我们明确了：

1. **串行约束**: oo-modeler 必须等待 requirements-analyst 完成
2. **交付物清单**: 明确列出必需和推荐的交付物
3. **前置条件**: 提供可检查的前置条件标准
4. **反馈循环**: 支持设计阶段向需求阶段的反馈

这些改进确保了 agents 按照正确的顺序工作，避免了"跳过需求分析直接设计"的问题。
