#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

require_root

INSTALL_DIR="/opt/l-panel"
CONFIG_DIR="/etc/l-panel"
BACKUP_DIR="/opt/l-panel-backups"

DATE=$(date +"%Y%m%d-%H%M%S")

mkdir -p "$BACKUP_DIR"

clear
title

echo
echo "=============================================="
echo "             L-PANEL BACKUP"
echo "=============================================="
echo

echo "Backup destination:"
echo "$BACKUP_DIR"

echo

echo "Items:"
echo "--------------------------------"

[[ -d "$INSTALL_DIR" ]] && echo "✓ L-Panel"

[[ -d "$CONFIG_DIR" ]] && echo "✓ Configuration"

[[ -d /etc/ocserv ]] && echo "✓ Ocserv"

[[ -f /etc/systemd/system/ocserv.service ]] && echo "✓ Systemd Service"

echo

read -rp "Create backup now? (y/n): " CONFIRM

[[ "$CONFIRM" != "y" ]] && exit 0

echo

info "Creating backup..."
BACKUP_FILE="$BACKUP_DIR/l-panel-backup-${DATE}.tar.gz"

INCLUDE_LIST=()

[[ -d "$INSTALL_DIR" ]] && INCLUDE_LIST+=("$INSTALL_DIR")
[[ -d "$CONFIG_DIR" ]] && INCLUDE_LIST+=("$CONFIG_DIR")
[[ -d /etc/ocserv ]] && INCLUDE_LIST+=("/etc/ocserv")
[[ -f /etc/systemd/system/ocserv.service ]] && INCLUDE_LIST+=("/etc/systemd/system/ocserv.service")

tar -czpf "$BACKUP_FILE" "${INCLUDE_LIST[@]}"

if [[ ! -f "$BACKUP_FILE" ]]; then

    fail "Backup failed."

    pause

    exit 1

fi

SIZE=$(du -h "$BACKUP_FILE" | awk '{print $1}')

FILES=$(tar -tf "$BACKUP_FILE" | wc -l)

echo

ok "Backup created successfully."

echo

echo "=============================================="
echo " Backup Information"
echo "=============================================="

echo

echo "File      : $BACKUP_FILE"

echo "Size      : $SIZE"

echo "Entries   : $FILES"

echo "Created   : $(date)"

echo

echo "Verifying archive..."

if tar -tf "$BACKUP_FILE" >/dev/null 2>&1; then

    ok "Archive verification passed."

else

    fail "Archive verification failed."

fi

echo

echo "Available backups"

echo "--------------------------------"

ls -lh "$BACKUP_DIR"

echo

pause

exit 0
