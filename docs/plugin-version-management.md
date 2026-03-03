---
title: 插件版本管理说明
date: 2025-03-03
---

# 插件版本管理说明

## 问题：当前安装机制会覆盖之前的版本

### 当前行为

使用 `install-user.sh` 或 `install-project.sh` 重新安装时：

```bash
cp -r "$PROJECT_DIR/agents/"* "$CLAUDE_DIR/agents/"
```

**问题**：
1. ✅ 新版本文件会覆盖旧版本
2. ❌ 旧版本中存在但新版本中删除的文件会保留（"孤儿文件"）
3. ❌ 无法回滚到之前的版本
4. ❌ 无法知道当前安装的是哪个版本

**示例**：
```
# 安装 v0.1.0（包含 agent-a.md, agent-b.md）
./install-user.sh

# 安装 v0.2.0（包含 agent-a.md, agent-c.md，删除了 agent-b.md）
./install-user.sh

# 结果：~/.claude/agents/ 包含 agent-a.md（v0.2.0）, agent-b.md（v0.1.0 孤儿）, agent-c.md（v0.2.0）
```

---

## 解决方案：版本化安装

### 目录结构

```
~/.claude/
├── plugins/
│   └── project-aletheia/
│       ├── current -> versions/v0.2.0  # 软链接指向当前版本
│       ├── versions/
│       │   ├── v0.1.0/
│       │   │   ├── agents/
│       │   │   ├── skills/
│       │   │   ├── hooks/
│       │   │   └── metadata.json
│       │   └── v0.2.0/
│       │       ├── agents/
│       │       ├── skills/
│       │       ├── hooks/
│       │       └── metadata.json
│       └── versions.json  # 版本历史
├── agents/
│   ├── requirements-analyst.md -> ../plugins/project-aletheia/current/agents/requirements-analyst.md
│   └── oo-modeler.md -> ../plugins/project-aletheia/current/agents/oo-modeler.md
├── skills/
│   ├── req-gate-check.md -> ../plugins/project-aletheia/current/skills/req-gate-check.md
│   └── artifact-init.md -> ../plugins/project-aletheia/current/skills/artifact-init.md
└── hooks/
    └── pre-command.sh -> ../plugins/project-aletheia/current/hooks/pre-command.sh
```

### 工作原理

1. **版本隔离**：每个版本安装到独立目录 `versions/v<version>/`
2. **符号链接**：`current` 指向当前激活的版本
3. **标准目录链接**：`~/.claude/agents/` 中的文件是指向 `current/agents/` 的符号链接
4. **版本切换**：只需更新 `current` 链接和重新创建符号链接

---

## 使用方法

### 1. 安装新版本

```bash
# 安装到用户层级
./install-user-versioned.sh

# 强制重新安装（覆盖已存在的版本）
./install-user-versioned.sh --force
```

**行为**：
- 读取 `package.json` 中的版本号
- 检查版本是否已安装
- 创建 `~/.claude/plugins/project-aletheia/versions/v<version>/` 目录
- 复制 agents、skills、hooks 到版本目录
- 更新 `current` 软链接
- 创建符号链接到 `~/.claude/agents/`, `~/.claude/skills/`, `~/.claude/hooks/`
- 更新 `versions.json`

### 2. 切换版本

```bash
# 列出可用版本
ls ~/.claude/plugins/project-aletheia/versions

# 切换到指定版本
./switch-version.sh v0.1.0
```

**行为**：
- 验证版本是否存在
- 更新 `current` 软链接
- 清理旧的符号链接
- 创建新的符号链接
- 需要重启 Claude Code

### 3. 卸载版本

```bash
# 卸载特定版本
./uninstall.sh v0.1.0

# 卸载整个插件（所有版本）
./uninstall.sh
```

**行为**：
- 删除版本目录
- 如果是当前版本，清理符号链接
- 如果卸载整个插件，删除 `plugins/project-aletheia/` 目录

---

## 版本历史文件

### versions.json

```json
[
  {
    "version": "0.1.0",
    "installed_at": "2025-03-03T10:00:00Z"
  },
  {
    "version": "0.2.0",
    "installed_at": "2025-03-03T12:00:00Z"
  }
]
```

### metadata.json（每个版本）

```json
{
  "version": "0.2.0",
  "installed_at": "2025-03-03T12:00:00Z",
  "source": "/Users/username/develop/project-aletheia"
}
```

---

## 优势

### 1. 多版本共存
- 可以安装多个版本
- 不会相互覆盖
- 可以快速切换

### 2. 安全回滚
- 如果新版本有问题，可以立即回滚到旧版本
- 不会丢失旧版本的文件

### 3. 清晰的版本管理
- 知道当前使用的是哪个版本
- 知道安装了哪些版本
- 知道每个版本的安装时间

### 4. 无孤儿文件
- 切换版本时，旧版本的文件不会残留
- 符号链接机制确保只有当前版本的文件可见

---

## 迁移指南

### 从旧安装方式迁移

如果你之前使用 `install-user.sh` 安装：

