---
name: artifact-init
description: Initialize artifact directory structure and create initial version. Use at the start of requirements analysis or object design phase.
tools: Bash, Write
---

# Skill: artifact-init

## Purpose
初始化产出物目录结构，创建初始版本（v1.0.0）或新版本。

## Usage

```javascript
// 初始化需求分析产出物目录
Skill("artifact-init", args="requirements")

// 初始化对象设计产出物目录
Skill("artifact-init", args="design")

// 创建新版本（升级）
Skill("artifact-init", args="requirements --version 1.1.0")
```

## Parameters

- `stage`: 阶段名称（requirements 或 design）
- `--version`: 可选，指定版本号（默认 v1.0.0）

## Behavior

### 如果目录不存在
1. 创建 `<stage>/v1.0.0/` 目录
2. 创建 `<stage>/current` 软链接指向 `v1.0.0`
3. 创建初始 `metadata.json`

### 如果目录已存在
1. 读取 `<stage>/current/metadata.json` 获取当前版本
2. 根据 `--version` 参数创建新版本目录
3. 复制当前版本的文件到新版本（作为起点）
4. 更新 `current` 软链接
5. 更新 `metadata.json`

## Output

返回初始化信息：
```json
{
  "stage": "requirements",
  "version": "1.0.0",
  "path": "requirements/v1.0.0",
  "status": "initialized",
  "message": "Initialized requirements v1.0.0"
}
```

## Directory Structure Created

```
<stage>/
├── current -> v1.0.0
└── v1.0.0/
    └── metadata.json
```

## Metadata Template

```json
{
  "version": "1.0.0",
  "agent": "<agent-name>",
  "created_at": "2025-03-03T12:00:00Z",
  "status": "in_progress",
  "artifacts": {}
}
```

## Error Handling

- 如果版本号格式不正确，返回错误
- 如果版本号已存在，返回错误
- 如果无法创建目录，返回错误

## Implementation

```bash
#!/bin/bash
# artifact-init.sh

STAGE=$1
VERSION=${2:-1.0.0}

# 验证参数
if [[ ! "$STAGE" =~ ^(requirements|design)$ ]]; then
  echo "Error: stage must be 'requirements' or 'design'"
  exit 1
fi

# 验证版本号格式
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: version must be in format X.Y.Z"
  exit 1
fi

# 创建目录
mkdir -p "$STAGE/v$VERSION"

# 创建或更新软链接
ln -sfn "v$VERSION" "$STAGE/current"

# 创建 metadata.json
cat > "$STAGE/v$VERSION/metadata.json" <<EOF
{
  "version": "$VERSION",
  "agent": "",
  "created_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "status": "in_progress",
  "artifacts": {}
}
EOF

echo "Initialized $STAGE v$VERSION"
```
