# 需求分析 Agent 定义对比分析

## 概述

对比两个需求分析 agent 的定义：
- **Ours (requirements-analyst)**: 基于经典理论的五层认知架构
- **GPT's (requirement-analyst)**: 基于门控机制的五层认知内核

---

## 一、整体架构对比

### Ours: 理论驱动的分层架构

```
哲学层 (问题本质)
    ↓
质量层 (需求质量)
    ↓
结构层 (需求结构)
    ↓
精度层 (需求精确)
    ↓
语义层 (统一语言)
```

**特点**:
- 基于 8 本经典书籍的理论体系
- 层次之间是"精化"关系（从抽象到具体）
- 强调理论完整性和学术严谨性

---

### GPT's: 门控驱动的分层架构

```
L0: Problem Legitimacy (问题合法性) [VETO]
    ↓
L1: Requirement Quality (需求质量) [VETO]
    ↓
L2: Value Structure (价值结构)
    ↓
L3: Delivery Slice (交付切片)
    ↓
L4: Executable Precision (可执行精度)
```

**特点**:
- 基于"门控"机制（上层可否决下层）
- 层次之间是"验证"关系（必须通过门控才能前进）
- 强调实用性和可操作性

---

## 二、详细对比

### 1. 认知架构

| 维度 | Ours | GPT's | 评价 |
|------|------|-------|------|
| **层数** | 5 层 | 5 层 | 相同 |
| **命名风格** | 哲学层、质量层... | L0-L4 编号 | GPT's 更工程化 |
| **层间关系** | 渐进精化 | 门控验证 | GPT's 更严格 |
| **理论基础** | 8 本经典书籍 | 5 本书籍 + 实践经验 | Ours 更全面 |
| **可操作性** | 依赖 skills | 内置操作规则 | GPT's 更自包含 |

**优势对比**:
- **Ours**: 理论完整，学术严谨，适合教学和深度理解
- **GPT's**: 实用导向，规则明确，适合直接执行

---

### 2. 门控机制

#### Ours: 隐式门控

```
Working Principles:
1. 问题优先于解决方案
2. 质量内建而非事后检查
3. 协作式理解而非单向收集
4. 渐进式精化
5. 实例驱动澄清
6. 领域语言为中心
```

**特点**:
- 原则性指导，非强制性
- 依赖 agent 的理解和判断
- 灵活但可能不一致

---

#### GPT's: 显式门控

```yaml
gates:
  - name: problem_confidence_gate
    metric: problem_confidence_score
    scale: "0-5"
    rule: "If score < 3, DO NOT proceed to L2/L3/L4"

  - name: testability_gate
    rule: "All acceptance criteria must be observable"
    prohibited_terms: ["fast", "stable", "reasonable"...]

  - name: structure_before_precision_gate
    rule: "No decision tables without story map backbone"
```

**特点**:
- 明确的评分标准（0-5 分）
- 强制性规则（DO NOT proceed）
- 禁止词列表（prohibited_terms）
- 可量化、可验证

**优势**: GPT's 的门控机制更严格、更可执行

---

### 3. 输出规范

#### Ours: 灵活的输出格式

```
Output Formats:
- 问题分析报告
- 用例文档
- 用户故事地图
- Given-When-Then 验收标准
- 统一语言词汇表
- 领域概念模型
```

**特点**:
- 列举主要输出类型
- 详细格式在 skills 中定义
- 灵活但需要查阅文档

---

#### GPT's: 结构化的输出契约

```yaml
outputs:
  format: markdown
  sections_in_order:
    - "0) Executive Summary"
    - "1) Validated Problem Statement (L0)"
    - "2) Problem Brief: Outcome/Evidence/Gap..."
    - "3) Open Questions + Assumptions"
    - "4) Story Map (L2)"
    - "5) User Stories (L3): INVEST check"
    - "6) Business Rules (L4)"
    - "7) Examples (L4): tables + boundaries"
    - "8) Acceptance Criteria (L4): Given/When/Then"
    - "9) Observability Hooks"
    - "10) Risks & Failure Modes"
```

**特点**:
- 固定的 10 个章节
- 明确的顺序
- 每个章节的内容要求清晰
- 包含可观测性和风险分析

**优势**: GPT's 的输出更标准化、更完整

---

### 4. 质量保证

#### Ours: 原则性质量要求

```
Working Principles:
- 质量内建而非事后检查
- 协作式理解
- 实例驱动澄清
```

**实现方式**:
- 通过 `/req-quality-check` skill 检查
- 6 个质量维度（明确性、完整性、一致性...）
- 需要主动调用

