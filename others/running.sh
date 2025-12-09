#!/bin/bash
# =========================================
# Quick Menu | Running Services Manager
# Edition : Stable Edition V1.1
# Auther  : NevermoreSSH
# (C) Copyright 2025 - 2026
# =========================================

# public ip
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
clear

# color
red="\e[1;31m"
green="\e[0;32m"
NC="\e[0m"
GitUser="NevermoreSSH"

# // VPS INFO
clear
Checkstart1=$(ip route | grep default | cut -d ' ' -f 3 | head -n 1);
if [[ $Checkstart1 == "venet0" ]]; then 
    clear
    lan_net="venet0"
    typevps="OpenVZ"
    sleep 1
else
    clear
    lan_net="eth0"
    typevps="KVM"
    sleep 1
fi

# // VPS ISP INFORMATION
echo -e "\e[32mloading...\e[0m"
clear
ITAM='\033[0;30m'
echo -e "$ITAM"
NAMAISP=$( curl -s ipinfo.io/org | cut -d " " -f 2-10  )
REGION=$( curl -s ipinfo.io/region )
COUNTRY=$( curl -s ipinfo.io/country )
WAKTU=$( curl -s ipinfo.ip/timezone )
CITY=$( curl -s ipinfo.io/city )
REGION=$( curl -s ipinfo.io/region )
WAKTUE=$( curl -s ipinfo.io/timezone )
koordinat=$( curl -s ipinfo.io/loc )

# // TOTAL RAM
tram=$( free -m | awk 'NR==2 {print $2}' )
uram=$( free -m | awk 'NR==2 {print $3}' )
fram=$( free -m | awk 'NR==2 {print $4}' )
swap=$( free -m | awk 'NR==4 {print $2}' )

# // USERNAME
echo -e "$NC"
rm -f /usr/bin/user
username=$( curl -sS https://raw.githubusercontent.com/${GitUser}/allow/main/ipvps.conf | grep $MYIP | awk '{print $2}' )
echo "$username" > /usr/bin/user

# // TYPE PROCS
totalcore="$(grep -c "^processor" /proc/cpuinfo)" 
totalcore+=" Core"
corediilik="$(grep -c "^processor" /proc/cpuinfo)" 
tipeprosesor="$(awk -F ': | @' '/model name|Processor|^cpu model|chip type|^cpu type/ {
                        printf $2;
                        exit
                        }' /proc/cpuinfo)"

# // SHELL VER
shellversion=""
shellversion=Bash
shellversion+=" Version" 
shellversion+=" ${BASH_VERSION/-*}" 
versibash=$shellversion

# // OS INFO
source /etc/os-release
Versi_OS=$VERSION
ver=$VERSION_ID
Tipe=$NAME
URL_SUPPORT=$HOME_URL
basedong=$ID

# // DOWNLOAD
download=`grep -e "lo:" -e "wlan0:" -e "eth0" /proc/net/dev  | awk '{print $2}' | paste -sd+ - | bc`
downloadsize=$(($download/1073741824))

# // UPLOAD
upload=`grep -e "lo:" -e "wlan0:" -e "eth0" /proc/net/dev | awk '{print $10}' | paste -sd+ - | bc`
uploadsize=$(($upload/1073741824))

# // CPU INFO
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${corediilik:-1}))"
cpu_usage+=" %"

# // OS UPTIME
uptime="$(uptime -p | cut -d " " -f 2-10)"

# // KERNEL
kernelku=$(uname -r)

# // DATE
harini=`date -d "0 days" +"%d-%m-%Y"`
jam=`date -d "0 days" +"%X"`

# // DNS PATH
tipeos2=$(uname -m)

# // DOMAIN
Domen="$(cat /usr/local/etc/xray/domain)"

echo -e "\e[32mloading...\e[0m"
clear
echo -e ""
echo -e "Your VPS Information :"
echo -e "\e[0;32mSCRIPT VPS\e[0m"
echo "-----------------------------------------------------------"
echo "Operating System Information :"
echo -e "VPS Type    : $typevps"
echo -e "OS Arch     : $tipeos2"
echo -e "Hostname    : $HOSTNAME"
echo -e "OS Name     : $Tipe"
echo -e "OS Version  : $Versi_OS"
echo -e "OS URL      : $URL_SUPPORT"
echo -e "OS BASE     : $basedong"
echo -e "OS TYPE     : Linux / Unix"
echo -e "Bash Ver    : $versibash"
echo -e "Kernel Ver  : $kernelku"
echo "-----------------------------------------------------------"
echo "Hardware Information :"
echo -e "Processor   : $tipeprosesor"
echo -e "Proc Core   : $totalcore"
echo -e "Virtual     : $typevps"
echo -e "Cpu Usage   : $cpu_usage"
echo "-----------------------------------------------------------"
echo "System Status / System Information :"
echo -e "Uptime      : $uptime ( From VPS Booting )"
echo -e "Total RAM   : $tram MB"
echo -e "Used RAM    : $uram MB"
echo -e "Avaible RAM : $fram MB"
echo -e "Download    : $downloadsize GB ( From Startup/VPS Booting )"
echo -e "Upload      : $uploadsize GB ( From Startup/VPS Booting )"
echo "-----------------------------------------------------------"
echo "Internet Service Provider Information :"
echo -e "Public IP   : $MYIP"
echo -e "Domain      : $Domen"
echo -e "ISP Name    : $NAMAISP"
echo -e "Region      : $REGION "
echo -e "Country     : $COUNTRY"
echo -e "City        : $CITY "
echo -e "Time Zone   : $WAKTUE"
echo "-----------------------------------------------------------"
echo "Time & Date & Location & Coordinate Information :"
echo -e "Location    : $COUNTRY"
echo -e "Coordinate  : $koordinat"
echo -e "Time Zone   : $WAKTUE"
echo -e "Date        : $harini"
echo -e "Time        : $jam ( WIB )"
echo "-----------------------------------------------------------"
echo -e "\e[1;32mSTATUS SCRIPT :\e[0m"
echo -e "\e[0;34mUser        :\e[0m $username"
echo -e "\e[0;34mOrder ID    :\e[0m $oid"
echo -e "\e[0;34mExpired     :\e[0m $exp"
echo "-----------------------------------------------------------"
echo -e ""
echo -e "              \e[0;32m[\e[1;36mSYSTEM STATUS INFORMATION\e[0;32m]\e[0m"
echo -e "             \e[0;34m=============================\e[0m"
echo -e ""
echo -e "\e[1;33mSTATUS SSH WEBSOCKET:\e[0m"
echo -e "\e[0;34m-----------------------\e[0m"

