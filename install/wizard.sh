#!/usr/bin/env bash

source "$(dirname "$0")/variables.sh"

echo "================================="
echo " L-PANEL INSTALL WIZARD"
echo "================================="


read -p "SuperAdmin Username: " SUPERADMIN_USER

read -s -p "SuperAdmin Password: " SUPERADMIN_PASS

echo

read -p "Panel Port [8080]: " INPUT_PORT


if [ -n "$INPUT_PORT" ]; then
    PANEL_PORT=$INPUT_PORT
fi


read -p "Install Ocserv? (y/n): " INSTALL_OCSERV


cat > "$CONFIG_DIR/install.conf" <<EOF

SUPERADMIN_USER=$SUPERADMIN_USER

SUPERADMIN_PASS=$SUPERADMIN_PASS

PANEL_PORT=$PANEL_PORT

INSTALL_OCSERV=$INSTALL_OCSERV

POSTGRES_DB=$POSTGRES_DB

POSTGRES_USER=$POSTGRES_USER

POSTGRES_PASSWORD=$POSTGRES_PASSWORD

EOF


echo "Configuration saved."
