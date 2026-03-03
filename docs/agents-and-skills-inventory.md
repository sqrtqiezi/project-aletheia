# Agent 和 Skills 完整清单

## 概述

本项目包含 4 个专业领域 agents（含 2 个改进版本）和 11 个配套 skills（不含示例文件）。

所有 agents 和 skills 都包含 YAML front matter 格式的 meta 信息，便于 Claude Code 识别和管理。

---

## Agents

### 1. requirements-analyst (需求分析专家 v1)

**文件**: `agents/requirements-analyst.md`

**Meta 信息**:
- version: 1.0.0
- category: analysis
- tags: requirements, analysis, use-cases, user-stories, domain-modeling, bdd

**特点**: 纯理论版，基于经典理论的五层架构

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

### 1.5. requirements-analyst-v2 (需求分析专家 v2)

**文件**: `agents/requirements-analyst-v2.md`

**Meta 信息**:
- version: 2.0.0
- category: analysis
- tags: requirements, analysis, use-cases, user-stories, domain-modeling, bdd

**特点**: 融合经典理论与实践门控机制

**认知架构**: 五层 + 三个门控
1. 哲学层 - 问题本质探索 + **problem_confidence_gate** ⚠️
2. 质量层 - 需求质量保证 + **testability_gate** ⚠️
3. 结构层 - 需求结构化表达 + **structure_before_precision_gate**
4. 精度层 - 需求精确规约
5. 语义层 - 领域语义一致

**门控机制**:
- **Gate 1: Problem Confidence Gate** (0-5 分评分，< 3 分不得进入下层)
- **Gate 2: Testability Gate** (禁止模糊词汇，强制可测量性)
- **Gate 3: Structure Before Precision Gate** (先建立全局结构，再精确化)

**新增特性**:
- 严格的输出契约（10 个必需章节）
- 结构化提问策略（每轮最多 8 个问题）
- 内置模板（问题简报、故事地图、Given/When/Then）
- 可观测性钩子（指标/日志/事件）
- 明确的质量标准（Must/Should）
- 两遍处理模式（探索验证 + 规约强化）

**相关 Skills**: 6 个
- req-gate-check (新增)
- req-quality-check
- req-use-case
- req-story-map
- req-example
- req-domain-model

**调用方式**:
```javascript
Task(subagent_type="requirements-analyst",
     prompt="分析这个功能需求的本质问题，评估问题置信度")
```

**对比文档**: `docs/requirements-analyst-comparison.md`

---

### 2. oo-modeler (面向对象建模专家 v1)

**文件**: `agents/oo-modeler.md`

**Meta 信息**:
- version: 1.0.0
- category: design
- tags: object-oriented, modeling, design, ddd, uml, grasp, rdd

**特点**: 纯理论版，基于经典理论的四层架构

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

### 2.5. oo-modeler-v2 (面向对象建模专家 v2)

**文件**: `agents/oo-modeler-v2.md`

**Meta 信息**:
- version: 2.0.0
- category: design
- tags: object-oriented, modeling, design, ddd, uml, grasp, rdd

**特点**: 融合经典理论与设计门控机制

**认知架构**: 四层 + 三个门控
1. 责任驱动核心 + **responsibility_clarity_gate** ⚠️
2. 交互与场景建模 + **coupling_control_gate** ⚠️
3. 语义桥梁 + **domain_alignment_gate** ⚠️
4. 形式表达

**门控机制**:
- **Gate 1: Responsibility Clarity Gate** (职责清晰度评分，检测上帝对象/懒惰对象)
- **Gate 2: Coupling Control Gate** (耦合度控制，循环依赖检测)
- **Gate 3: Domain Alignment Gate** (领域对齐检查，统一语言验证)

**新增特性**:
- 严格的输出契约（10 个必需章节）
- 5 种设计反模式自动检测（God Object, Anemic Model, Circular Dependency, Inappropriate Intimacy, Feature Envy）
- 内置模板（CRC 卡片、聚合设计、设计决策记录）
- 具体的耦合度阈值（依赖数 ≤ 5，被依赖数 ≤ 10）
- 技术术语检测（禁止 Manager, Service, Handler 等）
- 两遍处理模式（对象识别 + 领域建模）

**相关 Skills**: 5 个
- oo-gate-check (新增)
- oo-crc
- oo-grasp
- oo-ddd-tactical
- oo-review

**调用方式**:
```javascript
Task(subagent_type="oo-modeler",
     prompt="从这个用例识别候选对象，评估职责清晰度")
```

**对比文档**: `docs/oo-modeler-comparison.md`

---

## Skills

### 需求分析相关 (6 个)

#### 1. req-gate-check (需求门控检查) 🆕

**文件**: `skills/req-gate-check.md`

**功能**: 执行三个关键门控检查，评估需求是否满足进入下一层的条件

**门控检查**:
1. **Problem Confidence Gate**: 评估问题定义清晰度（0-5 分评分）
2. **Testability Gate**: 扫描禁止词汇，确保可测量性
3. **Structure Before Precision Gate**: 检查结构完整性

**输出**: 综合评估报告，包括评分、问题列表、改进建议、行动计划

**调用**: `/req-gate-check [需求文档路径]`

**关联**: requirements-analyst-v2 专用

---

#### 2. req-quality-check (需求质量检查)

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