```bash
# 1. 备份当前安装
cp -r ~/.claude/agents ~/.claude/agents.backup
cp -r ~/.claude/skills ~/.claude/skills.backup
cp -r ~/.claude/hooks ~/.claude/hooks.backup

# 2. 清理旧安装
rm -rf ~/.claude/agents/requirements-analyst.md
rm -rf ~/.claude/agents/oo-modeler.md
rm -rf ~/.claude/skills/req-*.md
rm -rf ~/.claude/skills/oo-*.md
rm -rf ~/.claude/skills/artifact-*.md

# 3. 使用新安装脚本
./install-user-versioned.sh
```

---

## 项目层级安装

项目层级安装使用相同的版本化机制，但文件安装在项目的 `.claude/` 目录中。

### 目录结构

```
your-project/
└── .claude/
    ├── plugins/
    │   └── project-aletheia/
    │       ├── current -> versions/v0.2.0  # 软链接指向当前版本
    │       ├── versions/
    │       │   ├── v0.1.0/
    │       │   │   ├── agents/
    │       │   │   ├── skills/
    │       │   │   ├── hooks/
    │       │   │   └── metadata.json
    │       │   └── v0.2.0/
    │       │       ├── agents/
    │       │       ├── skills/
    │       │       ├── hooks/
    │       │       └── metadata.json
    │       └── versions.json
    ├── agents/
    │   ├── requirements-analyst.md -> ../plugins/project-aletheia/current/agents/requirements-analyst.md
    │   └── oo-modeler.md -> ../plugins/project-aletheia/current/agents/oo-modeler.md
    ├── skills/
    │   ├── req-gate-check.md -> ../plugins/project-aletheia/current/skills/req-gate-check.md
    │   └── artifact-init.md -> ../plugins/project-aletheia/current/skills/artifact-init.md
    └── hooks/
        └── pre-command.sh -> ../plugins/project-aletheia/current/hooks/pre-command.sh
```

### 使用方法

#### 1. 安装到项目

```bash
# 从 project-aletheia 目录运行
./install-project-versioned.sh /path/to/your/project

# 强制重新安装
./install-project-versioned.sh /path/to/your/project --force
```

#### 2. 切换版本

```bash
# 从 project-aletheia 目录运行
./switch-version-project.sh /path/to/your/project v0.1.0

# 或在项目目录中运行
cd /path/to/your/project
/path/to/project-aletheia/switch-version-project.sh . v0.1.0
```

#### 3. 卸载

```bash
# 卸载特定版本
./uninstall-project.sh /path/to/your/project v0.1.0

# 卸载整个插件
./uninstall-project.sh /path/to/your/project
```

### 项目层级 vs 用户层级

| 特性 | 用户层级 | 项目层级 |
|------|---------|---------|
| 安装位置 | `~/.claude/` | `<project>/.claude/` |
| 作用范围 | 所有项目 | 仅当前项目 |
| 版本隔离 | 所有项目共享版本 | 每个项目独立版本 |
| 适用场景 | 通用工具、个人偏好 | 项目特定配置 |

**推荐策略**：
- **用户层级**：安装稳定版本，作为默认工具集
- **项目层级**：安装项目特定版本，或测试新版本

### 优先级

当同时存在用户层级和项目层级安装时：
- Claude Code 优先使用**项目层级**的 agents/skills/hooks
- 如果项目层级没有，则使用用户层级的

这允许你：
1. 在用户层级安装稳定版本（如 v0.1.0）
2. 在特定项目中测试新版本（如 v0.2.0-beta）
3. 项目层级的配置会覆盖用户层级

---

## 常见问题

### Q: 如何查看当前版本？

```bash
readlink ~/.claude/plugins/project-aletheia/current
# 输出: versions/v0.2.0
```

或查看 metadata：
```bash
cat ~/.claude/plugins/project-aletheia/current/metadata.json
```

### Q: 如何列出所有已安装版本？

```bash
ls -1 ~/.claude/plugins/project-aletheia/versions
```

### Q: 切换版本后需要重启 Claude Code 吗？

是的，需要重启 Claude Code 以重新加载 agents 和 skills。

### Q: 可以同时使用多个版本吗？

不可以。同一时间只能激活一个版本（通过 `current` 链接）。但可以快速切换。

### Q: 如何清理所有旧版本？

```bash
# 保留当前版本，删除其他版本
cd ~/.claude/plugins/project-aletheia/versions
CURRENT=$(readlink ../current | sed 's/versions\///')
for version in v*; do
  if [ "$version" != "$CURRENT" ]; then
    rm -rf "$version"
  fi
done
```

---

## 总结

**旧方式**：
- ❌ 覆盖安装
- ❌ 无版本管理
- ❌ 无法回滚
- ❌ 孤儿文件问题

**新方式**：
- ✅ 版本隔离
- ✅ 多版本共存
- ✅ 快速切换
- ✅ 安全回滚
- ✅ 无孤儿文件
- ✅ 清晰的版本历史

建议使用新的版本化安装方式（`install-user-versioned.sh`）。
