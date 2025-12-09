#!/bin/bash
# =========================================
# Restart All VPN Services with Loading Bar
# Author: NevermoreSSH
# =========================================

# Fungsi loading bar
loading_bar() {
    bar="####################"
    for i in $(seq 1 20); do
        echo -ne "[${bar:0:$i}${bar:$i:20}] $((i*5))%\r"
        sleep 0.1
    done
    echo -e ""
}

echo -e "\e[0;32mRestarting all services, please wait...\e[0m"
loading_bar

# Restart standard services
for svc in ssh dropbear stunnel4 fail2ban cron nginx; do
    /etc/init.d/$svc restart &>/dev/null
done

# Restart Xray services
xray_services=(
    xray
    xray@none
    xray@config
    xray@vless-tls
    xray@vless-none
    xray@vless-custom
    xray@httpupgrade-tls
    xray@httpupgrade-none
    xray@vmess-tls
    xray@vmess-none
    xray@vmess-custom
    ws-http
    ws-https
    client-sldns
    server-sldns
)

for svc in "${xray_services[@]}"; do
    systemctl restart $svc &>/dev/null
done

# Restart BadVPN untuk semua port
for port in 7100 7200 7300; do
    screen -dmS badvpn-$port badvpn-udpgw --listen-addr 127.0.0.1:$port --max-clients 1000
done

# Tamat
clear
echo -e "\e[0;32m======================================\e[0m"
echo -e "\e[0;32m         ALL Services Restarted        \e[0m"
echo -e "\e[0;32m======================================\e[0m"
echo ""
echo -e "   \e[1;32m Back to Menu In 5 seconds\e[0m"
sleep 5
exec menu