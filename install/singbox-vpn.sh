#!/bin/bash
# ====================================================
# Install Sing-box + persistent state file (VPS only)
# Author: NevermoreSSH
# Date: 2025-11-29
# =========================================

# 1️⃣ Buat direktori untuk config dan log
mkdir -p /etc/sing-box/
mkdir -p /var/log/sing-box/
touch /var/log/sing-box/access.log
touch /var/log/sing-box/error.log
touch /etc/sing-box/state.json

# 2️⃣ Download latest release dari GitHub
version="$(curl -s https://api.github.com/repos/SagerNet/sing-box/releases/latest | grep tag_name | sed -E 's/.*"v(.*)".*/\1/')"
echo "Installing Sing-box version: $version"

arch="$(uname -m)"
if [[ "$arch" == "x86_64" ]]; then
  arch="amd64"
elif [[ "$arch" == "aarch64" ]]; then
  arch="arm64"
else
  echo "Architecture $arch not supported!"
  exit 1
fi

wget -O /tmp/sing-box.zip "https://github.com/SagerNet/sing-box/releases/download/v$version/sing-box-v$version-linux-$arch.zip"
unzip -o /tmp/sing-box.zip -d /usr/local/bin/
chmod +x /usr/local/bin/sing-box
rm -f /tmp/sing-box.zip

# 3️⃣ Buat default config untuk quota limiter sahaja
cat > /etc/sing-box/config.json <<EOF
{
  "log": {
    "disabled": false,
    "level": "info",
    "access": "/var/log/sing-box/access.log",
    "error": "/var/log/sing-box/error.log"
  },
  "inbounds": [
    {
      "type": "tun",
      "tag": "tun-in",
      "inet4_address": "172.20.0.1/30",
      "inet6_address": "fd00::1/126"
    }
  ],
  "outbounds": [
    {
      "type": "direct",
      "tag": "direct-out"
    }
  ],
  "state": {
    "path": "/etc/sing-box/state.json"
  }
}
EOF

# 4️⃣ Buat systemd service
cat > /etc/systemd/system/sing-box.service <<EOF
[Unit]
Description=Sing-box Service
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/sing-box run -c /etc/sing-box/config.json
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# 5️⃣ Enable & start service
systemctl daemon-reload
systemctl enable sing-box
systemctl start sing-box

echo "✅ Sing-box installed and running!"
echo "State file: /etc/sing-box/state.json"
rm -r singbox-vpn.sh
sleep 1
