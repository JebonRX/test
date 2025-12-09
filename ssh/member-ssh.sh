#!/bin/bash
# =========================================
# Quick Menu - check member list
# Date: 2025-11-29
# Author : NevermoreSSH
# =========================================
#!/bin/bash

# ============================
# WARNA
# ============================
line="38;5;208"           # Oren terang untuk border
GREEN="\e[92m"            # Hijau untuk UNLOCKED
RED="\e[91m"              # Merah untuk LOCKED
PINK="\e[38;5;205m"       # Pink terang
reset="\e[0m"             # Reset warna

# ============================
# INFO
# ============================
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
domain=$(cat /usr/local/etc/xray/domain)

clear
echo -e "\e[32mLoading...\e[0m"
sleep 1
clear

# ────────────────────────────────
# HEADER TABLE
# ────────────────────────────────
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
printf "%-17s %-17s %-10s\n" "USERNAME" "EXP DATE" "STATUS"
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"

# ────────────────────────────────
# LOOP USER
# ────────────────────────────────
while read user_entry; do
    AKUN="$(echo $user_entry | cut -d: -f1)"
    ID="$(echo $user_entry | grep -v nobody | cut -d: -f3)"
    exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}')"
    status="$(passwd -S $AKUN | awk '{print $2}')"

    # Hanya user normal (UID >= 1000)
    if [[ $ID -ge 1000 ]]; then
        if [[ "$status" == "L" ]]; then
            STAT="${RED}LOCKED${reset}"
        else
            STAT="${GREEN}UNLOCKED${reset}"
        fi

        # Cetak table
        printf "%-17s %-17s %-10s\n" "$AKUN" "$exp" "$STAT"
    fi
done < /etc/passwd

# ────────────────────────────────
# TOTAL USER
# ────────────────────────────────
JUMLAH=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo "Account number: $JUMLAH user"
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu SSH"
exec menu-ssh