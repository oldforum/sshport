#!/bin/bash

# 创建关联数组,key是IP,value是备注
declare -A ips_desc

ips_desc[91.229.133.25]="AK.HKLite"
ips_desc[185.214.103.178]="AK.KRBGP"  
ips_desc[103.232.213.62]="AK.JPPRO"
ips_desc[181.214.136.81]="AK.JPLite"
ips_desc[85.237.68.236]="AK.SGLite"
ips_desc[108.165.254.235]="AK.LAXUS3"
ips_desc[51.158.62.251]="AK.FRNAT"

for ip in "${!ips_desc[@]}"
do
  ping_resp=$(ping -c 3 $ip | tail -1)
  ping_time=$(echo $ping_resp | cut -d '/' -f 5 | cut -d '.' -f 1)

  echo "${ips_desc[$ip]}, IP: $ip, Delay: $ping_time ms"
done
