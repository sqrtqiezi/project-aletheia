---
title: Agent 产出物命名规范与版本管理
date: 2025-03-03
---

# Agent 产出物命名规范与版本管理

## 设计原则

### 1. 可追溯性（Traceability）
- 每个产出物都有明确的版本号
- 可以追溯到创建它的 agent 和时间

### 2. 可发现性（Discoverability）
- 文件名清晰表达内容
- 统一的目录结构
- 易于查找和引用

### 3. 渐进式演进（Progressive Evolution）
- 支持多个 feature 逐步完善
- 保留历史版本
- 支持回滚

### 4. 协作友好（Collaboration-Friendly）
- 明确的交接点
- 清晰的依赖关系
- 易于验证完整性

---

## 目录结构

```
project-root/
├── requirements/              # 需求分析产出物
│   ├── current/              # 当前版本（软链接）
│   │   ├── problem-statement.md
│   │   ├── ubiquitous-language.md
│   │   ├── domain-model.md
│   │   ├── use-cases.md
│   │   ├── story-map.md
│   │   ├── user-stories.md
│   │   ├── business-rules.md
│   │   ├── acceptance-criteria.md
│   │   └── metadata.json
│   ├── v1.0.0/               # 版本快照
│   ├── v1.1.0/
│   └── v2.0.0/
├── design/                    # 对象设计产出物
│   ├── current/              # 当前版本（软链接）
│   │   ├── object-catalog.md
│   │   ├── crc-cards.md
│   │   ├── responsibility-matrix.md
│   │   ├── interaction-sequences.md
│   │   ├── aggregates.md
│   │   ├── domain-services.md
│   │   ├── class-diagram.puml
│   │   ├── sequence-diagrams.puml
│   │   ├── design-decisions.md
│   │   └── metadata.json
│   ├── v1.0.0/
│   ├── v1.1.0/
│   └── v2.0.0/
└── .aletheia/                 # 元数据和配置
    ├── workflow.json         # 工作流状态
    └── versions.json         # 版本历史
```

---

## 文件命名规范

### Requirements Analyst 产出物

| 文件名 | 描述 | 必需/推荐 |
|--------|------|-----------|
| `problem-statement.md` | 经过验证的问题陈述（问题简报） | ✅ 必需 |
| `ubiquitous-language.md` | 统一语言词汇表 | ✅ 必需 |
| `domain-model.md` | 领域概念模型 | ✅ 必需 |
| `use-cases.md` | 用例场景 | ✅ 必需 |
| `story-map.md` | 用户故事地图 | ⚠️ 推荐 |
| `user-stories.md` | 用户故事列表 | ⚠️ 推荐 |
| `business-rules.md` | 业务规则列表 | ⚠️ 推荐 |
| `acceptance-criteria.md` | 验收标准（Given/When/Then） | ⚠️ 推荐 |
| `metadata.json` | 元数据（版本、创建时间、agent 信息） | ✅ 必需 |

### OO Modeler 产出物

| 文件名 | 描述 | 必需/推荐 |
|--------|------|-----------|
| `object-catalog.md` | 对象清单（CRC 卡片集合） | ✅ 必需 |
| `crc-cards.md` | CRC 卡片详细定义 | ✅ 必需 |
| `responsibility-matrix.md` | 职责分配矩阵 | ✅ 必需 |
| `interaction-sequences.md` | 交互序列（文本描述） | ✅ 必需 |
| `aggregates.md` | 聚合设计 | ✅ 必需 |
| `domain-services.md` | 领域服务定义 | ⚠️ 推荐 |
| `class-diagram.puml` | 类图（PlantUML） | ⚠️ 推荐 |
| `sequence-diagrams.puml` | 序列图（PlantUML） | ⚠️ 推荐 |
| `design-decisions.md` | 设计决策记录 | ⚠️ 推荐 |
| `metadata.json` | 元数据 | ✅ 必需 |

---

## 版本管理系统

### 版本号格式：Semantic Versioning

```
v<major>.<minor>.<patch>

例如：v1.0.0, v1.1.0, v2.0.0
```

**版本号规则**：
- **Major（主版本）**: 重大变更，不兼容的修改（如重新定义问题、重构领域模型）
- **Minor（次版本）**: 新增功能，向后兼容（如新增用例、新增对象）
- **Patch（补丁版本）**: 修复错误，向后兼容（如修正术语、修复不一致）

### 版本快照

每个版本都是一个完整的快照，包含所有产出物：

```
requirements/v1.0.0/
├── problem-statement.md
├── ubiquitous-language.md
├── domain-model.md
├── use-cases.md
├── story-map.md
├── user-stories.md
├── business-rules.md
├── acceptance-criteria.md
└── metadata.json
```

### Current 软链接

`current/` 目录是指向最新版本的软链接：

```bash
requirements/current -> requirements/v1.0.0/
```