---

#### GPT's: 强制性质量门槛

```yaml
quality_bar:
  must:
    - "No solution before L0 is satisfied"
    - "Every story must map to measurable outcome"
    - "Every rule must have ≥2 examples (1 boundary)"
    - "Acceptance criteria must be automatable"
  should:
    - "Use decision tables for branching rules"
    - "Provide minimal release slice"

testability_gate:
  prohibited_terms:
    ["fast", "stable", "reasonable", "user-friendly",
     "secure enough", "optimize", "best"]
  remediation: "Convert to measurable metrics"
```

**特点**:
- must vs should 明确区分
- 禁止使用模糊词汇
- 强制要求可测量性
- 内置在流程中

**优势**: GPT's 的质量保证更严格、更自动化

---

### 5. 提问策略

#### Ours: 原则性指导

```
Working Principles:
- 协作式理解而非单向收集
- 实例驱动澄清

Tools:
- AskUserQuestion
```

**特点**:
- 原则性描述
- 依赖 agent 判断何时提问
- 没有具体的提问策略

---

#### GPT's: 结构化提问策略

```yaml
questioning:
  max_questions_per_round: 8
  prioritize_questions:
    - "success metrics & thresholds"
    - "hard constraints & non-goals"
    - "stakeholder conflicts / veto holders"
    - "current state evidence"
    - "edge cases and exception handling"
  techniques:
    - "restate + confirm"
    - "counterfactual: what if we do nothing?"
    - "boundary probing"
    - "glossary unification"
```

**特点**:
- 限制每轮最多 8 个问题
- 明确的优先级顺序
- 具体的提问技巧
- 包含反事实推理

**优势**: GPT's 的提问策略更系统化

---

### 6. 冲突处理

#### Ours: 理论整合

```
详细理论参见: docs/requirements-analyst-theory.md

书籍之间的关系与冲突:
- 互补关系
- 5 个主要冲突及解决方案
```

**特点**:
- 在理论文档中详细讨论
- 学术性的冲突解决
- 需要阅读文档理解

---

#### GPT's: 规则化冲突处理

```yaml
cognitive_kernel:
  principle:
    - "Upper layers have veto power"
    - "Skepticism decreases downward"
    - "Momentum increases only when gates are met"

gates:
  - problem_confidence_gate: "score < 3 → STOP"
  - testability_gate: "subjective terms → REJECT"
  - structure_before_precision_gate: "no map → no tables"
```

**特点**:
- 通过门控机制解决冲突
- 上层可否决下层
- 规则明确，易于执行

**优势**: GPT's 的冲突处理更可操作

---

### 7. 个性化 (Personality)

#### Ours: 无明确定义

**特点**:
- 没有明确的 personality 定义
- 依赖 Claude 的默认行为
- 可能不一致

---

#### GPT's: 明确的个性定义

```yaml
personality:
  tone: direct, analytical, non-fluffy
  behavior:
    - ask targeted questions when info missing
    - resist solution-jumping; clarify problem first
    - insist on measurable outcomes
    - prefer tables, checklists, decision tables
    - explicitly state assumptions and risks
```

**特点**:
- 明确的语气（直接、分析性、不啰嗦）
- 具体的行为模式
- 偏好的表达方式（表格、清单）

**优势**: GPT's 的个性更一致、更可预测

---

### 8. 模板和可复用性

#### Ours: 分散在 Skills 中

```
Related Skills:
- /req-use-case: 用例建模
- /req-story-map: 用户故事地图
- /req-example: 需求实例化
```

**特点**:
- 模板在各个 skill 中定义
- 需要调用 skill 获取
- 模块化但分散

---

#### GPT's: 内置模板

```yaml
templates:
  problem_brief: |
    Outcome:
    Current State:
    Evidence:
    Gap:
    Constraints (hard/soft):
    Stakeholders:
    Risks:
    If we do nothing:
    Non-Goals:
    Success Metrics:

  story_map_skeleton: |
    Backbone: [Discover][Choose][Transact][Fulfill][Support]
    User Tasks:
    Release Slice v1 (MVP):
    Release Slice v2:

  gwt_template: |
    Given ...
    When ...
    Then ...
```

**特点**:
- 模板直接内置在 agent 定义中
- 立即可用
- 自包含

**优势**: GPT's 的模板更便捷

---

## 三、综合评价

### Ours 的优势

1. **理论完整性** ⭐⭐⭐⭐⭐
   - 基于 8 本经典书籍
   - 详细的理论文档（1737 行）
   - 学术严谨，适合教学

