#!/bin/bash
# =========================================
# Quick Setup | Add / Renew Domain Script
# Author : Custom Version
# Date   : 11/12/2025
# =========================================

# Warna
GREEN='\e[0;32m'
BLUE='\e[0;34m'
RED='\e[1;31m'
NC='\e[0m'

DOMAIN_FILE="/usr/local/etc/xray/domain"
#IPVPS_FILE="/var/lib/premium-script/ipvps.conf"

clear
echo -e "${BLUE}══════════════════════════════════════════════${NC}"
echo -e "           Add / Renew New Domain"
echo -e "${BLUE}══════════════════════════════════════════════${NC}"
echo ""

# Input subdomain
echo -e "   .------------------------------."
echo -e "   |  \e[1;32mEnter your subdomain below\e[0m  |"
echo -e "   '------------------------------'"
read -rp "   Subdomain: " domain

if [[ -z "$domain" ]]; then
    echo -e "${RED}❌ Subdomain cannot be empty! Exiting...${NC}"
    exit 1
fi

# Simpan domain
#echo "IP=$domain" >> "$IPVPS_FILE"
echo "$domain" > "$DOMAIN_FILE"
echo -e "${GREEN}✔ Domain set to: $domain${NC}"
sleep 1

clear
echo -e "${BLUE}══════════════════════════════════════════════${NC}"
echo -e "1️⃣  Stopping Xray and Nginx services..."
systemctl stop xray
systemctl stop xray@none
systemctl stop nginx
sleep 1

echo -e "2️⃣  Preparing acme.sh for SSL issuance..."
mkdir -p /root/.acme.sh
curl -s https://raw.githubusercontent.com/JebonRX/test/main/others/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
sleep 1

echo -e "3️⃣  Issuing / Renewing SSL certificate for ${domain}..."
/root/.acme.sh/acme.sh --issue -d "$domain" -d "sshws.$domain" --standalone -k ec-256 --listen-v6
sleep 1

echo -e "4️⃣  Installing SSL certificate..."
/root/.acme.sh/acme.sh --installcert -d "$domain" -d "sshws.$domain" \
    --fullchainpath /usr/local/etc/xray/xray.crt \
    --keypath /usr/local/etc/xray/xray.key --ecc
chmod 644 /usr/local/etc/xray/xray.key
sleep 1

echo -e "5️⃣  Restarting services..."
systemctl restart nginx
systemctl restart xray
systemctl restart xray@*
sleep 1

clear
echo -e "${GREEN}✅ Add / Renew Domain Completed Successfully!${NC}"
echo -e "   Domain: ${domain}"
echo ""
read -n 1 -s -r -p "Press any key to Restart All Services"
exec restart