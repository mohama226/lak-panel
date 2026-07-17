#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/version.sh"

set -Eeuo pipefail


clear

title


echo
echo "=============================="
echo " OCSERV STATUS"
echo "=============================="
echo


if systemctl status ocserv --no-pager >/dev/null 2>&1
then

    systemctl status ocserv --no-pager -l

else

    fail "Ocserv service not found"

fi


echo

pause
