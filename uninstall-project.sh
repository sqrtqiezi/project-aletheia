#!/bin/bash

# Project Aletheia 项目层级卸载脚本
# 使用方法: ./uninstall-project.sh /path/to/your/project

set -e

if [ -z "$1" ]; then
    echo "❌ 错误: 请提供项目路径"
    echo "使用方法: ./uninstall-project.sh /path/to/your/project"
    exit 1
fi

PROJECT_PATH="$1"

if [ ! -d "$PROJECT_PATH" ]; then
    echo "❌ 错误: 项目路径不存在: $PROJECT_PATH"
    exit 1
fi

echo "🔮 开始从项目卸载 Project Aletheia: $PROJECT_PATH"

# 进入项目目录
cd "$PROJECT_PATH"

# 检查是否已安装
if [ ! -d ".claude" ]; then
    echo "⚠️  项目中未找到 .claude 目录"
    exit 0
fi

# 列出将要删除的文件
echo "📋 将要删除的文件："
echo ""

FOUND_FILES=false

if [ -f ".claude/agents/example-agent.md" ]; then
    echo "Agents:"
    echo "  - example-agent.md"
    FOUND_FILES=true
fi

if [ -f ".claude/skills/example.md" ]; then
    echo "Skills:"
    echo "  - example.md"
    FOUND_FILES=true
fi

if [ -f ".claude/hooks/pre-command.sh" ] || [ -f ".claude/hooks/post-command.sh" ]; then
    echo "Hooks:"
    [ -f ".claude/hooks/pre-command.sh" ] && echo "  - pre-command.sh"
    [ -f ".claude/hooks/post-command.sh" ] && echo "  - post-command.sh"
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

[ -f ".claude/agents/example-agent.md" ] && rm ".claude/agents/example-agent.md"
[ -f ".claude/skills/example.md" ] && rm ".claude/skills/example.md"
[ -f ".claude/hooks/pre-command.sh" ] && rm ".claude/hooks/pre-command.sh"
[ -f ".claude/hooks/post-command.sh" ] && rm ".claude/hooks/post-command.sh"

echo "✅ 文件已删除"

# 清理空目录
[ -d ".claude/agents" ] && [ -z "$(ls -A .claude/agents)" ] && rmdir .claude/agents
[ -d ".claude/skills" ] && [ -z "$(ls -A .claude/skills)" ] && rmdir .claude/skills
[ -d ".claude/hooks" ] && [ -z "$(ls -A .claude/hooks)" ] && rmdir .claude/hooks
[ -d ".claude" ] && [ -z "$(ls -A .claude)" ] && rmdir .claude

echo ""
echo "✨ 卸载完成！"
echo ""
echo "💡 提示: 如果在此项目中使用 Claude Code，请重启使更改生效"
