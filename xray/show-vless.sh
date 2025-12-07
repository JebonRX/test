#!/bin/bash
# =========================================
# Show Xray VLESS WS config
# Date: 2025-11-29
# Author : NevermoreSSH
# =========================================

# list config location
vless_json="/usr/local/etc/xray/vless-tls.json"
vless2="/usr/local/etc/xray/vless-none.json"
vless3="/usr/local/etc/xray/vless-custom.json"
vless4="/usr/local/etc/xray/httpupgrade-tls.json"
vless5="/usr/local/etc/xray/httpupgrade-none.json"

tls="$(cat ~/log-install.txt | grep -w "Vless Ws Tls" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vless Ws None Tls" | cut -d: -f2|sed 's/ //g')"
none2="8080"

NUMBER_OF_CLIENTS=$(grep -c -E "^#vls " "$vless_json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
    clear
    echo ""
    echo "You have no existing clients!"
    exit 1
fi

clear
echo ""
echo "SHOW USER XRAY VLESS WS"
echo "Select the existing client you want to view"
echo " Press CTRL+C to return"
echo -e "==============================="
grep -E "^#vls " "$vless_json" | cut -d ' ' -f 2-3 | nl -s ') '

until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
    read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
done

user=$(grep -E "^#vls " "$vless_json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
harini=$(grep -E "^#vls " "$vless_json" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^#vls " "$vless_json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
uuid=$(grep -E "^#vls " "$vless_json" | cut -d ' ' -f 5 | sed -n "${CLIENT_NUMBER}"p)

# Generate links
vlesslink1="vless://${uuid}@${sts}${domain}:$tls?path=/vless&security=tls&encryption=none&type=ws&sni=$sni#VLESS_TLS_${user}_${exp}"
vlesslink2="vless://${uuid}@${sts}${domain}:$none?path=/vless&encryption=none&host=$sni&type=ws#VLESS_NTLS_${user}_${exp}"
vlesslink3="vless://${uuid}@${sts}${domain}:$none2?path=/vless&encryption=none&host=$sni&type=ws#VLESS_NTLS_CUSTOM_${user}_${exp}"
# generate link for vless httpupgrade
vlesslink4="vless://${uuid}@${sts}${domain}:$tls?path=/vless&security=tls&encryption=none&type=httpupgrade&sni=$sni#VLESS_HTTPUPGRADE_TLS_${user}_${exp}"
vlesslink5="vless://${uuid}@${sts}${domain}:$none?path=/vless&encryption=none&host=$sni&type=httpupgrade#VLESS_HTTPUPGRADE_NTLS_${user}_${exp}"

clear
echo -e ""
echo -e "\e[$line═════════════════════════════════\e[m"
echo -e "\e[$back_text      \e[30m[\e[$box XRAY VLESS WS\e[30m ]\e[1m          \e[m"
echo -e "\e[$line═════════════════════════════════\e[m"
echo -e "Remarks          : ${user}"
echo -e "Domain           : ${domain}"
echo -e "IP/Host          : $MYIP"
echo -e "Port TLS         : $tls"
echo -e "Port None TLS    : $none"
echo -e "Port Multipath   : $none2"
echo -e "User ID          : ${uuid}"
echo -e "Encryption       : None"
echo -e "Network          : WebSocket"
echo -e "Path             : $patchtls"
echo -e "Path Multipath   : /anypath"
echo -e "allowInsecure    : True/allow"
echo -e "\e[$line═════════════════════════════════\e[m"
echo -e "Script By $creditt"
echo -e "\e[$line═════════════════════════════════\e[m"
echo -e "WS TLS           : ${vlesslink1}"
echo -e "WS NTLS          : ${vlesslink2}"
echo -e "Multipath NTLS   : ${vlesslink3}"
echo -e "Httpupgrade TLS  : ${vlesslink4}"
echo -e "Httpupgrade NTLS : ${vlesslink5}"
echo -e "\e[$line═════════════════════════════════\e[m"
echo -e "Created   : $harini"
echo -e "Expired   : $exp"
echo ""
echo ""
read -n 1 -s -r -p "Press any key to back on menu xray"
menu-vless
}
