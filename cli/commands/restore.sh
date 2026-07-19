#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

require_root

BACKUP_DIR="/opt/l-panel-backups"

clear
title

echo
echo "=============================================="
echo "            L-PANEL RESTORE"
echo "=============================================="
echo

if [[ ! -d "$BACKUP_DIR" ]]; then

    fail "Backup directory not found."

    pause

    exit 1

fi

mapfile -t FILES < <(find "$BACKUP_DIR" -maxdepth 1 -type f -name "*.tar.gz" | sort -r)

if [[ ${#FILES[@]} -eq 0 ]]; then

    fail "No backup files found."

    pause

    exit 1

fi

echo "Available Backups"
echo "--------------------------------"
echo

INDEX=1

for FILE in "${FILES[@]}"
do

    SIZE=$(du -h "$FILE" | awk '{print $1}')

    DATE=$(date -r "$FILE" "+%Y-%m-%d %H:%M")

    echo "$INDEX) $(basename "$FILE")"

    echo "    Size : $SIZE"

    echo "    Date : $DATE"

    echo

    INDEX=$((INDEX+1))

done

read -rp "Select backup number: " NUM

if ! [[ "$NUM" =~ ^[0-9]+$ ]]; then

    fail "Invalid selection."

    pause

    exit 1

fi

if (( NUM < 1 || NUM > ${#FILES[@]} )); then

    fail "Selection out of range."

    pause

    exit 1

fi

BACKUP_FILE="${FILES[$((NUM-1))]}"

echo

echo "Selected Backup"

echo "$BACKUP_FILE"

echo

read -rp "Restore this backup? (type YES): " CONFIRM

[[ "$CONFIRM" != "YES" ]] && exit 0

echo

info "Stopping services..."

systemctl stop ocserv 2>/dev/null || true
echo

info "Verifying backup archive..."

if ! tar -tzf "$BACKUP_FILE" >/dev/null 2>&1; then

    fail "Backup archive is corrupted."

    pause

    exit 1

fi

echo

info "Restoring files..."

tar -xzpf "$BACKUP_FILE" -C /

echo

ok "Files restored."

echo

info "Restoring permissions..."

[[ -d /opt/l-panel ]] && chmod -R 755 /opt/l-panel
[[ -f /opt/l-panel/cli/l-panel ]] && chmod +x /opt/l-panel/cli/l-panel
[[ -d /opt/l-panel/cli/commands ]] && chmod +x /opt/l-panel/cli/commands/*.sh 2>/dev/null || true
[[ -d /opt/l-panel/cli/lib ]] && chmod +x /opt/l-panel/cli/lib/*.sh 2>/dev/null || true

ln -sf /opt/l-panel/cli/l-panel /usr/local/bin/l-panel

echo

info "Reloading systemd..."

systemctl daemon-reload

if [[ -f /etc/systemd/system/ocserv.service ]]; then

    info "Starting ocserv..."

    systemctl enable ocserv >/dev/null 2>&1 || true
    systemctl restart ocserv >/dev/null 2>&1 || true

    if systemctl is-active ocserv >/dev/null 2>&1; then

        ok "Ocserv started successfully."

    else

        warn "Ocserv restored but service is not running."

    fi

fi

echo

echo "=============================================="
echo " RESTORE COMPLETED"
echo "=============================================="

echo

echo "Backup : $(basename "$BACKUP_FILE")"

echo "Date   : $(date)"

echo

ok "Restore completed successfully."

echo

pause

exit 0
