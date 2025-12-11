#!/bin/bash
# =========================================
# Limit Bandwidth Speed - Improved Version
# Edition : Stable Edition V1.6 (Color, Bash-safe)
# Author  : NevermoreSSH
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

start() {
    clear
    echo -e "${Cyan}============================================${NC}"
    echo -e "${Cyan}           APPLY BANDWIDTH LIMIT${NC}"
    echo -e "${Cyan}============================================${NC}"
    echo ""

    # Input bandwidth limit
        echo "Example:"
    echo "  - 100  = 100 Mbps"
    echo "  - 300  = 300 Mbps"
    echo "  - 1000 = 1 Gbps"
    echo "  - 5000 = 5 Gbps"
    echo ""
    read -p $'\033[97mSet maximum DOWNLOAD rate (Mbps): \033[0m' down_mbps
    read -p $'\033[97mSet maximum UPLOAD rate   (Mbps): \033[0m' up_mbps

    if [[ -z "$down_mbps" || -z "$up_mbps" ]]; then
        echo -e "${Red}Error: values cannot be empty!${NC}"
        exit 1
    fi

    # Convert Mbps → Kbps
    down=$(( down_mbps * 1000 ))
    up=$(( up_mbps * 1000 ))

    echo ""
    echo -e "${Magenta}Preparing to apply new limit...${NC}"
    sleep 1

    # OFF old limit only AFTER new input
    if [[ -f "$STATUS_FILE" ]] && grep -q "start" "$STATUS_FILE"; then
        echo -e "${Yellow}Old bandwidth limit detected. Removing old limit...${NC}"
        wondershaper -c -a "$NIC"
        sleep 1
    fi

    # Apply new limit
    echo -e "${Green}Applying new bandwidth limit...${NC}"
    wondershaper -a "$NIC" -d "$down" -u "$up"

    # Save new limit
    echo "start ${down_mbps} ${up_mbps}" > "$STATUS_FILE"

    echo ""
    echo -e "${Green}Done! New bandwidth limit is now active.${NC}"
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
    sleep 1

    wondershaper -c -a "$NIC"

    echo "" > "$STATUS_FILE"
    echo -e "${Green}Done! Bandwidth limit has been removed.${NC}"

    echo ""
    read -n 1 -s -r -p $'\033[97mPress any key to back on menu\033[0m'
    exec limit-speed
}

# ----------------------------------------------------------------------------- #

# Read current limit values
current_limit="None"
if [[ -f "$STATUS_FILE" ]] && grep -q "start" "$STATUS_FILE"; then
    sts=$Info
    read _ d u < "$STATUS_FILE"
    current_limit="${d} Mbps / ${u} Mbps"
else
    sts=$Error
fi

# ----------------------------------------------------------------------------- #
# Display Menu
clear
echo -e "${Cyan}========================================${NC}"
echo -e "${Cyan}           Bandwidth Limit Menu          ${NC}"
echo -e "${Cyan}========================================${NC}"
echo -e "${White} Network Interface : ${Magenta}$NIC${NC}"
echo -e " Limit Status      : $sts"
echo -e " Current Speed Limit = ${Yellow}${current_limit}${NC}"
echo -e "${Cyan}----------------------------------------${NC}"
echo -e "${White} 1. Start / Change Limit${NC}"
echo -e " 2. Stop Limit"
echo -e " 3. Speedtest"
echo -e ""
echo -e " Press CTRL + C to exit"
echo ""
read -rp $'\033[97mEnter your choice: \033[0m' num

case $num in
    1) start ;;
    3) speedtest ;;
    2) stop ;;
    *)
        echo -e "${Red}Invalid selection!${NC}"
        echo ""
        read -n 1 -s -r -p $'\033[97mPress any key to back on menu\033[0m'
        exec limit-speed
        ;;
esac