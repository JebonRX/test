#!/bin/bash
# =========================================
# Delete Xray VMESS WS config
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
vmess_json="/usr/local/etc/xray/vmess-tls.json"
vmess2="/usr/local/etc/xray/vmess-none.json"
vmess3="/usr/local/etc/xray/vmess-custom.json"

# restart after delete config
restart_xray() {
systemctl restart xray@vmess-tls
systemctl restart xray@vmess-none
systemctl restart xray@vmess-custom
#systemctl restart xray@*

}

clear
NUMBER_OF_CLIENTS=$(grep -c -E "^#vms " "$vmess_json")

if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
    echo ""
    echo "You have no existing clients!"
    exit 1
fi

echo " Delete User XRAY VMESS WS"
echo " Select the existing client you want to remove"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo "     No   Expired    User"

grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 2-3 | nl -s ') '

until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
    read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
done

harini=$(grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
uuid=$(grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 5 | sed -n "${CLIENT_NUMBER}"p)
user=$(grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)

# Delete entry from any config files
sed -i "/^#vms $user $exp $harini $uuid/,/^},{/d" "$vmess_json"
sed -i "/^#vms $user $exp $harini $uuid/,/^},{/d" "$vmess2"
sed -i "/^#vms $user $exp $harini $uuid/,/^},{/d" "$vmess3"

# clear any expired config
restart_xray

clear
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo " XRAY VMESS WS Account Deleted Successfully"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo " Client Name : $user"
echo " Expired On  : $exp"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu XRAY"
menu-vmess