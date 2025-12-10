#!/bin/bash
# =========================================
# Quick Menu | Show SSH Config
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
DIR="/etc/logcon/config"
clear
echo -e "\e[${line}m-----------------------------------------------${reset}\e[${below}m"
echo -e "        SHOW SSH WEBSOCKET CONFIG"
echo -e "\e[${line}m-----------------------------------------------${reset}"
echo -e "\e[${below}m"

declare -A users
count=1

# Ambil user bukan sistem (UID >= 1000)
for user in $(awk -F: '$3>=1000 && $1!="nobody"{print $1}' /etc/passwd); do
    config_file="/etc/logcon/config/ssh-$user.txt"
    
    if [[ -f "$config_file" ]]; then
        printf " %2s) %-20s\n" "$count" "$user"
        users[$count]=$user
        count=$((count + 1))
    fi
done

if [ ${#users[@]} -eq 0 ]; then
    echo " No detect any config SSH Websocket!"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu SSH"
    exec menu-ssh
    exit 0
fi

echo ""
echo -e "\e[${line}m-----------------------------------------------${reset}\e[${below}m"

# -----------------------------------------------
#  PILIH USER BERDASARKAN NOMBOR
# -----------------------------------------------
while true; do
    read -p " Select the user number to show the config : " user_no
    if [[ -n "${users[$user_no]}" ]]; then
        User="${users[$user_no]}"
        break
    else
        echo " Nombor tidak sah, cuba lagi."
    fi
done

# -----------------------------------------------
# TUNJUK ISI CONFIG
# -----------------------------------------------
clear
config_file="/etc/logcon/config/ssh-$User.txt"

echo ""
echo -e "\e[${line}m-----------------------------------------------${reset}\e[${below}m"
echo -e " Config SSH WEBSOCKET untuk user: $User"
echo -e "\e[${line}m-----------------------------------------------${reset}\e[${below}m"
echo ""

cat "$config_file"

echo ""
echo -e "\e[${line}m-----------------------------------------------${reset}\e[${below}m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu SSH"
exec menu-ssh