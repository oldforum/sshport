#!/bin/bash

# IP地址数组
ips=(8.8.8.8 4.4.4.4 1.1.1.1) 

for ip in ${ips[@]}
do
  ping -c 3 $ip &> /dev/null
  
  if [ $? -eq 0 ]; then
    echo "$ip is up"
  else
    echo "$ip is down"
  fi  
done
