---
title: YAML Front Matter 清理说明
date: 2025-03-XX
---

# YAML Front Matter 清理说明

## 清理原因

Claude Code 实际上**不会主动使用**大部分 YAML front matter 字段。这些字段主要是为了文档化和未来扩展，但会增加文件的复杂度和维护成本。

## 删除的字段

### 1. version
```yaml
version: 1.0.0  # ❌ 删除
```

**原因**: Claude Code 没有版本管理机制，不会根据版本号选择 agent。

### 2. author
```yaml
author: project-aletheia  # ❌ 删除
```

**原因**: 纯元数据，Claude Code 不使用。

### 3. tags
```yaml
tags:  # ❌ 删除
  - requirements
  - analysis
  - use-cases
```

**原因**: Claude Code 不会主动解析和使用 tags 进行搜索或推荐。

### 4. category
```yaml
category: analysis  # ❌ 删除
```

**原因**: 纯分类元数据，Claude Code 不使用。

### 5. theory_base
```yaml
theory_base:  # ❌ 从 YAML 删除，✅ 保留在正文中
  - Are Your Lights On (Weinberg)
  - Software Requirements (Wiegers)
```

**原因**:
- YAML 中的 theory_base 是冗余的，Claude Code 不使用
- **理论基础信息已保留在 agent 正文中**，在每一层的认知架构中都有标注

**保留位置**:
- **requirements-analyst.md**: 在 "Cognitive Kernel" 章节，每层都标注了理论基础
  ```markdown
  ### 五层认知架构
  1. **哲学层**: 问题本质探索 (Are Your Lights On?)
  2. **质量层**: 需求质量保证 (Exploring Requirements, Software Requirements, Volere)
  3. **结构层**: 需求结构化表达 (Use Cases, User Story Mapping)
  4. **精度层**: 需求精确规约 (Specification by Example)
  5. **语义层**: 统一语言与领域概念模型 (Domain-Driven Design)
  ```

- **requirements-analyst-v2.md**: 在每一层都详细标注了理论基础
  ```markdown
  #### 第 1 层: 哲学层 - 问题本质探索
  **理论基础**: Are Your Lights On? (Weinberg)

  #### 第 2 层: 质量层 - 需求质量保证
  **理论基础**: Exploring Requirements, Software Requirements, Volere
  ```

- **oo-modeler.md**: 在 "Cognitive Kernel" 章节标注了理论基础
  ```markdown
  ### 四层认知架构
  1. **责任驱动核心**: 职责分配与协作设计 (Wirfs-Brock RDD)
  2. **交互与场景建模**: 从用例到对象交互 (Cockburn Use Cases)
  3. **语义桥梁**: 从概念模型到设计模型 (Evans DDD)
  4. **形式表达**: UML 标准建模语言 (Martin UML)
  ```

- **oo-modeler-v2.md**: 在每一层都详细标注了理论基础
  ```markdown
  #### 第 1 层: 责任驱动核心 - 职责分配与协作设计
  **理论基础**: Object Design (Wirfs-Brock RDD)

  #### 第 2 层: 交互与场景建模 - 从用例到对象交互
  **理论基础**: Writing Effective Use Cases (Cockburn)
  ```

- **详细理论文档**:
  - `docs/requirements-analyst-theory.md`
  - `docs/oo-modeler-theory.md`

### 6. related_agents
```yaml
related_agents:  # ❌ 删除
  - oo-modeler
```

**原因**: 纯文档，Claude Code 不会自动加载关联 agents。关联关系已在正文中说明。

### 7. related_skills
```yaml
related_skills:  # ❌ 删除
  - req-gate-check
  - req-quality-check
```

**原因**: 纯文档，Claude Code 不会自动加载关联 skills。关联关系已在正文中说明。

---

## 保留的字段

### 1. name ✅
```yaml
name: requirements-analyst
```

**原因**: 这是 agent 的唯一标识符，用于 Task 调用：
```javascript
Task(subagent_type="requirements-analyst", ...)
```

### 2. description ✅
```yaml
description: 需求分析领域专家，融合经典理论与实践门控机制的五层认知架构
```

**原因**: 可能在某些 UI 或日志中显示，提供简短的 agent 说明。

---

## 清理后的 YAML Front Matter

### Agent 文件
```yaml
---
name: requirements-analyst
description: 需求分析领域专家，融合经典理论与实践门控机制的五层认知架构
---
```

### Skill 文件
```yaml
---
name: req-gate-check
description: 需求门控检查，评估是否满足进入下一层的条件
---
```

---

## 清理的文件列表

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

## 信息迁移

删除的元数据信息已迁移到以下位置：

### 1. 理论基础 (theory_base) ✅ 已保留
**位置**: Agent 正文的 "Cognitive Kernel" 章节

