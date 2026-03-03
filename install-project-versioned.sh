#!/bin/bash

# Project Aletheia 项目层级安装脚本（版本化）
# 使用方法: ./install-project-versioned.sh /path/to/your/project [--force]

set -e

if [ -z "$1" ]; then
    echo "❌ 错误: 请提供项目路径"
    echo "使用方法: ./install-project-versioned.sh /path/to/your/project [--force]"
    exit 1
fi

PROJECT_PATH="$1"
ALETHEIA_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -d "$PROJECT_PATH" ]; then
    echo "❌ 错误: 项目路径不存在: $PROJECT_PATH"
    exit 1
fi

# 读取版本号
VERSION=$(grep '"version"' "$ALETHEIA_DIR/package.json" | sed 's/.*"version": "\(.*\)".*/\1/')

# 解析命令行参数
FORCE_INSTALL=false
shift  # 跳过第一个参数（项目路径）
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

echo "🔮 开始安装 Project Aletheia 到项目: $PROJECT_PATH"
echo "📦 当前版本: v$VERSION"

# 进入项目目录
cd "$PROJECT_PATH"

# 创建插件目录结构
PLUGIN_DIR=".claude/plugins/project-aletheia"
VERSION_DIR="$PLUGIN_DIR/versions/v$VERSION"
CURRENT_LINK="$PLUGIN_DIR/current"

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
if [ -d "$ALETHEIA_DIR/agents" ]; then
    cp -r "$ALETHEIA_DIR/agents/"* "$VERSION_DIR/agents/"
    echo "✅ Agents 已安装"
fi

echo "📦 安装 skills..."
if [ -d "$ALETHEIA_DIR/skills" ]; then
    cp -r "$ALETHEIA_DIR/skills/"* "$VERSION_DIR/skills/"
    echo "✅ Skills 已安装"
fi

echo "📦 安装 hooks..."
if [ -d "$ALETHEIA_DIR/hooks" ]; then
    cp -r "$ALETHEIA_DIR/hooks/"* "$VERSION_DIR/hooks/"
    chmod +x "$VERSION_DIR/hooks/"*.sh 2>/dev/null || true
    echo "✅ Hooks 已安装"
fi

# 复制文档
if [ -d "$ALETHEIA_DIR/docs" ]; then
    cp -r "$ALETHEIA_DIR/docs" "$VERSION_DIR/"
fi

# 创建版本元数据
cat > "$VERSION_DIR/metadata.json" <<EOF
{
  "version": "$VERSION",
  "installed_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "source": "$ALETHEIA_DIR",
  "project": "$PROJECT_PATH"
}
EOF

# 更新 current 软链接
echo "🔗 更新 current 链接..."
rm -f "$CURRENT_LINK"
ln -s "versions/v$VERSION" "$CURRENT_LINK"

# 创建符号链接到项目的 .claude 标准目录
echo "🔗 创建符号链接..."
mkdir -p .claude/agents
mkdir -p .claude/skills
mkdir -p .claude/hooks

# 清理旧的符号链接
find .claude/agents -type l -lname "*project-aletheia*" -delete 2>/dev/null || true
find .claude/skills -type l -lname "*project-aletheia*" -delete 2>/dev/null || true
find .claude/hooks -type l -lname "*project-aletheia*" -delete 2>/dev/null || true

# 创建新的符号链接
for agent in "$VERSION_DIR/agents/"*.md; do
    [ -f "$agent" ] && ln -s "../plugins/project-aletheia/current/agents/$(basename "$agent")" ".claude/agents/$(basename "$agent")"
done

for skill in "$VERSION_DIR/skills/"*.md; do
    [ -f "$skill" ] && ln -s "../plugins/project-aletheia/current/skills/$(basename "$skill")" ".claude/skills/$(basename "$skill")"
done

for hook in "$VERSION_DIR/hooks/"*.sh; do
    [ -f "$hook" ] && ln -s "../plugins/project-aletheia/current/hooks/$(basename "$hook")" ".claude/hooks/$(basename "$hook")"
done

# 更新版本历史
VERSIONS_FILE="$PLUGIN_DIR/versions.json"
if [ ! -f "$VERSIONS_FILE" ]; then
    echo "[]" > "$VERSIONS_FILE"
fi

# 添加新版本到历史（需要 jq，如果没有则手动添加）
if command -v jq &> /dev/null; then
    jq ". += [{\"version\": \"$VERSION\", \"installed_at\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}]" "$VERSIONS_FILE" > "$VERSIONS_FILE.tmp"
    mv "$VERSIONS_FILE.tmp" "$VERSIONS_FILE"
else
    echo "⚠️  未安装 jq，跳过版本历史更新"
fi

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
echo "1. 在项目目录中启动 Claude Code"
echo "2. 使用 /req-gate-check 测试 skill"
echo "3. 通过 Task 工具调用 requirements-analyst"
echo ""
echo "🔧 版本管理命令："
echo "  - 列出所有版本: ls .claude/plugins/project-aletheia/versions"
echo "  - 切换版本: $ALETHEIA_DIR/switch-version-project.sh . <version>"
echo "  - 卸载版本: $ALETHEIA_DIR/uninstall-project.sh . <version>"
