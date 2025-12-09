#!/bin/bash
# =========================================
# Quick Menu | Renew SSH config
# Date: 2025-11-29
# Author : NevermoreSSH
# =========================================
# Warna
line="38;5;208"         # Oyen terang
GREEN="\e[92m" # hijau
PINK="\e[38;5;205m" # Pink terang
back_text="1;37;44"  # Putih + biru gelap
box="1;37"           # Putih bold
# ============================
# COLOR THEME PREMIUM
# ============================
text="1;37"          # Putih bold (info text)
title="\e[30;107m"   # 30 = hitam, 107 = background putih
number="\e[38;5;205"        # Kuning gold (untuk nombor menu)
below="0;37"         # Putih lembut
reset="\e[0m"

# Public IP
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
domain=$(cat /usr/local/etc/xray/domain)
clear
echo -e "\e[32mloading...\e[0m"
clear
echo -e "\e[32mloading...\e[0m"
clear
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo -e "  ${title}[ RENEW USER SSH WEBSOCKET ]${reset}"
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
read -p " Username :  " User
egrep "^$User" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
read -p "         Day Extend     :  " Days
Today=`date +%s`
Days_Detailed=$(( $Days * 86400 ))
Expire_On=$(($Today + $Days_Detailed))
Expiration=$(date -u --date="1970-01-01 $Expire_On sec GMT" +%Y/%m/%d)
Expiration_Display=$(date -u --date="1970-01-01 $Expire_On sec GMT" '+%d %b %Y')
passwd -u $User
usermod -e  $Expiration $User
egrep "^$User" /etc/passwd >/dev/null
echo -e "$Pass\n$Pass\n"|passwd $User &> /dev/null
clear
echo -e ""
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo -e "  ${title}[ RENEW USER SSH WEBSOCKET ]${reset}"
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo -e ""
echo -e "    Username        :  $User"
echo -e "    Days Added      :  $Days Days"
echo -e "    Expires on      :  $Expiration_Display"
echo -e ""
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
else
clear
echo -e ""
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo -e ""
echo -e "        Username Doesnt Exist         "
echo -e ""
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
fi