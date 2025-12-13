#!/bin/bash
# =========================================
# Delete any expired config v2
# Date: 2025-12-13
# Author : NevermoreSSH
# =========================================
clear

# (1)
#----- Auto Remove Vless
data=( `cat /usr/local/etc/xray/vless-tls.json | grep '^#vls' | cut -d ' ' -f 2 | sort | uniq`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^#vls $user" "/usr/local/etc/xray/vless-tls.json" | cut -d ' ' -f 3 | sort | uniq)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -le "0" ]]; then
sed -i "/^#vls $user $exp/,/^},{/d" /usr/local/etc/xray/vless-tls.json
sed -i "/^#vls $user $exp/,/^},{/d" /usr/local/etc/xray/vless-none.json
sed -i "/^#vls $user $exp/,/^},{/d" /usr/local/etc/xray/vless-custom.json
sed -i "/^#vls $user $exp/,/^},{/d" /usr/local/etc/xray/httpupgrade-tls.json
sed -i "/^#vls $user $exp/,/^},{/d" /usr/local/etc/xray/httpupgrade-none.json
# config from html
rm -r /etc/logcon/config/vless-$user-$exp.txt
systemctl restart xray@vless-tls
systemctl restart xray@vless-none
systemctl restart xray@vless-custom
systemctl restart xray@httpupgrade-tls
systemctl restart xray@httpupgrade-none
fi
done

# (2)
#----- Auto Remove Vmess
data=( `cat /usr/local/etc/xray/vmess-tls.json | grep '^#vms' | cut -d ' ' -f 2 | sort | uniq`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^#vms $user" "/usr/local/etc/xray/vmess-tls.json" | cut -d ' ' -f 3 | sort | uniq)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -le "0" ]]; then
sed -i "/^#vms $user $exp/,/^},{/d" /usr/local/etc/xray/vmess-tls.json
sed -i "/^#vms $user $exp/,/^},{/d" /usr/local/etc/xray/vmess-none.json
sed -i "/^#vms $user $exp/,/^},{/d" /usr/local/etc/xray/vmess-custom.json
rm -f /usr/local/etc/xray/$user-vmesstls.json
rm -f /usr/local/etc/xray/$user-vmessnone.json
rm -f /usr/local/etc/xray/$user-custom.json
# config from html
rm -r /etc/logcon/config/vmess-$user-$exp.txt
systemctl restart xray@vmess-tls
systemctl restart xray@vmess-none
systemctl restart xray@vmess-custom
fi
done

# (3)
#----- Auto Remove Shadowsocks

# (4)
#----- Auto Removes SSH
clear
hariini=`date +%d-%m-%Y`

cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
totalaccounts=`wc -l < /tmp/expirelist.txt`

for((i=1;i<=$totalaccounts;i++))
do
  tuserval=`sed -n "${i}p" /tmp/expirelist.txt`
  rawuser=`echo $tuserval | cut -d: -f1`
  userexp=`echo $tuserval | cut -d: -f2`

  userexpireinseconds=$(( userexp * 86400 ))
  todaystime=`date +%s`

  if [ $userexpireinseconds -lt $todaystime ]; then
    userdel $rawuser 2>/dev/null
    rm -f /etc/logcon/config/ssh-$rawuser.txt
  fi
done

# (5)
# backup config for restore later
sleep 1
# public ip
MYIP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
IP=$(curl -s ipv4.icanhazip.com || curl -s ipinfo.io/ip || curl -s ifconfig.me)
date=$(date +"%Y-%m-%d-%H:%M:%S")
domain=$(cat /usr/local/etc/xray/domain)
clear
# backup ssh xray
echo "Clear Expired User XRAY & SSH Accounts"
mkdir -p /root/backup
cp -r /usr/local/etc/xray/ /root/backup/xray/ >/dev/null 2>&1
cp -r /etc/shadow /root/backup/shadow >/dev/null 2>&1
cp -r /etc/gshadow /root/backup/gshadow >/dev/null 2>&1
cp -r /etc/passwd /root/backup/passwd >/dev/null 2>&1
cp -r /etc/group /root/backup/group >/dev/null 2>&1
# backup others
cp -r /usr/bin/xraay /root/backup/xraay >/dev/null 2>&1
cp -r /etc/logcon/config /root/backup/config >/dev/null 2>&1
# compress for gdrive
cd /root
zip -r $IP-$date-$domain-SkyNode.zip backup > /dev/null 2>&1
rclone copy /root/$IP-$date-$domain-SkyNode.zip dr:backup/
url=$(rclone link dr:backup/$IP-$date-$domain-SkyNode.zip)
id=(`echo $url | grep '^https' | cut -d'=' -f2`)
link="https://drive.google.com/u/4/uc?id=${id}&export=download"
clear
rm -rf /root/backup
rm -f /root/*SkyNode.zip
#rm -r /root/$IP-$date-$domain-SkyNode.zip
sleep 1

# (5)
# complete delete all exp config
echo -e " Success Delete Exp User Accounts"
echo -e "  "
echo -e " type 'menu' for other services"
sleep 2
pkill -f /usr/local/bin/xp-xrayssh