---
title: 版本管理快速参考
date: 2025-03-03
---

# 版本管理快速参考

## 用户层级安装（所有项目可用）

### 安装
```bash
# 安装新版本
./install-user-versioned.sh

# 强制重新安装
./install-user-versioned.sh --force
```

### 切换版本
```bash
# 列出可用版本
ls ~/.claude/plugins/project-aletheia/versions

# 切换到指定版本
./switch-version.sh v0.1.0
```

### 卸载
```bash
# 卸载特定版本
./uninstall.sh v0.1.0

# 卸载整个插件
./uninstall.sh
```

### 查看当前版本
```bash
readlink ~/.claude/plugins/project-aletheia/current
# 或
cat ~/.claude/plugins/project-aletheia/current/metadata.json
```

---

## 项目层级安装（仅当前项目可用）

### 安装
```bash
# 安装到项目
./install-project-versioned.sh /path/to/your/project

# 强制重新安装
./install-project-versioned.sh /path/to/your/project --force
```

### 切换版本
```bash
# 列出可用版本
ls /path/to/your/project/.claude/plugins/project-aletheia/versions

# 切换到指定版本
./switch-version-project.sh /path/to/your/project v0.1.0
```

### 卸载
```bash
# 卸载特定版本
./uninstall-project.sh /path/to/your/project v0.1.0

# 卸载整个插件
./uninstall-project.sh /path/to/your/project
```

### 查看当前版本
```bash
readlink /path/to/your/project/.claude/plugins/project-aletheia/current
# 或
cat /path/to/your/project/.claude/plugins/project-aletheia/current/metadata.json
```

---

## 目录结构对比

### 用户层级
```
~/.claude/
├── plugins/project-aletheia/
│   ├── current -> versions/v0.2.0
│   ├── versions/
│   │   ├── v0.1.0/
│   │   └── v0.2.0/
│   └── versions.json
├── agents/
│   └── requirements-analyst.md -> ../plugins/project-aletheia/current/agents/requirements-analyst.md
├── skills/
│   └── req-gate-check.md -> ../plugins/project-aletheia/current/skills/req-gate-check.md
└── hooks/
    └── pre-command.sh -> ../plugins/project-aletheia/current/hooks/pre-command.sh
```

### 项目层级
```
your-project/.claude/
├── plugins/project-aletheia/
│   ├── current -> versions/v0.2.0
│   ├── versions/
│   │   ├── v0.1.0/
│   │   └── v0.2.0/
│   └── versions.json
├── agents/
│   └── requirements-analyst.md -> ../plugins/project-aletheia/current/agents/requirements-analyst.md
├── skills/
│   └── req-gate-check.md -> ../plugins/project-aletheia/current/skills/req-gate-check.md
└── hooks/
    └── pre-command.sh -> ../plugins/project-aletheia/current/hooks/pre-command.sh
```

---

## 常用命令

### 查看版本历史
```bash
# 用户层级
cat ~/.claude/plugins/project-aletheia/versions.json

# 项目层级
cat /path/to/your/project/.claude/plugins/project-aletheia/versions.json
```

### 清理旧版本
```bash
# 保留当前版本和最新版本，删除其他版本
cd ~/.claude/plugins/project-aletheia/versions
CURRENT=$(readlink ../current | sed 's/versions\///')
LATEST=$(ls -1 | sort -V | tail -1)

for version in v*; do
  if [ "$version" != "$CURRENT" ] && [ "$version" != "$LATEST" ]; then
    echo "删除旧版本: $version"
    rm -rf "$version"
  fi
done
```

### 验证符号链接
```bash
# 检查符号链接是否正确
ls -la ~/.claude/agents/ | grep project-aletheia
ls -la ~/.claude/skills/ | grep project-aletheia
ls -la ~/.claude/hooks/ | grep project-aletheia
```

### 修复损坏的符号链接
```bash
# 如果符号链接损坏，重新运行切换版本命令
./switch-version.sh $(readlink ~/.claude/plugins/project-aletheia/current | sed 's/versions\///')
```

---

## 故障排除

### 问题：安装后 Claude Code 找不到 agents/skills

**原因**：符号链接可能未正确创建

**解决**：
```bash
# 重新运行安装脚本
./install-user-versioned.sh --force

# 或重新切换版本
./switch-version.sh $(readlink ~/.claude/plugins/project-aletheia/current | sed 's/versions\///')
```

### 问题：切换版本后仍然使用旧版本

**原因**：Claude Code 未重启

**解决**：
1. 完全退出 Claude Code
2. 重新启动 Claude Code

### 问题：版本号不匹配

**原因**：`package.json` 中的版本号未更新

**解决**：
```bash
# 更新 package.json 中的版本号
# 然后重新安装
./install-user-versioned.sh --force
```

### 问题：孤儿符号链接

**原因**：手动删除了版本目录但未清理符号链接

**解决**：
```bash
# 清理所有 project-aletheia 的符号链接
find ~/.claude/agents -type l -lname "*project-aletheia*" -delete
find ~/.claude/skills -type l -lname "*project-aletheia*" -delete
find ~/.claude/hooks -type l -lname "*project-aletheia*" -delete

# 重新创建符号链接
./switch-version.sh <version>
```

---

## 最佳实践

### 1. 版本命名
遵循语义化版本（Semantic Versioning）：
- **Major（主版本）**：不兼容的 API 变更
- **Minor（次版本）**：向后兼容的功能新增
- **Patch（补丁版本）**：向后兼容的问题修复

### 2. 版本管理策略
- **开发环境**：使用项目层级安装，测试新版本
- **生产环境**：使用用户层级安装，使用稳定版本
- **定期清理**：保留当前版本和最新版本，删除旧版本

### 3. 升级流程
```bash
# 1. 更新 package.json 版本号
# 2. 测试新版本（项目层级）
./install-project-versioned.sh /path/to/test/project

# 3. 验证功能
# 4. 升级用户层级
./install-user-versioned.sh

# 5. 清理旧版本
./uninstall.sh v0.1.0
```

### 4. 回滚流程
```bash
# 如果新版本有问题，立即回滚
./switch-version.sh v0.1.0

# 重启 Claude Code
```

---

## 脚本文件清单

| 脚本 | 用途 | 作用域 |
|------|------|--------|
| `install-user-versioned.sh` | 安装到用户层级 | 所有项目 |
| `install-project-versioned.sh` | 安装到项目层级 | 单个项目 |
| `switch-version.sh` | 切换用户层级版本 | 所有项目 |
| `switch-version-project.sh` | 切换项目层级版本 | 单个项目 |
| `uninstall.sh` | 卸载用户层级 | 所有项目 |
| `uninstall-project.sh` | 卸载项目层级 | 单个项目 |

---

## 相关文档

- [plugin-version-management.md](./plugin-version-management.md) - 详细的版本管理说明
- [artifact-naming-and-versioning.md](./artifact-naming-and-versioning.md) - 产出物版本管理
- [INSTALLATION.md](../INSTALLATION.md) - 安装指南
