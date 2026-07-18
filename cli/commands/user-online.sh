#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

title

echo
echo "=============================================="
echo "            ONLINE USERS"
echo "=============================================="
echo

if ! command -v occtl >/dev/null 2>&1; then

    fail "occtl command not found."

    pause

    exit 1

fi

if ! systemctl is-active ocserv >/dev/null 2>&1; then

    fail "Ocserv service is not running."

    pause

    exit 1

fi

TMP=$(mktemp)

occtl show users > "$TMP" 2>/dev/null || true

if [[ ! -s "$TMP" ]]; then

    warn "No users online."

    rm -f "$TMP"

    pause

    exit 0

fi
echo

printf "%-5s %-20s %-18s %-16s\n" \
"No." "Username" "IP Address" "Connected"

echo "---------------------------------------------------------------------"

COUNT=0

tail -n +2 "$TMP" | while read -r LINE
do

    USER=$(echo "$LINE" | awk '{print $2}')
    IP=$(echo "$LINE" | awk '{print $3}')
    TIME=$(echo "$LINE" | awk '{print $5}')

    COUNT=$((COUNT+1))

    printf "%-5s %-20s %-18s %-16s\n" \
    "$COUNT" "$USER" "$IP" "$TIME"

done

echo
echo "---------------------------------------------------------------------"

TOTAL=$(tail -n +2 "$TMP" | wc -l)

echo
echo "Total Online Users : $TOTAL"

rm -f "$TMP"

echo

pause

exit 0
