#!/bin/bash

# 定义要ping的IP地址列表
ip_addresses=("192.168.1.1" "8.8.8.8" "www.google.com")

# 循环遍历IP地址列表
for ip in "${ip_addresses[@]}"; do
    # 使用ping命令发送4个ICMP回显请求包，等待1秒，并将结果存储到变量output中
    output=$(ping -c 4 -W 1 "$ip")

    # 从ping命令的输出中提取平均延迟时间（ms）
    avg_delay=$(echo "$output" | grep -oP 'time=\K\d+' | awk '{sum+=$1} END {if(NR>0) print sum/NR; else print 0}')

    # 打印结果
    echo "IP地址: $ip"
    echo "平均延迟: ${avg_delay}ms"
    echo "-------------------------------"
done
