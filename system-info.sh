#!/bin/bash

# Get system info
cpu_info=$(lscpu | grep "Model name:" | cut -d ":" -f2 | xargs)
cpu_cores=$(lscpu | grep "^CPU(s):" | cut -d ":" -f2 | xargs)
mem_info=$(free -h | grep "Mem:" | awk '{print $2}')
disk_info=$(df -h --total | grep "total" | awk '{print $2}')
os_info=$(lsb_release -d | cut -d ":" -f2 | xargs)
gpu_info=$(lspci -vnn | grep 'VGA compatible controller' | cut -d ":" -f3 | cut -d "(" -f1 | xargs)

# Display as table
echo -e "Specification\t\tValue"
echo -e "-------------\t\t-----"
echo -e "Operating System\t$os_info"
echo -e "CPU Model\t\t$cpu_info"
echo -e "CPU Cores\t\t$cpu_cores"
echo -e "Memory\t\t\t$mem_info"
echo -e "Disk Space\t\t$disk_info"
echo -e "GPU Info\t\t$gpu_info"

# chmod +x system_info.sh