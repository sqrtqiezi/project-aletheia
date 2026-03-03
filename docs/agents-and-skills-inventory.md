# Agent 和 Skills 完整清单

## 概述

本项目包含 2 个专业领域 agents 和 9 个配套 skills（不含示例文件）。

所有 agents 和 skills 都包含 YAML front matter 格式的 meta 信息，便于 Claude Code 识别和管理。

---

## Agents

### 1. requirements-analyst (需求分析专家)

**文件**: `agents/requirements-analyst.md`

**Meta 信息**:
- version: 1.0.0
- category: analysis
- tags: requirements, analysis, use-cases, user-stories, domain-modeling, bdd

**认知架构**: 五层
1. 哲学层 - 问题本质探索
2. 质量层 - 需求质量保证
3. 结构层 - 需求结构化表达
4. 精度层 - 需求精确规约
5. 语义层 - 领域语义一致

**理论基础**: 8 本经典书籍
- Are Your Lights On (Weinberg)
- Exploring Requirements (Weinberg & Gause)
- Software Requirements (Wiegers)
- Mastering the Requirements Process (Robertson)
- Writing Effective Use Cases (Cockburn)
- User Story Mapping (Patton)
- Specification by Example (Adzic)
- Domain-Driven Design (Evans)

**相关 Skills**: 5 个
- req-quality-check
- req-use-case
- req-story-map
- req-example
- req-domain-model

**调用方式**:
```javascript
Task(subagent_type="requirements-analyst",
     prompt="分析这个功能需求的本质问题")
```

---

### 2. oo-modeler (面向对象建模专家)

**文件**: `agents/oo-modeler.md`

**Meta 信息**:
- version: 1.0.0
- category: design
- tags: object-oriented, modeling, design, ddd, uml, grasp, rdd

**认知架构**: 四层
1. 责任驱动核心 - 职责分配与协作设计
2. 交互与场景建模 - 从用例到对象交互
3. 语义桥梁 - 领域模型与战术模式
4. 形式表达 - UML 标准建模语言

**理论基础**: 4 本经典书籍
- Object Design (Wirfs-Brock)
- Writing Effective Use Cases (Cockburn)
- Domain-Driven Design (Evans)
- Object-Oriented Methods (Martin)

**相关 Skills**: 4 个
- oo-crc
- oo-grasp
- oo-ddd-tactical
- oo-review

**调用方式**:
```javascript
Task(subagent_type="oo-modeler",
     prompt="从这个用例识别候选对象及其职责")
```

---

## Skills

### 需求分析相关 (5 个)

#### 1. req-quality-check (需求质量检查)

**文件**: `skills/req-quality-check.md`

**功能**: 基于 Wiegers 和 Robertson 的质量标准，评估需求的 6 个质量维度

**质量维度**:
- 明确性 (Unambiguous)
- 完整性 (Complete)
- 一致性 (Consistent)
- 可验证性 (Verifiable)
- 可追踪性 (Traceable)
- 优先级 (Prioritized)

**输出**: 质量检查报告，包括评分、问题列表、改进建议

**调用**: `/req-quality-check [需求文档路径]`

---

#### 2. req-use-case (用例建模)

**文件**: `skills/req-use-case.md`

**功能**: 基于 Cockburn 的有效用例方法，创建结构化的用例文档

**包含**:
- 用例模板（前置/后置条件、主成功场景、扩展场景）
- 目标层次分类（云层、海平面、鱼层）
- 常见模式（验证、查询、创建）
- 质量检查清单

**输出**: 完整的用例文档

**调用**: `/req-use-case [功能描述]`

---

#### 3. req-story-map (用户故事地图)

**文件**: `skills/req-story-map.md`

**功能**: 基于 Jeff Patton 的故事地图方法，创建需求全景视图

**结构**:
- 用户旅程
- 用户活动 (Backbone)
- 用户任务 (Walking Skeleton)
- 用户故事（按优先级分层）
- 发布规划

**输出**: 用户故事地图文档，包括可视化表格

**调用**: `/req-story-map [产品描述]`

---

#### 4. req-example (需求实例化)

**文件**: `skills/req-example.md`

**功能**: 基于 Gojko Adzic 的实例化需求方法，将抽象需求转化为具体实例

**格式**:
- Given-When-Then 场景
- 实例表格（数据驱动）
- 关键实例类型（正常、边界、异常）

**原则**:
- 具体性、可验证性、完整性、简洁性、可读性

**输出**: 实例化需求文档（BDD 格式）

**调用**: `/req-example [用户故事]`

---

#### 5. req-domain-model (领域概念建模)

**文件**: `skills/req-domain-model.md`

**功能**: 基于 DDD，构建领域概念模型和统一语言词汇表

**包含**:
- 核心概念识别
- 概念关系定义
- 统一语言词汇表
- 限界上下文划分
- 上下文映射

