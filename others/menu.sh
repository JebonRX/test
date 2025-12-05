#!/bin/bash
# =========================================
# MENU SERVICES
# Date: 2025-11-29
# Author : NevermoreSSH
# =========================================
clear

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
version=$(cat /home/ver)
ver=$( curl https://raw.githubusercontent.com/${GitUser}/version/main/version.conf )
clear

# Getting CPU Information
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*/} / ${corediilik:-1}))"
cpu_usage+=" %"

# TOTAL ACC CREATE VMESS WS
vmess=$(grep -c -E "^#vms " "/usr/local/etc/xray/vmess.json")
# TOTAL ACC CREATE  VLESS WS
vless=$(grep -c -E "^#vls " "/usr/local/etc/xray/vless.json")
# TOTAL ACC CREATE OVPN SSH
sshws="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
# BANNER COLOUR
banner_colour=$(cat /etc/banner)
# TEXT ON BOX COLOUR
box=$(cat /etc/box)
# LINE COLOUR
line=$(cat /etc/line)
# TEXT COLOUR ON TOP
text=$(cat /etc/text)
# TEXT COLOUR BELOW
below=$(cat /etc/below)
# BACKGROUND TEXT COLOUR
back_text=$(cat /etc/back)
# NUMBER COLOUR
number=$(cat /etc/number)
# BANNER
banner=$(cat /usr/bin/bannerku)
ascii=$(cat /usr/bin/test)
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
totalmon="$(vnstat | grep "total:" | awk '{print $8, $9}')"

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
echo -e "\e[$banner_colour"
figlet -f $ascii "$banner"
echo -e "\e[$text VPS Script"
echo -e " \e[$line╒════════════════════════════════════════════════════════════╕\e[m"
echo -e "  \e[$back_text                    \e[30m[\e[$box SERVER INFORMATION\e[30m ]\e[1m                  \e[m"
echo -e " \e[$line╘════════════════════════════════════════════════════════════╛\e[m"
echo -e "  \e[$text Cpu Model            :$cname, ${name}"
echo -e "  \e[$text CPU Info             :${freq} MHz (${cpu_usage})\e[0m"
echo -e "  \e[$text Operating System     : $OS2 \e[0m"
echo -e "  \e[$text Kernel               : $(uname -r)"
echo -e "  \e[$text RAM Info             : $uram MB / $tram MB"
echo -e "  \e[$text Ip Vps/Address       : $IPVPS, $IPV6\e[0m"
echo -e "  \e[$text Domain Name          : $domain\e[0m"
echo -e "  \e[$text System Uptime        : $uptime"
#echo -e "  \e[$text Organization         : $( curl -s ipinfo.io/org )"
echo -e "  \e[$text Order ID             : $oid"
echo -e "  \e[$text Expired Status       : $exp $sts"
echo -e "  \e[$text Provided By          : $creditt"
echo -e " \e[$line╒════════════════════════════════════════════════════════════╕\e[m"
echo -e "  \e[$text Traffic\e[0m       \e[${text}Today      Yesterday        Month   "
echo -e "  \e[$text Download\e[0m   \e[${text}   $dtoday    $dyest       $dmon   \e[0m"
echo -e "  \e[$text Upload\e[0m     \e[${text}   $utoday    $uyest       $umon   \e[0m"
echo -e "  \e[$text Total\e[0m       \e[${text}  $ttoday    $tyest       $tmon ($totalmon)  \e[0m "
echo -e " \e[$line╘════════════════════════════════════════════════════════════╛\e[m"
echo -e " \e[$text Ssh/Ovpn   V2ray   Vless   Vlessxtls   Trojan-Ws   Trojan-Tls \e[0m "    
echo -e " \e[$below    $total_ssh         $vmess       $vless        $xtls           $trws           $trtls \e[0m "
echo -e " \e[$line╒════════════════════════════════════════════════════════════╕\e[m"
echo -e "  \e[$back_text                        \e[30m[\e[$box PANEL MENU\e[30m ]\e[1m                       \e[m"
echo -e " \e[$line╘════════════════════════════════════════════════════════════╛\e[m"
echo -e "  \e[$number (•1)\e[m \e[$below VLESS\e[m"
echo -e "  \e[$number (•2)\e[m \e[$below VMESS\e[m"
echo -e "  \e[$number (•3)\e[m \e[$below SSH\e[m"     
echo -e "  \e[$number (•4)\e[m \e[$below SHADOWSOCKS\e[m"   
echo -e " \e[$line╒════════════════════════════════════════════════════════════╕\e[m"
echo -e "  \e[$back_text                        \e[30m[\e[$box VPS MENU\e[30m ]\e[1m                       \e[m"
echo -e " \e[$line╘════════════════════════════════════════════════════════════╛\e[m"
echo -e "  \e[$number (•4)\e[m \e[$below SYSTEM MENU\e[m          \e[$number (•8)\e[m \e[$below MENU THEMES\e[m"
echo -e "  \e[$number (•5)\e[m \e[$below CHECK RUNNING\e[m        \e[$number (•9)\e[m \e[$below INFO ALL PORT\e[m"
echo -e "  \e[$number (•6)\e[m \e[$below CHANGE PORT\e[m          \e[$number (10)\e[m \e[$below CLEAR EXPIRED FILES\e[m"
echo -e "  \e[$number (•7)\e[m \e[$below REBOOT VPS\e[m           \e[$number (11)\e[m \e[$below CLEAR LOG VPS\e[m"
echo -e ""
echo -e "  \e[$below[Ctrl + C] For exit from main menu\e[m"
echo -e " \e[$line╒════════════════════════════════════════════════════════════╕\e[m"
echo -e "  \e[$below Version Name         : SSH XRAY WEBSOCKET MULTIPORT v2.2"
echo -e "  \e[$below Autoscript By        : NEVERMORESSH"
echo -e "  \e[$below Certificate Status   : Expired in $certifacate days"
echo -e "  \e[$below Client Name          : $username"
echo -e " \e[$line╘════════════════════════════════════════════════════════════╛\e[m"
echo -e "\e[$below "
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
    check-sc
    ;;
6)
    change-port
    ;;
7)
    reboot
    ;;
8)
    themes
    ;;
9)
    cat log-install.txt
    ;;
10)
    delete && xp
    ;;
11)
    clear-log
    ;;
x)
    clear
    exit
    echo -e "\e[1;31mPlease Type menu For More Option, Thank You\e[0m"
    ;;
*)
    clear
    echo -e "\e[1;31mPlease enter an correct number\e[0m"
    sleep 1
    menu
    ;;
esac