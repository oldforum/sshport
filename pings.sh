#!/bin/bash

# 声明一个关联数组来存储IP地址和备注
declare -A ip_addresses
ip_addresses=( ["192.168.1.1"]="Router" ["8.8.8.8"]="Google DNS" ["www.google.com"]="Google")

# 循环遍历关联数组中的IP地址和备注
for ip in "${!ip_addresses[@]}"; do
    remark="${ip_addresses[$ip]}"
    
    # 使用ping命令发送4个ICMP回显请求包，等待1秒，并将结果存储到变量output中
    output=$(ping -c 4 -W 1 "$ip")

    # 从ping命令的输出中提取平均延迟时间（ms）
    avg_delay=$(echo "$output" | grep -oP 'time=\K\d+' | awk '{sum+=$1} END {if(NR>0) print sum/NR; else print 0}')

    # 打印结果，包括IP地址、备注和平均延迟
    echo "备注: $remark"
    echo "IP地址: $ip"
    echo "平均延迟: ${avg_delay}ms"
    echo "-------------------------------"
done
