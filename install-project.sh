#!/bin/bash

# Project Aletheia 项目层级安装脚本
# 使用方法: ./install-project.sh /path/to/your/project

set -e

if [ -z "$1" ]; then
    echo "❌ 错误: 请提供项目路径"
    echo "使用方法: ./install-project.sh /path/to/your/project"
    exit 1
fi

PROJECT_PATH="$1"
ALETHEIA_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -d "$PROJECT_PATH" ]; then
    echo "❌ 错误: 项目路径不存在: $PROJECT_PATH"
    exit 1
fi

echo "🔮 开始安装 Project Aletheia 到项目: $PROJECT_PATH"

# 进入项目目录
cd "$PROJECT_PATH"

# 创建 .claude 目录
echo "📁 创建 .claude 目录..."
mkdir -p .claude

# 创建 package.json（如果不存在）
if [ ! -f "package.json" ]; then
    echo "📦 初始化 package.json..."
    npm init -y
fi

# 安装 project-aletheia
echo "📦 安装 project-aletheia..."
npm install "$ALETHEIA_DIR"

# 创建 .claude/config.json
CONFIG_FILE=".claude/config.json"
echo "📝 创建 $CONFIG_FILE..."

cat > "$CONFIG_FILE" << EOF
{
  "plugins": {
    "project-aletheia": {
      "enabled": true,
      "path": "./node_modules/project-aletheia"
    }
  },
  "agents": {
    "example-agent": {
      "enabled": true
    }
  },
  "skills": {
    "example-skill": {
      "enabled": true
    }
  }
}
EOF

echo ""
echo "✨ 安装完成！"
echo ""
echo "📚 下一步："
echo "1. 在项目目录中启动 Claude Code"
echo "2. 使用 /agent example-agent 测试 agent"
echo "3. 使用 /skill example-skill 测试 skill"
echo ""
echo "📖 查看 INSTALLATION.md 了解更多信息"
