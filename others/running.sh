#!/bin/bash
# =========================================
# Quick Menu | Running Services Manager
# Modern Interface Edition V2.0
# Author : NevermoreSSH
# (C) Copyright 2025 - 2026
# =========================================

# ----------------------
# COLORS
# ----------------------
red="\e[1;31m"
green="\e[0;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
cyan="\e[1;36m"
magenta="\e[1;35m"
NC="\e[0m"

# ----------------------
# PUBLIC IP
# ----------------------
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)

# ----------------------
# VPS TYPE CHECK
# ----------------------
Checkstart1=$(ip route | grep default | cut -d ' ' -f 3 | head -n 1)
if [[ $Checkstart1 == "venet0" ]]; then 
    lan_net="venet0"
    typevps="OpenVZ"
else
    lan_net="eth0"
    typevps="KVM"
fi

# ----------------------
# VPS INFO
# ----------------------
NAMAISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10)
REGION=$(curl -s ipinfo.io/region)
COUNTRY=$(curl -s ipinfo.io/country)
CITY=$(curl -s ipinfo.io/city)
WAKTU=$(curl -s ipinfo.io/timezone)
koordinat=$(curl -s ipinfo.io/loc)

tram=$(free -m | awk 'NR==2 {print $2}')
uram=$(free -m | awk 'NR==2 {print $3}')
fram=$(free -m | awk 'NR==2 {print $4}')
swap=$(free -m | awk 'NR==4 {print $2}')

totalcore="$(grep -c "^processor" /proc/cpuinfo) Core"
corediilik="$(grep -c "^processor" /proc/cpuinfo)"
tipeprosesor="$(awk -F ': | @' '/model name|Processor|^cpu model|chip type|^cpu type/ {printf $2; exit}' /proc/cpuinfo)"

shellversion="Bash Version ${BASH_VERSION/-*}"
source /etc/os-release
Versi_OS=$VERSION
Tipe=$NAME
kernelku=$(uname -r)
uptime="$(uptime -p | cut -d " " -f 2-10)"
tipeos2=$(uname -m)
Domen="$(cat /usr/local/etc/xray/domain 2>/dev/null || echo "-")"

cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${corediilik:-1}))"
cpu_usage+=" %"

# ----------------------
# HEADER
# ----------------------
clear
echo -e "${magenta}╔══════════════════════════════════════════╗${NC}"
echo -e "${magenta}║         VPS STATUS DASHBOARD             ║${NC}"
echo -e "${magenta}╚══════════════════════════════════════════╝${NC}"
echo ""

# ----------------------
# VPS & OS INFORMATION
# ----------------------
echo -e "${cyan}VPS Information${NC}"
echo -e "${blue}------------------------------${NC}"
printf "%-25s : %s\n" "VPS Type" "$typevps"
printf "%-25s : %s\n" "OS Name" "$Tipe $Versi_OS"
printf "%-25s : %s\n" "OS Arch" "$tipeos2"
printf "%-25s : %s\n" "Kernel Version" "$kernelku"
printf "%-25s : %s\n" "Hostname" "$HOSTNAME"
printf "%-25s : %s\n" "Public IP" "$MYIP"
#printf "%-25s : %s\n" "ISP / Org" "$NAMAISP"
#printf "%-25s : %s\n" "Region / City" "$REGION / $CITY"
#printf "%-25s : %s\n" "Time Zone" "$WAKTU"
echo ""

# ----------------------
# HARDWARE INFORMATION
# ----------------------
echo -e "${cyan}Hardware Information${NC}"
echo -e "${blue}------------------------------${NC}"
printf "%-25s : %s\n" "Processor" "$tipeprosesor"
printf "%-25s : %s\n" "CPU Core" "$totalcore"
printf "%-25s : %s\n" "CPU Usage" "$cpu_usage"
printf "%-25s : %s\n" "Total RAM" "$tram MB"
printf "%-25s : %s\n" "Used RAM" "$uram MB"
printf "%-25s : %s\n" "Available RAM" "$fram MB"
echo ""

# ----------------------
# SERVICES STATUS FUNCTION
# ----------------------
check_service() {
    local name=$1
    local display=$2
    status="$(systemctl show $name --no-page 2>/dev/null)"
    status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
    if [ "${status_text}" == "active" ]; then
        echo -e " $display : ${green}✔ RUNNING${NC}"
    else
        echo -e " $display : ${red}✖ ERROR${NC}"
    fi
}

# ----------------------
# SERVICE STATUS
# ----------------------
echo -e "${yellow}SSH Service Status${NC}"
echo -e "${blue}------------------------------${NC}"

# SSH / VPN
check_service "ssh.service" "OpenSSH"
check_service "stunnel4.service" "Stunnel(SSL)"
check_service "dropbear.service" "Dropbear"
check_service "server-sldns.service" "SlowDNS"
check_service "udp-custom.service" "UDP Custom"
check_service "ws-http.service" "Websocket HTTP"
check_service "ws-https.service" "Websocket HTTPS"

echo ""
# XRAY
echo -e "${yellow}XRAY Services Status${NC}"
echo -e "${blue}------------------------------${NC}"
check_service "xray@vmess-tls.service" "XRAY VMESS WS TLS"
check_service "xray@vmess-none.service" "XRAY VMESS WS NTLS"
echo -e "${blue}------------------------------${NC}"
check_service "xray@vless-tls.service" "XRAY VLESS WS TLS"
check_service "xray@vless-none.service" "XRAY VLESS WS NTLS"
check_service "xray@vless-custom.service" "XRAY VLESS WS CUSTOM"
echo -e "${blue}------------------------------${NC}"
check_service "xray@httpupgrade-tls.service" "XRAY VLESS HTTPUPGRADE TLS"
check_service "xray@httpupgrade-none.service" "XRAY VLESS HTTPUPGRADE NTLS"


echo ""
# OTHERS
echo -e "${yellow}Other Services Status${NC}"
echo -e "${blue}------------------------------${NC}"
check_service "xray@config.service" "Fallback TLS"
check_service "xray@none.service" "Fallback NTLS"
check_service "nginx.service" "Nginx"

echo -e "${blue}------------------------------${NC}"
echo ""
read -n 1 -s -r -p "Press any key to back to menu"
exec menu