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
DIR="/etc/xray/config"
clear
P='\e[0;35m'
B='\033[0;36m'
N='\e[0m'
clear
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo -e "  ${title}[ MENU XRAY VMESS WEBSOCKET ]${reset}"
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo ""
echo ""
echo -e " [\033[1;36m•1\033[0m]  Add XRAY VMESS Account"
echo -e " [\033[1;36m•2\033[0m]  Delete XRAY VMESS Account"
echo -e " [\033[1;36m•3\033[0m]  Renew XRAY VMESS Account"
echo -e " [\033[1;36m•4\033[0m]  Show XRAY VMESS Config"
echo -e " [\033[1;36m•5\033[0m]  Check User Login XRAY VMESS"
echo ""
echo ""
echo -e " [\033[1;36m•0\033[0m]  Back To Main Menu"
echo ""
echo -e " \033[1;37mPress [ Ctrl+C ] • To-Exit-Script\033[0m"
echo ""

read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; add-vmess ;;
2) clear ; delete-vmess ;;
3) clear ; renew-vmess ;;
4) clear ; show-vmess ;;
5) clear ; check-vmess ;;
0) clear ; menu ;;
x) clear ; menu ;;
#x) exit ;;
*) echo "Wrong Button" ; sleep 1 ; menu-vmess ;;
esac
