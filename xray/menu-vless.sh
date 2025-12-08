#!/bin/bash
# =========================================
# Menu XRAY Vless
# Date: 2025-11-29
# Author : NevermoreSSH
# =========================================
# Warna
line="38;5;208"
GREEN="\e[92m"
PINK="\e[38;5;205m"
back_text="1;37;44"
box="1;37"

# ============================
# COLOR THEME PREMIUM
# ============================
text="1;37"
title="\e[30;107m"
number="\e[38;5;205m"
below="0;37"
reset="\e[0m"
P='\e[0;35m'
B='\033[0;36m'
N='\e[0m'

clear
echo ""
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo -e "  ${title}[ MENU XRAY VLESS WEBSOCKET / HTTPUPGRADE ]${reset}"
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo ""
echo ""
echo -e " [\033[1;36m•1\033[0m]  Add XRAY VLESS Account"
echo -e " [\033[1;36m•2\033[0m]  Delete XRAY VLESS Account"
echo -e " [\033[1;36m•3\033[0m]  Renew XRAY VLESS Account"
echo -e " [\033[1;36m•4\033[0m]  Show XRAY VLESS Config"
echo -e " [\033[1;36m•5\033[0m]  Check User Login XRAY VLESS"
echo ""
echo ""
echo -e " [\033[1;36m•0\033[0m]  Back To Main Menu"
echo ""
echo -e " \033[1;37mPress [ Ctrl+C ] • To-Exit-Script\033[0m"
echo ""

read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; add-vless ;;
2) clear ; delete-vless ;;
3) clear ; renew-vless ;;
4) clear ; show-vless ;;
5) clear ; check-vless ;;
0) clear ; menu ;;
x) clear ; menu ;;
#x) exit ;;
*) echo "Wrong Button" ; sleep 1 ; menu-vless ;;
esac
