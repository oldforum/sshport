#!/bin/bash

# 检查sudo是否存在或者当前是否为root用户
if ! command -v sudo &> /dev/null && [ "$EUID" -ne 0 ]; then
    echo "sudo 未安装，并且当前不是root用户，请以root身份运行此脚本。"
    exit 1
fi

# 随机生成2000-65535之间的端口
NEW_PORT=$((RANDOM % (65535 - 2000 + 1) + 2000))

# 更改SSH配置文件中的端口
if command -v sudo &> /dev/null; then
    sudo sed -i "s/^Port .*/Port $NEW_PORT/" /etc/ssh/sshd_config
    sudo systemctl restart sshd

    # 如果ufw防火墙已经安装和运行，更新规则
    if sudo ufw status | grep -q "active"; then
        sudo ufw allow $NEW_PORT/tcp
    fi
else
    sed -i "s/^Port .*/Port $NEW_PORT/" /etc/ssh/sshd_config
    systemctl restart sshd

    # 如果ufw防火墙已经安装和运行，更新规则
    if ufw status | grep -q "active"; then
        ufw allow $NEW_PORT/tcp
    fi
fi

# 提示用户新的端口号
echo "SSH端口已更改为$NEW_PORT，请使用此端口进行连接。"
