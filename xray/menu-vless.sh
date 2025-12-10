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
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}
\033[1;37mXRAY VLESS By NevermoreSSH\033[0m
\033[1;37mTelegram : https://t.me/todfix667 \033[0m"
echo ""
echo ""
echo -e " [\033[1;36m•1\033[0m]  \e[${below}mAdd XRAY VLESS Account${reset}"
echo -e " [\033[1;36m•2\033[0m]  \e[${below}mDelete XRAY VLESS Account${reset}"
echo -e " [\033[1;36m•3\033[0m]  \e[${below}mRenew XRAY VLESS Account${reset}"
echo -e " [\033[1;36m•4\033[0m]  \e[${below}mShow XRAY VLESS Config${reset}"
echo -e " [\033[1;36m•5\033[0m]  \e[${below}mCheck User Login XRAY VLESS${reset}"
echo ""
echo ""
echo -e " [\033[1;36m•0\033[0m]  \e[${below}mBack To Main Menu"
echo ""
echo -e " \033[1;37mPress [ Ctrl+C ] • To-Exit-Script\033[0m"
echo ""
echo -e "\e[${below}m"
read -p " Select menu : " opt
echo -e ""
case $opt in
1) 
    clear
    exec add-vless
    ;;
2) 
    clear
    exec delete-vless
    ;;
3) 
    clear
    exec renew-vless
    ;;
4) 
    clear
    exec show-vless
    ;;
5) 
    clear
    exec check-vless
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
    exec menu-vless
    ;;
esac