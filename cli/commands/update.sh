#!/usr/bin/env bash

set -Eeuo pipefail


INSTALL_DIR="/opt/l-panel"
BACKUP_DIR="/opt/l-panel-backups"

REPO="https://github.com/mohama226/l-panel/archive/refs/heads/main.zip"

TMP_DIR="/tmp/l-panel-update"

DATE=$(date +"%Y%m%d-%H%M%S")


clear

echo
echo "==============================================="
echo "          L-PANEL UPDATE"
echo "==============================================="
echo


if [[ -f "$INSTALL_DIR/.last_update" ]]; then
    echo "Last Update:"
    cat "$INSTALL_DIR/.last_update"
else
    echo "Last Update: Never"
fi


echo
read -rp "Continue update? (y/n): " CONFIRM


if [[ "$CONFIRM" != "y" ]]; then
    exit 0
fi



####################################
# Backup
####################################

echo
echo "[+] Creating backup..."


mkdir -p "$BACKUP_DIR"


tar -czf \
"$BACKUP_DIR/l-panel-$DATE.tar.gz" \
-C /opt l-panel


echo
echo "Backup created:"
echo "$BACKUP_DIR/l-panel-$DATE.tar.gz"



####################################
# Download
####################################


echo
echo "[+] Downloading latest version..."


rm -rf "$TMP_DIR"

mkdir -p "$TMP_DIR"


curl -L "$REPO" \
-o "$TMP_DIR/update.zip"


unzip -q "$TMP_DIR/update.zip" \
-d "$TMP_DIR"



####################################
# Detect source
####################################


SOURCE=""


if [[ -f "$TMP_DIR/l-panel-main/cli/l-panel" ]]; then

    SOURCE="$TMP_DIR/l-panel-main"

elif [[ -f "$TMP_DIR/cli/l-panel" ]]; then

    SOURCE="$TMP_DIR"

else

    echo
    echo "ERROR: Invalid L-Panel source"
    exit 1

fi



echo
echo "New source directory:"
echo "$SOURCE"



####################################
# Compare
####################################


echo
echo "Changed files:"
echo "--------------------------------"


EXCLUDES="
--exclude=.installed
--exclude=.last_update
--exclude=.admin_user
--exclude=.panel_port
"



CHANGED=$(

rsync \
--dry-run \
-r \
--itemize-changes \
$EXCLUDES \
"$SOURCE/" \
"$INSTALL_DIR/" | \
awk '{print $2}'

)



if [[ -z "$CHANGED" ]]; then

    echo "No changes detected."

    COUNT=0

else

    echo "$CHANGED"

    COUNT=$(echo "$CHANGED" | wc -l)

fi



echo
echo "Total changed files: $COUNT"



echo
read -rp "Apply update? (y/n): " APPLY


if [[ "$APPLY" != "y" ]]; then

    echo "Cancelled."

    exit 0

fi



####################################
# Apply update
####################################


echo
echo "[+] Updating files..."


rsync \
-r \
--delete \
$EXCLUDES \
"$SOURCE/" \
"$INSTALL_DIR/"



####################################
# Restore state
####################################


touch "$INSTALL_DIR/.installed"


date "+%Y-%m-%d %H:%M:%S" \
> "$INSTALL_DIR/.last_update"



####################################
# Permissions
####################################


echo
echo "[+] Fix permissions..."


chmod +x "$INSTALL_DIR/cli/l-panel"

chmod +x "$INSTALL_DIR/cli/commands/"*.sh 2>/dev/null || true

chmod +x "$INSTALL_DIR/cli/lib/"*.sh 2>/dev/null || true



####################################
# Ensure command
####################################


ln -sf \
"$INSTALL_DIR/cli/l-panel" \
/usr/local/bin/l-panel



####################################


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

read -rp "Press ENTER to continue..."
