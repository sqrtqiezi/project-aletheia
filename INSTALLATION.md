# 安装指南

本文档说明如何将 Project Aletheia 的 agents 和 skills 安装到 Claude Code 环境中。

## 安装方式

### 方式一：用户层级安装（推荐）

用户层级安装会让所有项目都能使用这些 agents 和 skills。

#### 1. 安装插件

```bash
# 进入 Claude Code 插件目录
cd ~/.claude/plugins/cache

# 克隆或链接 project-aletheia
git clone <your-repo-url> project-aletheia
# 或者使用软链接（用于开发）
ln -s /Users/niujin/develop/project-aletheia project-aletheia
```

#### 2. 注册插件

编辑 `~/.claude/plugins/installed_plugins.json`：

```json
{
  "version": 2,
  "plugins": {
    "github@claude-plugins-official": [...],
    "project-aletheia@local": [
      {
        "scope": "user",
        "installPath": "/Users/niujin/.claude/plugins/cache/project-aletheia",
        "version": "0.1.0",
        "installedAt": "2026-03-03T08:00:00.000Z"
      }
    ]
  }
}
```

#### 3. 启用插件

编辑 `~/.claude/settings.json`：

```json
{
  "enabledPlugins": {
    "github@claude-plugins-official": true,
    "project-aletheia@local": true
  }
}
```

### 方式二：项目层级安装

项目层级安装只在特定项目中生效。

#### 1. 在项目中安装

```bash
# 进入你的项目目录
cd /path/to/your/project

# 创建 .claude 目录（如果不存在）
mkdir -p .claude

# 安装 project-aletheia
npm install project-aletheia
# 或使用本地路径
npm install /Users/niujin/develop/project-aletheia
```

#### 2. 创建项目配置

创建 `.claude/config.json`：

```json
{
  "plugins": {
    "project-aletheia": {
      "enabled": true,
      "path": "./node_modules/project-aletheia"
    }
  }
}
```

### 方式三：直接使用（开发模式）

在开发和测试阶段，可以直接导入使用：

```javascript
// 在你的 Claude Code 配置中
import { exampleAgent, exampleSkill, exampleHook } from '/Users/niujin/develop/project-aletheia/index.js';

// 注册 agent
registerAgent(exampleAgent);

// 注册 skill
registerSkill(exampleSkill);

// 注册 hook
registerHook(exampleHook);
```

## 使用示例

### 使用 Agent

```bash
# 在 Claude Code 中调用
/agent example-agent "帮我分析这个文件"
```

### 使用 Skill

```bash
# 在 Claude Code 中调用
/skill example-skill
```

### 使用 Hook

Hooks 会自动在相应事件触发时执行，无需手动调用。

## 验证安装

安装完成后，可以通过以下方式验证：

```bash
# 列出所有已安装的插件
claude plugins list

# 查看可用的 agents
claude agents list

# 查看可用的 skills
claude skills list
```

## 卸载

### 用户层级卸载

```bash
# 1. 从 settings.json 中移除插件启用配置
# 2. 从 installed_plugins.json 中移除插件注册
# 3. 删除插件目录
rm -rf ~/.claude/plugins/cache/project-aletheia
```

### 项目层级卸载

```bash
# 在项目目录中
npm uninstall project-aletheia
# 删除 .claude/config.json 中的相关配置
```

## 故障排查

### 插件未加载

1. 检查 `settings.json` 中是否正确启用
2. 检查 `installed_plugins.json` 中路径是否正确
3. 重启 Claude Code

### Agent/Skill 不可用

1. 确认插件已正确安装
2. 检查 `index.js` 导出是否正确
3. 查看 Claude Code 日志：`~/.claude/debug/`

## 开发建议

在开发自己的 agents 和 skills 时：

1. 使用软链接方式安装，便于实时更新
2. 在 `~/.claude/debug/` 中查看日志
3. 修改代码后重启 Claude Code 使更改生效
