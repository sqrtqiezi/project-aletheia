#!/bin/bash
# 示例 pre-command hook
# 在 Claude Code 命令执行前运行

# 可用变量：
# $COMMAND - 执行的命令名称
# $ARGS - 命令参数

echo "准备执行命令: $COMMAND"

# 在这里添加你的自定义逻辑
# 例如：检查环境、验证权限、记录日志等

# 返回 0 表示继续执行，非 0 表示阻止命令执行
exit 0
