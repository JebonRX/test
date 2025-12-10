#!/bin/bash
# =========================================
# Menu Services | Check User login XRAY Config
# Edition : Stable Edition V2.1
# Auther  : NevermoreSSH
# (C) Copyright 2025 - 2026
# =========================================
# Warna
line="38;5;208"         
GREEN="\e[92m"
PINK="\e[38;5;205m"
back_text="1;37;44"
box="1;37"
text="1;37"
title="\e[30;107m"
number="\e[38;5;205"
below="0;37"
reset="\e[0m"

# Public IP
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
domain=$(cat /usr/local/etc/xray/domain)
DIR="/etc/logcon/config"
clear

LOG="/var/log/xray/access.log"
LINES=1000   # ambil 1000 log terbaru ikut timestamp

echo -e "\e[${line}m--------------------------------------${reset}"
echo -e "  \e[${title}[ XRAY VMESS User Login ]${reset}"
echo -e "\e[${line}m--------------------------------------${reset}"
echo -e ""

# =============================
# AMBIL 1000 LOG TERBARU IKUT TIMESTAMP
# =============================
TEMP=$(mktemp)

cat "$LOG" | \
    sed -e 's/\./ /' | \
    awk '{print $1, $2, $0}' | \
    sort -k1,1 -k2,2r | \
    head -n $LINES | \
    awk '{$1=""; $2=""; sub(/^  */, ""); print}' \
    > "$TEMP"

# =============================
# FILTER DALAM 1 JAM TERAKHIR
# =============================
NOW=$(date +%s)
FILTERED=$(mktemp)

CURRENT_YEAR=$(date +%Y)
CURRENT_MONTH=$(date +%m)

while IFS= read -r line; do
    TS1=$(echo "$line" | awk '{print $1}')
    TS2=$(echo "$line" | awk '{print $2}')
    
    if [[ "$TS1" =~ ^[0-9]{4}/[0-9]{2}/[0-9]{2}$ ]]; then
        # FORMAT lengkap: YYYY/MM/DD HH:MM:SS(.micro)
        TS="$TS1 $TS2"
    else
        # FORMAT pendek: DD HH:MM:SS ? tambahkan year & month semasa
        DAY="$TS1"
        TIME="$TS2"
        TS="${CURRENT_YEAR}/${CURRENT_MONTH}/${DAY} ${TIME}"
    fi

    LOG_EPOCH=$(date -d "$TS" +%s 2>/dev/null)

    if [[ $((NOW - LOG_EPOCH)) -le 3600 ]]; then
        echo "$line" >> "$FILTERED"
    fi
done < "$TEMP"

# =============================
# PAPAR USER + IP LOGIN
# =============================
USERS=$(grep -oP 'email:\s*\K\S+' "$FILTERED" | sort -u)

COUNT=1
for USER in $USERS; do
    # Ubah grep/awk supaya sesuai dengan log XRAY terbaru
    RESULT=$(grep "email: $USER" "$FILTERED" | \
             awk -F'from ' '{print $2}' | \
             awk '{print $1}' | \
             awk -F: '{print $1}' | \
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
exec menu-vmess