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
echo "           SERVICE MANAGER"
echo "=============================================="
echo

echo "1) Service Status"
echo "2) Start Ocserv"
echo "3) Stop Ocserv"
echo "4) Restart Ocserv"
echo "5) Enable on Boot"
echo "6) Disable on Boot"
echo "7) Reload Systemd"
echo "0) Back"

echo

read -rp "Select option: " ACTION

case "$ACTION" in

1)

echo

systemctl status ocserv --no-pager -l

echo

pause

;;

2)
echo

info "Starting ocserv..."

systemctl start ocserv

if systemctl is-active ocserv >/dev/null 2>&1
then
    ok "Ocserv started."
else
    fail "Failed to start."
fi

pause

;;

3)

echo

info "Stopping ocserv..."

systemctl stop ocserv

ok "Ocserv stopped."

pause

;;

4)

echo

info "Restarting ocserv..."

systemctl restart ocserv

if systemctl is-active ocserv >/dev/null 2>&1
then
    ok "Ocserv restarted."
else
    fail "Restart failed."
fi

pause

;;

5)

echo

systemctl enable ocserv

ok "Enabled at boot."

pause

;;

6)

echo

systemctl disable ocserv

ok "Disabled at boot."

pause

;;

7)
echo

info "Reloading systemd..."

systemctl daemon-reload

ok "Systemd reloaded."

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
