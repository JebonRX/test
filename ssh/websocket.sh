#!/bin/bash
# =========================================
# Addons SSH Websocket
# Date: 2025-11-29
# Author : NevermoreSSH
# =========================================

clear
echo Installing Websocket-SSH Python
sleep 1
echo Wait a bit...
sleep 1
cd

# ================================
# SYSTEMD WEBSOCKET HTTPS (443)
# ================================
cat <<EOF> /etc/systemd/system/ws-https.service
[Unit]
Description=Python Proxy
Documentation=https://github.com/NevermoreSSH/
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
Restart=on-failure
ExecStart=/usr/bin/python3 -O /usr/local/bin/ws-https

[Install]
WantedBy=multi-user.target
EOF

# ================================
# SYSTEMD WEBSOCKET HTTP (80)
# ================================
cat <<EOF> /etc/systemd/system/ws-http.service
[Unit]
Description=Python Proxy
Documentation=https://github.com/NevermoreSSH/
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
Restart=on-failure
ExecStart=/usr/bin/python3 -O /usr/local/bin/ws-http

[Install]
WantedBy=multi-user.target
EOF

# ================================
# DOWNLOAD PYTHON FILES
# ================================
wget -q -O /usr/local/bin/ws-https https://raw.githubusercontent.com/JebonRX/sapphire/main/ssh/ws-https
chmod +x /usr/local/bin/ws-https

wget -q -O /usr/local/bin/ws-http https://raw.githubusercontent.com/JebonRX/sapphire/main/ssh/ws-http
chmod +x /usr/local/bin/ws-http


# ================================
# ENABLE & RESTART SERVICES
# ================================
systemctl daemon-reload
systemctl enable ws-https
systemctl restart ws-https
systemctl enable ws-http
systemctl restart ws-http

# delete any setup

