#!/bin/bash
# =========================================
# Menu Services | Create XRAY Config
# Edition : Stable Edition V1.1
# Auther  : NevermoreSSH
# (C) Copyright 2025 - 2026

# Set color
line="1;32"
back_text="1;47"
box="1;34"
creditt="NevermoreSSH"

# Warna
line="\e[1;36m"      # Cyan terang
title="\e[1;37;44m"   # Putih + background biru gelap
reset="\e[0m"

# Public IP
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
domain=$(cat /usr/local/etc/xray/domain)
DIR="/etc/xray/config"
clear

# Ambil port dari log-install.txt
tls="$(grep -w "VLESS WebSocket + TLS" ~/log-install.txt | cut -d: -f2 | sed 's/ //g')"
none="$(grep -w "VLESS WebSocket + NTLS" ~/log-install.txt | cut -d: -f2 | sed 's/ //g')"
none2="8080"
patch="/vless"


# Input username
echo -e "${line}══════════════════════════════════════════════${reset}"
echo -e "${title}   CREATE USER • XRAY VLESS WS                ${reset}"
echo -e "${line}══════════════════════════════════════════════${reset}"
#echo ""
echo ""
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
    read -rp "Username: " -e user
    CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/vless-tls.json | wc -l)
    if [[ ${CLIENT_EXISTS} == '1' ]]; then
        echo "A client with the specified name already exists. Choose another."
        exit 1
    fi
done

# UUID
uuid=$(cat /proc/sys/kernel/random/uuid)

# Bug address & SNI
#read -p "Bug Address (example: www.google.com): " address
#read -p "Bug SNI/Host (example: m.facebook.com): " sni
read -p "Input custom UUID (Press Enter For New UUID): " uuid_input
read -p "Expired (days): " masaaktif

bug_addr=${address}.
bug_addr2=$address
sts=${address:-$bug_addr2}

# normalize/validate function
normalize_uuid() {
  local u="$1"
  # buang braces / quotes / spaces
  u="${u//[\{\}\"]/}"
  u="${u// /}"
  # 32 hex tanpa dash -> tambah dash
  if [[ "$u" =~ ^[0-9a-fA-F]{32}$ ]]; then
    echo "${u:0:8}-${u:8:4}-${u:12:4}-${u:16:4}-${u:20:12}" | tr 'A-Z' 'a-z'
    return 0
  fi
  # sudah berbentuk dashed uuid
  if [[ "$u" =~ ^[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}$ ]]; then
    echo "$u" | tr 'A-Z' 'a-z'
    return 0
  fi
  return 1
}

if [[ -z "$uuid_input" ]]; then
  uuid="$(cat /proc/sys/kernel/random/uuid)"
else
  if normalized="$(normalize_uuid "$uuid_input")"; then
    uuid="$normalized"
  else
    echo "UUID yang anda masukkan tidak sah. Akan generate automatik." >&2
    uuid="$(cat /proc/sys/kernel/random/uuid)"
  fi
fi

# Expired date
exp=$(date -d "$masaaktif days" +"%Y-%m-%d")
harini=$(date +"%Y-%m-%d")

# create vless websocket
sed -i '/#vless-ws-tls$/a\#vls '"$user $exp $harini $uuid"'\n},{"id": "'$uuid'","email": "'$user'"' /usr/local/etc/xray/vless-tls.json
sed -i '/#vless-ws-ntls$/a\#vls '"$user $exp $harini $uuid"'\n},{"id": "'$uuid'","email": "'$user'"' /usr/local/etc/xray/vless-none.json
sed -i '/#vless-ws-custom$/a\#vls '"$user $exp $harini $uuid"'\n},{"id": "'$uuid'","email": "'$user'"' /usr/local/etc/xray/vless-custom.json
# create vless httpupgrade
sed -i '/#vless-httpupgrade-tls$/a\#vls '"$user $exp $harini $uuid"'\n},{"id": "'$uuid'","email": "'$user'"' /usr/local/etc/xray/httpupgrade-tls.json
sed -i '/#vless-httpupgrade-ntls$/a\#vls '"$user $exp $harini $uuid"'\n},{"id": "'$uuid'","email": "'$user'"' /usr/local/etc/xray/httpupgrade-none.json

