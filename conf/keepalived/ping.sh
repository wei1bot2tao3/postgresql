#!/bin/bash

output_file="unreachable_ips.txt"

# 清空文件
> "$output_file"

# 循环 ping 网段中的 IP 地址
for ((i=1; i<=254; i++)); do
    ip="172.31.254.$i"
    ping -c 1 "$ip" > /dev/null # -c 判定次数
    if [ $? -ne 0 ]; then
        echo "$ip" >> "$output_file"
    fi
done

echo "Ping 不通的 IP 地址已写入到 $output_file 文件中。"
