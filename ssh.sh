#!/bin/bash

# 随机生成2000-65535之间的端口
NEW_PORT=$((RANDOM % (65535 - 2000 + 1) + 2000))

# 更改SSH配置文件中的端口
sudo sed -i "s/^Port .*/Port $NEW_PORT/" /etc/ssh/sshd_config

# 重启SSH服务
sudo systemctl restart sshd

# 如果ufw防火墙已经安装和运行，更新规则
if sudo ufw status | grep -q "active"; then
    sudo ufw allow $NEW_PORT/tcp
fi

# 提示用户新的端口号
echo "SSH端口已更改为$NEW_PORT，请使用此端口进行连接。"
