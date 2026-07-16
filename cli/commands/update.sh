#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

REPO="mohama226/l-panel"
BRANCH="main"

TMP_DIR="/tmp/lpanel-update"
ZIP_FILE="$TMP_DIR/update.zip"

INSTALL_DIR="/opt/l-panel"

########################################

prepare() {

    rm -rf "$TMP_DIR"

    mkdir -p "$TMP_DIR"

}

########################################

download_update() {

    info "Downloading latest version..."

    curl -L \
    "https://github.com/${REPO}/archive/refs/heads/${BRANCH}.zip" \
    -o "$ZIP_FILE"

}
########################################

extract_update() {

    info "Extracting..."

    unzip -oq "$ZIP_FILE" -d "$TMP_DIR"

}

########################################

find_project() {

    PROJECT_DIR=$(find "$TMP_DIR" -maxdepth 1 -type d -name "l-panel-*")

    if [[ -z "$PROJECT_DIR" ]]; then

        fail "Cannot locate extracted project."

        exit 1

    fi

}

########################################

backup() {

    BACKUP="/tmp/lpanel-backup-$(date +%Y%m%d%H%M%S)"

    info "Creating Backup..."

    cp -a "$INSTALL_DIR" "$BACKUP"

}########################################

replace_files() {

    info "Updating files..."

    rsync -a \
    --delete \
    --exclude=".env" \
    --exclude=".installed" \
    --exclude=".last_update" \
    "$PROJECT_DIR/" \
    "$INSTALL_DIR/"

}

########################################

restart_services() {

    if systemctl list-unit-files | grep -q lpanel.service
    then

        info "Restarting Service..."

        systemctl restart lpanel

    fi

}########################################

finish() {

    save_last_update

    ok "Update Finished."

    echo

    echo "Installed Version : $(get_version)"

    echo "Last Update       : $(get_last_update)"

}########################################

title

info "L-PANEL Update"

prepare

download_update

extract_update

find_project

backup

replace_files

restart_services

finish

pause
