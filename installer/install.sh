#!/usr/bin/env bash

set -Eeuo pipefail


#############################################
# Variables
#############################################

PROJECT_NAME="l-panel"

INSTALL_DIR="/opt/l-panel"

BIN_PATH="/usr/local/bin/l-panel"

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"



#############################################
# Root Check
#############################################

if [[ $EUID -ne 0 ]]; then

    echo "Please run as root."

    exit 1

fi



#############################################
# Install Files
#############################################

install_files(){


    echo

    echo "Installing L-Panel files..."


    mkdir -p "$INSTALL_DIR"


    cp -rf "$CURRENT_DIR"/* "$INSTALL_DIR"/



    echo "Files copied."

}



#############################################
# Set Permissions
#############################################

set_permissions(){


    echo

    echo "Setting permissions..."


    chmod +x "$INSTALL_DIR/cli/l-panel"


    chmod +x "$INSTALL_DIR/cli/commands/"*.sh


    chmod +x "$INSTALL_DIR/cli/lib/"*.sh



}



#############################################
# Create Command Link
#############################################

create_command(){


    echo

    echo "Creating l-panel command..."


    ln -sf "$INSTALL_DIR/cli/l-panel" "$BIN_PATH"



}



#############################################
# Create Version Files
#############################################

create_state(){


    mkdir -p "$INSTALL_DIR"


    if [[ ! -f "$INSTALL_DIR/VERSION" ]]; then

        echo "0.0.1" > "$INSTALL_DIR/VERSION"

    fi



    touch "$INSTALL_DIR/.installed"



    date "+%Y-%m-%d %H:%M:%S" \
    > "$INSTALL_DIR/.last_update"



}



#############################################
# Finish
#############################################

finish(){


echo

echo "======================================"

echo " L-Panel Installed Successfully"

echo "======================================"

echo

echo "Run:"

echo

echo "l-panel"

echo


}



#############################################
# Main
#############################################

main(){


install_files


set_permissions


create_command


create_state


finish



}



main
