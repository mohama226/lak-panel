#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

require_root

clear

title

while true
do

clear

title

echo
echo "=============================================="
echo "            FAIL2BAN MANAGER"
echo "=============================================="
echo

echo "1) Install Fail2Ban"
echo "2) Service Status"
echo "3) Start Service"
echo "4) Stop Service"
echo "5) Restart Service"
echo "6) Enable On Boot"
echo "7) Disable On Boot"
echo "8) Jail Status"
echo "9) Show Banned IPs"
echo "10) Unban IP"
echo "11) View Log"
echo "0) Back"

echo

read -rp "Select option: " ACTION

case "$ACTION" in

1)

if command -v dnf >/dev/null 2>&1
then
    dnf install -y fail2ban
else
    yum install -y fail2ban
fi

systemctl enable fail2ban

ok "Fail2Ban installed."

pause

;;

2)

systemctl status fail2ban --no-pager -l

pause

;;

3)

systemctl start fail2ban

ok "Service started."

pause

;;

4)

systemctl stop fail2ban

ok "Service stopped."

pause

;;

5)

systemctl restart fail2ban

ok "Service restarted."

pause

;;

6)

systemctl enable fail2ban

ok "Enabled."

pause

;;

7)

systemctl disable fail2ban

ok "Disabled."

pause

;;

8)
echo

fail2ban-client status

echo

pause

;;

9)

echo

if ! systemctl is-active fail2ban >/dev/null 2>&1; then

    fail "Fail2Ban service is not running."

    pause

    continue

fi

JAILS=$(fail2ban-client status | sed -n 's/.*Jail list:\s*//p' | tr ',' ' ')

if [[ -z "$JAILS" ]]; then

    warn "No active jails."

    pause

    continue

fi

for JAIL in $JAILS
do

    echo "=============================================="

    echo "Jail : $JAIL"

    fail2ban-client status "$JAIL"

    echo

done

pause

;;

10)

echo

read -rp "Jail Name : " JAIL

read -rp "IP Address: " IP

if [[ -z "$JAIL" || -z "$IP" ]]; then

    fail "Jail and IP are required."

    pause

    continue

fi

if fail2ban-client set "$JAIL" unbanip "$IP"; then

    ok "IP unbanned successfully."

else

    fail "Failed to unban IP."

fi

pause

;;

11)

echo

if [[ -f /var/log/fail2ban.log ]]; then

    tail -100 /var/log/fail2ban.log

else

    warn "Log file not found."

fi

echo

pause

;;

0)

break

;;

*)

warn "Invalid option."

sleep 1

;;

esac

done

exit 0
