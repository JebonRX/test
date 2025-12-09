#!/bin/bash
# =========================================
# Quick Menu | Delete SSH Config by Number with Expiry
# Date: 2025-12-10
# Author : NevermoreSSH (modified)
# =========================================

# Warna
line="38;5;208"
GREEN="\e[92m"
PINK="\e[38;5;205m"
back_text="1;37;44"
box="1;37"
text="1;37"
title="\e[30;107m"
below="0;37"
reset="\e[0m"

# Public IP
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
DIR="/etc/logcon/config"
clear
echo -e "\e[32mloading...\e[0m"
clear
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo -e "  ${title}[ DELETE USER SSH WEBSOCKET BY NUMBER ]${reset}"
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}\e[${below}m"

# Declare associative array
declare -A users  
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

# Semak kalau tiada user
if [ ${#users[@]} -eq 0 ]; then
    echo "No SSH users found."
    read -n 1 -s -r -p "Press any key to back on menu SSH"
    exec menu-ssh
fi

# Pilih nombor untuk delete
read -p "Select number to delete: " number

# Semak input sah
if ! [[ "$number" =~ ^[0-9]+$ ]] || [ "$number" -lt 1 ] || [ "$number" -ge "$count" ]; then
    echo "Invalid selection."
    read -n 1 -s -r -p "Press any key to back on menu SSH"
    exec menu-ssh
fi

Pengguna="${users[$number]}"

# Delete user
if id "$Pengguna" &>/dev/null; then
    userdel "$Pengguna"
    echo "User $Pengguna removed."

    # DELETE FILE CONFIG
    filepath="/etc/logcon/config/ssh-$Pengguna.txt"
    if [ -f "$filepath" ]; then
        rm -f "$filepath"
        echo "File expired $Pengguna deleted."
    else
        echo "File expired $Pengguna not found."
    fi
else
    echo "Failure: User $Pengguna does not exist."
fi

echo ""
read -n 1 -s -r -p "Press any key to back on menu SSH"
exec menu-ssh