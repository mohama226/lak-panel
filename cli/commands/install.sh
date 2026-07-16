#!/usr/bin/env bash

set -Eeuo pipefail

# ================================
# New path resolver (as requested)
# ================================

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

# ================================

require_root

title

info "L-Panel Installation"

echo

read -rp "Panel Port [8080]: " PORT
PORT=${PORT:-8080}

read -rp "SuperAdmin Username: " USER

read -rsp "SuperAdmin Password: " PASS
echo
echo

ok "Configuration saved"

echo
echo "Port : $PORT"
echo "User : $USER"
echo

echo "$PORT" > /opt/l-panel/.panel_port
echo "$USER" > /opt/l-panel/.admin_user

mark_installed

pause
