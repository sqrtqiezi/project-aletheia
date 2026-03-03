#!/bin/bash

# Project Aletheia 项目层级版本切换脚本
# 使用方法: ./switch-version-project.sh /path/to/your/project <version>

set -e

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "❌ 错误: 请提供项目路径和版本号"
    echo "使用方法: ./switch-version-project.sh /path/to/your/project <version>"
    exit 1
fi

PROJECT_PATH="$1"
VERSION=$2

if [ ! -d "$PROJECT_PATH" ]; then
    echo "❌ 错误: 项目路径不存在: $PROJECT_PATH"
    exit 1
fi

cd "$PROJECT_PATH"

PLUGIN_DIR=".claude/plugins/project-aletheia"
VERSION_DIR="$PLUGIN_DIR/versions/$VERSION"
CURRENT_LINK="$PLUGIN_DIR/current"

# 检查版本是否存在
if [ ! -d "$VERSION_DIR" ]; then
    echo "❌ 错误: 版本 $VERSION 未安装"
    echo ""
    echo "可用版本:"
    ls -1 "$PLUGIN_DIR/versions" 2>/dev/null | sed 's/^/  - /' || echo "  (无已安装版本)"
    exit 1
fi

echo "🔄 切换到版本 $VERSION..."

# 更新 current 软链接
rm -f "$CURRENT_LINK"
ln -s "versions/$VERSION" "$CURRENT_LINK"

# 清理旧的符号链接
echo "🧹 清理旧链接..."
find .claude/agents -type l -lname "*project-aletheia*" -delete 2>/dev/null || true
find .claude/skills -type l -lname "*project-aletheia*" -delete 2>/dev/null || true
find .claude/hooks -type l -lname "*project-aletheia*" -delete 2>/dev/null || true

# 创建新的符号链接
echo "🔗 创建新链接..."
for agent in "$VERSION_DIR/agents/"*.md; do
    [ -f "$agent" ] && ln -s "../plugins/project-aletheia/current/agents/$(basename "$agent")" ".claude/agents/$(basename "$agent")"
done

for skill in "$VERSION_DIR/skills/"*.md; do
    [ -f "$skill" ] && ln -s "../plugins/project-aletheia/current/skills/$(basename "$skill")" ".claude/skills/$(basename "$skill")"
done

for hook in "$VERSION_DIR/hooks/"*.sh; do
    [ -f "$hook" ] && ln -s "../plugins/project-aletheia/current/hooks/$(basename "$hook")" ".claude/hooks/$(basename "$hook")"
done

echo ""
echo "✅ 已切换到版本 $VERSION"
echo ""
echo "📚 下一步："
echo "1. 重启 Claude Code 以应用更改"
