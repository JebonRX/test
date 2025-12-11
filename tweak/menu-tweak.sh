#!/bin/bash
clear
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
clear
# Warna dan reset
line="36"   # cyan
below="33"  # yellow
reset="0"

# Judul Menu
title="\033[1;37m"

echo ""
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo -e "  ${title}[ TWEAK MENU SYSTEM OPTIMIZATION ]${reset}"
echo -e "\e[${line}m═══════════════════════════════════════════════${reset}"
echo -e "\033[1;37mSystem Tweaks by NevermoreSSH\033[0m"
echo -e "\033[1;37mTelegram : https://t.me/todfix667 \033[0m"
echo ""
echo ""

# Pilihan Menu (Button text diubah, detail tetap sama)
echo -e " [\033[1;36m•1\033[0m]  \e[${below}mIPv4v6 Toggle${reset}"              # asal: IPv4 / IPv6 Toggle
echo -e " [\033[1;36m•2\033[0m]  \e[${below}mSwap RAM Manager${reset}"             # asal: Swap RAM Manager
echo -e " [\033[1;36m•3\033[0m]  \e[${below}mBBR Manager${reset}"  # tetap sama
echo -e " [\033[1;36m•4\033[0m]  \e[${below}mXray Core Changer${reset}"         # asal: Xray Core Changer
echo -e " [\033[1;36m•5\033[0m]  \e[${below}mCheck System Info${reset}"   # tetap sama
echo ""
echo -e " [\033[1;36m•0\033[0m]  \e[${below}mBack To Main Menu${reset}"
echo ""
echo -e " \033[1;37mPress [ Ctrl+C ] • To Exit Script\033[0m"
echo ""
echo -e "\e[${below}m"

# Input dari user
read -p " Select menu : " opt
echo -e ""

# Case statement untuk menu (detail tetap sama)
case $opt in
1)
    clear
    exec ip6menu        # tetap sama
    ;;
2)
    clear
    exec swapram        # tetap sama
    ;;
3)
    clear
    exec bbr-manager    # tetap sama
    ;;
4)
    clear
    exec xraychanger    # tetap sama
    ;;
5)
    clear
    exec system-info    # tetap sama
    ;;
0|x)
    clear
    exec menu           # Kembali ke main menu
    ;;
*)
    echo "Wrong Button"
    sleep 1
    exec tweak-menu     # Reload tweak menu
    ;;
esac
