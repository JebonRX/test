#!/bin/bash
# =========================================
# Fast Xray VLESS WS User Check
# Date: 2025-11-29
# Author : NevermoreSSH
# =========================================

clear
vless_json="/usr/local/etc/xray/vless-tls.json"

echo -e "\033[0;34m══════════════════════════════════════════\033[0m"
echo -e "\E[0;44;37m       ⇱ XRAY Vless WS User Login ⇲       \E[0m"
echo -e "\033[0;34m══════════════════════════════════════════\033[0m"

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
read -n 1 -s -r -p "Press any key to back on menu xray"
menu-vless
