#!/bin/bash

# IP地址和备注列表（每个条目格式为：节点名称,IP地址）
ip_remarks=(
    "AK.HKLite,91.229.133.25"
    "AK.KRBGP,185.214.103.178"
    "AK.JPPRO,103.232.213.62"
    "AK.JPLite,181.214.136.81"
    "AK.SGLite,85.237.68.236"
    "AK.LAXUS3,108.165.254.235"
    "AK.FRNAT,51.158.62.251"
    # 添加更多节点名称和IP地址
)

# 计算对齐所需的宽度
max_width=0
for entry in "${ip_remarks[@]}"; do
    IFS=',' read -ra parts <<< "$entry"
    node_name="${parts[0]}"
    if [ ${#node_name} -gt $max_width ]; then
        max_width=${#node_name}
    fi
done

# 打印表头
printf "%-${max_width}s %15s\n" "节点名称" "延迟"
echo "=============================="

# 循环遍历IP地址和备注列表
for entry in "${ip_remarks[@]}"; do
    IFS=',' read -ra parts <<< "$entry"
    node_name="${parts[0]}"
    ip="${parts[1]}"

    # 使用ping命令发送4个ICMP回显请求包，等待1秒，并将结果存储到变量output中
    output=$(ping -c 4 -W 1 "$ip")

    # 从ping命令的输出中提取平均延迟时间（ms）
    avg_delay=$(echo "$output" | grep -oP 'time=\K\d+' | awk '{sum+=$1} END {if(NR>0) print sum/NR; else print 0}')
    
    # 打印结果，包括节点名称和平均延迟
    printf "%-${max_width}s %12s ms\n" "$node_name" "$avg_delay"
done
