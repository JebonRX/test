#!/bin/bash
# =========================================
# Menu XRAY Vless
# Date: 2025-11-29
# Author : NevermoreSSH
# =========================================
P='\e[0;35m'
B='\033[0;36m'
N='\e[0m'
clear
echo -e "\e[36m╒════════════════════════════════════════════╕\033[0m"
echo -e " \E[0;47;30m             XRAY VLESS WS MENU             \E[0m"
echo -e "\e[36m╘════════════════════════════════════════════╛\033[0m

 [\033[1;36m•1 \033[0m]  Add XRAY VLESS WS Account
 [\033[1;36m•2 \033[0m]  Delete XRAY VLESS WS Account
 [\033[1;36m•3 \033[0m]  Renew XRAY VLESS WS Account
 [\033[1;36m•4 \033[0m]  Show XRAY VLESS WS Config
 [\033[1;36m•5 \033[0m]  Check User Login XRAY VLESS WS

 [\033[1;36m•0 \033[0m]  Back To Main Menu"
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
x) exit ;;
*) echo "Wrong Button" ; sleep 1 ; menu-vless ;;
esac
