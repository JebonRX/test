#!/bin/bash
# =========================================
# Quick Setup | Script Set-BR Manager
# Edition : Stable Edition V1.1
# Auther  : NevermoreSSH
# (C) Copyright 2025 - 2026
# =========================================
#
curl https://rclone.org/install.sh | bash
printf "q\n" | rclone config
#wget -O /root/.config/rclone/rclone.conf "https://raw.githubusercontent.com/JebonRX/test/main/others/rclone.conf"
git clone  https://github.com/MrMan21/wondershaper.git &> /dev/null
cd wondershaper
make install
cd
rm -rf wondershaper
cd /usr/bin
wget -O backup "https://raw.githubusercontent.com/JebonRX/test/main/others/backup.sh"
wget -O restore "https://raw.githubusercontent.com/JebonRX/test/main/others/restore.sh"
wget -O strt "https://raw.githubusercontent.com/JebonRX/test/main/others/strt.sh"
wget -O limit-speed "https://raw.githubusercontent.com/JebonRX/test/main/others/limit-speed.sh"
wget -O clear-log "https://raw.githubusercontent.com/JebonRX/test/main/others/clear-log"
chmod +x backup
chmod +x restore
chmod +x strt
chmod +x limit-speed
chmod +x clear-log
cd

# custom rclone
cat <<EOF > /root/.config/rclone/rclone.conf
[dr]
type = drive
scope = drive
token = {"access_token":"ya29.a0AfB_byCHyGVKxzRnHvcZSVUP1Bg2ac9saBpYT3obrrs-TQIs8nC9u8rjQHp-ynZ63oKVJ2w4uOzanI5_ZWHTlHBYdcZ_CiejnZ31qHygOCNWv62hGbNQLDUmmQxsPZ79v6iEJZngp414VSqkjf5E9zui46W4lSobe3mhaCgYKAXgSARISFQHGX2MidGiiOMmd4WsPuzS92VD41A0171","token_type":"Bearer","refresh_token":"1//0gpwNGHU76uq9CgYIARAAGBASNwF-L9Ir65Td3TXwFfZf8ECwBv4BIScUByryD1M0tpCuJrelRdoP9q_ZEYFGKWKiTuyqVuQGxeA","expiry":"2023-11-21T11:44:04.070595+08:00"}
EOF


# install speedtest ookla latest
# 1️⃣ Update package list
#apt-get update

# 2️⃣ Pasang curl kalau belum ada
#apt-get install curl -y

# 3️⃣ Tambah repository rasmi Ookla
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash

# 4️⃣ Pasang Speedtest CLI
apt-get install speedtest -y

# 5️⃣ Jalankan ujian speed
#speedtest

#done
rm -r set-br.sh
sleep 1

