#!/usr/bin/env bash

set -e

INSTALL_DIR="/opt/l-panel"
REPO_URL="https://github.com/mohama226/l-panel.git"
BRANCH="main"

echo "========================================"
echo "          L-PANEL INSTALLER"
echo "========================================"

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

echo "Updating packages..."
apt update

echo "Installing Git..."
apt install -y git

if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
fi

echo "Downloading L-Panel..."
git clone -b "$BRANCH" "$REPO_URL" "$INSTALL_DIR"

chmod -R +x "$INSTALL_DIR/install"
chmod -R +x "$INSTALL_DIR/cli"

echo "Starting Installer..."

exec bash "$INSTALL_DIR/install/setup.sh"
