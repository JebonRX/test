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

echo "[*] Applying TCP / network tweaks..."
cat >> /etc/sysctl.conf << EOF
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
net.ipv4.tcp_fastopen=3
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_fin_timeout=15
net.ipv4.tcp_keepalive_time=1200
net.ipv4.ip_local_port_range=1024 65535
EOF
sysctl -p

# -------------------------------
# 2️⃣ SSH Optimizations
# -------------------------------
echo "[*] Tweaking SSH..."
SSH_CONF="/etc/ssh/sshd_config"
sed -i '/Port 22/a Port 500' $SSH_CONF
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' $SSH_CONF
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' $SSH_CONF
echo "ClientAliveInterval 60" >> $SSH_CONF
echo "ClientAliveCountMax 3" >> $SSH_CONF
echo "MaxAuthTries 3" >> $SSH_CONF
systemctl restart sshd

# -------------------------------
# 3️⃣ Firewall (iptables)
# -------------------------------
echo "[*] Configuring iptables..."
iptables -F
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 500 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -m connlimit --connlimit-above 5 --connlimit-mask 32 -j REJECT
iptables -A INPUT -j DROP

# Save iptables
apt install -y iptables-persistent
netfilter-persistent save

# -------------------------------
# 4️⃣ Xray Optimizations
# -------------------------------
echo "[*] Tweaking Xray configuration..."
XRAY_CONF="/usr/local/etc/xray/config.json"
if [ -f "$XRAY_CONF" ]; then
    jq '.log.loglevel="warning" | .inbounds[].streamSettings.wsSettings.path="/vless"' $XRAY_CONF > $XRAY_CONF.tmp
    mv $XRAY_CONF.tmp $XRAY_CONF
    systemctl restart xray
fi

# -------------------------------
# 5️⃣ Cron / Auto Maintenance
# -------------------------------
echo "[*] Setting cron jobs..."
# Restart Xray weekly
(crontab -l 2>/dev/null; echo "0 4 * * 0 systemctl restart xray") | crontab -
# Clear Xray logs daily
(crontab -l 2>/dev/null; echo "0 3 * * * truncate -s 0 /var/log/xray/*.log") | crontab -

# -------------------------------
# 6️⃣ Done
# -------------------------------
echo "==================================="
echo "✅ VPS VPN & Xray tweak completed!"
echo "==================================="
