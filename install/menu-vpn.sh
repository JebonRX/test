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
cd /usr/local/bin/

# XRAY VMESS FILES
echo -e "[ ${green}INFO${NC} ] Downloading Vmess WS Files"
sleep 1
wget -O menu-vmess "https://${Server_URL}/menu-vmess.sh" && chmod +x menu-vmess
wget -O add-vmess "https://${Server_URL}/add-vmess.sh" && chmod +x add-vmess
wget -O check-vmess "https://${Server_URL}/check-vmess.sh" && chmod +x check-vmess
wget -O delete-vmess "https://${Server_URL}/delete-vmess.sh" && chmod +x delete-vmess
wget -O renew-vmess "https://${Server_URL}/renew-vmess.sh" && chmod +x renew-vmess
wget -O show-vmess "https://${Server_URL}/show-vmess.sh" && chmod +x show-vmess
#wget -O trial-vmess "https://${Server_URL}/trial-vmess.sh" && chmod +x trial-vmess
wget -O xp-xrayssh "https://${Server_URL}/xp-xrayssh.sh" && chmod +x xp-xrayssh

# XRAY VLESS FILES
echo -e "[ ${green}INFO${NC} ] Downloading Vless WS Files"
sleep 1
wget -O menu-vless "https://${Server_URL}/menu-vless.sh" && chmod +x menu-vless
wget -O add-vless "https://${Server_URL}/add-vless.sh" && chmod +x add-vless
wget -O check-vless "https://${Server_URL}/check-vless.sh" && chmod +x check-vless
wget -O delete-vless "https://${Server_URL}/delete-vless.sh" && chmod +x delete-vless
wget -O renew-vless "https://${Server_URL}/renew-vless.sh" && chmod +x renew-vless
wget -O show-vless "https://${Server_URL}/show-vless.sh" && chmod +x show-vless
#wget -O trial-vless "https://${Server_URL}/trial-vless.sh" && chmod +x trial-vless

# SSH Websocket files
echo -e "[ ${green}INFO${NC} ] Downloading SSH WS Files"
sleep 1
wget -O menu-ssh "https://raw.githubusercontent.com/JebonRX/test/main/ssh/menu-ssh.sh" && chmod +x menu-ssh
wget -O add-ssh "https://raw.githubusercontent.com/JebonRX/test/main/ssh/add-ssh.sh" && chmod +x add-ssh
wget -O check-ssh "https://raw.githubusercontent.com/JebonRX/test/main/ssh/check-ssh.sh" && chmod +x check-ssh
wget -O delete-ssh "https://raw.githubusercontent.com/JebonRX/test/main/ssh/delete-ssh.sh" && chmod +x delete-ssh
wget -O renew-ssh "https://raw.githubusercontent.com/JebonRX/test/main/ssh/renew-ssh.sh" && chmod +x renew-ssh
wget -O show-ssh "https://raw.githubusercontent.com/JebonRX/test/main/ssh/show-ssh.sh" && chmod +x show-ssh
#wget -O trial-ssh "https://raw.githubusercontent.com/JebonRX/test/main/ssh/trial-ssh.sh" && chmod +x trial-ssh
wget -O member-ssh "https://raw.githubusercontent.com/JebonRX/test/main/ssh/member-ssh.sh" && chmod +x member-ssh

# Shadowsocks Websocket files
echo -e "[ ${green}INFO${NC} ] Downloading Shadowsocks Websocket Files"
wget -O menu-ssws "https://${Server_URL}/menu-ssws.sh" && chmod +x menu-ssws
sleep 1


# Tweak files
sleep 1
wget -O menu-tweak "https://raw.githubusercontent.com/JebonRX/test/main/ssh/menu-tweak.sh" && chmod +x menu-tweak
wget -O bbr "https://raw.githubusercontent.com/JebonRX/test/main/tweak/bbr.sh" && chmod +x bbr;bbr
wget -O bbr-manager "https://raw.githubusercontent.com/JebonRX/test/main/tweak/bbr-manager.sh" && chmod +x bbr-manager
wget -O swapram "https://raw.githubusercontent.com/JebonRX/test/main/tweak/swapram.sh" && chmod +x swapram
wget -O xraychanger "https://raw.githubusercontent.com/JebonRX/test/main/tweak/xraychanger.sh" && chmod +x xraychanger
wget -O ip6menu "https://raw.githubusercontent.com/JebonRX/test/main/tweak/ip6menu.sh" && chmod +x ip6menu

# System files
sleep 1
wget -O menu "https://raw.githubusercontent.com/JebonRX/test/main/others/menu.sh" && chmod +x menu
wget -O netf "https://raw.githubusercontent.com/JebonRX/test/main/others/netf.sh" && chmod +x netf
wget -O dns "https://raw.githubusercontent.com/JebonRX/test/main/others/dns.sh" && chmod +x dns
wget -O add-host "https://raw.githubusercontent.com/JebonRX/test/main/others/add-host.sh" && chmod +x add-host
wget -O running "https://raw.githubusercontent.com/JebonRX/test/main/others/running.sh" && chmod +x running
wget -O change-port "https://raw.githubusercontent.com/JebonRX/test/main/others/port-xray.sh" && chmod +x change-port
#wget -O port-websocket "https://raw.githubusercontent.com/JebonRX/test/main/others/port-websocket.sh" && chmod +x port-websocket
wget -O clear-log "https://raw.githubusercontent.com/JebonRX/test/main/others/clear-log.sh" && chmod +x clear-log
wget -O restart "https://raw.githubusercontent.com/JebonRX/test/main/others/restart.sh" && chmod +x restart
wget -O system "https://raw.githubusercontent.com/JebonRX/test/main/others/system.sh" && chmod +x system
wget -O certv2ray "https://raw.githubusercontent.com/JebonRX/test/main/others/certv2ray.sh" && chmod +x certv2ray
wget -O change-dropbear "https://raw.githubusercontent.com/JebonRX/test/main/others/change-dropbear.sh" && chmod +x change-dropbear

# end
cd
rm -r menu-vpn.sh
clear