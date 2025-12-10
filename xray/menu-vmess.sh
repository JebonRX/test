#!/bin/bash
# =========================================
# Menu XRAY VMESS
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
P='\e[0;35m'
B='\033[0;36m'
N='\e[0m'
clear
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo -e "  ${title}[ MENU XRAY VMESS WEBSOCKET ]${reset}"
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}
\033[1;37mXRAY VMESS By NevermoreSSH\033[0m
\033[1;37mTelegram : https://t.me/todfix667 \033[0m"
echo ""
echo ""
echo -e " [\033[1;36m•1\033[0m]  \e[${below}mAdd XRAY VMESS Account${reset}"
echo -e " [\033[1;36m•2\033[0m]  \e[${below}mDelete XRAY VMESS Account${reset}"
echo -e " [\033[1;36m•3\033[0m]  \e[${below}mRenew XRAY VMESS Account${reset}"
echo -e " [\033[1;36m•4\033[0m]  \e[${below}mShow XRAY VMESS Config${reset}"
echo -e " [\033[1;36m•5\033[0m]  \e[${below}mCheck User Login XRAY VMESS${reset}"
echo ""
echo ""
echo -e " [\033[1;36m•0\033[0m]  Back To Main Menu"
echo ""
echo -e " \033[1;37mPress [ Ctrl+C ] • To-Exit-Script\033[0m"
echo ""
echo -e "\e[${below}m"
read -p " Select menu : " opt
echo -e ""
case $opt in
1) 
    clear
    exec add-vmess
    ;;
2) 
    clear
    exec delete-vmess
    ;;
3) 
    clear
    exec renew-vmess
    ;;
4) 
    clear
    exec show-vmess
    ;;
5) 
    clear
    exec check-vmess
    ;;
0) 
    clear
    exec menu
    ;;
x) 
    clear
    exec menu
    ;;
*) 
    echo "Wrong Button"
    sleep 1
    exec menu-vmess
    ;;
esac