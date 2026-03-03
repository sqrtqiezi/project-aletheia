# Project Aletheia

> **Aletheia** (ἀλήθεια) - 希腊语"真理的显现"

一个通过智能自动化揭示真理的 Claude Code 插件。本项目提供了一系列可复用的 agents、skills 和 hooks，旨在增强你的 Claude Code 开发体验。

## 理念

Aletheia 体现了希腊语"去蔽"的概念 - 将隐藏的真理带到光明之中。通过精心设计的 agents 和 skills，这个插件帮助开发者发现洞察、自动化工作流程，并揭示代码库的本质。

## 特性

- **自定义子代理**: 针对特定开发任务的专业化 agents
- **可复用技能**: 可在多个项目中调用的预构建 skills
- **事件钩子**: 用于自定义 Claude Code 行为的生命周期 hooks
- **可扩展架构**: 轻松添加你自己的 agents、skills 和 hooks

## 快速开始

### 用户层级安装（所有项目可用）

```bash
# 克隆仓库
git clone <your-repo-url> project-aletheia
cd project-aletheia

# 运行安装脚本
./install-user.sh
```

### 项目层级安装（仅当前项目可用）

```bash
# 在你的项目目录中
cd /path/to/your/project

# 运行安装脚本
/path/to/project-aletheia/install-project.sh .
```

### 手动安装

查看 [INSTALLATION.md](./INSTALLATION.md) 了解详细的安装步骤和配置说明。

## 使用

安装后，你可以在 Claude Code 中使用以下功能：

### Skills（技能）
```bash
# 调用示例 skill
/example [参数]
```

### Agents（代理）
在与 Claude Code 对话时，可以通过 Task 工具调用自定义代理：
```
请使用 example-agent 分析这个文件
```

### Hooks（钩子）
Hooks 会自动在命令执行前后触发，无需手动调用。

## 项目结构

```
project-aletheia/
├── agents/          # 自定义子代理（Markdown 格式）
│   └── example-agent.md
├── skills/          # 可复用技能（Markdown 格式）
│   └── example.md
├── hooks/           # 事件钩子（Shell 脚本）
│   ├── pre-command.sh
│   └── post-command.sh
├── index.js         # 主入口文件
├── package.json     # 项目配置
└── README.md        # 文档
```

## 贡献

欢迎贡献！随时添加新的 agents、skills 或 hooks，帮助在开发工作流程中揭示真理。

## 许可证

MIT