**requirements-analyst.md / requirements-analyst-v2.md**:
- 每一层都标注了对应的理论基础
- 第 1 层: Are Your Lights On? (Weinberg)
- 第 2 层: Exploring Requirements, Software Requirements, Volere
- 第 3 层: Use Cases, User Story Mapping
- 第 4 层: Specification by Example
- 第 5 层: Domain-Driven Design

**oo-modeler.md / oo-modeler-v2.md**:
- 每一层都标注了对应的理论基础
- 第 1 层: Object Design (Wirfs-Brock RDD)
- 第 2 层: Writing Effective Use Cases (Cockburn)
- 第 3 层: Domain-Driven Design (Evans)
- 第 4 层: Object-Oriented Methods (Martin)

**详细理论文档**:
- `docs/requirements-analyst-theory.md` (完整理论阐述)
- `docs/oo-modeler-theory.md` (完整理论阐述)

### 2. 关联关系 (related_agents, related_skills)
- 保留在 agent 正文的 "Related Skills" 和 "Integration" 章节
- 保留在 docs/agents-and-skills-inventory.md

### 3. 版本信息 (version)
- v1 和 v2 通过文件名区分：
  - requirements-analyst.md (v1)
  - requirements-analyst-v2.md (v2)
- 版本对比保留在：
  - docs/requirements-analyst-comparison.md
  - docs/oo-modeler-comparison.md

### 4. 分类信息 (category, tags)
- 保留在 docs/agents-and-skills-inventory.md
- 通过文件目录结构体现：
  - agents/ (agent 文件)
  - skills/ (skill 文件)

---

## 优势

### 1. 简洁性
- YAML front matter 从 20+ 行减少到 3 行
- 更容易阅读和维护

### 2. 减少冗余
- 避免在 YAML 和正文中重复相同信息
- 单一信息源原则

### 3. 聚焦核心
- 只保留 Claude Code 实际使用的字段
- 避免误导（让人以为这些字段会被使用）

### 4. 易于维护
- 更新信息时只需修改一处（正文）
- 不需要同步 YAML 和正文

---

## 对比

### 清理前
```yaml
---
name: requirements-analyst
version: 2.0.0
author: project-aletheia
description: 需求分析领域专家，融合经典理论与实践门控机制的五层认知架构
tags:
  - requirements
  - analysis
  - use-cases
  - user-stories
  - domain-modeling
  - bdd
category: analysis
theory_base:
  - Are Your Lights On (Weinberg)
  - Exploring Requirements (Weinberg & Gause)
  - Software Requirements (Wiegers)
  - Mastering the Requirements Process (Robertson)
  - Writing Effective Use Cases (Cockburn)
  - User Story Mapping (Patton)
  - Specification by Example (Adzic)
  - Domain-Driven Design (Evans)
related_agents:
  - oo-modeler
related_skills:
  - req-gate-check
  - req-quality-check
  - req-use-case
  - req-story-map
  - req-example
  - req-domain-model
---
```

**行数**: 32 行

### 清理后
```yaml
---
name: requirements-analyst
description: 需求分析领域专家，融合经典理论与实践门控机制的五层认知架构
---
```

**行数**: 3 行

**减少**: 29 行 (90.6%)

---

## 注意事项

### 如果未来 Claude Code 支持更多字段

如果 Claude Code 未来支持 tags、category 等字段，可以：

1. 从 docs/agents-and-skills-inventory.md 恢复这些信息
2. 使用脚本批量添加回 YAML front matter
3. 所有信息都有备份，不会丢失

### 文档化

虽然删除了 YAML 中的元数据，但这些信息仍然保留在：

**理论基础 (theory_base)**:
- ✅ Agent 正文的 "Cognitive Kernel" 章节（每一层都有标注）
- ✅ docs/requirements-analyst-theory.md（完整理论阐述）
- ✅ docs/oo-modeler-theory.md（完整理论阐述）

**关联关系 (related_agents, related_skills)**:
- ✅ Agent 正文的 "Related Skills" 和 "Integration" 章节
- ✅ docs/agents-and-skills-inventory.md（完整清单）

**版本信息 (version)**:
- ✅ 文件名区分（requirements-analyst.md vs requirements-analyst-v2.md）
- ✅ docs/requirements-analyst-comparison.md（版本对比）
- ✅ docs/oo-modeler-comparison.md（版本对比）

**分类信息 (category, tags)**:
- ✅ docs/agents-and-skills-inventory.md（完整分类）
- ✅ 文件目录结构（agents/ vs skills/）

---

## 总结

**删除的字段**: version, author, tags, category, theory_base, related_agents, related_skills

**保留的字段**: name, description

**原因**: Claude Code 只使用 name 和 description，其他字段是纯元数据

**信息保留**: 所有删除的信息都已迁移到正文或文档中，不会丢失

**优势**: 简洁、减少冗余、易于维护、聚焦核心
