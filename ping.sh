#!/bin/bash

# IP地址数组
ips=(8.8.8.8 4.4.4.4 1.1.1.1)

for ip in ${ips[@]}
do
  ping_resp=$(ping -c 3 $ip | tail -1)
  ping_time=$(echo $ping_resp | cut -d '/' -f 5 | cut -d '.' -f 1)
  
  echo "Google DNS: $ip, Delay: $ping_time ms"
done