2. **模块化设计** ⭐⭐⭐⭐⭐
   - Agent 简洁（124 行）
   - Skills 独立可复用
   - 按需加载

3. **DDD 桥梁** ⭐⭐⭐⭐⭐
   - 明确了与 oo-modeler 的协作
   - 统一语言和概念模型的传递
   - 需求到设计的无缝衔接

4. **可扩展性** ⭐⭐⭐⭐⭐
   - 易于添加新的 skills
   - 理论基础扎实，可持续演进

---

### Ours 的劣势

1. **可操作性** ⭐⭐⭐
   - 原则性指导多，具体规则少
   - 依赖 agent 的理解和判断
   - 可能执行不一致

2. **质量保证** ⭐⭐⭐
   - 需要主动调用 skills 检查
   - 没有强制性门控
   - 可能遗漏检查

3. **输出标准化** ⭐⭐⭐
   - 输出格式灵活但不统一
   - 需要查阅 skills 文档
   - 可能不完整

4. **自包含性** ⭐⭐
   - 依赖外部 skills
   - 需要多次调用
   - 学习曲线较陡

---

### GPT's 的优势

1. **可操作性** ⭐⭐⭐⭐⭐
   - 明确的门控机制
   - 具体的评分标准（0-5）
   - 强制性规则（DO NOT proceed）

2. **质量保证** ⭐⭐⭐⭐⭐
   - 内置质量门槛
   - 禁止模糊词汇
   - 强制可测量性

3. **输出标准化** ⭐⭐⭐⭐⭐
   - 固定的 10 个章节
   - 明确的顺序和内容
   - 包含可观测性和风险

4. **自包含性** ⭐⭐⭐⭐⭐
   - 内置模板
   - 内置提问策略
   - 立即可用

5. **个性一致性** ⭐⭐⭐⭐
   - 明确的 personality 定义
   - 行为模式清晰
   - 输出风格统一

---

### GPT's 的劣势

1. **理论深度** ⭐⭐⭐
   - 基于 5 本书 + 实践
   - 没有详细的理论文档
   - 学术性较弱

2. **模块化** ⭐⭐
   - 所有功能在一个文件中
   - 文件较长（约 200 行）
   - 难以扩展

3. **灵活性** ⭐⭐⭐
   - 规则严格，可能过于死板
   - 固定的输出格式
   - 适应性较差

4. **协作性** ⭐⭐
   - 没有明确的与其他 agent 协作机制
   - 缺少 DDD 桥梁概念
   - 孤立的需求分析

---

## 四、改进建议

### 对 Ours 的改进建议

#### 1. 增加门控机制

```yaml
# 在 requirements-analyst.md 中添加
gates:
  - name: problem_confidence_gate
    rule: "问题置信度 < 3 分时，不进入需求建模阶段"
    scoring:
      0: 只有解决方案请求，无问题上下文
      1: 有问题陈述但无证据
      2: 有目标但不清晰
      3: 目标、成功指标、约束基本清晰
      4: 清晰且有证据支持
      5: 清晰、验证、有反例

  - name: testability_gate
    rule: "验收标准必须可观测、可测量"
    prohibited_terms: ["快速", "稳定", "合理", "用户友好"]
```

#### 2. 增加输出契约

```yaml
# 标准化输出格式
output_contract:
  required_sections:
    1. 问题陈述（经过验证）
    2. 问题简报（目标/现状/证据/差距/约束）
    3. 开放问题 + 假设
    4. 用户故事地图
    5. 用户故事（INVEST 检查）
    6. 业务规则
    7. 实例表格
    8. 验收标准（Given/When/Then）
    9. 可观测性钩子
    10. 风险和失败模式
```

#### 3. 增加个性定义

```yaml
personality:
  tone: 专业、分析性、简洁
  behavior:
    - 信息缺失时提出针对性问题
    - 抵制过早跳入解决方案
    - 坚持可测量的结果
    - 偏好表格、清单、决策表
    - 明确陈述假设和风险
```

#### 4. 内置关键模板

```yaml
templates:
  problem_brief: |
    目标:
    现状:
    证据:
    差距:
    约束:
    利益相关者:
    风险:
    如果什么都不做:
    非目标:
    成功指标:
```

---

### 对 GPT's 的改进建议

#### 1. 增加理论基础

