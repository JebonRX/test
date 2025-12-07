#!/bin/bash
# =========================================
# Renew Xray VMESS WS config
# Date: 2025-11-29
# Author : NevermoreSSH
# =========================================

# list config location
vmess_json="/usr/local/etc/xray/vmess-tls.json"
vmess2="/usr/local/etc/xray/vmess-none.json"
vmess3="/usr/local/etc/xray/vmess-custom.json"

# restart after delete config
restart_xray() {
systemctl restart xray@*
service cron restart
}

clear
NUMBER_OF_CLIENTS=$(grep -c -E "^#vms " "$vmess_json")

if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
    echo ""
    echo "You have no existing clients!"
    exit 1
fi

echo " Renew User Xray VMESS WS"
echo " Select the existing client"
echo " ==============================="
grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 2-3 | nl -s ') '

until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
    read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
done

read -rp "Extend days: " masaaktif

harini=$(grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
uuid=$(grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 5 | sed -n "${CLIENT_NUMBER}"p)
user=$(grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)

now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)

exp2=$(( (d1 - d2) / 86400 ))
exp3=$((exp2 + masaaktif))
exp4=$(date -d "$exp3 days" +"%Y-%m-%d")

# Renew on all 5 config files
sed -i "s/#vms $user $exp $harini $uuid/#vms $user $exp4 $harini $uuid/g" "$vmess_json"
sed -i "s/#vms $user $exp $harini $uuid/#vms $user $exp4 $harini $uuid/g" "$vmess2"
sed -i "s/#vms $user $exp $harini $uuid/#vms $user $exp4 $harini $uuid/g" "$vmess3"
sed -i "s/#vms $user $exp $harini $uuid/#vms $user $exp4 $harini $uuid/g" "$vmess4"
sed -i "s/#vms $user $exp $harini $uuid/#vms $user $exp4 $harini $uuid/g" "$vmess5"

# restart after delete config
restart_xray

clear
echo " VMESS WS Account Successfully Renewed"
echo " =========================="
echo " Client Name : $user"
echo " Expired On  : $exp4"
echo " =========================="
echo ""
read -n 1 -s -r -p "Press any key to back on menu VMESS"
menu-vmess
