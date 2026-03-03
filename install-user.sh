#!/bin/bash

# Project Aletheia 用户层级安装脚本
# 使用方法: ./install-user.sh

set -e

echo "🔮 开始安装 Project Aletheia 到用户层级..."

# 定义路径
CLAUDE_DIR="$HOME/.claude"
PLUGINS_DIR="$CLAUDE_DIR/plugins/cache"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="$PLUGINS_DIR/project-aletheia"

# 检查 Claude Code 是否已安装
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "❌ 错误: 未找到 Claude Code 配置目录 (~/.claude)"
    echo "请先安装 Claude Code"
    exit 1
fi

# 创建插件目录（如果不存在）
mkdir -p "$PLUGINS_DIR"

# 创建软链接
echo "📦 创建软链接到 $INSTALL_DIR..."
if [ -L "$INSTALL_DIR" ] || [ -d "$INSTALL_DIR" ]; then
    echo "⚠️  目标位置已存在，正在删除..."
    rm -rf "$INSTALL_DIR"
fi
ln -s "$PROJECT_DIR" "$INSTALL_DIR"

# 更新 installed_plugins.json
INSTALLED_PLUGINS="$CLAUDE_DIR/plugins/installed_plugins.json"
echo "📝 更新 installed_plugins.json..."

if [ -f "$INSTALLED_PLUGINS" ]; then
    # 备份原文件
    cp "$INSTALLED_PLUGINS" "$INSTALLED_PLUGINS.backup"

    # 使用 jq 更新（如果已安装）或手动提示
    if command -v jq &> /dev/null; then
        TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
        jq --arg path "$INSTALL_DIR" --arg time "$TIMESTAMP" \
           '.plugins["project-aletheia@local"] = [{
              "scope": "user",
              "installPath": $path,
              "version": "0.1.0",
              "installedAt": $time
            }]' "$INSTALLED_PLUGINS" > "$INSTALLED_PLUGINS.tmp"
        mv "$INSTALLED_PLUGINS.tmp" "$INSTALLED_PLUGINS"
        echo "✅ installed_plugins.json 已更新"
    else
        echo "⚠️  未安装 jq，请手动编辑 $INSTALLED_PLUGINS"
        echo "添加以下内容到 plugins 对象中："
        echo ""
        echo "\"project-aletheia@local\": ["
        echo "  {"
        echo "    \"scope\": \"user\","
        echo "    \"installPath\": \"$INSTALL_DIR\","
        echo "    \"version\": \"0.1.0\","
        echo "    \"installedAt\": \"$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")\""
        echo "  }"
        echo "]"
    fi
else
    echo "⚠️  未找到 installed_plugins.json，跳过此步骤"
fi

# 更新 settings.json
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
echo "📝 更新 settings.json..."

if [ -f "$SETTINGS_FILE" ]; then
    # 备份原文件
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup"

    if command -v jq &> /dev/null; then
        jq '.enabledPlugins["project-aletheia@local"] = true' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp"
        mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
        echo "✅ settings.json 已更新"
    else
        echo "⚠️  未安装 jq，请手动编辑 $SETTINGS_FILE"
        echo "在 enabledPlugins 对象中添加："
        echo "\"project-aletheia@local\": true"
    fi
else
    echo "⚠️  未找到 settings.json，跳过此步骤"
fi

echo ""
echo "✨ 安装完成！"
echo ""
echo "📚 下一步："
echo "1. 重启 Claude Code"
echo "2. 使用 /agent example-agent 测试 agent"
echo "3. 使用 /skill example-skill 测试 skill"
echo ""
echo "📖 查看 INSTALLATION.md 了解更多信息"
