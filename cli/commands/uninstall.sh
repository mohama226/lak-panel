#!/usr/bin/env bash

set -Eeuo pipefail

# ================================
# New path resolver (as requested)
# ================================

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

# ================================

require_root

#############################################
# Confirm
#############################################

confirm_remove(){

    echo
    warn "This will remove L-Panel files."
    echo

    read -rp "Continue? (yes/no): " ANSWER

    if [[ "$ANSWER" != "yes" ]]; then
        info "Cancelled."
        exit 0
    fi
}

#############################################
# Stop Services
#############################################

stop_services(){

    info "Stopping services..."

    if systemctl list-unit-files | grep -q l-panel.service; then
        systemctl stop l-panel || true
        systemctl disable l-panel || true
    fi

    if systemctl list-unit-files | grep -q ocserv.service; then
        systemctl stop ocserv || true
        systemctl disable ocserv || true
    fi

    ok "Services stopped."
}

#############################################
# Remove System Files
#############################################

remove_files(){

    info "Removing files..."

    rm -rf /opt/l-panel
    rm -rf /etc/l-panel
    rm -rf /var/log/l-panel
    rm -f /usr/local/bin/l-panel

    ok "Files removed."
}

#############################################
# Remove Systemd Files
#############################################

remove_systemd(){

    info "Removing systemd files..."

    rm -f /etc/systemd/system/l-panel.service
    rm -f /etc/systemd/system/ocserv.service

    systemctl daemon-reload

    ok "Systemd cleaned."
}

#############################################
# Remove Ocserv
#############################################

remove_ocserv(){

    echo
    read -rp "Remove Ocserv configuration too? (yes/no): " OCSERV_REMOVE

    if [[ "$OCSERV_REMOVE" == "yes" ]]; then

        rm -rf /etc/ocserv
        rm -rf /var/lib/ocserv
        rm -rf /var/log/ocserv

        ok "Ocserv removed."

    else
        info "Ocserv files kept."
    fi
}

#############################################
# Main
#############################################

main(){

    title

    confirm_remove
    stop_services
    remove_systemd
    remove_files
    remove_ocserv

    echo
    ok "L-Panel uninstall completed."
    echo
}

main
