#!/usr/bin/env bash

set -Eeuo pipefail


#############################################
# L-PANEL UNINSTALL MANAGER
#############################################


INSTALL_DIR="/opt/l-panel"

CONFIG_DIR="/etc/l-panel"

LOG_DIR="/var/log/l-panel"

BACKUP_DIR="/opt/l-panel-backups"

BIN_FILE="/usr/local/bin/l-panel"



#############################################
# Load Libraries
#############################################


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BASE_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"


source "$BASE_DIR/cli/lib/colors.sh"
source "$BASE_DIR/cli/lib/common.sh"



#############################################
# Header
#############################################


clear

title


echo
echo "=============================================="
echo "          L-PANEL UNINSTALL"
echo "=============================================="
echo



#############################################
# Root Check
#############################################


if [[ $EUID -ne 0 ]]; then

    fail "Please run as root."

    exit 1

fi



#############################################
# Check Installation
#############################################


if [[ ! -d "$INSTALL_DIR" ]]; then


    echo

    warn "L-Panel installation not found."

    pause

    exit 0


fi



#############################################
# Information
#############################################


echo

echo "Installation:"
echo "-------------"

echo "$INSTALL_DIR"


echo

echo "Command:"
echo "-------------"

echo "$BIN_FILE"


echo

echo "Configuration:"
echo "-------------"

echo "$CONFIG_DIR"


echo

echo "Logs:"
echo "-------------"

echo "$LOG_DIR"



echo

echo "Size:"

du -sh "$INSTALL_DIR"



#############################################
# Backup
#############################################


echo

read -rp "Create backup before uninstall? (y/n): " BACKUP



if [[ "$BACKUP" == "y" ]]; then


    mkdir -p "$BACKUP_DIR"


    BACKUP_FILE="$BACKUP_DIR/l-panel-before-remove-$(date +%Y%m%d-%H%M%S).tar.gz"


    echo

    echo "[+] Creating backup..."


    tar -czf "$BACKUP_FILE" \
    -C /opt \
    l-panel



    if [[ -d "$CONFIG_DIR" ]]; then

        tar -rzf "$BACKUP_FILE" \
        -C /etc \
        l-panel 2>/dev/null || true

    fi



    ok "Backup created"

    echo "$BACKUP_FILE"


fi



#############################################
# Confirmation
#############################################


echo

echo "=============================================="

echo "WARNING"

echo "This will remove:"
echo

echo "- L-Panel application"
echo "- CLI command"
echo "- Panel configuration"
echo "- Panel logs"

echo

echo "Ocserv will NOT be removed."

echo "VPN service will NOT be modified."

echo "=============================================="


echo

read -rp "Type REMOVE to continue: " CONFIRM



if [[ "$CONFIRM" != "REMOVE" ]]; then


    echo

    echo "Cancelled."

    pause

    exit 0


fi



#############################################
# Remove command
#############################################


echo

echo "[+] Removing command..."


rm -f "$BIN_FILE"



#############################################
# Remove Application
#############################################


echo

echo "[+] Removing L-Panel files..."


rm -rf "$INSTALL_DIR"



#############################################
# Remove Config
#############################################


if [[ -d "$CONFIG_DIR" ]]; then


    echo

    echo "[+] Removing panel configuration..."


    rm -rf "$CONFIG_DIR"


fi



#############################################
# Remove Logs
#############################################


if [[ -d "$LOG_DIR" ]]; then


    echo

    echo "[+] Removing logs..."


    rm -rf "$LOG_DIR"


fi



#############################################
# Verify
#############################################


echo

echo "[+] Checking removal..."


if [[ -e "$BIN_FILE" ]]; then

    warn "Command still exists."

else

    ok "Command removed."

fi



if [[ -d "$INSTALL_DIR" ]]; then

    warn "Installation directory still exists."

else

    ok "Installation removed."

fi



#############################################
# Finish
#############################################


echo

echo "=============================================="

echo " L-PANEL REMOVED SUCCESSFULLY"

echo "=============================================="

echo


if [[ -n "${BACKUP_FILE:-}" ]]; then

echo "Backup:"
echo "$BACKUP_FILE"

fi


echo

echo "Ocserv was not touched."

echo


pause
