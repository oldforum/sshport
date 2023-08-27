#!/bin/bash

# 检查sudo是否存在或者当前是否为root用户
if ! command -v sudo &> /dev/null && [ "$EUID" -ne 0 ]; then
    echo "sudo 未安装，并且当前不是root用户，请以root身份运行此脚本。"
    exit 1
fi

# 获取当前SSH端口
CURRENT_PORT=$(grep "^Port" /etc/ssh/sshd_config | awk '{print $2}')

# 随机生成2000-65535之间的端口
NEW_PORT=$((RANDOM % (65535 - 2000 + 1) + 2000))

# 如果sudo存在，则使用sudo，否则直接运行命令
CMD_PREFIX=""
if command -v sudo &> /dev/null; then
    CMD_PREFIX="sudo "
fi

# 更改SSH配置文件中的端口
${CMD_PREFIX}sed -i "s/^\(#[ ]*\)\?Port .*/Port $NEW_PORT/" /etc/ssh/sshd_config
${CMD_PREFIX}systemctl restart sshd

# 获取更改后的SSH端口
ACTUAL_NEW_PORT=$(grep "^Port" /etc/ssh/sshd_config | awk '{print $2}')

# 如果ufw防火墙已经安装和运行，更新规则
if command -v ufw &> /dev/null; then
    if ${CMD_PREFIX}ufw status | grep -q "active"; then
        ${CMD_PREFIX}ufw allow $NEW_PORT/tcp
    fi
fi

# 提示用户旧的端口和新的端口号
echo "原SSH端口为$CURRENT_PORT，现已更改为$ACTUAL_NEW_PORT，请使用此端口进行连接。"
