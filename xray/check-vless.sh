#!/bin/bash
# =========================================
# Menu Services | Check User login XRAY Config
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

# Public IP
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
domain=$(cat /usr/local/etc/xray/domain)
DIR="/etc/logcon/config"
clear

LOG="/var/log/xray/access.log"
LINES=1000  # ambil last 1000 line

echo -e "\e[${line}m══════════════════════════════════════${reset}"
echo -e "  \e[${title}[ XRAY VLESS User Login ]${reset}"
echo -e "\e[${line}m══════════════════════════════════════${reset}"
echo -e ""
# Ambil last N line sahaja
TEMP=$(mktemp)
tail -n $LINES "$LOG" > "$TEMP"

# Masukkan waktu sekarang (epoch)
NOW=$(date +%s)

# Filter line dalam 1 jam terakhir
FILTERED=$(mktemp)
while IFS= read -r line; do
    TS=$(echo "$line" | awk '{print $1" "$2}' | cut -d'.' -f1)
    LOG_EPOCH=$(date -d "$TS" +%s 2>/dev/null)
    if [[ $((NOW - LOG_EPOCH)) -le 3600 ]]; then
        echo "$line" >> "$FILTERED"
    fi
done < "$TEMP"

# Ambil user unik
USERS=$(grep -oP 'email:\s*\K\S+' "$FILTERED" | sort -u)

COUNT=1
for USER in $USERS; do
    # Kira login per IP
    RESULT=$(grep "email: $USER" "$FILTERED" | \
        grep "from tcp:" | \
        awk -F"from tcp:" '{print $2}' | \
        awk -F":" '{print $1}' | \
        grep -Eo '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | \
        sort | uniq -c)

    [[ -z "$RESULT" ]] && continue

    echo "${COUNT}. user : $USER"
    echo "$RESULT"
    echo "-------------------------------"

    COUNT=$((COUNT+1))
done

rm -f "$TEMP" "$FILTERED"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu XRAY"
exec menu-vless