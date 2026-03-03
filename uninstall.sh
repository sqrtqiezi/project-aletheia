#!/bin/bash

# Project Aletheia 卸载脚本
# 使用方法: ./uninstall.sh [version]

set -e

CLAUDE_DIR="$HOME/.claude"
PLUGIN_DIR="$CLAUDE_DIR/plugins/project-aletheia"

# 如果指定了版本，只卸载该版本
if [ -n "$1" ]; then
    VERSION=$1
    VERSION_DIR="$PLUGIN_DIR/versions/$VERSION"

    if [ ! -d "$VERSION_DIR" ]; then
        echo "❌ 错误: 版本 $VERSION 未安装"
        exit 1
    fi

    echo "🗑️  卸载版本 $VERSION..."

    # 如果是当前版本，先清理链接
    CURRENT_VERSION=$(readlink "$PLUGIN_DIR/current" | sed 's/versions\///')
    if [ "$CURRENT_VERSION" = "$VERSION" ]; then
        echo "🧹 清理符号链接..."
        find "$CLAUDE_DIR/agents" -type l -lname "*project-aletheia*" -delete
        find "$CLAUDE_DIR/skills" -type l -lname "*project-aletheia*" -delete
        find "$CLAUDE_DIR/hooks" -type l -lname "*project-aletheia*" -delete
        rm -f "$PLUGIN_DIR/current"
    fi

    # 删除版本目录
    rm -rf "$VERSION_DIR"

    echo "✅ 版本 $VERSION 已卸载"

    # 列出剩余版本
    echo ""
    echo "📋 剩余版本:"
    ls -1 "$PLUGIN_DIR/versions" 2>/dev/null | sed 's/^/  - /' || echo "  (无剩余版本)"

else
    # 卸载整个插件
    echo "🗑️  卸载 Project Aletheia..."
    echo ""
    echo "⚠️  这将删除所有版本和配置"
    read -p "确认卸载? (y/N) " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ 已取消"
        exit 0
    fi

    # 清理符号链接
    echo "🧹 清理符号链接..."
    find "$CLAUDE_DIR/agents" -type l -lname "*project-aletheia*" -delete
    find "$CLAUDE_DIR/skills" -type l -lname "*project-aletheia*" -delete
    find "$CLAUDE_DIR/hooks" -type l -lname "*project-aletheia*" -delete

    # 删除插件目录
    rm -rf "$PLUGIN_DIR"

    echo "✅ Project Aletheia 已完全卸载"
fi

echo ""
echo "📚 下一步："
echo "1. 重启 Claude Code 以应用更改"
