#!/bin/bash

# ===========================
#     VPS TWEAK MENU
# ===========================

# --- Warna ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ===========================
#   CHECK STATUS IPV6
# ===========================
ipv6_status_simple() {
    if sysctl net.ipv6.conf.all.disable_ipv6 2>/dev/null | grep -q "1"; then
        echo -e "${RED}Disabled${NC}"
    else
        echo -e "${GREEN}Enabled${NC}"
    fi
}

# ===========================
#  ENABLE / DISABLE IPV6
# ===========================
disable_ipv6() {
    echo "Disabling IPv6..."
    sed -i '/net.ipv6.conf.all.disable_ipv6/d' /etc/sysctl.conf
    sed -i '/net.ipv6.conf.default.disable_ipv6/d' /etc/sysctl.conf

    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
    echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf

    sysctl -p >/dev/null 2>&1
    echo -e "${GREEN}IPv6 telah di-disable!${NC}"
    sleep 1
}

enable_ipv6() {
    echo "Enabling IPv6..."
    sed -i '/net.ipv6.conf.all.disable_ipv6/d' /etc/sysctl.conf
    sed -i '/net.ipv6.conf.default.disable_ipv6/d' /etc/sysctl.conf

    sysctl -p >/dev/null 2>&1
    echo -e "${GREEN}IPv6 telah di-enable!${NC}"
    sleep 1
}

# ===========================
#        MENU IPV6
# ===========================
ipv6_menu() {
    while true; do
        clear
        echo "=============================="
        echo "           IPv6 MENU"
        echo "=============================="
        echo "1) Disable IPv6"
        echo "2) Enable IPv6"
        echo "0) Kembali"
        echo "------------------------------"
        read -p "Pilih: " ip

        case $ip in
            1) disable_ipv6 ;;
            2) enable_ipv6 ;;
            0) break ;;
            *) echo -e "${RED}Pilihan tidak sah!${NC}"; sleep 1 ;;
        esac
    done
}

# ===========================
#       SWAP FUNCTIONS
# ===========================

check_swap() {
    swapon --show | grep -q "file" || swapon --show | grep -q "partition"
}

create_swap_custom() {
    read -p "Masukkan saiz swap (contoh: 1G, 2G, 4096M): " CUSTOMSWAP
    if [[ -z "$CUSTOMSWAP" ]]; then
        echo -e "${RED}Nilai kosong!${NC}"
        return
    fi
    fallocate -l $CUSTOMSWAP /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile

    if ! grep -q "/swapfile" /etc/fstab; then
        echo "/swapfile none swap sw 0 0" >> /etc/fstab
    fi

    echo -e "${GREEN}Swap $CUSTOMSWAP berjaya dibuat!${NC}"
}

create_swap() {
    SIZE=$1
    echo -e "${YELLOW}Sedang membuat swap ${SIZE}...${NC}"

    fallocate -l $SIZE /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile

    if ! grep -q "/swapfile" /etc/fstab; then
        echo "/swapfile none swap sw 0 0" >> /etc/fstab
    fi

    echo -e "${GREEN}Swap ${SIZE} berjaya dibuat!${NC}"
}

remove_swap() {
    if check_swap; then
        swapoff -a
        rm -f /swapfile
        sed -i '/swapfile/d' /etc/fstab
        echo -e "${GREEN}Swap berjaya dibuang!${NC}"
    else
        echo -e "${RED}Tiada swap untuk dibuang.${NC}"
    fi
}

swap_menu() {
    while true; do
        clear
        echo "============================"
        echo "          SWAP MENU"
        echo "============================"
        echo "1) Create Swap 1GB"
        echo "2) Create Swap 2GB"
        echo "3) Create Swap 4GB"
        echo "4) Create Custom Swap"
        echo "5) Remove Swap"
        echo "0) Kembali"
        echo "----------------------------"
        read -p "Pilih: " sw

        case $sw in
            1) create_swap "1G" ;;
            2) create_swap "2G" ;;
            3) create_swap "4G" ;;
            4) create_swap_custom ;;
            5) remove_swap ;;
            0) break ;;
            *) echo -e "${RED}Pilihan tidak sah!${NC}"; sleep 1 ;;
        esac
    done
}

# ===========================
#       MENU UTAMA
# ===========================
main_menu() {
while true; do
clear

echo "==============================="
echo "         VPS TWEAK MENU"
echo "==============================="
echo -n "IPv6 Status: "; ipv6_status_simple
echo "-------------------------------"
echo "1) System Optimization"
echo "2) Network Optimization"
echo "3) Security Hardening"
echo "4) Monitoring Tools"
echo "5) Tools Tambahan"
echo "6) Swap RAM"
echo "7) IPv6 Settings"
echo "0) Exit"
echo "-------------------------------"
read -p "Pilih menu: " menu

case $menu in
    1) echo "System Optimization (placeholder)"; sleep 1 ;;
    2) echo "Network Optimization (placeholder)"; sleep 1 ;;
    3) echo "Security Hardening (placeholder)"; sleep 1 ;;
    4) echo "Monitoring Tools (placeholder)"; sleep 1 ;;
    5) echo "Tools Tambahan (placeholder)"; sleep 1 ;;
    6) swap_menu ;;
    7) ipv6_menu ;;
    0) exit ;;
    *) echo -e "${RED}Pilihan tidak sah!${NC}"; sleep 1 ;;
esac

done
}

# Start Program
main_menu
