#!/bin/bash

ips=(
  "91.229.133.25"
  "85.237.68.236"
)

for ip in ${ips[@]}
do
  ping_resp=$(ping -c 3 $ip | tail -1)
  ping_time=$(echo $ping_resp | cut -d '/' -f 5 | cut -d '.' -f 1)

  if [[ $ip == "91.229.133.25" ]]; then
    echo "AK.HKLite, IP: $ip, Delay: $ping_time ms"  
  elif [[ $ip == "85.237.68.236" ]]; then
    echo "AK.SGLite, IP: $ip, Delay: $ping_time ms"
  fi
done
