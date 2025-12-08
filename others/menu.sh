#!/bin/bash
# =========================================
# MENU SERVICES
# Date: 2025-11-29
# Author : NevermoreSSH
# =========================================
# public ip
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
clear

# Detail VPS
OS=$(hostnamectl 2>/dev/null | awk -F': ' '/Operating System/ {print $2; exit}')
OS2=$(lsb_release -ds)
domain=$(cat /usr/local/etc/xray/domain)
ISP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
CITY=$(curl -s ipinfo.io/city)
WKT=$(curl -s ipinfo.io/timezone)
IPVPS=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
IPV6=$(curl -s -6 ipv6.icanhazip.com)

# if no IPv6
IPVPS=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
IPV6=$(curl -s -6 ipv6.icanhazip.com)

if [ -z "$IPV6" ]; then
    IPV6="\e[32m(IPv4 only)\e[0m"
else
    IPV6="\e[32m($IPV6)\e[0m"
fi

# detail cpu ram
cname=$(awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo)
freq=$(awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo)
tram=$(free -m | awk 'NR==2 {print $2}')
uram=$(free -m | awk 'NR==2 {print $3}')
fram=$(free -m | awk 'NR==2 {print $4}')
clear

# Dapatkan jumlah CPU cores
cores=$(awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo)

# Tentukan nama berdasarkan jumlah cores
case $cores in
  1)
    name="Single-Core"
    ;;
  2)
    name="Dual-Core"
    ;;
  4)
    name="Quad-Core"
    ;;
  *)
    name="$cores-Core"
    ;;
esac

echo "$name"
clear

# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"

# version updates
ver=$( curl https://raw.githubusercontent.com/JebonRX/test/main/version.conf )
clear

# Getting CPU Information
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*/} / ${corediilik:-1}))"
cpu_usage+=" %"

# TOTAL ACC CREATE VMESS WS
vmess=$(grep -c -E "^#vms " "/usr/local/etc/xray/vmess-tls.json")
# TOTAL ACC CREATE  VLESS WS
vless=$(grep -c -E "^#vls " "/usr/local/etc/xray/vless-tls.json")
# TOTAL ACC CREATE OVPN SSH
sshws="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
# Total Shadowsocks
ss=$(grep -c -E "^#ss " "/usr/local/etc/xray/ss-tls.json")
clear

# ------------------------------
# Detect interface vnstat
# ------------------------------
iface="$(ifconfig 2>/dev/null | awk 'NR==1 {sub(/:$/, "", $1); print $1}')"
if [ -z "$iface" ]; then
    iface=$(ip -o link show | awk -F': ' '$2 != "lo" {print $2; exit}')
fi

# ------------------------------
# Prepare date variables
# ------------------------------
today=$(date +%Y-%m-%d)
yesterday=$(date -d 'yesterday' +%Y-%m-%d)
month=$(date +%Y-%m)
month_deb=$(date +"%b '%y")  # For Debian old format
#totalmon="$(vnstat | grep "total:" | awk '{print $8, $9}')"
totalmon="$(vnstat -i $iface | grep 'total:' | awk '{print $8, $9}')"

# ------------------------------
# 1️⃣ Modern v2 global
# ------------------------------
dmon="$(vnstat -m | grep "$month" | awk '{print $2, $3}')"
umon="$(vnstat -m | grep "$month" | awk '{print $5, $6}')"
tmon="$(vnstat -m | grep "$month" | awk '{print $8, $9}')"

dtoday="$(vnstat -d | grep "$today" | awk '{print $2, $3}')"
utoday="$(vnstat -d | grep "$today" | awk '{print $5, $6}')"
ttoday="$(vnstat -d | grep "$today" | awk '{print $8, $9}')"

dyest="$(vnstat -d | grep "$yesterday" | awk '{print $2, $3}')"
uyest="$(vnstat -d | grep "$yesterday" | awk '{print $5, $6}')"
tyest="$(vnstat -d | grep "$yesterday" | awk '{print $8, $9}')"

# ------------------------------
# 2️⃣ Modern v2 interface (-i $iface)
# ------------------------------
dmon_if2="$(vnstat -i $iface -m | grep "$month" | awk '{print $2, $3}')"
umon_if2="$(vnstat -i $iface -m | grep "$month" | awk '{print $5, $6}')"
tmon_if2="$(vnstat -i $iface -m | grep "$month" | awk '{print $8, $9}')"

dtoday_if2="$(vnstat -i $iface -d | grep "$today" | awk '{print $2, $3}')"
utoday_if2="$(vnstat -i $iface -d | grep "$today" | awk '{print $5, $6}')"
ttoday_if2="$(vnstat -i $iface -d | grep "$today" | awk '{print $8, $9}')"

dyest_if2="$(vnstat -i $iface -d | grep "$yesterday" | awk '{print $2, $3}')"
uyest_if2="$(vnstat -i $iface -d | grep "$yesterday" | awk '{print $5, $6}')"
tyest_if2="$(vnstat -i $iface -d | grep "$yesterday" | awk '{print $8, $9}')"

