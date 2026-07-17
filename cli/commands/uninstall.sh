#!/usr/bin/env bash

set -Eeuo pipefail


#############################################
# L-PANEL Uninstall Manager
#############################################


INSTALL_DIR="/opt/l-panel"

BACKUP_DIR="/opt/l-panel-backups"

BIN_FILE="/usr/local/bin/l-panel"

CONFIG_DIR="/etc/l-panel"



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
# Check
#############################################


if [[ ! -d "$INSTALL_DIR" ]]; then

    echo

    fail "L-Panel installation not found."

    pause

    exit 1

fi



#############################################
# Information
#############################################


echo "Installation directory:"

echo "$INSTALL_DIR"


echo

echo "Binary command:"

echo "$BIN_FILE"


echo

echo "Configuration directory:"

echo "$CONFIG_DIR"



echo

echo "Files will be removed:"

echo "--------------------------------"


du -sh "$INSTALL_DIR"

echo "$INSTALL_DIR"

echo "$BIN_FILE"



#############################################
# Backup
#############################################


echo

read -rp "Create backup before uninstall? (y/n): " BACKUP



if [[ "$BACKUP" == "y" ]]; then


    mkdir -p "$BACKUP_DIR"


    BACKUP_FILE="$BACKUP_DIR/l-panel-uninstall-$(date +%Y%m%d-%H%M%S).tar.gz"


    echo

    echo "[+] Creating backup..."


    tar -czf "$BACKUP_FILE" \
        -C /opt \
        l-panel


    echo

    ok "Backup created"

    echo "$BACKUP_FILE"


fi



#############################################
# Ocserv Config
#############################################


echo

read -rp "Keep Ocserv configuration? (y/n): " KEEP_OCSERV



if [[ "$KEEP_OCSERV" == "y" ]]; then


    echo

    echo "Ocserv configuration kept."

else


    echo

    echo "Ocserv configuration will be removed."

fi



#############################################
# Confirmation
#############################################


echo

echo "WARNING!"

echo "This action cannot be undone."

echo


read -rp "Type REMOVE to continue: " CONFIRM



if [[ "$CONFIRM" != "REMOVE" ]]; then


    echo

    echo "Cancelled."

    exit 0

fi



#############################################
# Stop Services
#############################################


echo

echo "[+] Stopping services..."



if systemctl list-unit-files | grep -q ocserv.service; then

    systemctl stop ocserv || true

fi



#############################################
# Remove Command
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


if [[ "$KEEP_OCSERV" != "y" ]]; then


    echo

    echo "[+] Removing configuration..."


    rm -rf "$CONFIG_DIR"


fi



#############################################
# Finish
#############################################


echo

echo "=============================================="

echo " L-PANEL REMOVED"

echo "=============================================="


echo


echo "Backup directory:"

echo "$BACKUP_DIR"


echo


exit 0
