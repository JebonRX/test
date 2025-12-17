#!/bin/bash
# =========================================
# Limit Bandwidth Speed - Persistent Version
# Edition : v1.8
# Author  : NevermoreSSH (Improved by ChatGPT)
# =========================================

# Colors
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
Cyan="\033[36m"
Magenta="\033[35m"
White="\033[97m"
NC="\033[0m"

Info="${Green}[ON]${NC}"
Error="${Red}[OFF]${NC}"

STATUS_FILE="/home/limit"

# Auto-detect main network interface (excluding lo)
NIC=$(ip -o link show | awk -F': ' '$2!="lo"{print $2; exit}')

# ----------------------------------------------------------------------------- #

save_limit() {
    # Simpan NIC, download, upload ke file untuk systemd
    echo "$NIC $1 $2" > "$STATUS_FILE"
}

apply_limit() {
    # $1 = download Mbps, $2 = upload Mbps
    down=$(( $1 * 1000 ))
    up=$(( $2 * 1000 ))
    wondershaper -c -a "$NIC" 2>/dev/null
    wondershaper -a "$NIC" -d "$down" -u "$up"
    save_limit "$1" "$2"
}

start() {
    clear
    echo -e "${Cyan}============================================${NC}"
    echo -e "${Cyan}           APPLY SPEED LIMIT${NC}"
    echo -e "${Cyan}============================================${NC}"
    echo ""

    read -p $'\033[97mSet maximum DOWNLOAD rate (Mbps): \033[0m' down_mbps
    read -p $'\033[97mSet maximum UPLOAD rate   (Mbps): \033[0m' up_mbps

    if [[ -z "$down_mbps" || -z "$up_mbps" ]]; then
        echo -e "${Red}Error: values cannot be empty!${NC}"
        exit 1
    fi

    echo ""
    echo -e "${Magenta}Applying new bandwidth limit...${NC}"
    apply_limit "$down_mbps" "$up_mbps"

    echo -e "${Green}Done! Bandwidth limit is now active.${NC}"
    echo -e "${Yellow}DOWNLOAD Limit: ${down_mbps} Mbps${NC}"
    echo -e "${Yellow}UPLOAD Limit  : ${up_mbps} Mbps${NC}"

    echo ""
    read -n 1 -s -r -p $'\033[97mPress any key to back on menu\033[0m'
    exec limit-speed
}

# ----------------------------------------------------------------------------- #

stop() {
    clear
    echo -e "${Red}Removing bandwidth limit...${NC}"
    wondershaper -c -a "$NIC" 2>/dev/null

    # Hapus status file sepenuhnya
    rm -f "$STATUS_FILE"

    echo -e "${Green}Bandwidth limit removed.${NC}"
    echo ""
    read -n 1 -s -r -p $'\033[97mPress any key to back on menu\033[0m'
    exec limit-speed
}

# ----------------------------------------------------------------------------- #

# Read current limit
current_limit="None"
if [[ -f "$STATUS_FILE" ]] && [[ -s "$STATUS_FILE" ]]; then
    sts=$Info
    read nic d u < "$STATUS_FILE"
    current_limit="${d} Mbps / ${u} Mbps"
else
    sts=$Error
fi

# ----------------------------------------------------------------------------- #
# Display menu
clear
echo -e "${Cyan}========================================${NC}"
echo -e "${Cyan}           Speed Limit Menu          ${NC}"
echo -e "${Cyan}========================================${NC}"
echo -e "${White} Network Interface : ${Magenta}$NIC${NC}"
echo -e " Limit Status      : $sts"
echo -e " Current Speed Limit = ${Yellow}${current_limit}${NC}"
echo -e "${Cyan}----------------------------------------${NC}"
echo -e "${White} 1. Start / Change Limit${NC}"
echo -e " 2. Stop Limit"
echo -e " 3. Speedtest"
echo -e ""
echo -e " 0. Back to Menu"
echo -e ""
echo -e " Press CTRL + C to exit"
echo ""
read -rp $'\033[97mEnter your choice: \033[0m' num

case $num in
    1) start ;;
    2) stop ;;
    0) exec menu-tweak ;;
    x) exec menu-tweak ;;
    3)
        if command -v speedtest &>/dev/null; then
            speedtest
        else
            echo -e "${Red}Speedtest CLI not installed!${NC}"
        fi
        read -n 1 -s -r -p $'\033[97mPress any key to back on menu\033[0m'
        exec limit-speed
        ;;
    *)
        echo -e "${Red}Invalid selection!${NC}"
        read -n 1 -s -r -p $'\033[97mPress any key to back on menu\033[0m'
        exec limit-speed
        ;;
esac