# ------------------------------
# 3️⃣ v1 global (fallback)
# ------------------------------
dmon_v1="$(vnstat -m | grep "$month_deb" | awk '{print $3" "substr($4,1,1)}')"
umon_v1="$(vnstat -m | grep "$month_deb" | awk '{print $6" "substr($7,1,1)}')"
tmon_v1="$(vnstat -m | grep "$month_deb" | awk '{print $9" "substr($10,1,1)}')"

dtoday_v1="$(vnstat -d | grep "today" | awk '{print $2" "substr($3,1,1)}')"
utoday_v1="$(vnstat -d | grep "today" | awk '{print $5" "substr($6,1,1)}')"
ttoday_v1="$(vnstat -d | grep "today" | awk '{print $8" "substr($9,1,1)}')"

dyest_v1="$(vnstat -d | grep "yesterday" | awk '{print $2" "substr($3,1,1)}')"
uyest_v1="$(vnstat -d | grep "yesterday" | awk '{print $5" "substr($6,1,1)}')"
tyest_v1="$(vnstat -d | grep "yesterday" | awk '{print $8" "substr($9,1,1)}')"

# ------------------------------
# 4️⃣ v1 interface (-i $iface)
# ------------------------------
dmon_if1="$(vnstat -i $iface -m | grep "$month_deb" | awk '{print $3" "substr($4,1,1)}')"
umon_if1="$(vnstat -i $iface -m | grep "$month_deb" | awk '{print $6" "substr($7,1,1)}')"
tmon_if1="$(vnstat -i $iface -m | grep "$month_deb" | awk '{print $9" "substr($10,1,1)}')"

dtoday_if1="$(vnstat -i $iface | grep "today" | awk '{print $2" "substr($3,1,1)}')"
utoday_if1="$(vnstat -i $iface | grep "today" | awk '{print $5" "substr($6,1,1)}')"
ttoday_if1="$(vnstat -i $iface | grep "today" | awk '{print $8" "substr($9,1,1)}')"

dyest_if1="$(vnstat -i $iface | grep "yesterday" | awk '{print $2" "substr($3,1,1)}')"
uyest_if1="$(vnstat -i $iface | grep "yesterday" | awk '{print $5" "substr($6,1,1)}')"
tyest_if1="$(vnstat -i $iface | grep "yesterday" | awk '{print $8" "substr($9,1,1)}')"

# ------------------------------
# Fallback logic: pilih yang ada output
# ------------------------------
dmon="${dmon:-$dmon_if2:-$dmon_v1:-$dmon_if1}"
umon="${umon:-$umon_if2:-$umon_v1:-$umon_if1}"
tmon="${tmon:-$tmon_if2:-$tmon_v1:-$tmon_if1}"

dtoday="${dtoday:-$dtoday_if2:-$dtoday_v1:-$dtoday_if1}"
utoday="${utoday:-$utoday_if2:-$utoday_v1:-$utoday_if1}"
ttoday="${ttoday:-$ttoday_if2:-$ttoday_v1:-$ttoday_if1}"

dyest="${dyest:-$dyest_if2:-$dyest_v1:-$dyest_if1}"
uyest="${uyest:-$uyest_if2:-$uyest_v1:-$uyest_if1}"
tyest="${tyest:-$tyest_if2:-$tyest_v1:-$tyest_if1}"
clear
# ============================
# SERVER INFORMATION
# ============================

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
white="\e[97m"
clear
echo ""
echo -e "\e[97m"  # warna putih terang
echo "███    ██ ███████ ██    ██ ███████ ██████  ███    ███  ██████  ██████  ███████ "
echo "████   ██ ██      ██    ██ ██      ██   ██ ████  ████ ██    ██ ██   ██ ██      "
echo "██ ██  ██ █████   ██    ██ █████   ██████  ██ ████ ██ ██    ██ ██████  █████   "
echo "██  ██ ██ ██       ██  ██  ██      ██   ██ ██  ██  ██ ██    ██ ██   ██ ██      "
echo "██   ████ ███████   ████   ███████ ██   ██ ██      ██  ██████  ██   ██ ███████ "
echo "                    N  E  V  E  R  M  O  R  E  S  S  H"
echo -e "\e[${line}m═══════════════════════════════════════════════════════${reset}"
echo -e "  \e[${title}[ SERVER INFORMATION ]${reset}"
echo -e "\e[${line}m═══════════════════════════════════════════════════════${reset}"

