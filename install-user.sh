#!/bin/bash

# Project Aletheia 用户层级安装脚本
# 使用方法: ./install-user.sh

set -e

echo "🔮 开始安装 Project Aletheia 到用户层级..."

# 定义路径
CLAUDE_DIR="$HOME/.claude"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 检查 Claude Code 是否已安装
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "❌ 错误: 未找到 Claude Code 配置目录 (~/.claude)"
    echo "请先安装 Claude Code"
    exit 1
fi

# 创建目标目录
echo "📁 创建目标目录..."
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/hooks"

# 复制 agents
echo "📦 安装 agents..."
if [ -d "$PROJECT_DIR/agents" ]; then
    cp -r "$PROJECT_DIR/agents/"* "$CLAUDE_DIR/agents/"
    echo "✅ Agents 已安装"
else
    echo "⚠️  未找到 agents 目录"
fi

# 复制 skills
echo "📦 安装 skills..."
if [ -d "$PROJECT_DIR/skills" ]; then
    cp -r "$PROJECT_DIR/skills/"* "$CLAUDE_DIR/skills/"
    echo "✅ Skills 已安装"
else
    echo "⚠️  未找到 skills 目录"
fi

# 复制 hooks
echo "📦 安装 hooks..."
if [ -d "$PROJECT_DIR/hooks" ]; then
    cp -r "$PROJECT_DIR/hooks/"* "$CLAUDE_DIR/hooks/"
    # 确保 hooks 有执行权限
    chmod +x "$CLAUDE_DIR/hooks/"*.sh 2>/dev/null || true
    echo "✅ Hooks 已安装"
else
    echo "⚠️  未找到 hooks 目录"
fi

# 列出已安装的文件
echo ""
echo "📋 已安装的文件："
echo ""
echo "Agents:"
ls -1 "$CLAUDE_DIR/agents/" | grep -E "\.md$" | sed 's/^/  - /'
echo ""
echo "Skills:"
ls -1 "$CLAUDE_DIR/skills/" | grep -E "\.md$" | sed 's/^/  - /'
echo ""
echo "Hooks:"
ls -1 "$CLAUDE_DIR/hooks/" | grep -E "\.sh$" | sed 's/^/  - /'

echo ""
echo "✨ 安装完成！"
echo ""
echo "📚 下一步："
echo "1. 重启 Claude Code"
echo "2. 使用 /example 测试 skill"
echo "3. 通过 Task 工具调用 example-agent"
echo ""
echo "📖 查看 INSTALLATION.md 了解更多信息"
