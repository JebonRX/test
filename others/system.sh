#!/bin/bash
# =========================================
# MENU SERVICES
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
white="\e[97m"
# public ip
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
clear
echo -e ""
echo -e "\e[${line}m══════════════════════════════════════════════${reset}"
echo -e "  \e[${title}[ SYSTEM MENU ]${reset}"
echo -e "\e[${line}m══════════════════════════════════════════════${reset}"
echo -e "   \e[${number}m(•1) \e[${below}mAdd New Subdomain\e[m"
echo -e "   \e[${number}m(•2) \e[${below}mRenew Cert Xray Core\e[m"
echo -e "   \e[${number}m(•3) \e[${below}mCustom DNS Changer\e[m"
echo -e "   \e[${number}m(•4) \e[${below}mNetflix Checker\e[m"
echo -e "   \e[${number}m(•5) \e[${below}mBackup VPS\e[m"
echo -e "   \e[${number}m(•6) \e[${below}mRestore VPS\e[m"
echo -e "   \e[${number}m(•7) \e[${below}mLimit Speed VPS\e[m"
echo -e "   \e[${number}m(•8) \e[${below}mReboot VPN\e[m"
echo -e "   \e[${number}m(•9) \e[${below}mRestart VPN\e[m"
echo -e "   \e[${number}m(10) \e[${below}mSpeedtest VPS\e[m"
echo -e "   \e[${number}m(11) \e[${below}mChange Password VPS\e[m"
#echo -e ""
#echo -e "   \e[${number}m(77) \e[${below}mInstall SlowDNS\e[m"
#echo -e "   \e[${number}m(88) \e[${below}mInstall UDP Custom\e[m"
echo -e "   \e[${line}m═══════════════════════════════════════════${reset}"
echo -e "\e[$line"
read -p "       PPlease Input Number  [1-99 or x] :  "  sys
echo -e ""
case $sys in
1)
add-host
;;
2)
certv2ray
;;
3)
dns
;;
4)
netf
;;
5)
backup
;;
6)
restore
;;
7)
limit-speed
;;
8)
reboot
;;
9)
restart
;;
10)
speedtest
;;
11)
passwd
;;
77)
wget https://raw.githubusercontent.com/NevermoreSSH/Vergil/main2/addons/dns2.sh && chmod +x dns2.sh && ./dns2.sh
;;
88)
wget https://raw.githubusercontent.com/NevermoreSSH/Vergil/main/Tunnel/udp.sh && bash udp.sh
;;
x)
menu
;;
*)
echo "Please enter an correct number"
sleep 1
system
;;
esac