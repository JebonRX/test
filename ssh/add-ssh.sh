#!/bin/bash
# =========================================
# Menu Services | Create SSH Config
# Edition : Stable Edition V1.1
# Auther  : NevermoreSSH
# (C) Copyright 2025 - 2026
# =========================================

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
IP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me);
DIR="/etc/xray/config"
clear

clear
echo ""
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo -e "  \e[${title}[ CREATE USER • SSH WEBSOCKET ]${reset}"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo ""
read -p "   Username : " Login
read -p "   Password : " Pass
read -p "   Expired (days): " masaaktif

export ssl="$(cat ~/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
export wsdropbear="$(cat ~/log-install.txt | grep -w "Websocket HTTP" | cut -d: -f2|sed 's/ //g')"
export wsstunnel="$(cat ~/log-install.txt | grep -w "Websocket HTTPS" | cut -d: -f2|sed 's/ //g')"
#nsdomain1=$(cat /root/nsdomain)
#pubkey1=$(cat /etc/slowdns/server.pub)

sleep 1
echo Create Premium SSH Config
clear
sleep 1
echo Create Acc: $Login
sleep 1
echo Setting Password: $Pass
sleep 1
clear

# // DATE
export harini=`date -d "0 days" +"%Y-%m-%d"`
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
export exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
export exp1=`date -d "$masaaktif days" +"%Y-%m-%d"`

# Check if the folder exists
if [ -d "$DIR" ]; then
    echo "Folder $DIR already exists. Skipping..."
else
    echo "Folder $DIR does not exist. Creating folder..."
    mkdir -p "$DIR"
    echo "Folder $DIR has been created successfully."
fi

cat >  /etc/xray/config/ssh-$Login.txt <<-END
====================================================================
P R O J E C T  O F  N E V E R M O R E S S H
[Freedom Internet]
====================================================================
https://github.com/NevermoreSSH/SkyNode
====================================================================
Format SSH Websocket Account
====================================================================

====================================================================
Premium Account SSH & OpenVPN
====================================================================
Username         : $Login
Password         : $Pass
Created          : $harini
Expired          : $exp1
====================================================================
Domain           : $domain
Name Server(NS)  : $nsdomain1
Pubkey           : $pubkey1
IP/Host          : $MYIP
OpenSSH          : 22
Dropbear         : 143, 109
SSL/TLS          :$ssl
SlowDNS          : 22,80,443,53,5300
SSH-UDP          : 1-65535
WS SSH(HTTP)     : $wsdropbear
WS SSL(HTTPS)    : $wsstunnel
Badvpn(UDPGW)    : 7100-7300
====================================================================
CONFIG SSH WS
SSH 22      : $(cat /usr/local/etc/xray/domain):22@$Login:$Pass
SSH 80      : $(cat /usr/local/etc/xray/domain):80@$Login:$Pass
SSH 443     : $(cat /usr/local/etc/xray/domain):443@$Login:$Pass
SSH 1-65535 : $(cat /usr/local/etc/xray/domain):1-65535@$Login:$Pass
====================================================================
====================================================================
PAYLOAD WS       : GET / HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf][crlf]"
====================================================================
PAYLOAD WSS      : GET wss://$sni/ HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf]Connection: Keep-Alive[crlf][crlf]"
====================================================================

END

echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
clear
echo -e ""
# OUTPUT
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo -e "  \e[${line}m[ PREMIUM SERVER SSH WEBSOCKET ]\e[${reset}"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo -e "Username         : $Login"
echo -e "Password         : $Pass"
echo -e "Created          : $harini"
echo -e "Expired          : $exp1"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo -e "Domain           : $domain"
#echo -e "Name Server(NS)  : $nsdomain1"
#echo -e "Pubkey           : $pubkey1"
echo -e "IP/Host          : $MYIP"
echo -e "OpenSSH          : 22"
echo -e "Dropbear         : 143, 109"
echo -e "SSL/TLS          :$ssl"
#echo -e "SlowDNS          : 22,80,443,53,5300"
#echo -e "SSH-UDP          : 1-65535"
echo -e "WS SSH(HTTP)     : $wsdropbear"
echo -e "WS SSL(HTTPS)    : $wsstunnel"
echo -e "Badvpn(UDPGW)    : 7100-7300"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo -e "CONFIG SSH WS"
echo "---------------"
#echo -e "SSH Config  : http://${domain}:81/ssh-$Login.txt"
echo -e "SSH 22      : $(cat /usr/local/etc/xray/domain):22@$Login:$Pass"
echo -e "SSH 80      : $(cat /usr/local/etc/xray/domain):80@$Login:$Pass"
echo -e "SSH 443     : $(cat /usr/local/etc/xray/domain):443@$Login:$Pass"
#echo -e "UDP-CUSTOM  : $(cat /usr/local/etc/xray/domain):1-65535@$Login:$Pass"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
#echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo -e "PAYLOAD WS       : GET / HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf][crlf]"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo -e "PAYLOAD WSS      : GET wss://$sni/ HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf]Connection: Keep-Alive[crlf][crlf]"
echo -e "\e[${line}m════════════════════════════════════════════════════${reset}"
echo ""
read -n 1 -s -r -p "Press any key to back on menu SSH"
exec menu-ssh