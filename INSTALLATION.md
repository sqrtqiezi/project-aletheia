# 安装指南

本文档说明如何将 Project Aletheia 的 agents、skills 和 hooks 安装到 Claude Code 环境中。

## 安装方式

### 方式一：用户层级安装（推荐）

用户层级安装会让所有项目都能使用这些 agents、skills 和 hooks。

#### 自动安装

```bash
# 克隆仓库
git clone <your-repo-url> project-aletheia
cd project-aletheia

# 运行安装脚本
./install-user.sh
```

安装脚本会自动将文件复制到：
- `~/.claude/agents/` - Agent 定义
- `~/.claude/skills/` - Skill 定义
- `~/.claude/hooks/` - Hook 脚本

#### 手动安装

```bash
# 创建目录（如果不存在）
mkdir -p ~/.claude/agents
mkdir -p ~/.claude/skills
mkdir -p ~/.claude/hooks

# 复制文件
cp project-aletheia/agents/* ~/.claude/agents/
cp project-aletheia/skills/* ~/.claude/skills/
cp project-aletheia/hooks/* ~/.claude/hooks/

# 确保 hooks 有执行权限
chmod +x ~/.claude/hooks/*.sh
```

### 方式二：项目层级安装

项目层级安装只在特定项目中生效。

#### 自动安装

```bash
# 在你的项目目录中
cd /path/to/your/project

# 运行安装脚本
/path/to/project-aletheia/install-project.sh .
```

安装脚本会自动将文件复制到：
- `项目/.claude/agents/` - Agent 定义
- `项目/.claude/skills/` - Skill 定义
- `项目/.claude/hooks/` - Hook 脚本

#### 手动安装

```bash
# 在你的项目目录中
cd /path/to/your/project

# 创建目录
mkdir -p .claude/agents
mkdir -p .claude/skills
mkdir -p .claude/hooks

# 复制文件
cp /path/to/project-aletheia/agents/* .claude/agents/
cp /path/to/project-aletheia/skills/* .claude/skills/
cp /path/to/project-aletheia/hooks/* .claude/hooks/

# 确保 hooks 有执行权限
chmod +x .claude/hooks/*.sh
```

## 使用示例

### 使用 Skill

```bash
# 在 Claude Code 中调用
/example [参数]
```

### 使用 Agent

在与 Claude Code 对话时，通过 Task 工具调用：
```
请使用 example-agent 分析这个文件
```

或者直接在提示中提到：
```
帮我分析代码质量（使用 example-agent）
```

### 使用 Hook

Hooks 会自动在命令执行前后触发，无需手动调用。

- `pre-command.sh` - 在命令执行前运行
- `post-command.sh` - 在命令执行后运行

## 验证安装

安装完成后，可以通过以下方式验证：

```bash
# 检查文件是否存在
ls ~/.claude/agents/
ls ~/.claude/skills/
ls ~/.claude/hooks/

# 或在项目中
ls .claude/agents/
ls .claude/skills/
ls .claude/hooks/
```

在 Claude Code 中测试：
```bash
# 测试 skill
/example

# 测试 agent（在对话中）
请使用 example-agent 帮我分析代码
```

## 卸载

### 用户层级卸载

#### 自动卸载

```bash
cd project-aletheia
./uninstall-user.sh
```

#### 手动卸载

```bash
# 删除文件
rm ~/.claude/agents/example-agent.md
rm ~/.claude/skills/example.md
rm ~/.claude/hooks/pre-command.sh
rm ~/.claude/hooks/post-command.sh
```

### 项目层级卸载

#### 自动卸载

```bash
/path/to/project-aletheia/uninstall-project.sh /path/to/your/project
```

#### 手动卸载

```bash
# 在项目目录中
cd /path/to/your/project

# 删除文件
rm .claude/agents/example-agent.md
rm .claude/skills/example.md
rm .claude/hooks/pre-command.sh
rm .claude/hooks/post-command.sh

# 清理空目录
rmdir .claude/agents .claude/skills .claude/hooks .claude 2>/dev/null || true
```

## 故障排查

### Skill 不可用

1. 确认文件已正确复制到 `.claude/skills/` 目录
2. 检查文件名是否正确（应为 `.md` 格式）
3. 重启 Claude Code

### Agent 不可用

1. 确认文件已正确复制到 `.claude/agents/` 目录
2. 检查文件格式是否正确（Markdown 格式）
3. 在对话中明确提到 agent 名称

### Hook 未执行

1. 确认文件已正确复制到 `.claude/hooks/` 目录
2. 检查文件是否有执行权限：`chmod +x ~/.claude/hooks/*.sh`
3. 检查脚本语法是否正确
4. 查看 Claude Code 日志：`~/.claude/debug/`

## 开发建议

在开发自己的 agents、skills 和 hooks 时：

1. **使用软链接**（开发模式）：
   ```bash
   ln -s /path/to/project-aletheia/agents/your-agent.md ~/.claude/agents/
   ```
   这样修改源文件后无需重新复制

2. **查看日志**：
   ```bash
   tail -f ~/.claude/debug/*.log
   ```

3. **测试后再分发**：
   在本地充分测试后再提交到仓库

4. **遵循命名规范**：
   - Agents: `agent-name.md`
   - Skills: `skill-name.md`（对应 `/skill-name` 命令）
   - Hooks: `pre-command.sh`, `post-command.sh`

## 文件结构说明

```
~/.claude/                    # 用户层级（全局）
├── agents/
│   └── example-agent.md     # Agent 定义
├── skills/
│   └── example.md           # Skill 定义（对应 /example）
└── hooks/
    ├── pre-command.sh       # 命令前钩子
    └── post-command.sh      # 命令后钩子

项目/.claude/                 # 项目层级（仅当前项目）
├── agents/
│   └── example-agent.md
├── skills/
│   └── example.md
└── hooks/
    ├── pre-command.sh
    └── post-command.sh
```

## 更新

要更新已安装的 agents、skills 或 hooks：

```bash
# 拉取最新代码
cd project-aletheia
git pull

# 重新运行安装脚本
./install-user.sh
# 或
./install-project.sh /path/to/your/project
```

安装脚本会覆盖现有文件。
