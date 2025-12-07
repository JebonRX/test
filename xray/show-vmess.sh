#!/bin/bash
# =========================================
# Show Xray Vmess WS config
# Date: 2025-11-29
# Author : NevermoreSSH
# =========================================

# list config location
vmess_json="/usr/local/etc/xray/vmess-tls.json"
vmess2="/usr/local/etc/xray/vmess-none.json"
vmess3="/usr/local/etc/xray/vmess-custom.json"
vmess4="/usr/local/etc/xray/httpupgrade-tls.json"
vmess5="/usr/local/etc/xray/httpupgrade-none.json"

tls="$(cat ~/log-install.txt | grep -w "VMESS WebSocket + TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "VMESS WebSocket + NTLS" | cut -d: -f2|sed 's/ //g')"
none2="$(cat ~/log-install.txt | grep -w "VMESS WS + NTLS(Multipath)" | cut -d: -f2|sed 's/ //g')"

NUMBER_OF_CLIENTS=$(grep -c -E "^#vms " "$vmess_json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
    clear
    echo ""
    echo "You have no existing clients!"
    exit 1
fi

clear
echo ""
echo "SHOW USER XRAY Vmess WS"
echo "Select the existing client you want to view"
echo " Press CTRL+C to return"
echo -e "==============================="
grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 2-3 | nl -s ') '

until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
    read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
done

user=$(grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
harini=$(grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
uuid=$(grep -E "^#vms " "$vmess_json" | cut -d ' ' -f 5 | sed -n "${CLIENT_NUMBER}"p)

# Generate links ws
cat>/usr/local/etc/xray/$user-tls.json<<EOF
      {
      "v": "2",
      "ps": "VMESS_TLS_${user}_${exp}",
      "add": "${sts}${domain}",
      "port": "${tls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "$patch",
      "type": "none",
      "host": "$sni",
      "tls": "tls",
	  "sni": "$sni"
}
EOF
cat>/usr/local/etc/xray/$user-ntls.json<<EOF
      {
      "v": "2",
      "ps": "VMESS_NTLS_${user}_${exp}",
      "add": "${sts}${domain}",
      "port": "${none}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "$patch",
      "type": "none",
      "host": "$sni",
      "tls": "none"
}
EOF
# custom
cat>/usr/local/etc/xray/$user-custom.json<<EOF
      {
      "v": "2",
      "ps": "VMESS_NTLS_CUSTOM_${user}_${exp}",
      "add": "${sts}${domain}",
      "port": "${none2}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "$patch",
      "type": "none",
      "host": "$sni",
      "tls": "none"
}
EOF

# create vmess base64
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmesslink1="vmess://$(base64 -w 0 /usr/local/etc/xray/$user-tls.json)"
vmesslink2="vmess://$(base64 -w 0 /usr/local/etc/xray/$user-none.json)"
vmesslink3="vmess://$(base64 -w 0 /usr/local/etc/xray/$user-none2.json)"

clear
echo -e ""
echo -e "\e[$line═════════════════════════════════\e[m"
echo -e "\e[$back_text      \e[30m[\e[$box XRAY Vmess WS\e[30m ]\e[1m          \e[m"
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
echo -e "WS TLS           : ${vmesslink1}"
echo -e "WS NTLS          : ${vmesslink2}"
echo -e "Multipath NTLS   : ${vmesslink3}"
echo -e "\e[$line═════════════════════════════════\e[m"
echo -e "Created   : $harini"
echo -e "Expired   : $exp"
echo ""
echo ""
read -n 1 -s -r -p "Press any key to back on menu xray"
menu-vmess
}
