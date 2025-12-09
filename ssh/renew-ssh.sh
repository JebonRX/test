#!/bin/bash
# =========================================
# Quick Menu | Renew SSH config + file
# Date: 2025-12-10
# Author : NevermoreSSH (Modified)
# =========================================

# Warna
line="38;5;208"         # Oyen terang
GREEN="\e[92m"          # hijau
PINK="\e[38;5;205m"     # Pink terang
title="\e[30;107m"      # hitam text + putih background
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

# Public IP
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
domain=$(cat /usr/local/etc/xray/domain)

clear
echo -e "\e[32mloading...\e[0m"
sleep 0.5
clear

# Header
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo -e "  ${title}[ LIST USER SSH & TARIKH EXPIRE ]${reset}"
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo -e "\e[${below}m"

declare -A users  # array untuk simpan user nombor=>username
count=1

# Ambil user bukan sistem (UID >= 1000)
for user in $(awk -F: '$3>=1000 && $1!="nobody"{print $1}' /etc/passwd); do
    
    Exp=$(chage -l $user | grep "Account expires" | awk -F": " '{print $2}')
    
    if [[ "$Exp" == "never" ]]; then
        ExpDisplay="Never"
    else
        ExpDisplay="$Exp"
    fi

    printf " %2s) %-20s : %s\n" "$count" "$user" "$ExpDisplay"

    users[$count]=$user
    count=$((count + 1))
done

echo ""
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo -e "  ${title}[ RENEW USER SSH WEBSOCKET ]${reset}"
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo -e "\e[${below}m"

# ───────────────────────────────
# INPUT PILIHAN BERASASKAN NOMBOR
# ───────────────────────────────
while true; do
    read -p " Choose No. user : " user_no
    if [[ -n "${users[$user_no]}" ]]; then
        User="${users[$user_no]}"
        break
    else
        echo " Wrong Number, Try Again..."
    fi
done

read -p " Day Extend :  " Days

# ───────────────────────────────
# Dapatkan tarikh expire semasa
# ───────────────────────────────
Old_Exp=$(chage -l $User | grep "Account expires" | awk -F": " '{print $2}')

if [[ "$Old_Exp" == "never" ]]; then
    Old_Exp_Epoch=0
else
    Old_Exp_Epoch=$(date -d "$Old_Exp" +%s)
fi

Today=$(date +%s)
Extend=$(( Days * 86400 ))

if [ $Old_Exp_Epoch -gt $Today ]; then
    New_Exp_Epoch=$(( Old_Exp_Epoch + Extend ))
else
    New_Exp_Epoch=$(( Today + Extend ))
fi

# Format tarikh
Expiration=$(date -d @$New_Exp_Epoch '+%Y-%m-%d')       # untuk file config
Expiration_Display=$(date -d @$New_Exp_Epoch '+%d %b %Y') # untuk display

# ───────────────────────────────
# Apply tarikh expire baru
# ───────────────────────────────
passwd -u $User
usermod -e $Expiration $User

# reset password jika ada var $Pass
if [[ -n "$Pass" ]]; then
    echo -e "$Pass\n$Pass\n" | passwd $User &> /dev/null
fi

# ───────────────────────────────
# UPDATE FILE CONFIG JIKA ADA
# ───────────────────────────────
CONFIG_FILE="/etc/xray/config/ssh-$User.txt"
if [[ -f "$CONFIG_FILE" ]]; then
    # update line Expired sesuai format: "Expired          : YYYY-MM-DD"
    if grep -q "^Expired" "$CONFIG_FILE"; then
        sed -i "s/^Expired\s*:.*$/Expired          : $Expiration/" "$CONFIG_FILE"
    else
        # Jika tiada line Expired, tambah line baru
        echo "Expired          : $Expiration" >> "$CONFIG_FILE"
    fi
fi

# ───────────────────────────────
# Tunjuk summary
# ───────────────────────────────
clear
echo -e ""
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo -e "  ${title}[ RENEW USER SSH WEBSOCKET ]${reset}"
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo -e "\e[${below}m"
echo -e "    Username        :  $User"
echo -e "    Days Added      :  $Days Days"
echo -e "    Expires on      :  $Expiration_Display"
if [[ -f "$CONFIG_FILE" ]]; then
    echo -e "    Config Updated  :  Done ✅"
fi
echo -e ""
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"

echo -e "\e[${below}m"
read -n 1 -s -r -p "Press any key to back on menu SSH"
exec menu-ssh