**优势**：
- Agent 总是读取 `current/` 目录
- 版本切换只需更新软链接
- 保留所有历史版本

---

## Metadata 格式

### requirements/current/metadata.json

```json
{
  "version": "1.0.0",
  "agent": "requirements-analyst",
  "created_at": "2025-03-03T12:00:00Z",
  "created_by": "user@example.com",
  "status": "completed",
  "confidence_score": {
    "problem_confidence_gate": 4,
    "testability_gate": "passed",
    "structure_before_precision_gate": "passed"
  },
  "artifacts": {
    "problem-statement.md": {
      "status": "completed",
      "checksum": "sha256:abc123..."
    },
    "ubiquitous-language.md": {
      "status": "completed",
      "checksum": "sha256:def456...",
      "term_count": 12
    },
    "domain-model.md": {
      "status": "completed",
      "checksum": "sha256:ghi789...",
      "concept_count": 8
    },
    "use-cases.md": {
      "status": "completed",
      "checksum": "sha256:jkl012...",
      "use_case_count": 5
    }
  },
  "dependencies": [],
  "next_agent": "oo-modeler",
  "notes": "Initial requirements analysis for e-commerce system"
}
```

### design/current/metadata.json

```json
{
  "version": "1.0.0",
  "agent": "oo-modeler",
  "created_at": "2025-03-03T14:00:00Z",
  "created_by": "user@example.com",
  "status": "completed",
  "quality_score": {
    "responsibility_clarity_gate": 4,
    "coupling_control_gate": 4,
    "domain_alignment_gate": 5
  },
  "artifacts": {
    "object-catalog.md": {
      "status": "completed",
      "checksum": "sha256:mno345...",
      "object_count": 15
    },
    "crc-cards.md": {
      "status": "completed",
      "checksum": "sha256:pqr678..."
    },
    "aggregates.md": {
      "status": "completed",
      "checksum": "sha256:stu901...",
      "aggregate_count": 4
    }
  },
  "dependencies": [
    {
      "agent": "requirements-analyst",
      "version": "1.0.0",
      "artifacts": [
        "ubiquitous-language.md",
        "domain-model.md",
        "use-cases.md"
      ]
    }
  ],
  "anti_patterns_detected": [],
  "notes": "Initial object design based on requirements v1.0.0"
}
```

---

## 工作流状态管理

### .aletheia/workflow.json

```json
{
  "current_stage": "design",
  "stages": {
    "requirements": {
      "agent": "requirements-analyst",
      "status": "completed",
      "version": "1.0.0",
      "completed_at": "2025-03-03T12:00:00Z"
    },
    "design": {
      "agent": "oo-modeler",
      "status": "in_progress",
      "version": "1.0.0",
      "started_at": "2025-03-03T14:00:00Z"
    },
    "implementation": {
      "agent": null,
      "status": "pending",
      "version": null
    }
  },
  "history": [
    {
      "stage": "requirements",
      "agent": "requirements-analyst",
      "version": "1.0.0",
      "action": "completed",
      "timestamp": "2025-03-03T12:00:00Z"
    }
  ]
}
```

### .aletheia/versions.json

```json
{
  "requirements": {
    "current": "1.0.0",
    "versions": [
      {
        "version": "1.0.0",
        "created_at": "2025-03-03T12:00:00Z",
        "created_by": "user@example.com",
        "description": "Initial requirements analysis",
        "changes": "Initial version"
      }
    ]
  },
  "design": {
    "current": "1.0.0",
    "versions": [
      {
        "version": "1.0.0",
        "created_at": "2025-03-03T14:00:00Z",
        "created_by": "user@example.com",
        "description": "Initial object design",
        "changes": "Initial version based on requirements v1.0.0",
        "based_on": {
          "requirements": "1.0.0"
        }
      }
    ]
  }
}
```

---

## Agent 行为规范

### Requirements Analyst

#### 启动时
1. 检查 `requirements/current/` 是否存在
2. 如果存在，读取 `metadata.json` 获取当前版本
3. 如果不存在，创建 `v1.0.0` 目录

#### 工作时
1. 在 `requirements/v<version>/` 目录中创建产出物
2. 使用标准文件名（见上表）
3. 创建 `metadata.json` 记录元数据

#### 完成时
1. 验证所有必需产出物已创建
2. 更新 `metadata.json` 的 status 为 "completed"
3. 创建或更新 `current/` 软链接指向新版本
4. 更新 `.aletheia/workflow.json` 和 `.aletheia/versions.json`
5. 输出交接清单

#### 版本升级规则
- **Major 升级**：重新定义问题、重构领域模型
- **Minor 升级**：新增用例、新增业务规则
- **Patch 升级**：修正术语、修复不一致

### OO Modeler

#### 启动时（前置条件检查）
1. 检查 `requirements/current/metadata.json`
2. 验证 status 为 "completed"
3. 验证必需产出物存在：
   - `ubiquitous-language.md`（至少 5 个术语）
   - `domain-model.md`（至少 3 个概念）
   - `use-cases.md`（至少 1 个用例）