```yaml
theory_base:
  - Are Your Lights On (Weinberg)
  - Exploring Requirements (Weinberg & Gause)
  - Software Requirements (Wiegers)
  - Mastering the Requirements Process (Robertson)
  - Writing Effective Use Cases (Cockburn)
  - User Story Mapping (Patton)
  - Specification by Example (Adzic)
  - Domain-Driven Design (Evans)

# 添加理论文档引用
detailed_theory: docs/requirement-analyst-theory.md
```

#### 2. 模块化设计

```yaml
# 将大文件拆分为 agent + skills
related_skills:
  - /req-problem-validation: 问题验证（L0）
  - /req-quality-check: 质量检查（L1）
  - /req-story-map: 故事地图（L2）
  - /req-story-slice: 故事切片（L3）
  - /req-example: 实例化（L4）
```

#### 3. 增加协作机制

```yaml
integration:
  with: oo-modeler
  provides:
    - unified_language_glossary
    - domain_concept_model
    - use_cases
    - acceptance_criteria
  receives:
    - design_complexity_feedback
    - technical_constraints
    - concept_clarification_requests
```

#### 4. 增加 DDD 桥梁

```yaml
ddd_bridge:
  role: "在需求阶段建立统一语言和概念模型"
  outputs:
    - unified_language: "业务术语的标准定义"
    - concept_model: "核心业务概念及关系"
  handoff_to: oo-modeler
  ensures: "需求和设计使用相同的业务语言"
```

---

## 五、融合方案

### 方案 A: 增强 Ours（推荐）

**保留**:
- 五层认知架构（理论完整）
- 模块化设计（agent + skills）
- DDD 桥梁（与 oo-modeler 协作）
- 详细理论文档

**增加**:
- 门控机制（从 GPT's）
- 输出契约（从 GPT's）
- 个性定义（从 GPT's）
- 内置模板（从 GPT's）
- 提问策略（从 GPT's）

**优势**:
- 理论完整 + 实践可操作
- 模块化 + 自包含
- 学术严谨 + 工程实用

---

### 方案 B: 增强 GPT's

**保留**:
- 门控机制（严格质量保证）
- 输出契约（标准化）
- 个性定义（一致性）
- 内置模板（便捷）

**增加**:
- 理论基础（8 本书）
- 模块化设计（拆分 skills）
- DDD 桥梁（协作机制）
- 详细理论文档

**优势**:
- 实践可操作 + 理论支撑
- 自包含 + 可扩展
- 工程实用 + 学术严谨

---

## 六、推荐行动

### 短期（立即可做）

1. **为 Ours 添加门控机制**
   - 在 requirements-analyst.md 中添加 gates 部分
   - 定义 problem_confidence_gate 和 testability_gate

2. **标准化输出格式**
   - 定义固定的输出章节
   - 包含可观测性和风险分析

3. **添加个性定义**
   - 明确 tone 和 behavior
   - 确保输出一致性

---

### 中期（1-2 周）

1. **创建门控检查 skill**
   - `/req-gate-check`: 检查是否满足门控条件
   - 自动评分和建议

2. **增强提问策略**
   - 在 requirements-analyst 中添加 questioning 部分
   - 限制每轮问题数量
   - 明确优先级

3. **内置关键模板**
   - problem_brief 模板
   - story_map 模板
   - gwt 模板

---

### 长期（持续改进）

1. **理论与实践融合**
   - 将 GPT's 的实践经验整合到理论文档
   - 用案例验证理论

2. **建立最佳实践库**
   - 收集成功案例
   - 总结失败教训
   - 持续优化门控标准

3. **社区反馈**
   - 收集用户反馈
   - 调整门控阈值
   - 优化输出格式

---

## 七、总结

### 核心差异

| 维度 | Ours | GPT's |
|------|------|-------|
| **定位** | 理论驱动的教学型 | 实践驱动的执行型 |
| **优势** | 理论完整、模块化、协作性 | 可操作、质量保证、标准化 |
| **劣势** | 可操作性弱、质量保证弱 | 理论浅、模块化弱、协作性弱 |
| **适用场景** | 学习、研究、长期项目 | 快速执行、标准化流程 |

### 最佳实践

**融合两者优势**:
1. 保留 Ours 的理论完整性和模块化设计
2. 引入 GPT's 的门控机制和质量保证
3. 标准化输出格式，增加可观测性
4. 明确个性定义，确保一致性
5. 保持 DDD 桥梁，强化协作

**最终目标**:
> 创建一个既有理论深度又有实践可操作性的需求分析 agent，能够在保证质量的前提下，高效地将业务需求转化为可实现的设计。

---

**文档版本**: 1.0.0
**创建日期**: 2026-03-03
**作者**: project-aletheia
