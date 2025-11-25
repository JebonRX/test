# test
test for future
debian 11/ubuntu 22 above

setup
```
apt update -y && apt upgrade -y && apt dist-upgrade -y && sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt install -y bzip2 gzip coreutils screen wget curl && wget https://raw.githubusercontent.com/JebonRX/test/main/setup.sh && chmod +x setup.sh && sed -i -e 's/\r$//' setup.sh && screen -S setup ./setup.sh
```
