#!/bin/bash
# =========================================
# Quick Setup | Script Setup Manager
# Edition : Stable Edition V1.1
# Auther  : NevermoreSSH
# (C) Copyright 2025 - 2026
# =========================================
# Color Validation
Lred='\e[1;91m'
Lgreen='\e[92m'
Lyellow='\e[93m'
green='\e[32m'
RED='\033[0;31m'
NC='\033[0m'
BGBLUE='\e[1;44m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0;37m'

# starting
clear
echo "Updating system packages..."
apt update -y && apt upgrade -y && apt dist-upgrade -y
echo "Installing base packages..."
apt install -y bzip2 gzip coreutils screen wget curl
clear

# Warna
BOLD="\e[1m"
RESET="\e[0m"
yellow="\e[1;33m"
green="\e[1;32m"
cyan="\e[1;36m"
purple="\e[1;35m"

# ================================
#   NEVERMORESSH SIGNATURE LOGO
# ================================
echo -e "${cyan}"
echo "███    ██ ███████ ██    ██ ███████ ██████  ███    ███  ██████  ██████  ███████ "
echo "████   ██ ██      ██    ██ ██      ██   ██ ████  ████ ██    ██ ██   ██ ██      "
echo "██ ██  ██ █████   ██    ██ █████   ██████  ██ ████ ██ ██    ██ ██████  █████   "
echo "██  ██ ██ ██       ██  ██  ██      ██   ██ ██  ██  ██ ██    ██ ██   ██ ██      "
echo "██   ████ ███████   ████   ███████ ██   ██ ██      ██  ██████  ██   ██ ███████ "
echo "                    N  E  V  E  R  M  O  R  E  S  S  H"
echo -e "${RESET}"

# Frame
echo -e "${yellow}────────────────────────────────────────────────────────────${RESET}"
echo -e "${green}                ⚡ PREMIUM VPS AUTOSCRIPT ⚡${RESET}"
echo -e "${yellow}────────────────────────────────────────────────────────────${RESET}"
echo -e "${cyan} Telegram: ${RESET}@todfix667"
echo -e "${cyan} Developer: ${RESET}NevermoreSSH"
#echo -e "${cyan} ScriptName: ${RESET}SynXNet
echo -e "${yellow}────────────────────────────────────────────────────────────${RESET}"

# Notification before setup
echo -e "${green}You are authorized to install this VPN autoscript.${RESET}"
echo -e "${green}Setup will start in 5 seconds... Get ready!${RESET}"
sleep 5

# Countdown 5 seconds
for i in {5..1}; do
    echo -ne "${yellow}Starting in $i...\r${RESET}"
    sleep 1
done
echo ""

# Loading Bar 5 seconds
echo -ne "${cyan}Loading..."
# 50 blok, setiap 0.1 saat → total ~5s
for i in {1..50}; do
    echo -ne "▓"
    sleep 0.1
done
echo ""
echo -e "${yellow}────────────────────────────────────────────────────────────${RESET}"
sleep 1
clear


# ===================
# check root
clear
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'

# public ip
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
clear
#
# Insert Password
Password=SynXNet
# Execute
echo -e "${green}=========================================${reset}"
echo -e "${yellow}       LICENSE KEY VERIFICATION${reset}"
echo -e "${green}=========================================${reset}"
echo -e "${cyan}Developed by NevermoreSSH | Telegram: @todfix667${reset}"
echo ""
read -p "$(echo -e ${yellow}Please insert your License Key:  ${reset})" Passwordnya
#if [ $Password = $Passwordnya ]; then
clear
echo -e ""
# Permission Check Example
if [ "$Passwordnya" == "$Password" ]; then
    clear
    echo ""
    echo -e "${green}✅ Permission Accepted!${reset}"
    echo ""
    echo -e "${cyan}Thanks for using this Autoscript-VPN by NevermoreSSH${reset}"
    echo ""
    sleep 3
else
    clear
    echo ""
    echo -e "${red}❌ Permission Denied!${reset}"
    echo -e "${red}Please insert the correct License Key!${reset}"
    echo ""
    echo -e "Contact ${green}Admin${reset}"
    echo -e "Telegram: ${cyan}t.me/todfix667${reset}"
    echo ""
    sleep 3
