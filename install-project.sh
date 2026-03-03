#!/bin/bash

# Project Aletheia 项目层级安装脚本
# 使用方法: ./install-project.sh /path/to/your/project

set -e

if [ -z "$1" ]; then
    echo "❌ 错误: 请提供项目路径"
    echo "使用方法: ./install-project.sh /path/to/your/project"
    exit 1
fi

PROJECT_PATH="$1"
ALETHEIA_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -d "$PROJECT_PATH" ]; then
    echo "❌ 错误: 项目路径不存在: $PROJECT_PATH"
    exit 1
fi

echo "🔮 开始安装 Project Aletheia 到项目: $PROJECT_PATH"

# 进入项目目录
cd "$PROJECT_PATH"

# 创建 .claude 目录结构
echo "📁 创建 .claude 目录结构..."
mkdir -p .claude/agents
mkdir -p .claude/skills
mkdir -p .claude/hooks

# 复制 agents
echo "📦 安装 agents..."
if [ -d "$ALETHEIA_DIR/agents" ]; then
    cp -r "$ALETHEIA_DIR/agents/"* .claude/agents/
    echo "✅ Agents 已安装"
else
    echo "⚠️  未找到 agents 目录"
fi

# 复制 skills
echo "📦 安装 skills..."
if [ -d "$ALETHEIA_DIR/skills" ]; then
    cp -r "$ALETHEIA_DIR/skills/"* .claude/skills/
    echo "✅ Skills 已安装"
else
    echo "⚠️  未找到 skills 目录"
fi

# 复制 hooks
echo "📦 安装 hooks..."
if [ -d "$ALETHEIA_DIR/hooks" ]; then
    cp -r "$ALETHEIA_DIR/hooks/"* .claude/hooks/
    # 确保 hooks 有执行权限
    chmod +x .claude/hooks/*.sh 2>/dev/null || true
    echo "✅ Hooks 已安装"
else
    echo "⚠️  未找到 hooks 目录"
fi

# 列出已安装的文件
echo ""
echo "📋 已安装的文件："
echo ""
echo "Agents:"
ls -1 .claude/agents/ | grep -E "\.md$" | sed 's/^/  - /'
echo ""
echo "Skills:"
ls -1 .claude/skills/ | grep -E "\.md$" | sed 's/^/  - /'
echo ""
echo "Hooks:"
ls -1 .claude/hooks/ | grep -E "\.sh$" | sed 's/^/  - /'

echo ""
echo "✨ 安装完成！"
echo ""
echo "📚 下一步："
echo "1. 在项目目录中启动 Claude Code"
echo "2. 使用 /example 测试 skill"
echo "3. 通过 Task 工具调用 example-agent"
echo ""
echo "📖 查看 INSTALLATION.md 了解更多信息"
