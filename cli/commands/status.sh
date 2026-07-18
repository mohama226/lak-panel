#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

INFO_FILE="/etc/l-panel/ocserv.info"

title

echo
echo "=============================================="
echo "             OCSERV STATUS"
echo "=============================================="
echo

VERSION="-"
PORT="-"

if [[ -f "$INFO_FILE" ]]; then

    source "$INFO_FILE"

    VERSION="${VERSION:-Unknown}"
    PORT="${PORT:-Unknown}"

fi

echo "Version : $VERSION"
echo "Port    : $PORT"
echo
STATUS="Stopped"

if systemctl is-active ocserv >/dev/null 2>&1; then
    STATUS="Running"
fi

PID="-"

if systemctl is-active ocserv >/dev/null 2>&1; then

    PID=$(pidof ocserv || echo "-")

fi

UPTIME="-"

if [[ "$PID" != "-" ]]; then

    UPTIME=$(ps -o etime= -p "$PID" | xargs)

fi

echo "Service : $STATUS"
echo "PID     : $PID"
echo "Uptime  : $UPTIME"

echo