echo -e "  \e[${text}mCpu Model            :${cname}, ${name}${reset}"
echo -e "  \e[${text}mCPU Info             :${freq} MHz (${cpu_usage})${reset}"
echo -e "  \e[${text}mOperating System     : ${OS2}${reset}"
echo -e "  \e[${text}mKernel               : $(uname -r)${reset}"
echo -e "  \e[${text}mRAM Info             : ${uram} MB / ${tram} MB${reset}"
echo -e "  \e[${text}mIp VPS/Address       : ${IPVPS}, ${IPV6}${reset}"
echo -e "  \e[${text}mDomain Name          : ${domain}${reset}"
echo -e "  \e[${text}mSystem Uptime        : ${uptime}${reset}"

# ============================
# TRAFFIC TABLE
# ============================
echo -e "\e[${line}m═══════════════════════════════════════════════════════${reset}"
echo -e "  \e[${title}[ VNSTAT STATUS ]${reset}      \e[97mTotal : (${totalmon})"
echo -e "\e[${line}m═══════════════════════════════════════════════════════${reset}"

echo -e "  \e[${text}mTRAFFIC     Today        Yesterday       Month${reset}"
echo -e "  \e[${text}mDownload    ${dtoday}    ${dyest}      ${dmon}${reset}"
echo -e "  \e[${text}mUpload      ${utoday}    ${uyest}      ${umon}${reset}"
echo -e "  \e[${text}mTotal       ${ttoday}    ${tyest}      ${tmon}${reset}"

# ============================
# PANEL MENU
# ============================
echo -e "\e[${line}m═══════════════════════════════════════════════════════${reset}"
echo -e "  \e[${title}[ SERVICES MENU ]${reset}"
echo -e "\e[${line}m═══════════════════════════════════════════════════════${reset}"

echo -e "  \e[${number}m(•1)\e[0m \e[${below}mXRAY VLESS${reset}     ${PINK}[${GREEN}${vless}${PINK}]  "
echo -e "  \e[${number}m(•2)\e[0m \e[${below}mXRAY VMESS${reset}     ${PINK}[${GREEN}${vmess}${PINK}]"
echo -e "  \e[${number}m(•3)\e[0m \e[${below}mSSH WEBSOCKET${reset}  ${PINK}[${GREEN}${sshws}${PINK}]"
echo -e "  \e[${number}m(•4)\e[0m \e[${below}mSHADOWSOCKS${reset}    ${PINK}[${GREEN}${ss}${PINK}]"

# ============================
# VPS MENU
# ============================
echo -e "\e[${line}m═══════════════════════════════════════════════════════${reset}"
echo -e "  \e[${title}[ VPS MENU ]${reset}"
echo -e "\e[${line}m═══════════════════════════════════════════════════════${reset}"
echo -e "  \e[${number}m(•5)\e[0m \e[${below}mSYSTEM MENU${reset}          \e[${number}m(•6)\e[0m \e[${below}mCHECK RUNNING${reset}"
echo -e "  \e[${number}m(•7)\e[0m \e[${below}mCHANGE PORT${reset}          \e[${number}m(•8)\e[0m \e[${below}mCUSTOM DNS${reset}"
echo -e "  \e[${number}m(•9)\e[0m \e[${below}mSPEEDTEST${reset}            \e[${number}m(10)\e[0m \e[${below}mINFO ALL PORT${reset}"
echo -e "  \e[${number}m(11)\e[0m \e[${below}mCLEAR LOG${reset}            \e[${number}m(12)\e[0m \e[${below}mCLEAR EXPIRED FILES${reset}"
echo -e "  \e[${number}m(13)\e[0m \e[${below}mTWEAK MENU${reset}           \e[${number}m(14)\e[0m \e[${below}mRESTART SERVICES${reset}"

echo -e ""
echo -e ""
echo -e "  \e[${below}m[Ctrl + C] For exit from main menu${reset}"

# ============================
# FOOTER INFO
# ============================
echo -e "\e[${line}m═══════════════════════════════════════════════════════${reset}"
echo -e "  \e[${text}mSCRIPT NAME        : SSH XRAY WEBSOCKET (SkyNode) ${reset}"
echo -e "  \e[${text}mVERSION            : $ver ${reset}"
echo -e "\e[${line}m═══════════════════════════════════════════════════════${reset}"
echo -e ""
echo -e "\e[97m"  # warna putih terang
read -p " Select menu :  " menu
echo -e ""
case $menu in
1)
    menu-vless
    ;;
2)
    menu-vmess
    ;;
3)
    menu-ssh
    ;;
4)
    menu-ss
    ;;
5)
    system
    ;;
6)
    running
    ;;
7)
    change-port
    ;;
8)
    dns
    ;;
9)
    speedtest
    ;;
10)
    cat log-install.txt
    ;;
11)
    delete && xp
    ;;
12)
    menu-tweak
    ;;
13)
    netf
    ;;
14)
    restart
    ;;
x)
    clear
    exit
    echo -e "\e[1;31mPlease Type menu For More Service, Thank You\e[0m"
    ;;
*)
    clear
    echo -e "\e[1;31mPlease enter an correct number\e[0m"
    sleep 1
    menu
    ;;
esac