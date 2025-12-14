#!/bin/bash
# =========================================
# Menu Services | Check User login XRAY Config
# Edition : Stable Edition V2.2
# Author  : NevermoreSSH
# (C) Copyright 2025 - 2026
# =========================================

# ===== WARNA =====
line="38;5;208"
GREEN="\e[92m"
PINK="\e[38;5;205m"
title="\e[30;107m"
reset="\e[0m"
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

# details
LOG="/var/log/xray/access.log"
LIMIT_TIME="$(date -d '1 hour ago' '+%Y/%m/%d %H:%M:%S')"
NOW_TIME="$(date '+%Y-%m-%d %H:%M:%S')"

clear
echo -e "\e[${line}m═════════════════════════════════${reset}"
echo -e "  \e[${title}[ Show Vless User Login ]${reset}"
echo -e "\e[${line}m═════════════════════════════════${reset}"
echo ""
echo -e "${GREEN}• Filtering logins from ${LIMIT_TIME//\//-} to ${NOW_TIME}${reset}"
echo ""

# =============================
# PARSE LOG (BETUL FORMAT & FIX TCP)
# =============================
RESULT=$(awk -v limit="$LIMIT_TIME" '
$1" "$2 >= limit {
    # Ambil IP sebenar dari field ke-3, skip kalau bukan IPv4
    split($3,a,":")
    if(a[1] ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/){
        ip=a[1]
    } else { next }

    # Ambil user dari email:
    user=""
    for(i=1;i<=NF;i++){
        if($i=="email:"){ user=$(i+1); break }
    }
    if(user=="") next

    count[user,ip]++
    users[user]=1
    total++
}
END{
    if(total==0){ print "NOLOG"; exit }
    print total
    for(u in users){
        print "USER|"u
        for(k in count){
            split(k,a,SUBSEP)
            if(a[1]==u){
                print "IP|"a[2]"|"count[k]
            }
        }
    }
}' "$LOG")

FIRST=$(echo "$RESULT" | head -n1)

if [[ "$FIRST" == "NOLOG" ]]; then
    echo -e "${PINK}• No XRAY login detected in the last 1 hour${reset}"
else
    TOTAL="$FIRST"
    echo -e "${GREEN}• Found $TOTAL login records in the last 1 hour${reset}"
    echo ""

    IDX=1
    echo "$RESULT" | tail -n +2 | while read -r line; do
        if [[ "$line" == USER* ]]; then
            [[ $IDX -gt 1 ]] && echo "-------------------------------"
            USER="${line#USER|}"
            echo "${IDX}. user : $USER"
            IDX=$((IDX+1))
        elif [[ "$line" == IP* ]]; then
            IFS='|' read _ IP CNT <<< "$line"
            echo "   IP: $IP -> $CNT data "
        fi
    done
    echo "-------------------------------"
fi

echo ""
read -n 1 -s -r -p "Press any key to back on menu XRAY"
exec menu-vless