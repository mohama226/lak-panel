#!/usr/bin/env bash

set -Eeuo pipefail


#############################################
# L-PANEL UPDATE SYSTEM
#############################################

INSTALL_DIR="/opt/l-panel"

BACKUP_DIR="/opt/l-panel-backups"

REPO="mohama226/l-panel"

BRANCH="main"

WORK_DIR="/tmp/l-panel-update"

DATE=$(date +"%Y%m%d-%H%M%S")



#############################################
# Header
#############################################

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



#############################################
# Backup
#############################################

echo

echo "[+] Creating backup..."

mkdir -p "$BACKUP_DIR"


tar -czf \
"$BACKUP_DIR/l-panel-$DATE.tar.gz" \
-C /opt l-panel



echo

echo "Backup created:"
echo "$BACKUP_DIR/l-panel-$DATE.tar.gz"



#############################################
# Download
#############################################

echo

echo "[+] Downloading latest version..."


rm -rf "$WORK_DIR"

mkdir -p "$WORK_DIR"



wget -q \
"https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" \
-O "$WORK_DIR/source.tar.gz"



tar -xzf \
"$WORK_DIR/source.tar.gz" \
-C "$WORK_DIR"



#############################################
# Detect Source
#############################################

SOURCE=$(find "$WORK_DIR" \
-maxdepth 1 \
-type d \
-name "l-panel-*" \
| head -n 1)



if [[ -z "$SOURCE" ]]; then

    echo

    echo "ERROR: Source directory not found"

    exit 1

fi



echo

echo "New source directory:"
echo "$SOURCE"



#############################################
# Validate Source
#############################################

if [[ ! -f "$SOURCE/cli/l-panel" ]]; then


    echo

    echo "ERROR: Invalid L-Panel source"

    echo "$SOURCE/cli/l-panel missing"

    exit 1


fi



echo

echo "Source validation OK."



#############################################
# Compare Files
#############################################

echo

echo "Changed files:"
echo "--------------------------------"



mapfile -t CHANGED < <(

rsync \
-rcn \
--exclude=".git" \
--exclude="source.tar.gz" \
--out-format="%n" \
"$SOURCE/" \
"$INSTALL_DIR/"


)



if [[ ${#CHANGED[@]} -eq 0 ]]; then

    echo "No changes detected."

else


    for FILE in "${CHANGED[@]}"
    do

        echo "$FILE"

    done


fi



echo

echo "Total changed files: ${#CHANGED[@]}"


echo

read -rp "Apply update? (y/n): " APPLY



if [[ "$APPLY" != "y" ]]; then

    echo "Cancelled."

    exit 0

fi



#############################################
# Apply Update
#############################################

echo

echo "[+] Updating files..."



rsync \
-r \
--exclude=".git" \
--exclude="source.tar.gz" \
"$SOURCE/" \
"$INSTALL_DIR/"



#############################################
# Permissions
#############################################

echo

echo "[+] Fix permissions..."



chmod +x "$INSTALL_DIR/cli/l-panel"



find "$INSTALL_DIR/cli" \
-name "*.sh" \
-exec chmod +x {} \;



#############################################
# Cleanup
#############################################

rm -rf "$WORK_DIR"



#############################################
# Save Update Time
#############################################

date "+%Y-%m-%d %H:%M:%S" \
> "$INSTALL_DIR/.last_update"



#############################################
# Finish
#############################################

echo

echo "=============================================="

echo " L-PANEL UPDATED SUCCESSFULLY"

echo "=============================================="

echo

echo "Updated files: ${#CHANGED[@]}"

echo

echo "Time:"

date



echo

read -rp "Press ENTER to continue..."
