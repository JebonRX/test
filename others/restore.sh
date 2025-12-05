#!/bin/bash
# =========================================
# Quick Setup | Restore any config
# Edition : Stable Edition V1.0
# Auther  : NevermoreSSH
# (C) Copyright 2025 - 2026
# =========================================
# color
red='\e[1;31m'
green='\e[0;32m'
purple='\e[0;35m'
orange='\e[0;33m'
NC='\e[0m'
clear
echo ""
echo -e   "  \e[$line═══════════════════════════════════════════════════════\e[m"
echo -e   "  \e[$back_text            \e[30m[\e[$box RESTORE SSH & XRAY ACCOUNT \e[30m ]\e[1m            \e[m"
echo -e   "  \e[$line═══════════════════════════════════════════════════════\e[m"
echo ""
echo " This Feature Can Only Be Used According To VPS Data With This Autoscript"
echo " Please Insert VPS Data Backup Link To Restore The Data"
echo ""

#read -rp " Password File: " -e InputPass
read -rp " Link File: " -e url
wget -O backup.zip "$url"

#unzip -P $InputPass /root/backup.zip &> /dev/null
unzip backup.zip
rm -f backup.zip
sleep 1
echo -e "[ ${green}INFO${NC} ] Start Restore . . . "
cp -r /root/backup/xray/ /usr/local/etc/ >/dev/null
cp -r /root/backup/crontab /etc/ &> /dev/null
cp -r /root/backup/cron.d /etc/ &> /dev/null
cp -r /root/backup/shadow /etc/ &> /dev/null
cp -r /root/backup/gshadow /etc/ &> /dev/null
cp -r /root/backup/passwd /etc/ &> /dev/null
cp -r /root/backup/group /etc/ &> /dev/null
#cp -r /root/backup/xraay /usr/bin/xraay &> /dev/null
rm -rf /root/backup
rm -f backup.zip

echo ""
echo -e "[ ${green}INFO${NC} ] VPS Data Restore Complete !"
echo ""
echo -e "[ ${green}INFO${NC} ] Back to menu . . . "

# restart all services
systemctl restart nginx
systemctl restart xray
service cron restart

# back to settings
sleep 5
system
clear
