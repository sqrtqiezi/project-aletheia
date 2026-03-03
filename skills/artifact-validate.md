---
name: artifact-validate
description: Validate that all required artifacts are present and meet quality standards. Use before completing a stage or handing off to next agent.
tools: Read, Bash
---

# Skill: artifact-validate

## Purpose
验证产出物的完整性和质量，确保满足交接条件。

## Usage

```javascript
// 验证需求分析产出物
Skill("artifact-validate", args="requirements")

// 验证对象设计产出物
Skill("artifact-validate", args="design")

// 验证特定版本
Skill("artifact-validate", args="requirements --version 1.0.0")
```

## Parameters

- `stage`: 阶段名称（requirements 或 design）
- `--version`: 可选，指定版本号（默认 current）

## Validation Rules

### Requirements Stage

**必需产出物**:
- ✅ `problem-statement.md` - 必须存在
- ✅ `ubiquitous-language.md` - 至少 5 个术语
- ✅ `domain-model.md` - 至少 3 个概念
- ✅ `use-cases.md` - 至少 1 个完整用例
- ✅ `metadata.json` - 必须存在且 status 为 "completed"

**推荐产出物**:
- ⚠️ `story-map.md`
- ⚠️ `user-stories.md`
- ⚠️ `business-rules.md`
- ⚠️ `acceptance-criteria.md`

**质量门控**:
- `problem_confidence_gate` ≥ 3
- `testability_gate` = "passed"
- `structure_before_precision_gate` = "passed"

### Design Stage

**必需产出物**:
- ✅ `object-catalog.md` - 必须存在
- ✅ `crc-cards.md` - 必须存在
- ✅ `responsibility-matrix.md` - 必须存在
- ✅ `interaction-sequences.md` - 必须存在
- ✅ `aggregates.md` - 必须存在
- ✅ `metadata.json` - 必须存在且 status 为 "completed"

**推荐产出物**:
- ⚠️ `domain-services.md`
- ⚠️ `class-diagram.puml`
- ⚠️ `sequence-diagrams.puml`
- ⚠️ `design-decisions.md`

**质量门控**:
- `responsibility_clarity_gate` ≥ 3
- `coupling_control_gate` ≥ 3
- `domain_alignment_gate` ≥ 3

**反模式检测**:
- 无 God Object
- 无 Anemic Domain Model
- 无 Circular Dependency

## Output

### 验证通过

```json
{
  "stage": "requirements",
  "version": "1.0.0",
  "status": "passed",
  "required_artifacts": {
    "present": 4,
    "missing": 0
  },
  "recommended_artifacts": {
    "present": 4,
    "missing": 0
  },
  "quality_gates": {
    "problem_confidence_gate": 4,
    "testability_gate": "passed",
    "structure_before_precision_gate": "passed"
  },
  "ready_for_handoff": true,
  "next_agent": "oo-modeler"
}
```

### 验证失败

```json
{
  "stage": "requirements",
  "version": "1.0.0",
  "status": "failed",
  "required_artifacts": {
    "present": 3,
    "missing": 1
  },
  "missing_artifacts": [
    {
      "filename": "ubiquitous-language.md",
      "reason": "File exists but only has 3 terms (minimum 5 required)"
    }
  ],
  "quality_gates": {
    "problem_confidence_gate": 2,
    "testability_gate": "failed",
    "structure_before_precision_gate": "passed"
  },
  "ready_for_handoff": false,
  "errors": [
    "problem_confidence_gate score is 2 (minimum 3 required)",
    "testability_gate failed: found vague terms in acceptance criteria"
  ]
}
```

## Validation Report

生成详细的验证报告：

```markdown
## 产出物验证报告

**阶段**: requirements
**版本**: v1.0.0
**验证时间**: 2025-03-03T12:00:00Z

### 必需产出物 ✅
- [x] problem-statement.md (存在)
- [x] ubiquitous-language.md (12 个术语 ≥ 5) ✅
- [x] domain-model.md (8 个概念 ≥ 3) ✅
- [x] use-cases.md (5 个用例 ≥ 1) ✅
- [x] metadata.json (status: completed) ✅

### 推荐产出物 ⚠️
- [x] story-map.md
- [x] user-stories.md (15 个故事)
- [x] business-rules.md (8 条规则)
- [x] acceptance-criteria.md (20 个场景)

### 质量门控评分
- problem_confidence_gate: 4/5 ✅ (≥ 3)
- testability_gate: passed ✅
- structure_before_precision_gate: passed ✅

### 验证结果
✅ **通过** - 可以交接给 oo-modeler

### 下一步
```javascript
Task(subagent_type="oo-modeler",
     prompt="基于 requirements v1.0.0 创建对象模型")
```
```

## Error Handling

- 如果 current 目录不存在，返回错误
- 如果 metadata.json 不存在，返回错误
- 如果必需产出物缺失，返回验证失败
- 如果质量门控未通过，返回验证失败
