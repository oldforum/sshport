#!/bin/bash

# 要求用户输入新的SSH端口
read -p "请输入新的SSH端口: " new_port

# 检查端口是否在指定范围内
if [[ $new_port -lt 1024 || $new_port -gt 49151 ]]; then
    echo "错误：端口值必须在1024-49151之间"
    exit 1
fi

# 更改SSH配置文件中的端口值
sudo sed -i "s/^Port .*/Port $new_port/" /etc/ssh/sshd_config

# 重启SSH服务
sudo systemctl restart sshd

# 如果ufw防火墙已经安装和运行，更新规则
if sudo ufw status | grep -q "active"; then
    sudo ufw allow $new_port/tcp
fi

# 提示用户更改已完成
echo "SSH端口已更改为$new_port，请尝试使用新端口进行连接。"

