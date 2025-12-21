#!/bin/bash
clear

# ============================
# WARNA
# ============================
RESET="\e[0m"
CYAN="\e[36m"
YELLOW="\e[33m"
WHITE_BOLD="\e[1;37m"
MAGENTA="\e[38;5;205m"

# ============================
# PUBLIC IP & DOMAIN
# ============================
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
domain=$(cat /usr/local/etc/xray/domain)

# ============================
# JUDUL MENU
# ============================
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════${RESET}"
echo -e "  ${WHITE_BOLD}[ TWEAK MENU SYSTEM OPTIMIZATION ]${RESET}"
echo -e "${CYAN}═══════════════════════════════════════════════${RESET}"
echo -e "${WHITE_BOLD}System Tweaks by NevermoreSSH${RESET}"
echo -e "${WHITE_BOLD}Telegram : https://t.me/todfix667${RESET}"
echo ""

# ============================
# MENU OPTIONS
# ============================
echo -e " [${CYAN}•1${RESET}]  IPv4v6 Toggle"
echo -e " [${CYAN}•2${RESET}]  Swap RAM Manager"
echo -e " [${CYAN}•3${RESET}]  BBR Manager"
echo -e " [${CYAN}•4${RESET}]  Xray Core Changer"
echo -e " [${CYAN}•5${RESET}]  Change Dropbear SSH"
echo -e " [${CYAN}•6${RESET}]  Cloudflare WARP+ (WireGuard)"
echo ""
echo -e " [${CYAN}•0${RESET}]  Back To Main Menu"
echo ""
echo -e "${WHITE_BOLD}Press [ Ctrl+C ] • To Exit Script${RESET}"
echo ""

# ============================
# INPUT USER
# ============================
read -p " Select menu : " opt
echo ""

# ============================
# CASE STATEMENT MENU
# ============================
case $opt in
1)
    clear
    exec ip6menu        # IPv4/IPv6 toggle
    ;;
2)
    clear
    exec swapram        # Swap RAM manager
    ;;
3)
    clear
    exec bbr-manager    # BBR manager
    ;;
4)
    clear
    exec xraychanger    # Xray Core changer
    ;;
5)
    clear
    exec change-dropbear    # Check system info
    ;;
6)
    clear
	exec warp
#    wget -q -O /usr/sbin/setup2 "https://raw.githubusercontent.com/NevermoreSSH/cfwarp/main/setup.sh" && chmod +x /usr/sbin/setup2 && setup2
    ;;
0)
    clear
    exec menu           # Back to main menu
    ;;
x)
    clear
    exec menu           # Back to main menu
    ;;
*)
    echo "Wrong Button"
    sleep 1
    exec tweak-menu     # Reload tweak menu
    ;;
esac