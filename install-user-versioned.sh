#!/bin/bash

# Project Aletheia 用户层级安装脚本（版本化）
# 使用方法: ./install-user.sh [--version VERSION]

set -e

echo "🔮 开始安装 Project Aletheia 到用户层级..."

# 定义路径
CLAUDE_DIR="$HOME/.claude"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 读取版本号
VERSION=$(grep '"version"' "$PROJECT_DIR/package.json" | sed 's/.*"version": "\(.*\)".*/\1/')

# 解析命令行参数
FORCE_INSTALL=false
while [[ $# -gt 0 ]]; do
  case $1 in
    --force)
      FORCE_INSTALL=true
      shift
      ;;
    *)
      echo "未知参数: $1"
      exit 1
      ;;
  esac
done

# 检查 Claude Code 是否已安装
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "❌ 错误: 未找到 Claude Code 配置目录 (~/.claude)"
    echo "请先安装 Claude Code"
    exit 1
fi

# 创建插件目录结构
PLUGIN_DIR="$CLAUDE_DIR/plugins/project-aletheia"
VERSION_DIR="$PLUGIN_DIR/versions/v$VERSION"
CURRENT_LINK="$PLUGIN_DIR/current"

echo "📦 当前版本: v$VERSION"

# 检查版本是否已安装
if [ -d "$VERSION_DIR" ] && [ "$FORCE_INSTALL" = false ]; then
    echo "⚠️  版本 v$VERSION 已安装"
    echo "使用 --force 强制重新安装"
    exit 0
fi

# 创建版本目录
echo "📁 创建版本目录..."
mkdir -p "$VERSION_DIR/agents"
mkdir -p "$VERSION_DIR/skills"
mkdir -p "$VERSION_DIR/hooks"

# 复制文件到版本目录
echo "📦 安装 agents..."
if [ -d "$PROJECT_DIR/agents" ]; then
    cp -r "$PROJECT_DIR/agents/"* "$VERSION_DIR/agents/"
    echo "✅ Agents 已安装"
fi

echo "📦 安装 skills..."
if [ -d "$PROJECT_DIR/skills" ]; then
    cp -r "$PROJECT_DIR/skills/"* "$VERSION_DIR/skills/"
    echo "✅ Skills 已安装"
fi

echo "📦 安装 hooks..."
if [ -d "$PROJECT_DIR/hooks" ]; then
    cp -r "$PROJECT_DIR/hooks/"* "$VERSION_DIR/hooks/"
    chmod +x "$VERSION_DIR/hooks/"*.sh 2>/dev/null || true
    echo "✅ Hooks 已安装"
fi

# 复制文档
if [ -d "$PROJECT_DIR/docs" ]; then
    cp -r "$PROJECT_DIR/docs" "$VERSION_DIR/"
fi

# 创建版本元数据
cat > "$VERSION_DIR/metadata.json" <<EOF
{
  "version": "$VERSION",
  "installed_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "source": "$PROJECT_DIR"
}
EOF

# 更新 current 软链接
echo "🔗 更新 current 链接..."
rm -f "$CURRENT_LINK"
ln -s "versions/v$VERSION" "$CURRENT_LINK"

# 创建符号链接到 Claude Code 标准目录
echo "🔗 创建符号链接..."
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/hooks"

# 清理旧的符号链接
find "$CLAUDE_DIR/agents" -type l -lname "*project-aletheia*" -delete
find "$CLAUDE_DIR/skills" -type l -lname "*project-aletheia*" -delete
find "$CLAUDE_DIR/hooks" -type l -lname "*project-aletheia*" -delete

# 创建新的符号链接
for agent in "$VERSION_DIR/agents/"*.md; do
    [ -f "$agent" ] && ln -s "$agent" "$CLAUDE_DIR/agents/$(basename "$agent")"
done

for skill in "$VERSION_DIR/skills/"*.md; do
    [ -f "$skill" ] && ln -s "$skill" "$CLAUDE_DIR/skills/$(basename "$skill")"
done

for hook in "$VERSION_DIR/hooks/"*.sh; do
    [ -f "$hook" ] && ln -s "$hook" "$CLAUDE_DIR/hooks/$(basename "$hook")"
done

# 更新版本历史
VERSIONS_FILE="$PLUGIN_DIR/versions.json"
if [ ! -f "$VERSIONS_FILE" ]; then
    echo "[]" > "$VERSIONS_FILE"
fi

# 添加新版本到历史
jq ". += [{\"version\": \"$VERSION\", \"installed_at\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}]" "$VERSIONS_FILE" > "$VERSIONS_FILE.tmp"
mv "$VERSIONS_FILE.tmp" "$VERSIONS_FILE"

# 列出已安装的版本
echo ""
echo "📋 已安装的版本："
ls -1 "$PLUGIN_DIR/versions" | sed 's/^/  - /'

echo ""
echo "📋 当前激活版本: v$VERSION"

echo ""
echo "✨ 安装完成！"
echo ""
echo "📚 下一步："
echo "1. 重启 Claude Code"
echo "2. 使用 /req-gate-check 测试 skill"
echo "3. 通过 Task 工具调用 requirements-analyst"
echo ""
echo "🔧 版本管理命令："
echo "  - 列出所有版本: ls ~/.claude/plugins/project-aletheia/versions"
echo "  - 切换版本: ./switch-version.sh <version>"
echo "  - 卸载版本: ./uninstall.sh <version>"
