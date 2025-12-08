#!/bin/bash
# =========================================
# Renew Xray VLESS WS config
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

# list config location
vless_json="/usr/local/etc/xray/vless-tls.json"
vless2="/usr/local/etc/xray/vless-none.json"
vless3="/usr/local/etc/xray/vless-custom.json"
vless4="/usr/local/etc/xray/httpupgrade-tls.json"
vless5="/usr/local/etc/xray/httpupgrade-none.json"

# restart after delete config
restart_xray() {
systemctl restart xray@*
service cron restart
}

clear
NUMBER_OF_CLIENTS=$(grep -c -E "^#vls " "$vless_json")

if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
    echo ""
    echo "You have no existing clients!"
    exit 1
fi

echo " Renew User XRAY VLESS Account"
echo " Select the existing client"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
grep -E "^#vls " "$vless_json" | cut -d ' ' -f 2-3 | nl -s ') '

until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
    read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
done

read -rp "Extend days: " masaaktif

harini=$(grep -E "^#vls " "$vless_json" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
uuid=$(grep -E "^#vls " "$vless_json" | cut -d ' ' -f 5 | sed -n "${CLIENT_NUMBER}"p)
user=$(grep -E "^#vls " "$vless_json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^#vls " "$vless_json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)

now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)

exp2=$(( (d1 - d2) / 86400 ))
exp3=$((exp2 + masaaktif))
exp4=$(date -d "$exp3 days" +"%Y-%m-%d")

# Renew on all 5 config files
sed -i "s/#vls $user $exp $harini $uuid/#vls $user $exp4 $harini $uuid/g" "$vless_json"
sed -i "s/#vls $user $exp $harini $uuid/#vls $user $exp4 $harini $uuid/g" "$vless2"
sed -i "s/#vls $user $exp $harini $uuid/#vls $user $exp4 $harini $uuid/g" "$vless3"
sed -i "s/#vls $user $exp $harini $uuid/#vls $user $exp4 $harini $uuid/g" "$vless4"
sed -i "s/#vls $user $exp $harini $uuid/#vls $user $exp4 $harini $uuid/g" "$vless5"

# restart after delete config
restart_xray

clear
echo " XRAY VLESS Account Successfully Renewed"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo " Client Name : $user"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu VLESS"
menu-vless
