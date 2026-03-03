#!/bin/bash

# Project Aletheia 项目层级卸载脚本
# 使用方法: ./uninstall-project.sh /path/to/your/project [version]

set -e

if [ -z "$1" ]; then
    echo "❌ 错误: 请提供项目路径"
    echo "使用方法: ./uninstall-project.sh /path/to/your/project [version]"
    exit 1
fi

PROJECT_PATH="$1"

if [ ! -d "$PROJECT_PATH" ]; then
    echo "❌ 错误: 项目路径不存在: $PROJECT_PATH"
    exit 1
fi

cd "$PROJECT_PATH"

PLUGIN_DIR=".claude/plugins/project-aletheia"

if [ ! -d "$PLUGIN_DIR" ]; then
    echo "❌ 错误: 项目中未安装 Project Aletheia"
    exit 1
fi

# 如果指定了版本，只卸载该版本
if [ -n "$2" ]; then
    VERSION=$2
    VERSION_DIR="$PLUGIN_DIR/versions/$VERSION"

    if [ ! -d "$VERSION_DIR" ]; then
        echo "❌ 错误: 版本 $VERSION 未安装"
        exit 1
    fi

    echo "🗑️  卸载版本 $VERSION..."

    # 如果是当前版本，先清理链接
    CURRENT_VERSION=$(readlink "$PLUGIN_DIR/current" 2>/dev/null | sed 's/versions\///')
    if [ "$CURRENT_VERSION" = "$VERSION" ]; then
        echo "🧹 清理符号链接..."
        find .claude/agents -type l -lname "*project-aletheia*" -delete 2>/dev/null || true
        find .claude/skills -type l -lname "*project-aletheia*" -delete 2>/dev/null || true
        find .claude/hooks -type l -lname "*project-aletheia*" -delete 2>/dev/null || true
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
    find .claude/agents -type l -lname "*project-aletheia*" -delete 2>/dev/null || true
    find .claude/skills -type l -lname "*project-aletheia*" -delete 2>/dev/null || true
    find .claude/hooks -type l -lname "*project-aletheia*" -delete 2>/dev/null || true

    # 删除插件目录
    rm -rf "$PLUGIN_DIR"

    echo "✅ Project Aletheia 已从项目中完全卸载"
fi

echo ""
echo "📚 下一步:"
echo "1. 重启 Claude Code 以应用更改"
