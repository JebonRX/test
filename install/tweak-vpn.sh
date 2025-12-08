#!/bin/bash
# =========================================
# VPS VPN & Xray Optimization Script
# Author: NevermoreSSH Style
# Date: 2025-11-29
# =========================================

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "Run this script as root!" 
   exit 1
fi

echo "=============================="
echo "Starting VPS VPN & Xray Tweak"
echo "=============================="

# -------------------------------
# 1️⃣ System Optimization
# -------------------------------
echo "[*] Setting up swap RAM 1GB by default..."
dd if=/dev/zero of=/swapfile bs=1024 count=1048576
mkswap /swapfile
chmod 600 /swapfile
swapon /swapfile
sed -i '/\/swapfile/d' /etc/fstab
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
sleep 1

# -------------------------------
# 4️⃣ Xray Optimizations
# -------------------------------
#echo "[*] Tweaking Xray configuration..."
#XRAY_CONF="/usr/local/etc/xray/config.json"
#if [ -f "$XRAY_CONF" ]; then
#    jq '.log.loglevel="warning" | .inbounds[].streamSettings.wsSettings.path="/vless"' $XRAY_CONF > $XRAY_CONF.tmp
#    mv $XRAY_CONF.tmp $XRAY_CONF
#    systemctl restart xray
#fi

# -------------------------------
# 5️⃣ Cron / Auto Maintenance
# -------------------------------
#
# -------------------------------
# 6️⃣ Done
# -------------------------------
echo "==================================="
echo "✅ VPS VPN & Xray tweak completed!"
echo "==================================="
rm -r tweak-vpn.sh
sleep 1
