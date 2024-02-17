#!/bin/bash
echo "System Information and Resource Utilization"

# Architecture 
echo "OS and Kernel version :"
arch=$(uname -a)
echo "$arch"

# CPU Physical 
echo "Number of Physical Processors :"
cpuf=$(grep "physical id" /proc/cpuinfo | wc -l)
echo "$cpuf"

# CPU 
echo "Number of Virtual Processers :"
cpuv=$(grep "processor" /proc/cpuinfo | wc -l)
echo "$cpuv"

# RAM
echo "Memory Usage and Utilization Rate :"
ram_total=$(free --mega | awk '$1 == "Mem:" {print $2}')
ram_use=$(free --mega | awk '$1 == "Mem:" {print $3}')
ram_percent=$(free --mega | awk '$1 == "Mem:" {print("%.2f"), $3/$2*100}')
echo "$ram_use/${ram_total}MB ($ram_percent%)"

# DISK
echo "Disk Usage and Utilization Rate :"
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf "%.1fGb\n", disk_t/1024}')
disk_use=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} END {print disk_u}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_t+= $2} END {printf("%d"), disk_u/disk_t*100}')
echo "$disk_use/${disk_total} ($disk_percent%)"

#CPU LOAD
echo "Processeor Utilization Rate :"
cpul=$(vmstat 1 2 | tail -1 | awk '{printf $15}')
cpu_op=$(expr 100 - $cpul)
cpu_fin=$(printf "%.1f" $cpu_op)
echo "$cpu_fin%"

#LAST BOOT
echo "Last Reboot Time :"
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')
echo "$lb"

# LVM USE
echo "LVM Active :"
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)
echo "$lvmu"

# TCP CONNEXTIONS
echo "Connection TCP :"
tcpc=$(ss -ta | grep ESTAB | wc -l)
echo "＄tcpc"

# USER LOG
echo "Number of Users Currently Logged In :"
ulog=$(users | wc -w)
echo "$ulog"

# NETWORK
echo "Server's IPv4 and MAC Address :"
echo "IPv4 Address(es):"
ip=$(hostname -I)
echo "$ip"
echo "MAC Address(es):"
mac=$(ip link | grep "link/ether" | awk '{print $2}')
echo "$mac"

# SUDO
echo "Number of Commands Executed with sudo :"
cmnd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
echo "$cmnd"