**输出**: 领域概念模型文档，包括词汇表和概念关系图

**调用**: `/req-domain-model [业务领域描述]`

---

### 对象建模相关 (4 个)

#### 6. oo-crc (CRC 卡片建模)

**文件**: `skills/oo-crc.md`

**功能**: 基于 Wirfs-Brock 的 RDD，创建 CRC 卡片

**包含**:
- Class-Responsibility-Collaborator 三元组
- 6 种角色构造型
- 职责分类（Doing/Knowing）

**输出**: CRC 卡片文档

**调用**: `/oo-crc [用例描述]`

---

#### 7. oo-grasp (GRASP 模式应用)

**文件**: `skills/oo-grasp.md`

**功能**: 应用 9 大 GRASP 职责分配模式

**模式**:
1. Information Expert
2. Creator
3. Controller
4. Low Coupling
5. High Cohesion
6. Polymorphism
7. Pure Fabrication
8. Indirection
9. Protected Variations

**输出**: 职责分配矩阵

**调用**: `/oo-grasp [场景描述]`

---

#### 8. oo-ddd-tactical (DDD 战术模式)

**文件**: `skills/oo-ddd-tactical.md`

**功能**: 应用 DDD 的 6 个核心战术模式

**模式**:
1. Entity (实体)
2. Value Object (值对象)
3. Aggregate (聚合)
4. Domain Service (领域服务)
5. Repository (仓储)
6. Factory (工厂)

**包含**: 决策树、设计规则、聚合设计文档模板

**输出**: 聚合设计文档、领域服务定义

**调用**: `/oo-ddd-tactical [领域场景]`

---

#### 9. oo-review (对象设计评审)

**文件**: `skills/oo-review.md`

**功能**: 综合检查对象设计质量

**评审维度**:
1. 职责分配
2. 内聚与耦合
3. 领域模型
4. 协作设计
5. SOLID 原则

**包含**: 常见问题识别、评分标准

**输出**: 设计评审报告（评分、问题、建议）

**调用**: `/oo-review [设计文档路径]`

---

## 使用流程

### 完整的分析-设计流程

```
1. 问题探索
   ↓
   Task(subagent_type="requirements-analyst",
        prompt="分析问题本质")

2. 需求建模
   ↓
   /req-use-case [功能描述]
   /req-story-map [产品描述]

3. 需求精化
   ↓
   /req-example [用户故事]

4. 领域建模
   ↓
   /req-domain-model [业务领域]

5. 需求质量检查
   ↓
   /req-quality-check [需求文档]

6. 对象识别
   ↓
   Task(subagent_type="oo-modeler",
        prompt="从用例识别对象")
   /oo-crc [用例描述]

7. 职责分配
   ↓
   /oo-grasp [场景描述]

8. 领域建模
   ↓
   /oo-ddd-tactical [领域场景]

9. 设计评审
   ↓
   /oo-review [设计文档]
```

---

## Meta 信息规范

所有 agents 和 skills 都包含以下 YAML front matter：

### Agent Meta 字段
```yaml
---
name: agent-name
version: 1.0.0
author: project-aletheia
description: 简短描述
tags:
  - tag1
  - tag2
category: analysis|design
theory_base:
  - Book 1
  - Book 2
related_agents:
  - agent-name
related_skills:
  - skill-name
---
```

### Skill Meta 字段
```yaml
---
name: skill-name
version: 1.0.0
author: project-aletheia
description: 简短描述
category: requirements|design
tags:
  - tag1
  - tag2
related_agent: agent-name
theory_base:
  - Book 1
---
```

---

## 文件结构

```
project-aletheia/
├── agents/
│   ├── requirements-analyst.md (98 行，含 meta)
│   └── oo-modeler.md (104 行，含 meta)
├── skills/
│   ├── req-quality-check.md
│   ├── req-use-case.md
│   ├── req-story-map.md
│   ├── req-example.md
│   ├── req-domain-model.md
│   ├── oo-crc.md
│   ├── oo-grasp.md
│   ├── oo-ddd-tactical.md
│   └── oo-review.md
└── docs/
    ├── requirements-analyst-theory.md (详细理论，1737 行)
    ├── oo-modeler-theory.md (详细理论，1737 行)
    └── agent-refactoring-summary.md (重构总结)
```

---

## 优势

1. **模块化**: Agents 简洁，Skills 专注
2. **可发现**: 通过 meta 信息便于索引和搜索
3. **可扩展**: 易于添加新的 skills
4. **可维护**: 每个文件职责单一
5. **可复用**: Skills 可被多个 agents 共享
6. **理论扎实**: 基于经典书籍的认知内核
7. **实践导向**: 提供具体的模板和检查清单

---

**文档版本**: 1.0.0
**创建日期**: 2026-03-03
**作者**: project-aletheia
