---
name: artifact-handoff
description: Generate handoff checklist and prepare artifacts for next agent. Use when completing a stage and ready to hand off to next agent.
tools: Read, Write
---

# Skill: artifact-handoff

## Purpose
生成交接清单，准备产出物交接给下一个 agent。

## Usage

```javascript
// 需求分析完成，准备交接给对象设计
Skill("artifact-handoff", args="requirements")

// 对象设计完成，准备交接给实现阶段
Skill("artifact-handoff", args="design")
```

## Parameters

- `stage`: 阶段名称（requirements 或 design）

## Behavior

1. 读取 `<stage>/current/metadata.json`
2. 验证 status 为 "completed"
3. 生成交接清单
4. 更新 metadata.json 的 `next_agent` 字段
5. 输出交接清单

## Output

### Requirements → OO Modeler

```markdown
## 需求分析完成 - 交接清单

**版本**: v1.0.0
**完成时间**: 2025-03-03T12:00:00Z
**Agent**: requirements-analyst

### 必需产出物 ✅
- [x] problem-statement.md (4 KB)
- [x] ubiquitous-language.md (12 个术语)
- [x] domain-model.md (8 个概念)
- [x] use-cases.md (5 个用例)

### 推荐产出物 ⚠️
- [x] story-map.md
- [x] user-stories.md (15 个故事)
- [x] business-rules.md (8 条规则)
- [x] acceptance-criteria.md (20 个场景)

### 质量门控评分
- problem_confidence_gate: 4/5 ✅
- testability_gate: passed ✅
- structure_before_precision_gate: passed ✅

### 产出物路径
所有产出物位于: `requirements/current/`

### 下一步
可以启动 oo-modeler 进行对象设计。

**命令**:
```javascript
Task(subagent_type="oo-modeler",
     prompt="基于 requirements v1.0.0 创建对象模型")
```

### 前置条件检查
oo-modeler 启动前会自动验证：
- ✅ requirements-analyst 已完成
- ✅ 统一语言词汇表已交付（≥ 5 个术语）
- ✅ 领域概念模型已交付（≥ 3 个概念）
- ✅ 用例场景已交付（≥ 1 个用例）
```

### Design → Implementation

```markdown
## 对象设计完成 - 交接清单

**版本**: v1.0.0
**完成时间**: 2025-03-03T14:00:00Z
**Agent**: oo-modeler
**基于**: requirements v1.0.0

### 必需产出物 ✅
- [x] object-catalog.md (15 个对象)
- [x] crc-cards.md
- [x] responsibility-matrix.md
- [x] interaction-sequences.md
- [x] aggregates.md (4 个聚合)

### 推荐产出物 ⚠️
- [x] domain-services.md (3 个服务)
- [x] class-diagram.puml
- [x] sequence-diagrams.puml
- [x] design-decisions.md (5 个决策)

### 质量门控评分
- responsibility_clarity_gate: 4/5 ✅
- coupling_control_gate: 4/5 ✅
- domain_alignment_gate: 5/5 ✅

### 反模式检测
- 无反模式检测到 ✅

### 产出物路径
所有产出物位于: `design/current/`

### 下一步
可以开始实现阶段。

**建议**:
1. 从核心聚合开始实现
2. 优先实现 Entity 和 Value Object
3. 使用 TDD 方法
4. 参考 `class-diagram.puml` 和 `sequence-diagrams.puml`
```

## JSON Output

同时生成 JSON 格式的交接清单：

```json
{
  "stage": "requirements",
  "version": "1.0.0",
  "completed_at": "2025-03-03T12:00:00Z",
  "agent": "requirements-analyst",
  "required_artifacts": [
    {
      "filename": "problem-statement.md",
      "status": "completed",
      "size": 4096
    },
    {
      "filename": "ubiquitous-language.md",
      "status": "completed",
      "term_count": 12
    },
    {
      "filename": "domain-model.md",
      "status": "completed",
      "concept_count": 8
    },
    {
      "filename": "use-cases.md",
      "status": "completed",
      "use_case_count": 5
    }
  ],
  "recommended_artifacts": [
    {
      "filename": "story-map.md",
      "status": "completed"
    },
    {
      "filename": "user-stories.md",
      "status": "completed",
      "story_count": 15
    },
    {
      "filename": "business-rules.md",
      "status": "completed",
      "rule_count": 8
    },
    {
      "filename": "acceptance-criteria.md",
      "status": "completed",
      "scenario_count": 20
    }
  ],
  "quality_gates": {
    "problem_confidence_gate": 4,
    "testability_gate": "passed",
    "structure_before_precision_gate": "passed"
  },
  "next_agent": "oo-modeler",
  "ready_for_handoff": true
}
```

## Error Handling

- 如果 metadata.json 的 status 不是 "completed"，返回错误
- 如果必需产出物缺失，返回错误
- 如果质量门控未通过，返回错误
