---
name: artifact-save
description: Save an artifact file to the current version directory with automatic metadata update. Use when creating or updating requirement/design documents.
tools: Write, Read, Edit, Bash
---

# Skill: artifact-save

## Purpose
保存产出物文件到当前版本目录，并自动更新 metadata.json。

## Usage

```javascript
// 保存需求分析产出物
Skill("artifact-save", args="requirements ubiquitous-language.md")

// 保存对象设计产出物
Skill("artifact-save", args="design crc-cards.md")
```

## Parameters

- `stage`: 阶段名称（requirements 或 design）
- `filename`: 文件名（必须是标准文件名）
- `content`: 文件内容（通过 stdin 或文件路径）

## Standard Filenames

### Requirements Stage
- `problem-statement.md` ✅ 必需
- `ubiquitous-language.md` ✅ 必需
- `domain-model.md` ✅ 必需
- `use-cases.md` ✅ 必需
- `story-map.md` ⚠️ 推荐
- `user-stories.md` ⚠️ 推荐
- `business-rules.md` ⚠️ 推荐
- `acceptance-criteria.md` ⚠️ 推荐

### Design Stage
- `object-catalog.md` ✅ 必需
- `crc-cards.md` ✅ 必需
- `responsibility-matrix.md` ✅ 必需
- `interaction-sequences.md` ✅ 必需
- `aggregates.md` ✅ 必需
- `domain-services.md` ⚠️ 推荐
- `class-diagram.puml` ⚠️ 推荐
- `sequence-diagrams.puml` ⚠️ 推荐
- `design-decisions.md` ⚠️ 推荐

## Behavior

1. 验证文件名是否在标准列表中
2. 将内容写入 `<stage>/current/<filename>`
3. 更新 `<stage>/current/metadata.json`：
   - 添加或更新 `artifacts[filename]`
   - 记录 checksum
   - 记录统计信息（如术语数、对象数等）

## Output

```json
{
  "stage": "requirements",
  "filename": "ubiquitous-language.md",
  "path": "requirements/current/ubiquitous-language.md",
  "status": "saved",
  "stats": {
    "term_count": 12,
    "size_bytes": 2048
  }
}
```

## Metadata Update

更新 `metadata.json` 的 `artifacts` 字段：

```json
{
  "artifacts": {
    "ubiquitous-language.md": {
      "status": "completed",
      "checksum": "sha256:abc123...",
      "term_count": 12,
      "updated_at": "2025-03-03T12:30:00Z"
    }
  }
}
```

## Statistics Extraction

根据文件类型自动提取统计信息：

- `ubiquitous-language.md`: 术语数（term_count）
- `domain-model.md`: 概念数（concept_count）
- `use-cases.md`: 用例数（use_case_count）
- `user-stories.md`: 故事数（story_count）
- `business-rules.md`: 规则数（rule_count）
- `object-catalog.md`: 对象数（object_count）
- `aggregates.md`: 聚合数（aggregate_count）

## Error Handling

- 如果文件名不在标准列表中，返回警告（但仍然保存）
- 如果 current 目录不存在，返回错误（需要先运行 artifact-init）
- 如果无法写入文件，返回错误
