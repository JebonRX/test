#!/bin/bash

# ===== COLORS =====
ORANGE='\033[38;5;208m'
WHITE='\033[97m'
PINK='\033[38;5;213m'
GREEN='\033[92m'
RESET='\033[0m'

clear

CURRENT_TZ=$(timedatectl show --property=Timezone --value)
CURRENT_DATE=$(date)
CURRENT_GMT=$(date +"GMT%z")

echo -e "${ORANGE}======================================${RESET}"
echo -e "${WHITE}        GMT TIMEZONE MENU${RESET}"
echo -e "${ORANGE}======================================${RESET}"
echo -e ""
echo -e "${GREEN}Current Timezone :${WHITE} $CURRENT_TZ${RESET}"
echo -e "${GREEN}Current Time     :${WHITE} $CURRENT_DATE${RESET}"
echo -e "${GREEN}Current Offset   :${WHITE} $CURRENT_GMT${RESET}"
echo -e ""
echo -e "${ORANGE}======================================${RESET}"
echo -e ""
echo -e "${PINK} 1${WHITE}) GMT-12  Pacific/Kwajalein${RESET}"
echo -e "${PINK} 2${WHITE}) GMT-11  Pacific/Midway${RESET}"
echo -e "${PINK} 3${WHITE}) GMT-10  Pacific/Honolulu${RESET}"
echo -e "${PINK} 4${WHITE}) GMT-9   America/Anchorage${RESET}"
echo -e "${PINK} 5${WHITE}) GMT-8   America/Los_Angeles${RESET}"
echo -e "${PINK} 6${WHITE}) GMT-7   America/Denver${RESET}"
echo -e "${PINK} 7${WHITE}) GMT-6   America/Chicago${RESET}"
echo -e "${PINK} 8${WHITE}) GMT-5   America/New_York${RESET}"
echo -e "${PINK} 9${WHITE}) GMT-4   America/Halifax${RESET}"
echo -e "${PINK}10${WHITE}) GMT-3   America/Sao_Paulo${RESET}"
echo -e "${PINK}11${WHITE}) GMT-2   America/Noronha${RESET}"
echo -e "${PINK}12${WHITE}) GMT-1   Atlantic/Azores${RESET}"
echo -e "${PINK}13${WHITE}) GMT+0   UTC${RESET}"
echo -e "${PINK}14${WHITE}) GMT+1   Europe/Berlin${RESET}"
echo -e "${PINK}15${WHITE}) GMT+2   Europe/Athens${RESET}"
echo -e "${PINK}16${WHITE}) GMT+3   Europe/Moscow${RESET}"
echo -e "${PINK}17${WHITE}) GMT+4   Asia/Dubai${RESET}"
echo -e "${PINK}18${WHITE}) GMT+5   Asia/Karachi${RESET}"
echo -e "${PINK}19${WHITE}) GMT+6   Asia/Dhaka${RESET}"
echo -e "${PINK}20${WHITE}) GMT+7   Asia/Jakarta${RESET}"
echo -e "${PINK}21${WHITE}) GMT+8   Asia/Kuala_Lumpur${RESET}"
echo -e "${PINK}22${WHITE}) GMT+9   Asia/Tokyo${RESET}"
echo -e "${PINK}23${WHITE}) GMT+10  Australia/Sydney${RESET}"
echo -e "${PINK}24${WHITE}) GMT+11  Pacific/Noumea${RESET}"
echo -e "${PINK}25${WHITE}) GMT+12  Pacific/Auckland${RESET}"
echo -e ""
echo -e "${PINK} 0${WHITE}) Back to Menu${RESET}"

echo -e "${ORANGE}======================================${RESET}"
echo -e ""
read -p "$(echo -e "${WHITE}Select GMT [0-25]: ${RESET}")" gmt

set_tz() {
    timedatectl set-timezone "$1" && \
    echo -e "${GREEN}✅ Timezone set to:${WHITE} $1${RESET}" && \
    echo -e "${GREEN}Current Time:${WHITE} $(date)${RESET}"

    echo
    read -p "$(echo -e "${WHITE}Press ENTER to return to menu...${RESET}")"
    exec gmt "$0"
}


case "$gmt" in
  1)  set_tz "Pacific/Kwajalein" ;;
  2)  set_tz "Pacific/Midway" ;;
  3)  set_tz "Pacific/Honolulu" ;;
  4)  set_tz "America/Anchorage" ;;
  5)  set_tz "America/Los_Angeles" ;;
  6)  set_tz "America/Denver" ;;
  7)  set_tz "America/Chicago" ;;
  8)  set_tz "America/New_York" ;;
  9)  set_tz "America/Halifax" ;;
 10)  set_tz "America/Sao_Paulo" ;;
 11)  set_tz "America/Noronha" ;;
 12)  set_tz "Atlantic/Azores" ;;
 13)  set_tz "UTC" ;;
 14)  set_tz "Europe/Berlin" ;;
 15)  set_tz "Europe/Athens" ;;
 16)  set_tz "Europe/Moscow" ;;
 17)  set_tz "Asia/Dubai" ;;
 18)  set_tz "Asia/Karachi" ;;
 19)  set_tz "Asia/Dhaka" ;;
 20)  set_tz "Asia/Jakarta" ;;
 21)  set_tz "Asia/Kuala_Lumpur" ;;
 22)  set_tz "Asia/Tokyo" ;;
 23)  set_tz "Australia/Sydney" ;;
 24)  set_tz "Pacific/Noumea" ;;
 25)  set_tz "Pacific/Auckland" ;;
  0)  exec system ;;
  x)  exec system ;;
  *)  echo -e "${PINK}❌ Invalid selection${RESET}" ;;
esac
