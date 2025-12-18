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

# NTP status
NTP_ACTIVE=$(timedatectl show -p NTP --value 2>/dev/null)
NTP_SYNC=$(timedatectl show -p NTPSynchronized --value 2>/dev/null)

pretty_bool() {
  case "$1" in
    yes|true|1) echo "ON" ;;
    no|false|0) echo "OFF" ;;
    *) echo "$1" ;;
  esac
}

NTP_ACTIVE_P=$(pretty_bool "$NTP_ACTIVE")
NTP_SYNC_P=$(pretty_bool "$NTP_SYNC")

echo -e "${ORANGE}======================================${RESET}"
echo -e "${WHITE}        GMT TIMEZONE MENU${RESET}"
echo -e "${ORANGE}======================================${RESET}"
echo -e ""
echo -e "${GREEN}Current Timezone :${WHITE} $CURRENT_TZ${RESET}"
echo -e "${GREEN}Current Time     :${WHITE} $CURRENT_DATE${RESET}"
echo -e "${GREEN}Current Offset   :${WHITE} $CURRENT_GMT${RESET}"
echo -e "${GREEN}NTP Status       :${WHITE} $NTP_ACTIVE_P${RESET} ${GREEN}(Sync:${WHITE} $NTP_SYNC_P${GREEN})${RESET}"
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
echo -e "${PINK}88${WHITE}) Custom Date & Time${RESET}"
echo -e "${PINK}99${WHITE}) Toggle NTP ON/OFF${RESET}"
echo -e ""
echo -e "${PINK} 0${WHITE}) Back / Refresh Menu${RESET}"

echo -e "${ORANGE}======================================${RESET}"
echo -e ""
read -p "$(echo -e "${WHITE}Select option: ${RESET}")" gmt

pause_back() {
  echo
  read -p "$(echo -e "${WHITE}Press ENTER to return to menu...${RESET}")"
  exec "$0"
}

set_tz() {
    timedatectl set-timezone "$1" && \
    echo -e "${GREEN}✅ Timezone set to:${WHITE} $1${RESET}" && \
    echo -e "${GREEN}Current Time:${WHITE} $(date)${RESET}"
    pause_back
}

toggle_ntp() {
  current=$(timedatectl show -p NTP --value 2>/dev/null)
  if [[ "$current" == "yes" || "$current" == "true" || "$current" == "1" ]]; then
    timedatectl set-ntp false
    echo -e "${GREEN}✅ NTP is now:${WHITE} OFF${RESET}"
  else
    timedatectl set-ntp true
    echo -e "${GREEN}✅ NTP is now:${WHITE} ON${RESET}"
  fi
  echo -e "${GREEN}Current Time:${WHITE} $(date)${RESET}"
  pause_back
}

set_custom_datetime() {
  clear
  echo -e "${ORANGE}======================================${RESET}"
  echo -e "${WHITE}        CUSTOM DATE & TIME${RESET}"
  echo -e "${ORANGE}======================================${RESET}"
  echo

  echo -e "${WHITE}Enter date first (DD/MM/YYYY)${RESET}"
  echo -e "  ${PINK}Example:${WHITE} 31/12/1970${RESET}"
  echo
  read -p "$(echo -e "${WHITE}Date : ${RESET}")" USER_DATE

  echo
  echo -e "${WHITE}Enter time (24-hour format, no seconds)${RESET}"
  echo -e "  ${PINK}Example:${WHITE} 23:59${RESET}"
  echo
  read -p "$(echo -e "${WHITE}Time : ${RESET}")" USER_TIME

  if [[ -z "$USER_DATE" || -z "$USER_TIME" ]]; then
    echo -e "${PINK}❌ Date or time cannot be empty${RESET}"
    pause_back
  fi

  # Convert DD/MM/YYYY → YYYY-MM-DD
  DAY=$(echo "$USER_DATE" | cut -d/ -f1)
  MONTH=$(echo "$USER_DATE" | cut -d/ -f2)
  YEAR=$(echo "$USER_DATE" | cut -d/ -f3)

  FINAL_TIME="${YEAR}-${MONTH}-${DAY} ${USER_TIME}:00"

  echo
  echo -e "${GREEN}Final system format:${WHITE} $FINAL_TIME${RESET}"
  echo

  # Disable NTP if ON
  current=$(timedatectl show -p NTP --value 2>/dev/null)
  if [[ "$current" == "yes" || "$current" == "true" || "$current" == "1" ]]; then
    timedatectl set-ntp false
    echo -e "${GREEN}ℹ️  NTP was ON → turned OFF for manual set${RESET}"
  fi

  if timedatectl set-time "$FINAL_TIME"; then
    echo
    echo -e "${GREEN}✅ Date & Time successfully set${RESET}"
    echo -e "${GREEN}Current Time:${WHITE} $(date)${RESET}"
  else
    echo
    echo -e "${PINK}❌ Invalid date or time format${RESET}"
  fi

  pause_back
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
 88)  set_custom_datetime ;;
 99)  toggle_ntp ;;
  0)  exec "$0" ;;
  *)  echo -e "${PINK}❌ Invalid selection${RESET}" ; pause_back ;;
esac