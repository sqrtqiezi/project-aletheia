---
title: Agent Meta 定义优化说明
date: 2025-03-XX
---

# Agent Meta 定义优化说明

## 优化内容

### 1. 新增字段

#### tools
列出 agent/skill 使用的工具。

**示例**:
```yaml
tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
```

**常用工具**:
- `Read` - 读取文件
- `Write` - 写入文件
- `Edit` - 编辑文件
- `Grep` - 搜索内容
- `Glob` - 查找文件
- `Bash` - 执行命令
- `AskUserQuestion` - 询问用户

#### model
指定使用的模型。

**可选值**:
- `sonnet` - 平衡性能和成本（推荐）
- `opus` - 最强性能
- `haiku` - 快速简单任务

**示例**:
```yaml
model: sonnet
```

**注意**: Skills 通常不需要 model 字段，因为它们是被 agent 调用的。

---

### 2. description 格式优化

#### 旧格式（中文，描述性）
```yaml
description: 需求分析领域专家，基于需求工程经典理论的五层认知架构
```

#### 新格式（英文，功能 + 时机）
```yaml
description: Analyze requirements using five-layer cognitive architecture (problem exploration, quality assurance, structure, precision, domain modeling). Use when defining system requirements or clarifying business needs.
```

#### 格式规范
```
[能做什么]. Use when [使用时机].
```

**能做什么**:
- 使用动词开头（Analyze, Design, Create, Check, Review, etc.）
- 简要说明核心功能
- 可以包含关键特性（括号说明）

**使用时机**:
- 以 "Use when" 或 "Use after" 开头
- 说明什么情况下应该使用这个 agent/skill
- 帮助用户判断是否需要使用

---

## 优化后的 Meta 定义

### Agent 示例

#### requirements-analyst (v1)
```yaml
---
name: requirements-analyst
description: Analyze requirements using five-layer cognitive architecture (problem exploration, quality assurance, structure, precision, domain modeling). Use when defining system requirements or clarifying business needs.
tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
model: sonnet
---
```

#### requirements-analyst-v2
```yaml
---
name: requirements-analyst
description: Analyze requirements with quality gates (problem confidence, testability, structure). Detect vague terms, enforce measurable criteria. Use when requirements need strict quality control or when team lacks requirements experience.
tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
model: sonnet
---
```

#### oo-modeler (v1)
```yaml
---
name: oo-modeler
description: Design object models using four-layer architecture (responsibility-driven design, interaction modeling, DDD tactical patterns, UML). Use when translating requirements into object-oriented design or identifying domain objects.
tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
model: sonnet
---
```

#### oo-modeler-v2
```yaml
---
name: oo-modeler
description: Design object models with quality gates (responsibility clarity, coupling control, domain alignment). Detect design anti-patterns (God Object, Anemic Model, Circular Dependency). Use when design needs strict quality control or when team lacks OO design experience.
tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
model: sonnet
---
```

---

### Skill 示例

#### req-gate-check
```yaml
---
name: req-gate-check
description: Evaluate requirements quality using three gates (problem confidence 0-5 scoring, testability check for vague terms, structure completeness). Use after requirements drafting to ensure quality standards.
tools: Read
---
```

#### oo-gate-check
```yaml
---
name: oo-gate-check
description: Evaluate design quality using three gates (responsibility clarity 0-5 scoring, coupling control with circular dependency detection, domain alignment check). Detect five anti-patterns (God Object, Anemic Model, Circular Dependency, Inappropriate Intimacy, Feature Envy). Use after design drafting to ensure quality standards.
tools: Read
---
```

#### req-use-case
```yaml
---
name: req-use-case
description: Create structured use cases with preconditions, main success scenario, extensions using Cockburn's method. Classify by goal level (cloud/sea/fish). Use when modeling system interactions from user perspective.
tools: Read, Write
---
```

#### oo-crc
```yaml
---
name: oo-crc
description: Create CRC cards (Class-Responsibility-Collaborator) with six role stereotypes (Information Holder, Structurer, Service Provider, Controller, Coordinator, Interfacer) and responsibility classification (Doing/Knowing) using Wirfs-Brock's RDD. Use when identifying objects and assigning responsibilities.
tools: Read, Write
---
```

---

## 对比

### 优化前
```yaml
---
name: requirements-analyst
description: 需求分析领域专家，基于需求工程经典理论的五层认知架构
---
```

**问题**:
- 中文描述（不符合国际化标准）
- 只说明"是什么"，没有说明"做什么"和"何时用"
- 缺少 tools 和 model 声明

---

### 优化后
```yaml
---
name: requirements-analyst
description: Analyze requirements using five-layer cognitive architecture (problem exploration, quality assurance, structure, precision, domain modeling). Use when defining system requirements or clarifying business needs.
tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
model: sonnet
---
```

**改进**:
- ✅ 英文描述
- ✅ 说明能做什么（Analyze requirements...）
- ✅ 说明使用时机（Use when...）
- ✅ 列出使用的工具
- ✅ 指定使用的模型

---

## Description 编写指南

### 结构
```
[动词] [对象] [方法/特性]. Use when [场景/时机].
```

### 动词选择
- **Analyze** - 分析类（requirements-analyst）
- **Design** - 设计类（oo-modeler）
- **Create** - 创建类（req-use-case, oo-crc）
- **Build** - 构建类（req-story-map, req-domain-model）
- **Transform** - 转换类（req-example）
- **Apply** - 应用类（oo-grasp, oo-ddd-tactical）
- **Evaluate** - 评估类（req-gate-check, oo-gate-check）
- **Check** - 检查类（req-quality-check）
- **Review** - 审查类（oo-review）

### 方法/特性说明
使用括号简要说明关键方法或特性：
- `(problem exploration, quality assurance, structure, precision, domain modeling)`
- `(responsibility clarity, coupling control, domain alignment)`
- `(God Object, Anemic Model, Circular Dependency)`

### 使用时机
- **Use when** - 一般情况
  - `Use when defining system requirements`
  - `Use when translating requirements into design`

- **Use after** - 在某个步骤之后
  - `Use after requirements drafting`
  - `Use after design drafting`
  - `Use after code changes`

- **Use when ... or when ...** - 多种情况
  - `Use when requirements need strict quality control or when team lacks requirements experience`

---

## 优化的文件列表

### Agents (4 个)
- [x] agents/requirements-analyst.md
- [x] agents/requirements-analyst-v2.md
- [x] agents/oo-modeler.md
- [x] agents/oo-modeler-v2.md

### Skills (11 个)
- [x] skills/req-gate-check.md
- [x] skills/req-quality-check.md
- [x] skills/req-use-case.md
- [x] skills/req-story-map.md
- [x] skills/req-example.md
- [x] skills/req-domain-model.md
- [x] skills/oo-gate-check.md
- [x] skills/oo-crc.md
- [x] skills/oo-grasp.md
- [x] skills/oo-ddd-tactical.md
- [x] skills/oo-review.md

---

## 总结

### 新增字段
- `tools` - 列出使用的工具
- `model` - 指定使用的模型（仅 agents）

### Description 优化
- 使用英文
- 格式：`[能做什么]. Use when [使用时机].`
- 动词开头，说明功能
- 括号说明关键特性
- 明确使用时机

### 优势
- 更清晰的功能说明
- 更明确的使用时机
- 国际化标准（英文）
- 明确的工具和模型声明
- 更容易被 Claude Code 解析和使用
