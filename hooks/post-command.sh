#!/bin/bash
# 示例 post-command hook
# 在 Claude Code 命令执行后运行

# 可用变量：
# $COMMAND - 执行的命令名称
# $ARGS - 命令参数
# $EXIT_CODE - 命令的退出码

if [ $EXIT_CODE -eq 0 ]; then
    echo "命令执行成功: $COMMAND"
else
    echo "命令执行失败: $COMMAND (退出码: $EXIT_CODE)"
fi

# 在这里添加你的自定义逻辑
# 例如：记录日志、发送通知、清理临时文件等

exit 0
