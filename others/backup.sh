#!/bin/bash
# =========================================
# Backup Config
# Author: NevermoreSSH
# Date: 2025-11-29
# =========================================

# color 
red='\e[1;31m'
green='\e[0;32m'
purple='\e[0;35m'
orange='\e[0;33m'
NC='\e[0m'
clear

# public ip
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
IP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
date=$(date +"%Y-%m-%d-%H:%M:%S")
domain=$(cat /usr/local/etc/xray/domain)
clear

# start backup
echo " VPS Data Backup By NevermoreSSH "
sleep 1
echo -e "[ ${green}INFO${NC} ] Processing . . . "
mkdir -p /root/backup
sleep 1
clear
echo " Please Wait VPS Data Backup In Progress . . . "
echo " "
echo " Backup SSH & XRAY Account . . . "

# backup ssh xray
cp -r /home/vps/public_html /root/backup/public_html
cp -r /usr/local/etc/xray/ /root/backup/xray/ >/dev/null 2>&1
cp -r /etc/shadow /root/backup/shadow >/dev/null 2>&1
cp -r /etc/gshadow /root/backup/gshadow >/dev/null 2>&1
cp -r /etc/passwd /root/backup/passwd >/dev/null 2>&1
cp -r /etc/group /root/backup/group >/dev/null 2>&1

# backup others
cp -r /usr/bin/xraay /root/backup/xraay >/dev/null 2>&1
cp -r /etc/logcon/config /root/backup/config >/dev/null 2>&1

# compress for gdrive
cd /root
zip -r $IP-$date-$domain-SkyNode.zip backup > /dev/null 2>&1
rclone copy /root/$IP-$date-$domain-SkyNode.zip dr:backup/
url=$(rclone link dr:backup/$IP-$date-$domain-SkyNode.zip)
id=(`echo $url | grep '^https' | cut -d'=' -f2`)
link="https://drive.google.com/u/4/uc?id=${id}&export=download"
clear
echo -e "\033[1;37mVPS Data Backup By NevermoreSSH\033[0m
\033[1;37mTelegram : https://t.me/todfix667 / @NevermoreSSH\033[0m"
echo ""
echo "Please Copy Link Below & Save In Notepad"
echo ""
echo -e "Your VPS IP ( \033[1;37m$IP\033[0m )"
echo ""
echo -e "\033[1;37m$link\033[0m"
echo ""
echo "If you want to restore data, please enter the link above"
rm -rf /root/backup
rm -r /root/$IP-$date-$domain-SkyNode.zip
echo ""
