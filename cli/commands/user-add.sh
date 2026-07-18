#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

PASSWD_FILE="/etc/ocserv/ocpasswd"

title

echo
echo "=============================================="
echo "               ADD USER"
echo "=============================================="
echo

if ! command -v ocpasswd >/dev/null 2>&1; then

    fail "ocpasswd command not found."

    pause

    exit 1

fi

read -rp "Username : " USERNAME

USERNAME=$(echo "$USERNAME" | xargs)

if [[ -z "$USERNAME" ]]; then

    fail "Username cannot be empty."

    pause

    exit 1

fi

if [[ ! "$USERNAME" =~ ^[a-zA-Z0-9._-]+$ ]]; then

    fail "Invalid username."

    pause

    exit 1

fi

if [[ -f "$PASSWD_FILE" ]]; then

    if grep -q "^${USERNAME}:" "$PASSWD_FILE"; then

        fail "User already exists."

        pause

        exit 1

    fi

fi

echo

read -rsp "Password : " PASSWORD

echo

read -rsp "Confirm  : " PASSWORD2

echo
if [[ "$PASSWORD" != "$PASSWORD2" ]]; then

    fail "Passwords do not match."

    pause

    exit 1

fi

if [[ ${#PASSWORD} -lt 6 ]]; then

    fail "Password must be at least 6 characters."

    pause

    exit 1

fi

echo
info "Creating user..."

printf "%s\n%s\n" "$PASSWORD" "$PASSWORD" | \
ocpasswd -c "$PASSWD_FILE" "$USERNAME"

if [[ $? -ne 0 ]]; then

    fail "Failed to create user."

    pause

    exit 1

fi

echo

ok "User created successfully."

echo

echo "=============================================="
echo " User Information"
echo "=============================================="
echo

echo "Username : $USERNAME"
echo "Password : $PASSWORD"
echo "Status   : Active"

echo

if command -v occtl >/dev/null 2>&1; then

    echo "Current user count:"

    occtl show users 2>/dev/null || true

fi

echo

pause

exit 0