#rm -f setup.sh
rm -rf /root/*
exit 0
fi

#Email domain
echo -e "\e[1;32m════════════════════════════════════════════════════════════\e[0m"
echo -e ""
echo -e "   \e[1;32mPlease enter your email Domain/Cloudflare."
echo -e "   \e[1;31m(Press ENTER for default email)\e[0m"
read -p "   Email : " email
default=${default_email}
new_email=$email
if [[ $email == "" ]]; then
sts=$default_email
else
sts=$new_email
fi
# email
mkdir -p /usr/local/etc/xray/
touch /usr/local/etc/xray/email
echo $sts > /usr/local/etc/xray/email
echo ""
echo -e "\e[1;32m════════════════════════════════════════════════════════════\e[0m"
echo ""
echo -e "   .----------------------------------."
echo -e "   |\e[1;32mPlease select a domain type below \e[0m|"
echo -e "   '----------------------------------'"
echo -e "     \e[1;32m1)\e[0m Enter your Subdomain"
echo -e "     \e[1;32m2)\e[0m Use a random Subdomain"
echo -e "   ------------------------------------"
read -t 30 -p "   Please select numbers 1-2 or Any Button(Random) (30s timeout): " host

# Jika user tidak tekan apa² → host akan kosong "" → dianggap random
if [[ -z "$host" ]]; then
    host="timeout"
fi

echo ""

if [[ $host == "1" ]]; then
    echo -e "   \e[1;32mPlease enter your subdomain "
    read -p "   Subdomain: " host1
    echo "IP=" >> /var/lib/premium-script/ipvps.conf
    echo $host1 > /root/domain
    echo ""

elif [[ $host == "2" ]]; then
    # install cf
    wget https://raw.githubusercontent.com/JebonRX/test/main/install/cf.sh && chmod +x cf.sh && ./cf.sh
    rm -f /root/cf.sh
    clear

else
    echo -e "Random Subdomain/Domain is used"
    wget https://raw.githubusercontent.com/JebonRX/test/main/install/cf.sh && chmod +x cf.sh && ./cf.sh
    rm -f /root/cf.sh
    clear
fi

echo ""
clear


# ───────────────────────────────────────────────
# Choose IPv4 / IPv6
# ───────────────────────────────────────────────
clear
echo -e "\n\033[1;32m───────────────────────────────────────────────\033[0m"
echo -e "   🌐  \033[1;37mSelect Network Mode\033[0m"
echo -e "   \033[1;33m1) IPv4 Only (Disable IPv6)\033[0m"
echo -e "   \033[1;36m2) IPv4 + IPv6 (Enable IPv6)\033[0m"
echo -e "\033[1;32m───────────────────────────────────────────────\033[0m"

read -t 10 -p "   Choose (1/2) [Auto: 1]: " ipmode

disable_ipv6() {
    sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null
    sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null
}

if [[ "$ipmode" == "2" ]]; then
    echo -e "\n\033[1;32mIPv6 Enabled (IPv4 + IPv6)\033[0m"
else
    echo -e "\n\033[1;31mIPv6 Disabled (IPv4 Only)\033[0m"
    disable_ipv6
fi

sleep 1

# =============================
# INSTALL SSH SERVER SECTION
# =============================
#printf '\n\033[1;32m╭────────────────────────────────────────────╮\033[0m\n'
printf '   🚀  \033[1;37mReady for installation script...\033[0m\n'
#printf '\033[1;32m╰────────────────────────────────────────────╯\033[0m\n\n'
sleep 2

clear
printf '\n\033[1;32m╭────────────────────────────────────────────╮\033[0m\n'
printf '   ⚙️  \033[1;37mInstalling SSH Server...\033[0m\n'
printf '\033[1;32m╰────────────────────────────────────────────╯\033[0m\n\n'
# install ssh
wget https://raw.githubusercontent.com/JebonRX/test/main/install/ssh-vpn.sh && chmod +x ssh-vpn.sh && screen -S ssh-vpn ./ssh-vpn.sh
# install websocket
wget https://raw.githubusercontent.com/JebonRX/test/main/ssh/websocket.sh && chmod +x websocket.sh && screen -S websocket ./websocket.sh
printf '\n\033[1;32m╭────────────────────────────────────────────╮\033[0m\n'
printf '   ✅  \033[1;37mDone installing SSH Server\033[0m\n'
printf '\033[1;32m╰────────────────────────────────────────────╯\033[0m\n\n'
clear

# =============================
# INSTALL XRAY SERVER SECTION
# =============================
clear
printf '\n\033[1;32m╭────────────────────────────────────────────╮\033[0m\n'
printf '   ⚙️  \033[1;37mInstalling Xray Server...\033[0m\n'
printf '\033[1;32m╰────────────────────────────────────────────╯\033[0m\n\n'
sleep 1
wget https://raw.githubusercontent.com/JebonRX/test/main/install/xray-vpn.sh && chmod +x xray-vpn.sh && screen -S xray-vpn ./xray-vpn.sh
sleep 1
printf '\n\033[1;32m╭────────────────────────────────────────────╮\033[0m\n'
printf '   ✅  \033[1;37mDone installing Xray Server\033[0m\n'
printf '\033[1;32m╰────────────────────────────────────────────╯\033[0m\n\n'
sleep 1
clear

# =============================
# INSTALL SET-BR SERVER SECTION
# =============================
clear
printf '\n\033[1;32m╭────────────────────────────────────────────╮\033[0m\n'
printf '   ⚙️  \033[1;37mInstalling Backup~Restore Server...\033[0m\n'
printf '\033[1;32m╰────────────────────────────────────────────╯\033[0m\n\n'
echo -e "\e[0;32mINSTALLING SET-BR...\e[0m"
sleep 1
wget https://raw.githubusercontent.com/JebonRX/test/main/install/set-br.sh && chmod +x set-br.sh && ./set-br.sh
printf '\n\033[1;32m╭────────────────────────────────────────────╮\033[0m\n'
printf '   ✅  \033[1;37mDone Installing Backup~Restore Server\033[0m\n'
printf '\033[1;32m╰────────────────────────────────────────────╯\033[0m\n\n'
sleep 1
clear

# =============================
# INSTALL TWEAK SERVER SECTION
# =============================
clear
printf '\n\033[1;32m╭────────────────────────────────────────────╮\033[0m\n'
printf '   ⚙️  \033[1;37mInstalling Tweak Server...\033[0m\n'
printf '\033[1;32m╰────────────────────────────────────────────╯\033[0m\n\n'
echo -e "\e[0;32mINSTALLING TWEAK...\e[0m"
sleep 1
wget https://raw.githubusercontent.com/JebonRX/test/main/install/tweak-vpn.sh && chmod +x tweak-vpn.sh && ./tweak-vpn.sh
printf '\n\033[1;32m╭────────────────────────────────────────────╮\033[0m\n'
printf '   ✅  \033[1;37mDone Installing Tweak Server\033[0m\n'
printf '\033[1;32m╰────────────────────────────────────────────╯\033[0m\n\n'
sleep 1
clear

# =============================
# INSTALL MENU SERVER SECTION
# =============================
clear
printf '\n\033[1;32m╭────────────────────────────────────────────╮\033[0m\n'
printf '   ⚙️  \033[1;37mInstalling Backup~Restore Server...\033[0m\n'
printf '\033[1;32m╰────────────────────────────────────────────╯\033[0m\n\n'
echo -e "\e[0;32mINSTALLING SET-BR...\e[0m"
sleep 1
wget https://raw.githubusercontent.com/JebonRX/test/main/install/menu-vpn.sh && chmod +x menu-vpn.sh && ./menu-vpn.sh
printf '\n\033[1;32m╭────────────────────────────────────────────╮\033[0m\n'
printf '   ✅  \033[1;37mDone Installing Backup~Restore Server\033[0m\n'
printf '\033[1;32m╰────────────────────────────────────────────╯\033[0m\n\n'
sleep 1
clear


# set time GMT +8
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

# install clouflare JQ
apt install jq curl -y

# install webserver
apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/JebonRX/test/main/others/nginx.conf"
mkdir -p /home/vps/public_html
#wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/JebonRX/test/main/others/vps.conf"
sudo cat <<EOF > /etc/nginx/conf.d/vps.conf
server {
    listen       81;
	listen       5000;
    server_name  127.0.0.1 localhost;

    access_log /var/log/nginx/vps-access.log;
    error_log  /var/log/nginx/vps-error.log error;

    # Root asal
    root /home/vps/public_html;

    location / {
        index  index.html index.htm index.php;
        try_files $uri $uri/ /index.php?$args;
    }

    # Folder Xray config
    location /xray/ {
        alias /etc/logcon/config/;
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }

    location ~ \.php$ {
        include /etc/nginx/fastcgi_params;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
EOF
/etc/init.d/nginx restart

# Version
ver=$( curl https://raw.githubusercontent.com/JebonRX/test/main/version.conf )
history -c
echo "$ver" > /home/ver
clear
echo " "
echo "Installation has been completed!!"
echo ""
echo -e "\e[38;5;46m══════════════════════════════════════════════════════════════\e[0m" | tee -a log-install.txt
echo -e "\e[1;97m                🚀 AUTOSCRIPT PREMIUM • 2025–2026 🚀\e[0m" | tee -a log-install.txt
echo -e "\e[38;5;46m══════════════════════════════════════════════════════════════\e[0m" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "   ▶ SERVICES & PORTS" | tee -a log-install.txt
echo -e "   \e[38;5;245m───────────────────────────────────────────────\e[0m" | tee -a log-install.txt
echo -e "\e[38;5;208m   [ SSH & WEBSOCKET ]\e[0m" | tee -a log-install.txt
echo "   - OpenSSH                    : 22" | tee -a log-install.txt
echo "   - Dropbear                   : 143, 109" | tee -a log-install.txt
echo "   - Stunnel4                   : 222, 777" | tee -a log-install.txt
echo "   - Websocket HTTP             : 80" | tee -a log-install.txt
echo "   - Websocket HTTPS            : 443" | tee -a log-install.txt
echo "   - BadVPN                     : 7100, 7200, 7300" | tee -a log-install.txt
echo "   - Nginx                      : 81, 5000" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo -e "\e[38;5;208m   [ XRAY SERVICES ]\e[0m" | tee -a log-install.txt
echo -e "   \e[38;5;245m───────────────────────────────────────────────\e[0m" | tee -a log-install.txt
echo "   - VMESS WebSocket + TLS      : 443" | tee -a log-install.txt
echo "   - VLESS WebSocket + TLS      : 443" | tee -a log-install.txt
echo "   - VLESS HTTPUpgrade + TLS    : 443" | tee -a log-install.txt
echo "   - VMESS WebSocket + NTLS     : 80" | tee -a log-install.txt
echo "   - VLESS WebSocket + NTLS     : 80" | tee -a log-install.txt
echo "   - VLESS HTTPUpgrade + NTLS   : 80" | tee -a log-install.txt
echo -e "\e[38;5;208m   [ CUSTOM-PATH ]\e[0m" | tee -a log-install.txt
echo -e "   \e[38;5;245m───────────────────────────────────────────────\e[0m" | tee -a log-install.txt
echo "   VMESS WS + NTLS(Multipath) : 8880" | tee -a log-install.txt
echo "   VLESS WS + NTLS(Multipath) : 8080" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo -e "\e[38;5;46m──────────────────────────────────────────────────────────────\e[0m" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "   ▶ SERVER INFORMATION & FEATURES" | tee -a log-install.txt
echo -e "   \e[38;5;245m───────────────────────────────────────────────\e[0m" | tee -a log-install.txt
echo "   - Timezone                 : Asia/Kuala_Lumpur (GMT +8)" | tee -a log-install.txt
echo "   - Fail2Ban                 : [ENABLED]" | tee -a log-install.txt
echo "   - Dflate                   : [ENABLED]" | tee -a log-install.txt
echo "   - IPTables                 : [ENABLED]" | tee -a log-install.txt
echo "   - Auto-Reboot              : [ENABLED]" | tee -a log-install.txt
echo "   - Daily Reboot Time        : 05:00 (GMT +8)" | tee -a log-install.txt
echo "   - Auto Backup Data         : Yes" | tee -a log-install.txt
echo "   - Restore Data             : Yes" | tee -a log-install.txt
echo "   - Auto Delete Expired      : Yes" | tee -a log-install.txt
echo "   - Full Orders Support      : Yes" | tee -a log-install.txt
#echo "   - White Label Ready        : Yes" | tee -a log-install.txt
#echo "   - Log File                 : /root/log-install.txt" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo -e "\e[38;5;46m══════════════════════════════════════════════════════════════\e[0m" | tee -a log-install.txt
echo -e "\e[1;97m           ⭐ AUTOSCRIPT VPN BY NEVERMORESSH ⭐\e[0m" | tee -a log-install.txt
echo -e "\e[38;5;46m══════════════════════════════════════════════════════════════\e[0m" | tee -a log-install.txt
sleep 5
clear
echo ""
echo -e "${cyan}"
echo "███    ██ ███████ ██    ██ ███████ ██████  ███    ███  ██████  ██████  ███████ "
echo "████   ██ ██      ██    ██ ██      ██   ██ ████  ████ ██    ██ ██   ██ ██      "
echo "██ ██  ██ █████   ██    ██ █████   ██████  ██ ████ ██ ██    ██ ██████  █████   "
echo "██  ██ ██ ██       ██  ██  ██      ██   ██ ██  ██  ██ ██    ██ ██   ██ ██      "
echo "██   ████ ███████   ████   ███████ ██   ██ ██      ██  ██████  ██   ██ ███████ "
echo "                    N  E  V  E  R  M  O  R  E  S  S  H"
echo -e "${RESET}"
echo -e "    \e[1;32m.----------------------------------------------.\e[0m"
echo -e "    \e[1;32m|     SUCCESFULLY INSTALLED PREMIUM SCRIPT     |\e[0m"
echo -e "    \e[1;32m|           PREMIUM BY NevermoreSSH            |\e[0m"
echo -e "    \e[1;32m'----------------------------------------------'\e[0m"
echo ""
echo -e "   \e[1;32m Server Will Reboot In 5 seconds\e[0m"

#finish
rm -r setup.sh
sleep 5
reboot
