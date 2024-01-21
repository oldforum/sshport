#!/bin/bash

# 检查sudo是否存在或者当前是否为root用户
if ! command -v sudo &> /dev/null && [ "$EUID" -ne 0 ]; then
    echo "sudo 未安装，并且当前不是root用户，请以root身份运行此脚本。"
    exit 1
fi

# 获取当前SSH端口
CURRENT_PORT=$(grep "^Port" /etc/ssh/sshd_config | awk '{print $2}')

# 随机生成20000-65535之间的端口
NEW_PORT=$((RANDOM % (65535 - 20000 + 1) + 20000))

# 随机生成一个强密码
ROOT_PASS=$(openssl rand -base64 16)

# 如果sudo存在，则使用sudo，否则直接运行命令
CMD_PREFIX=""
if command -v sudo &> /dev/null; then
    CMD_PREFIX="sudo "
fi

# 更改SSH配置文件中的端口
${CMD_PREFIX}sed -i "s/^\(#[ ]*\)\?Port .*/Port $NEW_PORT/" /etc/ssh/sshd_config

# 更改root用户密码
echo "root:$ROOT_PASS" | ${CMD_PREFIX}chpasswd

# 重启SSH服务
${CMD_PREFIX}systemctl restart sshd

# 获取更改后的SSH端口
ACTUAL_NEW_PORT=$(grep "^Port" /etc/ssh/sshd_config | awk '{print $2}')

# 如果ufw防火墙已经安装和运行，更新规则
if command -v ufw &> /dev/null; then
    if ${CMD_PREFIX}ufw status | grep -q "active"; then
        ${CMD_PREFIX}ufw allow $NEW_PORT/tcp
    fi
fi

# 获取真实公网IP地址
REAL_IP=$(curl -s http://ipinfo.io/ip)

# 检查是否成功获取到IP地址
if [ -z "$REAL_IP" ]; then
    echo "无法获取公网IP地址。"
else
    echo "公网IP地址: $REAL_IP"
fi

# 显示原SSH端口、新的SSH端口号、新的root密码以及IP和端口
echo "原SSH端口为$CURRENT_PORT，现已更改为$ACTUAL_NEW_PORT，请使用此端口进行连接。"
echo "新root密码已设置，请妥善保存：$ROOT_PASS"
echo "IP:端口 - $REAL_IP:$ACTUAL_NEW_PORT"
