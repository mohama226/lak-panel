#!/usr/bin/env bash

set -Eeuo pipefail


INSTALL_DIR="/opt/l-panel"
BACKUP_DIR="/opt/l-panel-backups"

REPO="mohama226/l-panel"
BRANCH="main"

TMP_DIR="/tmp/l-panel-update"

ZIP_URL="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.zip"


#####################################

pause(){
    echo
    read -rp "Press ENTER to continue..."
}


#####################################

title(){

clear

echo
echo "==============================================="
echo "          L-PANEL UPDATE"
echo "==============================================="
echo

}


#####################################

title


echo "Last Update:"

cat "$INSTALL_DIR/.last_update" 2>/dev/null || echo "Never"

echo


read -rp "Continue update? (y/n): " CONFIRM


if [[ "$CONFIRM" != "y" ]]; then
    exit 0
fi



#####################################
# Backup
#####################################


mkdir -p "$BACKUP_DIR"


BACKUP_FILE="$BACKUP_DIR/l-panel-$(date +%Y%m%d-%H%M%S).tar.gz"


echo
echo "[+] Creating backup..."

tar -czf "$BACKUP_FILE" \
-C /opt \
l-panel



echo

echo "Backup created:"
echo "$BACKUP_FILE"



#####################################
# Download
#####################################


echo

echo "[+] Downloading latest version..."


rm -rf "$TMP_DIR"

mkdir -p "$TMP_DIR"


curl -L \
"$ZIP_URL" \
-o "$TMP_DIR/update.zip"



unzip -q \
"$TMP_DIR/update.zip" \
-d "$TMP_DIR"



#####################################
# Detect Source
#####################################


SOURCE=""


if [[ -f "$TMP_DIR/cli/l-panel" ]]; then

    SOURCE="$TMP_DIR"


elif [[ -f "$TMP_DIR/l-panel-main/cli/l-panel" ]]; then

    SOURCE="$TMP_DIR/l-panel-main"


else

    echo
    echo "ERROR: Invalid L-Panel source"

    find "$TMP_DIR" -maxdepth 3 -type f | head -20

    exit 1

fi



echo

echo "New source directory:"
echo "$SOURCE"



#####################################
# Compare Files
#####################################


echo

echo "Changed files:"
echo "--------------------------------"


CHANGED=$(rsync \
-avnc \
--delete \
"$SOURCE/" \
"$INSTALL_DIR/" \
| grep -v '/$' || true)



if [[ -z "$CHANGED" ]]; then

    echo "No changes detected."

    COUNT=0

else

    echo "$CHANGED"

    COUNT=$(echo "$CHANGED" | wc -l)

fi



echo

echo "Total changed files: $COUNT"



read -rp "Apply update? (y/n): " APPLY


if [[ "$APPLY" != "y" ]]; then

    echo "Cancelled."

    exit 0

fi



#####################################
# Update
#####################################


echo

echo "[+] Updating files..."



rsync \
-av \
--delete \
--exclude ".admin_user" \
--exclude ".panel_port" \
--exclude ".installed" \
--exclude ".last_update" \
"$SOURCE/" \
"$INSTALL_DIR/"



#####################################
# Permissions
#####################################


echo

echo "[+] Fix permissions..."


chmod +x "$INSTALL_DIR/cli/l-panel"

chmod +x "$INSTALL_DIR/cli/commands/"*.sh

chmod +x "$INSTALL_DIR/cli/lib/"*.sh



#####################################
# Update Time
#####################################


date "+%Y-%m-%d %H:%M:%S" \
> "$INSTALL_DIR/.last_update"



echo

echo "==============================================="

echo " L-PANEL UPDATED SUCCESSFULLY"

echo "==============================================="


echo

echo "Updated files: $COUNT"

echo

echo "Time:"

date



pause
