#!/bin/bash
# =========================================
# Delete any expired config
# Date: 2025-11-29
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
rm -r /etc/xray/config/vless-$user-$exp.txt
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
rm -r /etc/xray/config/vmess-$user-$exp.txt
systemctl restart xray@vmess-tls
systemctl restart xray@vmess-none
systemctl restart xray@vmess-custom
fi
done

# (3)
#----- Auto Remove Shadowsocks

# (4)
#----- Auto Delete Expired SSH Account
clear
hariini=`date +%d-%m-%Y`
echo "Thank you for removing the EXPIRED USERS"
echo "--------------------------------------"
cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
totalaccounts=`cat /tmp/expirelist.txt | wc -l`

for((i=1; i<=$totalaccounts; i++ ))
do
    tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
    rawuser=`echo $tuserval | cut -f1 -d:`  # <-- username asli
    userexp=`echo $tuserval | cut -f2 -d:`
    userexpireinseconds=$(( userexp * 86400 ))
    tglexp=`date -d @$userexpireinseconds`
    tgl=`echo $tglexp | awk '{print $3}'`

    while [ ${#tgl} -lt 2 ]; do
        tgl="0"$tgl
    done

    # username dengan padding hanya untuk tampilan
    username=$rawuser
    while [ ${#username} -lt 15 ]; do
        username="$username "
    done

    bulantahun=`echo $tglexp | awk '{print $2,$6}'`

    echo "echo \"Expired- User : $username Expire at : $tgl $bulantahun\"" >> /usr/local/bin/alluser

    todaystime=`date +%s`

    if [ $userexpireinseconds -ge $todaystime ]; then
        :
    else
        echo "echo \"Expired- Username : $username are expired at: $tgl $bulantahun and removed : $hariini\"" >> /usr/local/bin/deleteduser
        echo "Username $rawuser expired at $tgl $bulantahun removed $hariini"

        # DELETE USER
        userdel $rawuser 2>/dev/null

        # DELETE FILE CONFIG
        filepath="/etc/xray/config/ssh-$rawuser.txt"
        if [ -f "$filepath" ]; then
            rm -f "$filepath"
            echo "File expired $rawuser deleted."
        else
            echo "File expired $rawuser not found."
        fi
    fi
done

echo " "
echo "--------------------------------------"
echo "Script successfully run"



# (5)
# backup config for restore later
sleep 5;backup

# (5)
# complete delete all exp config
echo -e " Success Delete Exp User Accounts"
echo 
echo -e " Back To Menu In 2 Sec"
sleep 2
exec menu