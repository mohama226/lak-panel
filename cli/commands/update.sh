#!/usr/bin/env bash

set -Eeuo pipefail


#############################################
# L-PANEL Update Manager
#############################################


REPO="mohama226/l-panel"
BRANCH="main"

INSTALL_DIR="/opt/l-panel"
TMP_DIR="/tmp/l-panel-update"
BACKUP_DIR="/opt/l-panel-backups"


#############################################
# Load Libraries
#############################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$BASE_DIR/cli/lib/colors.sh"
source "$BASE_DIR/cli/lib/common.sh"


#############################################
# Start
#############################################

clear
title

echo
echo "=============================================="
echo "          L-PANEL UPDATE"
echo "=============================================="
echo


#############################################
# Dependencies
#############################################

install_dependency(){

    if ! command -v "$1" >/dev/null 2>&1; then

        echo "[+] Installing dependency: $2"

        if command -v dnf >/dev/null 2>&1; then
            dnf install -y "$2"
        elif command -v yum >/dev/null 2>&1; then
            yum install -y "$2"
        fi

    fi

}

install_dependency rsync rsync
install_dependency curl curl
install_dependency tar tar


#############################################
# Previous Update
#############################################

echo "Last Update:"
if [[ -f "$INSTALL_DIR/.last_update" ]]; then
    cat "$INSTALL_DIR/.last_update"
else
    echo "Never"
fi

echo


#############################################
# Confirm
#############################################

read -rp "Continue update? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" ]]; then
    echo "Cancelled"
    exit 0
fi


#############################################
# Prepare
#############################################

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
mkdir -p "$BACKUP_DIR"


#############################################
# Backup
#############################################

BACKUP_FILE="$BACKUP_DIR/l-panel-$(date +%Y%m%d-%H%M%S).tar.gz"

echo
echo "[+] Creating backup..."

tar -czf "$BACKUP_FILE" \
    -C /opt \
    l-panel

echo
echo "Backup created:"
echo "$BACKUP_FILE"


#############################################
# Download
#############################################

echo
echo "[+] Downloading latest version..."

curl -fsSL \
"https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz" \
-o "$TMP_DIR/update.tar.gz"

tar -xzf "$TMP_DIR/update.tar.gz" -C "$TMP_DIR"

NEW_DIR=$(find "$TMP_DIR" -maxdepth 1 -type d -name "l-panel-*")


#############################################
# Compare Files (NEW RSYNC VERSION)
#############################################

echo
echo "Changed files:"
echo "--------------------------------"

RSYNC_OUTPUT=$(rsync -avnc \
--exclude=".git" \
--exclude=".installed" \
--exclude=".last_update" \
--exclude=".admin_user" \
--exclude=".panel_port" \
"$NEW_DIR/" \
"$INSTALL_DIR/")

FILES=$(echo "$RSYNC_OUTPUT" | \
grep -v "^sending" | \
grep -v "^sent" | \
grep -v "^total")

COUNT=$(echo "$FILES" | grep -c "/" || true)

if [[ "$COUNT" -eq 0 ]]; then
    echo "No changes detected."
else
    echo "Total changed files: $COUNT"
    echo
    echo "$FILES"
fi

echo
read -rp "Apply update? (y/n): " APPLY

if [[ "$APPLY" != "y" ]]; then
    echo "Update stopped."
    exit 0
fi


#############################################
# Update Files (UPDATED)
#############################################

echo
echo "[+] Updating files..."

rsync -av \
--exclude=".git" \
--exclude=".installed" \
--exclude=".last_update" \
--exclude=".admin_user" \
--exclude=".panel_port" \
"$NEW_DIR/" \
"$INSTALL_DIR/" \
| tee "$TMP_DIR/rsync.log"


#############################################
# Permissions
#############################################

echo
echo "[+] Fix permissions..."

chmod +x "$INSTALL_DIR/cli/l-panel"
chmod +x "$INSTALL_DIR/cli/commands/"*.sh
chmod +x "$INSTALL_DIR/cli/lib/"*.sh


#############################################
# Update Date
#############################################

save_last_update


#############################################
# Finish
#############################################

echo
echo "=============================================="
echo " L-PANEL UPDATED SUCCESSFULLY"
echo "=============================================="
echo

echo "Updated files: $COUNT"
echo

echo "Time:"
date

echo
pause