4. 如果验证失败，**拒绝启动**，返回缺失信息

#### 工作时
1. 读取 `requirements/current/` 的产出物
2. 在 `design/v<version>/` 目录中创建产出物
3. 使用标准文件名（见上表）
4. 在 `metadata.json` 中记录依赖关系

#### 完成时
1. 验证所有必需产出物已创建
2. 更新 `metadata.json` 的 status 为 "completed"
3. 创建或更新 `current/` 软链接
4. 更新 `.aletheia/workflow.json` 和 `.aletheia/versions.json`
5. 输出交接清单

#### 版本升级规则
- **Major 升级**：重构对象模型、重新设计聚合
- **Minor 升级**：新增对象、新增领域服务
- **Patch 升级**：修正职责分配、修复循环依赖

---

## 交接清单（Handoff Checklist）

### Requirements Analyst → OO Modeler

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

### 下一步
可以启动 oo-modeler 进行对象设计。

**命令**:
```javascript
Task(subagent_type="oo-modeler",
     prompt="基于 requirements v1.0.0 创建对象模型")
```
```

### OO Modeler → Implementation

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

### 下一步
可以开始实现阶段。

**建议**:
1. 从核心聚合开始实现
2. 优先实现 Entity 和 Value Object
3. 使用 TDD 方法
```

---

## 版本演进示例

### 场景：新增一个 Feature

**初始状态**:
- requirements: v1.0.0
- design: v1.0.0

**步骤 1**: 需求分析新增用例
```bash
# requirements-analyst 工作
# 新增 2 个用例到 use-cases.md
# 新增 3 个术语到 ubiquitous-language.md
# 版本升级：v1.0.0 → v1.1.0 (Minor)
```

**步骤 2**: 对象设计新增对象
```bash
# oo-modeler 工作
# 基于 requirements v1.1.0
# 新增 3 个对象到 object-catalog.md
# 版本升级：v1.0.0 → v1.1.0 (Minor)
```

**最终状态**:
- requirements: v1.1.0
- design: v1.1.0

### 场景：重大重构

**初始状态**:
- requirements: v1.1.0
- design: v1.1.0

**步骤 1**: 重新定义问题
```bash
# requirements-analyst 工作
# 重新定义问题陈述
# 重构领域模型
# 版本升级：v1.1.0 → v2.0.0 (Major)
```

**步骤 2**: 重新设计对象模型
```bash
# oo-modeler 工作
# 基于 requirements v2.0.0
# 重构聚合边界
# 版本升级：v1.1.0 → v2.0.0 (Major)
```

**最终状态**:
- requirements: v2.0.0
- design: v2.0.0

---

## 实用工具

### 创建新版本

```bash
#!/bin/bash
# create-version.sh

STAGE=$1  # requirements 或 design
VERSION=$2  # 例如 1.1.0

mkdir -p "$STAGE/v$VERSION"
cp -r "$STAGE/current/"* "$STAGE/v$VERSION/"
ln -sfn "v$VERSION" "$STAGE/current"

echo "Created $STAGE v$VERSION"
```

### 验证产出物完整性

```bash
#!/bin/bash
# validate-artifacts.sh

STAGE=$1  # requirements 或 design

if [ "$STAGE" == "requirements" ]; then
  REQUIRED=(
    "problem-statement.md"
    "ubiquitous-language.md"
    "domain-model.md"
    "use-cases.md"
    "metadata.json"
  )
elif [ "$STAGE" == "design" ]; then
  REQUIRED=(
    "object-catalog.md"
    "crc-cards.md"
    "responsibility-matrix.md"
    "interaction-sequences.md"
    "aggregates.md"
    "metadata.json"
  )
fi

for file in "${REQUIRED[@]}"; do
  if [ ! -f "$STAGE/current/$file" ]; then
    echo "❌ Missing: $file"
    exit 1
  fi
done

echo "✅ All required artifacts present"
```

### 查看版本历史

```bash
#!/bin/bash
# list-versions.sh

STAGE=$1  # requirements 或 design

echo "Versions for $STAGE:"
ls -1 "$STAGE" | grep "^v" | sort -V
```

---

## 总结

### 核心优势

1. **清晰的交接点** - 通过 metadata.json 和交接清单
2. **可追溯性** - 每个版本都有完整的快照
3. **渐进式演进** - 支持 Major/Minor/Patch 升级
4. **协作友好** - 标准化的文件名和目录结构
5. **质量保证** - 通过前置条件检查和门控评分

### 下一步

1. 在 agent 定义中添加文件命名和版本管理规范
2. 创建 `/artifact-init` skill 初始化目录结构
3. 创建 `/artifact-validate` skill 验证产出物完整性
4. 创建 `/artifact-version` skill 管理版本升级
