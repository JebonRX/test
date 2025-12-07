#!/bin/bash
# =========================================
# Delete Xray VLESS WS config
# Date: 2025-11-29
# Author : NevermoreSSH
# =========================================

# list config location
vless_json="/usr/local/etc/xray/vless-tls.json"
vless2="/usr/local/etc/xray/vless-none.json"
vless3="/usr/local/etc/xray/vless-custom.json"
vless4="/usr/local/etc/xray/httpupgrade-tls.json"
vless5="/usr/local/etc/xray/httpupgrade-none.json"

# restart after delete config
restart_xray() {
systemctl restart xray@*
}

clear
NUMBER_OF_CLIENTS=$(grep -c -E "^#vls " "$vless_json")

if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
    echo ""
    echo "You have no existing clients!"
    exit 1
fi

echo " Delete User Xray Vless Ws"
echo " Select the existing client you want to remove"
echo " ==============================="
echo "     No   Expired    User"

grep -E "^#vls " "$vless_json" | cut -d ' ' -f 2-3 | nl -s ') '

until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
    read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
done

harini=$(grep -E "^#vls " "$vless_json" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
uuid=$(grep -E "^#vls " "$vless_json" | cut -d ' ' -f 5 | sed -n "${CLIENT_NUMBER}"p)
user=$(grep -E "^#vls " "$vless_json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^#vls " "$vless_json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)

# Delete entry from any config files
sed -i "/^#vls $user $exp $harini $uuid/,/^},{/d" "$vless_json"
sed -i "/^#vls $user $exp $harini $uuid/,/^},{/d" "$vless2"
sed -i "/^#vls $user $exp $harini $uuid/,/^},{/d" "$vless3"
sed -i "/^#vls $user $exp $harini $uuid/,/^},{/d" "$vless4"
sed -i "/^#vls $user $exp $harini $uuid/,/^},{/d" "$vless5"

# clear any expired config
restart_xray

clear
echo " Xray Vless WS Account Deleted Successfully"
echo " =========================="
echo " Client Name : $user"
echo " Expired On  : $exp"
echo " =========================="
echo ""
read -n 1 -s -r -p "Press any key to back on menu Vless"
menu-vless