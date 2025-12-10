#!/bin/bash
# =========================================
# Quick Menu | Change Port Manager
# Edition : Stable Edition V1.1
# Auther  : NevermoreSSH
# (C) Copyright 2025 - 2026
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
# public ip
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
clear
export RED='\033[0;31m';
export NC='\033[0m';

tls="$(cat ~/log-install.txt | grep -w "VLESS WebSocket + TLS " | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "VLESS WebSocket + NTLS" | cut -d: -f2|sed 's/ //g')"
clear
echo -e "\e[${line}m══════════════════════════════════════════════${reset}"
echo -e "  \e[${title}[ CHANGE PORT XRAYS ]${reset}"
echo -e "\e[${line}m══════════════════════════════════════════════${reset}
\033[1;37mChange Port XRAY By NevermoreSSH\033[0m
\033[1;37mTelegram : https://t.me/todfix667 \033[0m"
echo -e " "
#echo -e " \e[1;31m>>\e[0m\e[0;32mChange Port For Xray :\e[0m"
echo -e " ============================================="
echo -e "  [1]  Change Port Fallback TLS  [ ${RED}$tls${NC} ]"
echo -e "  [2]  Change Port Fallback NTLS [ ${RED}$none${NC} ]"
echo -e " ============================================="
echo -e "  [x]  Back To Menu Change Port"
echo -e "  [y]  Go To Main Menu"
echo -e ""
read -p "   Select From Options [1-3 or x & y] :  " prot
echo -e ""
case $prot in
1)
read -p " New Port XRAYS (TLS): " tls1
if [ -z $tls1 ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $tls1)
if [[ -z $cek ]]; then
sed -i "s/$tls/$tls1/g" /usr/local/etc/xray/config.json
sed -i "s/   - Websocket HTTPS            : $tls/   - Websocket HTTPS            : $tls1/g" /root/log-install.txt
sed -i "s/   - VMESS WebSocket + TLS      : $tls/   - VMESS WebSocket + TLS      : $tls1/g" /root/log-install.txt
sed -i "s/   - VLESS WebSocket + TLS      : $tls/   - VLESS WebSocket + TLS      : $tls1/g" /root/log-install.txt
sed -i "s/   - VLESS HTTPUpgrade + TLS    : $tls/   - VLESS HTTPUpgrade + TLS    : $tls1/g" /root/log-install.txt
iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $tls -j ACCEPT
iptables -D INPUT -m state --state NEW -m udp -p udp --dport $tls -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $tls1 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport $tls1 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save > /dev/null
netfilter-persistent reload > /dev/null
systemctl restart xray.service > /dev/null
clear
echo -e "\e[032;1mPort $tls1 modified successfully\e[0m"
echo -e " "
read -n 1 -s -r -p "Press any key to back on menu"
exec change-port
else
echo -e "\e[1;31mPort $tls1 is used\e[0m"
echo -e " "
read -n 1 -s -r -p "Press any key to back on menu"
exec change-port
fi

;;
2)
read -p " New Port XRAYS (NTLS): " none1
if [ -z $none1 ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $none1)
if [[ -z $cek ]]; then
sed -i "s/$none/$none1/g" /usr/local/etc/xray/none.json
sed -i "s/   - Websocket HTTP             : $none/   - Websocket HTTP             : $none1/g" /root/log-install.txt
sed -i "s/   - VMESS WebSocket + NTLS     : $none/   - VMESS WebSocket + NTLS     : $none1/g" /root/log-install.txt
sed -i "s/   - VLESS WebSocket + NTLS     : $none/   - VLESS WebSocket + NTLS     : $none1/g" /root/log-install.txt
sed -i "s/   - VLESS HTTPUpgrade + NTLS   : $none/   - VLESS HTTPUpgrade + NTLS   : $none1/g" /root/log-install.txt
iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $none -j ACCEPT
iptables -D INPUT -m state --state NEW -m udp -p udp --dport $none -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $none1 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport $none1 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save > /dev/null
netfilter-persistent reload > /dev/null
systemctl restart xray@none > /dev/null
clear
echo -e "\e[032;1mPort $none1 modified successfully\e[0m"
echo -e " "
read -n 1 -s -r -p "Press any key to back on menu"
exec change-port
else
echo -e "\e[1;31mPort $none1 is used\e[0m"
echo -e " "
read -n 1 -s -r -p "Press any key to back on menu"
exec change-port
fi
;;
x)
clear
change-port
;;
y)
clear
exec menu
;;
*)
echo "Please enter an correct number"
;;
esac