#!/bin/bash

# Project Aletheia 版本切换脚本
# 使用方法: ./switch-version.sh <version>

set -e

if [ -z "$1" ]; then
    echo "❌ 错误: 请提供版本号"
    echo "使用方法: ./switch-version.sh <version>"
    echo ""
    echo "可用版本:"
    ls -1 "$HOME/.claude/plugins/project-aletheia/versions" 2>/dev/null | sed 's/^/  - /' || echo "  (无已安装版本)"
    exit 1
fi

VERSION=$1
CLAUDE_DIR="$HOME/.claude"
PLUGIN_DIR="$CLAUDE_DIR/plugins/project-aletheia"
VERSION_DIR="$PLUGIN_DIR/versions/$VERSION"
CURRENT_LINK="$PLUGIN_DIR/current"

# 检查版本是否存在
if [ ! -d "$VERSION_DIR" ]; then
    echo "❌ 错误: 版本 $VERSION 未安装"
    echo ""
    echo "可用版本:"
    ls -1 "$PLUGIN_DIR/versions" | sed 's/^/  - /'
    exit 1
fi

echo "🔄 切换到版本 $VERSION..."

# 更新 current 软链接
rm -f "$CURRENT_LINK"
ln -s "versions/$VERSION" "$CURRENT_LINK"

# 清理旧的符号链接
echo "🧹 清理旧链接..."
find "$CLAUDE_DIR/agents" -type l -lname "*project-aletheia*" -delete
find "$CLAUDE_DIR/skills" -type l -lname "*project-aletheia*" -delete
find "$CLAUDE_DIR/hooks" -type l -lname "*project-aletheia*" -delete

# 创建新的符号链接
echo "🔗 创建新链接..."
for agent in "$VERSION_DIR/agents/"*.md; do
    [ -f "$agent" ] && ln -s "$agent" "$CLAUDE_DIR/agents/$(basename "$agent")"
done

for skill in "$VERSION_DIR/skills/"*.md; do
    [ -f "$skill" ] && ln -s "$skill" "$CLAUDE_DIR/skills/$(basename "$skill")"
done

for hook in "$VERSION_DIR/hooks/"*.sh; do
    [ -f "$hook" ] && ln -s "$hook" "$CLAUDE_DIR/hooks/$(basename "$hook")"
done

echo ""
echo "✅ 已切换到版本 $VERSION"
echo ""
echo "📚 下一步："
echo "1. 重启 Claude Code 以应用更改"
