#!/bin/bash
# =========================================
# Quick Setup | Menu Manager
# Edition : Stable Edition V1.0
# Auther  : NevermoreSSH
# (C) Copyright 2025 - 2026
# =========================================

# public ip
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
clear

# url files
Server_URL="raw.githubusercontent.com/JebonRX/test/main/xray"

# make directory Menu
cd /usr/bin

# XRAY VMESS FILES
echo -e "[ ${green}INFO${NC} ] Downloading Vmess WS Files"
sleep 1
wget -O menu-vmess "https://${Server_URL}/add-vmess.sh" && chmod +x menu-vmess
wget -O add-vmess "https://${Server_URL}/add-vmess.sh" && chmod +x add-vmess
wget -O check-vmess "https://${Server_URL}/check-vmess.sh" && chmod +x check-vmess
wget -O delete-vmess "https://${Server_URL}/delete-vmess.sh" && chmod +x delete-vmess
wget -O renew-vmess "https://${Server_URL}/renew-vmess.sh" && chmod +x renew-vmess
wget -O show-vmess "https://${Server_URL}/show-vmess.sh" && chmod +x show-vmess
wget -O trial-vmess "https://${Server_URL}/trial-vmess.sh" && chmod +x trial-vmess

# XRAY VLESS FILES
echo -e "[ ${green}INFO${NC} ] Downloading Vless WS Files"
sleep 1
wget -O menu-vless "https://${Server_URL}/add-vless.sh" && chmod +x menu-vless
wget -O add-vless "https://${Server_URL}/add-vless.sh" && chmod +x add-vless
wget -O check-vless "https://${Server_URL}/check-vless.sh" && chmod +x check-vless
wget -O delete-vless "https://${Server_URL}/delete-vless.sh" && chmod +x delete-vless
wget -O renew-vless "https://${Server_URL}/renew-vless.sh" && chmod +x renew-vless
wget -O show-vless "https://${Server_URL}/show-vless.sh" && chmod +x show-vless
wget -O trial-vless "https://${Server_URL}/trial-vless.sh" && chmod +x trial-vless

# SSH Websocket files
sleep 1

# Tweak files
sleep 1
wget -O bbr "https://raw.githubusercontent.com/JebonRX/test/main/tweak/bbr.sh" && chmod +x bbr


# System files
sleep 1
wget -O menu "https://raw.githubusercontent.com/JebonRX/test/main/others/menu.sh" && chmod +x menu
wget -O netf "https://raw.githubusercontent.com/JebonRX/test/main/others/netf.sh" && chmod +x netf
wget -O dns "https://raw.githubusercontent.com/JebonRX/test/main/others/dns.sh" && chmod +x dns






# end
cd
rm -r menu-vpn.sh
clear