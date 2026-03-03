#!/bin/bash

# Project Aletheia 用户层级卸载脚本
# 使用方法: ./uninstall-user.sh

set -e

echo "🔮 开始从用户层级卸载 Project Aletheia..."

# 定义路径
CLAUDE_DIR="$HOME/.claude"

# 检查 Claude Code 是否已安装
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "❌ 错误: 未找到 Claude Code 配置目录 (~/.claude)"
    exit 1
fi

# 列出将要删除的文件
echo "📋 将要删除的文件："
echo ""

FOUND_FILES=false

if [ -f "$CLAUDE_DIR/agents/example-agent.md" ]; then
    echo "Agents:"
    echo "  - example-agent.md"
    FOUND_FILES=true
fi

if [ -f "$CLAUDE_DIR/skills/example.md" ]; then
    echo "Skills:"
    echo "  - example.md"
    FOUND_FILES=true
fi

if [ -f "$CLAUDE_DIR/hooks/pre-command.sh" ] || [ -f "$CLAUDE_DIR/hooks/post-command.sh" ]; then
    echo "Hooks:"
    [ -f "$CLAUDE_DIR/hooks/pre-command.sh" ] && echo "  - pre-command.sh"
    [ -f "$CLAUDE_DIR/hooks/post-command.sh" ] && echo "  - post-command.sh"
    FOUND_FILES=true
fi

if [ "$FOUND_FILES" = false ]; then
    echo "⚠️  未找到 Project Aletheia 的文件"
    exit 0
fi

echo ""
read -p "确认删除这些文件？(y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 取消卸载"
    exit 0
fi

# 删除文件
echo "🗑️  删除文件..."

[ -f "$CLAUDE_DIR/agents/example-agent.md" ] && rm "$CLAUDE_DIR/agents/example-agent.md"
[ -f "$CLAUDE_DIR/skills/example.md" ] && rm "$CLAUDE_DIR/skills/example.md"
[ -f "$CLAUDE_DIR/hooks/pre-command.sh" ] && rm "$CLAUDE_DIR/hooks/pre-command.sh"
[ -f "$CLAUDE_DIR/hooks/post-command.sh" ] && rm "$CLAUDE_DIR/hooks/post-command.sh"

echo "✅ 文件已删除"

echo ""
echo "✨ 卸载完成！"
echo ""
echo "💡 提示: 重启 Claude Code 使更改生效"