#### 3. req-use-case (用例建模)

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

#### 4. req-story-map (用户故事地图)

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

#### 5. req-example (需求实例化)

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

#### 6. req-domain-model (领域概念建模)

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

### 对象建模相关 (5 个)

#### 7. oo-gate-check (对象设计门控检查) 🆕

**文件**: `skills/oo-gate-check.md`

**功能**: 执行三个关键门控检查，评估设计是否满足质量标准

**门控检查**:
1. **Responsibility Clarity Gate**: 评估职责清晰度（0-5 分评分，检测上帝对象/懒惰对象）
2. **Coupling Control Gate**: 评估耦合度（循环依赖检测、依赖图分析）
3. **Domain Alignment Gate**: 评估领域对齐（统一语言检查、Entity/Value Object 分类）

**反模式检测**:
- God Object (上帝对象)
- Anemic Domain Model (贫血模型)
- Circular Dependency (循环依赖)
- Inappropriate Intimacy (过度亲密)
- Feature Envy (特性依恋)

**输出**: 综合评估报告，包括评分、反模式检测结果、改进建议、行动计划

**调用**: `/oo-gate-check [设计文档路径]`

**关联**: oo-modeler-v2 专用

---

#### 8. oo-crc (CRC 卡片建模)

**文件**: `skills/oo-crc.md`

**功能**: 基于 Wirfs-Brock 的 RDD，创建 CRC 卡片

**包含**:
- Class-Responsibility-Collaborator 三元组
- 6 种角色构造型
- 职责分类（Doing/Knowing）

**输出**: CRC 卡片文档

**调用**: `/oo-crc [用例描述]`

---

#### 9. oo-grasp (GRASP 模式应用)

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

#### 10. oo-ddd-tactical (DDD 战术模式)

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

#### 11. oo-review (对象设计评审)

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

### 完整的分析-设计流程（v2 版本，带门控）

```
1. 问题探索
   ↓
   Task(subagent_type="requirements-analyst",
        prompt="分析问题本质，评估问题置信度")
   ↓
   /req-gate-check → Gate 1 评估
   ↓ (如果 < 3 分，补充信息)

2. 需求建模
   ↓
   /req-use-case [功能描述]
   /req-story-map [产品描述]
   ↓
   /req-gate-check → Gate 3 评估（结构完整性）

3. 需求精化
   ↓
   /req-example [用户故事]
   ↓
   /req-gate-check → Gate 2 评估（可测试性）

4. 领域建模
   ↓
   /req-domain-model [业务领域]
   ↓
   输出: 统一语言词汇表 + 领域概念模型

5. 需求质量检查
   ↓
   /req-quality-check [需求文档]
   /req-gate-check [需求文档] (综合评估)

---

6. 对象识别（接收统一语言和概念模型）
   ↓
   Task(subagent_type="oo-modeler",
        prompt="从用例识别对象，评估职责清晰度")
   /oo-crc [用例描述]
   ↓
   /oo-gate-check → Gate 1 评估（职责清晰度）
   ↓ (如果发现上帝对象，重新分配职责)

7. 职责分配与交互设计
   ↓
   /oo-grasp [场景描述]
   ↓
   /oo-gate-check → Gate 2 评估（耦合控制）
   ↓ (如果有循环依赖，重构)

8. 领域建模（DDD 战术模式）
   ↓
   /oo-ddd-tactical [领域场景]
   ↓
   /oo-gate-check → Gate 3 评估（领域对齐）
   ↓ (如果领域不对齐，调整命名和分类)

9. 设计评审
   ↓
   /oo-review [设计文档]
   /oo-gate-check [设计文档] (综合评估 + 反模式检测)

10. 交付设计文档
```

### 经典流程（v1 版本，无门控）

```
1. 问题探索 → requirements-analyst
2. 需求建模 → /req-use-case, /req-story-map
3. 需求精化 → /req-example
4. 领域建模 → /req-domain-model
5. 需求质量检查 → /req-quality-check
6. 对象识别 → oo-modeler, /oo-crc
7. 职责分配 → /oo-grasp
8. 领域建模 → /oo-ddd-tactical
9. 设计评审 → /oo-review
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
│   ├── requirements-analyst.md (v1, 纯理论版)
│   ├── requirements-analyst-v2.md (v2, 含门控机制)
│   ├── oo-modeler.md (v1, 纯理论版)
│   └── oo-modeler-v2.md (v2, 含门控机制)
├── skills/
│   ├── req-gate-check.md (新增，v2 专用)
│   ├── req-quality-check.md
│   ├── req-use-case.md
│   ├── req-story-map.md
│   ├── req-example.md
│   ├── req-domain-model.md
│   ├── oo-gate-check.md (新增，v2 专用)
│   ├── oo-crc.md
│   ├── oo-grasp.md
│   ├── oo-ddd-tactical.md
│   └── oo-review.md
└── docs/
    ├── requirements-analyst-theory.md (详细理论)
    ├── oo-modeler-theory.md (详细理论)
    ├── requirements-analyst-comparison.md (v1 vs v2 对比)
    ├── oo-modeler-comparison.md (v1 vs v2 对比)
    ├── ddd-as-bridge.md (DDD 桥梁机制)
    └── agents-and-skills-inventory.md (本文档)
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
