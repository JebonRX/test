#!/bin/bash
# =========================================
# Fast Xray VMESS WS User Check
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
vmess_json="/usr/local/etc/xray/vmess-tls.json"

echo ""
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo -e "  \e[${title}[ XRAY VMESS USER LOGIN ]${reset}"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo ""

# Ambil list user sekali sahaja
mapfile -t users < <(grep '^#vls' "$vless_json" | awk '{print $2}')

# Ambil IP aktif sekali sahaja
mapfile -t active_ips < <(ss -nptu | grep xray | awk '{print $5}' | cut -d: -f1 | sort -u)

# Ambil log access sekali sahaja
mapfile -t access_log < <(awk '{print $3,$7}' /var/log/xray/access.log | sed 's/:.*//')

declare -A user_ips

# Proses matching sekali sahaja
for ip in "${active_ips[@]}"; do
    for entry in "${access_log[@]}"; do
        log_ip=$(echo "$entry" | awk '{print $1}')
        log_user=$(echo "$entry" | awk '{print $2}')

        if [[ "$ip" == "$log_ip" ]]; then
            user_ips["$log_user"]+="$ip "
        fi
    done
done

# Papar output
for user in "${users[@]}"; do
    ips="${user_ips[$user]}"

    if [[ -n "$ips" ]]; then
        echo "User : $user"
        echo "$ips" | tr ' ' '\n' | nl
        echo -e "\033[0;34m──────────────────────────────────────────\033[0m"
    fi
done

echo ""
read -n 1 -s -r -p "Press any key to back on menu XRAY"
exec menu-vmess