#!/usr/bin/env bash

# ======================================
# L-PANEL Common Library
# ======================================

PROJECT_NAME="L-PANEL"

INSTALL_DIR="/opt/l-panel"

CONFIG_DIR="/etc/l-panel"

LOG_DIR="/var/log/l-panel"

BIN_FILE="/usr/local/bin/l-panel"

VERSION_FILE="${INSTALL_DIR}/VERSION"

LAST_UPDATE_FILE="${INSTALL_DIR}/.last_update"

INSTALLED_FILE="${INSTALL_DIR}/.installed"

########################################

pause() {
    echo
    read -rp "Press ENTER to continue..."
}

########################################

require_root() {

    if [[ $EUID -ne 0 ]]; then
        echo
        echo "Please run as root."
        exit 1
    fi

}

########################################

mkdirs() {

    mkdir -p "$INSTALL_DIR"
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$LOG_DIR"

}

########################################

is_installed() {

    [[ -f "$INSTALLED_FILE" ]]

}

########################################

mark_installed() {

    touch "$INSTALLED_FILE"

}

########################################

mark_removed() {

    rm -f "$INSTALLED_FILE"

}

########################################

get_version() {

    if [[ -f "$VERSION_FILE" ]]; then
        cat "$VERSION_FILE"
    else
        echo "Unknown"
    fi

}

########################################

get_last_update() {

    if [[ -f "$LAST_UPDATE_FILE" ]]; then
        cat "$LAST_UPDATE_FILE"
    else
        echo "Never"
    fi

}

########################################
# NEW save_last_update (updated as requested)
########################################

save_last_update() {

    mkdir -p "$INSTALL_DIR"
    date "+%Y-%m-%d %H:%M:%S" > "$LAST_UPDATE_FILE"

}

########################################

panel_status() {

    if is_installed; then
        echo "Installed"
    else
        echo "Not Installed"
    fi

}

########################################

line() {

    printf '%*s\n' "${COLUMNS:-50}" '' | tr ' ' '='

}