status="$(systemctl show ssh.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Open SSH                : "$green"running"$NC" ✓"
else
echo -e " Open SSH                : "$red"not running (Error)"$NC" "
fi

status="$(systemctl show stunnel4.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Stunnel(SSL)            : "$green"running"$NC" ✓"
else
echo -e " Stunnel(SSL)            : "$red"not running (Error)"$NC" "
fi

status="$(systemctl show dropbear.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " DropBear                : "$green"running"$NC" ✓"
else
echo -e " DropBear                : "$red"not running (Error)"$NC" "
fi

#status="$(systemctl show server-sldns.service --no-page)"
#status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
#if [ "${status_text}" == "active" ]
#then
#echo -e " DNSTT                   : "$green"running"$NC" ✓"
#else
#echo -e " DNSTT                   : "$red"not running (Error)"$NC" "
#fi

status="$(systemctl show server-sldns.service --no-page)"
#status="$(systemctl show client-sldns.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " SlowDNS                 : "$green"running"$NC" ✓"
else
echo -e " SlowDNS                 : "$red"not running (Error)"$NC" "
fi

status="$(systemctl show udp-custom.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " UDP Custom              : "$green"running"$NC" ✓"
else
echo -e " UDP Custom              : "$red"not running (Error)"$NC" "
fi

status="$(systemctl show ws-http.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Websocket SSH(HTTP)     : "$green"running"$NC" ✓"
else
echo -e " Websocket SSH(HTTP)     : "$red"not running (Error)"$NC" "
fi

status="$(systemctl show ws-https.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Websocket SSL(HTTPS)    : "$green"running"$NC" ✓"
else
echo -e " Websocket SSL(HTTPS)    : "$red"not running (Error)"$NC" "
fi

echo -e ""
echo -e "\e[1;33mSTATUS XRAY:\e[0m"
echo -e "\e[0;34m-------------\e[0m"

status="$(systemctl show xray@none.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Xray Vless Tcp Xtls     : "$green"running"$NC" ✓"
else
echo -e " Xray Vless Tcp Xtls     : "$red"not running (Error)"$NC" "
fi

status="$(systemctl show xray@tcp.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Xray Trojan Tcp tls     : "$green"running"$NC" ✓"
else
echo -e " Xray Trojan Tcp tls     : "$red"not running (Error)"$NC" "
fi

status="$(systemctl show xray@vless.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Xray Vless Ws Tls       : "$green"running"$NC" ✓"
else
echo -e " Xray Vless Ws Tls       : "$red"not running (Error)"$NC" "
fi

status="$(systemctl show xray@vmess.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Xray Vmess Ws Tls       : "$green"running"$NC" ✓"
else
echo -e " Xray Vmess Ws Tls       : "$red"not running (Error)"$NC" "
fi

status="$(systemctl show xray@trojan.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Xray Trojan Ws Tls      : "$green"running"$NC" ✓"
else
echo -e " Xray Trojan Ws Tls      : "$red"not running (Error)"$NC" "
fi

status="$(systemctl show xray@vlessnone.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Xray Vless Ws None      : "$green"running"$NC" ✓"
else
echo -e " Xray Vless Ws None      : "$red"not running (Error)"$NC" "
fi

status="$(systemctl show xray@vlessc.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Xray Vless Ws Custom    : "$green"running"$NC" ✓"
else
echo -e " Xray Vless Ws Custom    : "$red"not running (Error)"$NC" "
fi

status="$(systemctl show xray@vmessnone.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Xray Vmess Ws None      : "$green"running"$NC" ✓"
else
echo -e " Xray Vmess Ws None      : "$red"not running (Error)"$NC" "
fi

echo -e ""
echo -e "\e[1;33mSTATUS NGINX:\e[0m"
echo -e "\e[0;34m--------------------\e[0m"
status="$(systemctl show nginx.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " Nginx                   : "$green"running"$NC" ✓"
else
echo -e " Nginx                   : "$red"not running (Error)"$NC" "
fi

echo -e "\e[0;34m-----------------------------------------------------------\e[0m"
echo -e ""
#echo -e "${green}JIKA TERDAPAT NOT RUNNING, PLEASE REPORT TO ADMIN FOR FIX$NC"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
exec menu
sleep 1