#!/bin/bash
# =========================================
# Show Xray Vmess WS config
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
vmess_json="/usr/local/etc/xray/vmess-tls.json"
vmess2="/usr/local/etc/xray/vmess-none.json"
vmess3="/usr/local/etc/xray/vmess-custom.json"

tls="$(cat ~/log-install.txt | grep -w "VMESS WebSocket + TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "VMESS WebSocket + NTLS" | cut -d: -f2|sed 's/ //g')"
none2="$(cat ~/log-install.txt | grep -w "VMESS WS + NTLS(Multipath)" | cut -d: -f2|sed 's/ //g')"
patch="/vmess"

NUMBER_OF_CLIENTS=$(grep -c -E "^#vms " "$vmess_json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
    clear
    echo ""
    echo "You have no existing clients!"
    exit 1
fi

clear
echo ""
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo -e "  \e[${title}[ SHOW USER XRAY VMESS WEBSOCKET ]${reset}"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}\e[${below}m"
echo "Select the existing client you want to view"
echo " Press CTRL+C to return"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 2-3 | nl -s ') '

until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
    read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
done

user=$(grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
harini=$(grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
uuid=$(grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 5 | sed -n "${CLIENT_NUMBER}"p)

# Generate links ws
cat>/usr/local/etc/xray/$user-tls.json<<EOF
      {
      "v": "2",
      "ps": "VMESS_TLS_${user}_${exp}",
      "add": "${sts}${domain}",
      "port": "${tls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "$patch",
      "type": "none",
      "host": "$sni",
      "tls": "tls",
	  "sni": "$sni"
}
EOF
cat>/usr/local/etc/xray/$user-ntls.json<<EOF
      {
      "v": "2",
      "ps": "VMESS_NTLS_${user}_${exp}",
      "add": "${sts}${domain}",
      "port": "${none}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "$patch",
      "type": "none",
      "host": "$sni",
      "tls": "none"
}
EOF
# custom
cat>/usr/local/etc/xray/$user-custom.json<<EOF
      {
      "v": "2",
      "ps": "VMESS_NTLS_CUSTOM_${user}_${exp}",
      "add": "${sts}${domain}",
      "port": "${none2}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "$patch",
      "type": "none",
      "host": "$sni",
      "tls": "none"
}
EOF

# create vmess base64
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmesslink1="vmess://$(base64 -w 0 /usr/local/etc/xray/$user-tls.json)"
vmesslink2="vmess://$(base64 -w 0 /usr/local/etc/xray/$user-none.json)"
vmesslink3="vmess://$(base64 -w 0 /usr/local/etc/xray/$user-custom.json)"

clear
echo -e ""
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo -e "  \e[${title}[ XRAY VMESS WEBSOCKET ]${reset}"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}\e[${below}m"
echo -e "Remakrs          : ${user}"
echo -e "Domain           : ${domain}"
echo -e "IP Address       : $MYIP"
echo -e "Port NTLS / TLS  : $none / $tls"
echo -e "Port Multipath   : $none2"
echo -e "UUID             : ${uuid}"
echo -e "Encryption       : None"
echo -e "Network          : WebSocket"
echo -e "Path             : $patch"
echo -e "Path Multipath   : /anypath"
echo -e "AllowInsecure    : True "
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo -e "  \e[${title}[ Script By NevermoreSSH ]${reset}"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}\e[${below}m"
echo -e "WS TLS           : ${vmesslink1}"
echo -e ""
echo -e "WS NTLS          : ${vmesslink2}"
echo -e ""
echo -e "Multipath NTLS   : ${vmesslink3}"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}\e[${below}m"
echo -e "Created   : $harini"
echo -e "Expired   : $exp"
echo ""
echo ""
read -n 1 -s -r -p "Press any key to back on menu XRAY"
exec menu-vmess