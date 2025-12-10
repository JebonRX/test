#!/bin/bash
# =========================================
# Show Xray VLESS WS config
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

# list config location
vless_json="/usr/local/etc/xray/vless-tls.json"
vless2="/usr/local/etc/xray/vless-none.json"
vless3="/usr/local/etc/xray/vless-custom.json"
vless4="/usr/local/etc/xray/httpupgrade-tls.json"
vless5="/usr/local/etc/xray/httpupgrade-none.json"

tls="$(cat ~/log-install.txt | grep -w "VLESS WebSocket + TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "VLESS WebSocket + NTLS" | cut -d: -f2|sed 's/ //g')"
none2="$(cat ~/log-install.txt | grep -w "VLESS WS + NTLS(Multipath)" | cut -d: -f2|sed 's/ //g')"
patch="/vless"

NUMBER_OF_CLIENTS=$(grep -c -E "^#vls " "$vless_json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
    clear
    echo ""
    echo "You have no existing clients!"
    exit 1
fi

clear
echo ""
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo -e "  \e[${title}[ SHOW USER XRAY VLESS ACCOUNT ]${reset}"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}\e[${below}m"
echo "Select the existing client you want to view"
echo " Press CTRL+C to return"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}\e[${below}m"
grep -E "^#vls " "$vless_json" | cut -d ' ' -f 2-3 | nl -s ') '

until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
    read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
done

user=$(grep -E "^#vls " "$vless_json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
harini=$(grep -E "^#vls " "$vless_json" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^#vls " "$vless_json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
uuid=$(grep -E "^#vls " "$vless_json" | cut -d ' ' -f 5 | sed -n "${CLIENT_NUMBER}"p)

# Generate links
vlesslink1="vless://${uuid}@${sts}${domain}:$tls?path=/vless&security=tls&encryption=none&type=ws&sni=$sni#VLESS_TLS_${user}_${exp}"
vlesslink2="vless://${uuid}@${sts}${domain}:$none?path=/vless&encryption=none&host=$sni&type=ws#VLESS_NTLS_${user}_${exp}"
vlesslink3="vless://${uuid}@${sts}${domain}:$none2?path=/vless&encryption=none&host=$sni&type=ws#VLESS_NTLS_CUSTOM_${user}_${exp}"
# generate link for vless httpupgrade
vlesslink4="vless://${uuid}@${sts}${domain}:$tls?path=/hvless&security=tls&encryption=none&type=httpupgrade&sni=$sni#VLESS_HTTPUPGRADE_TLS_${user}_${exp}"
vlesslink5="vless://${uuid}@${sts}${domain}:$none?path=/hvless&encryption=none&host=$sni&type=httpupgrade#VLESS_HTTPUPGRADE_NTLS_${user}_${exp}"

clear
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo -e "  \e[${title}[ XRAY VLESS WEBSOCKET / HTTPUPGRADE ]${reset}"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}\e[${below}m"
echo -e "Remarks          : ${user}"
echo -e "Domain           : ${domain}"
echo -e "IP Address       : $MYIP"
echo -e "Port NTLS / TLS  : $none / $tls"
echo -e "Port Multipath   : $none2"
echo -e "UUID             : ${uuid}"
echo -e "Encryption       : None"
echo -e "Network          : WebSocket / HTTPUpgrade "
echo -e "Path WS          : /vless"
echo -e "Path HTTPUpgrade : /hvless"
echo -e "AllowInsecure    : True "
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo -e "  \e[${title}[ Script By NevermoreSSH ]${reset}"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}\e[${below}m"
echo -e "WS TLS           : ${vlesslink1}"
echo ""
echo -e "WS NTLS          : ${vlesslink2}"
echo ""
echo -e "Multipath NTLS   : ${vlesslink3}"
echo ""
echo -e "Httpupgrade TLS  : ${vlesslink4}"
echo ""
echo -e "Httpupgrade NTLS : ${vlesslink5}"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}\e[${below}m"
echo -e "Created   : $harini"
echo -e "Expired   : $exp"
echo ""
read -n 1 -s -r -p "Press any key to back on menu XRAY"
exec menu-vless