# Generate links ws
vlesslink1="vless://${uuid}@${sts}${domain}:$tls?path=/vless&security=tls&encryption=none&host=${domain}&type=ws&sni=${domain}#VLESS_TLS_${user}_${exp}"
vlesslink2="vless://${uuid}@${sts}${domain}:$none?path=/vless&encryption=none&host=${domain}&type=ws#VLESS_NTLS_${user}_${exp}"
vlesslink3="vless://${uuid}@${sts}${domain}:$none2?path=/vless&encryption=none&host=${domain}&type=ws#VLESS_NTLS_CUSTOM_${user}_${exp}"
# Generate link httpupgrade
vlesslink4="vless://${uuid}@${sts}${domain}:$tls?path=/httpupgrade&security=tls&encryption=none&host=${domain}&type=httpupgrade&sni=$sni#VLESS_HTTPUPGRADE_TLS_${user}_${exp}"
vlesslink5="vless://${uuid}@${sts}${domain}:$none?path=/httpupgrade&encryption=none&host=${domain}&type=httpupgrade#VLESS_HTTPUPGRADE_NTLS_${user}_${exp}"

# Restart Xray VLESS services
systemctl restart xray@vless-tls
systemctl restart xray@vless-none
systemctl restart xray@vless-custom
systemctl restart xray@httpupgrade-tls
systemctl restart xray@httpupgrade-none

# Check if the folder exists
if [ -d "$DIR" ]; then
    echo "Folder $DIR already exists. Skipping..."
else
    echo "Folder $DIR does not exist. Creating folder..."
    mkdir -p "$DIR"
    echo "Folder $DIR has been created successfully."
fi

cat > /etc/xray/config/vless-$user-$exp.txt <<-END

====================================================================
P R O J E C T  O F  N E V E R M O R E S S H
[Freedom Internet]
====================================================================
https://github.com/NevermoreSSH/SynXNet
====================================================================
Premium XRAY VLESS config
====================================================================
Remarks          : ${user}
Domain           : ${domain}
IP/Host          : $MYIP
Port TLS         : $tls
Port None TLS    : $none
Port Multipath   : $none2
User ID          : ${uuid}
Encryption       : None
Network          : WebSocket
Path WS          : /vless
Path httpupgrade : /httpupgrade
allowInsecure    : True
====================================================================
Link WS TLS : `$vlesslink1`
====================================================================
Link WS NTLS : `$vlesslink2`
====================================================================
Link WS NTLS Multipath: `$vlesslink3`
====================================================================
Link HTTPUPGRADE TLS : `$vlesslink4`
====================================================================
Link HTTPUPGRADE NTLS : `$vlesslink5`
====================================================================
Expired On : $harini - $exp
====================================================================

END

# Tampilkan info
clear
echo -e "${line}══════════════════════════════════════════${reset}"
echo -e "${title}   XRAY VLESS WEBSOCKET                   ${reset}"
echo -e "${line}══════════════════════════════════════════${reset}"
echo -e "Remarks          : ${user}"
echo -e "Domain           : ${domain}"
echo -e "IP/Host          : $MYIP"
echo -e "Port TLS         : $tls"
echo -e "Port None TLS    : $none"
echo -e "Port Multipath   : $none2"
echo -e "User ID          : ${uuid}"
echo -e "Encryption       : None"
echo -e "Network          : WebSocket"
echo -e "Path WS          : /vless"
echo -e "Path httpupgrade : /httpupgrade"
echo -e "allowInsecure    : True "
echo -e "${line}══════════════════════════════════════════${reset}"
echo -e "Script By $creditt"
echo -e "${line}══════════════════════════════════════════${reset}"
echo -e "WS TLS           : ${vlesslink1}"
echo ""
echo -e "WS NTLS          : ${vlesslink2}"
echo ""
echo -e "Multipath NTLS   : ${vlesslink3}"
echo ""
echo -e "Httpupgrade TLS  : ${vlesslink4}"
echo ""
echo -e "Httpupgrade NTLS : ${vlesslink5}"
echo -e "${line}══════════════════════════════════════════${reset}"
echo -e "Created   : $harini"
echo -e "Expired   : $exp"
echo ""
