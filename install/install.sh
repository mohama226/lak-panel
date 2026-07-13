#!/usr/bin/env bash

set -e

INSTALL_DIR="/opt/l-panel"
REPO_URL="https://github.com/mohama226/l-panel.git"
BRANCH="main"

echo "========================================"
echo "        L-PANEL INSTALLER"
echo "========================================"

if [ "$EUID" -ne 0 ]; then
    echo "Please run installer as root."
    exit 1
fi

apt update

apt install -y git

if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
fi

git clone --depth=1 -b "$BRANCH" "$REPO_URL" "$INSTALL_DIR"

chmod -R +x "$INSTALL_DIR/install"
chmod -R +x "$INSTALL_DIR/cli"

exec bash "$INSTALL_DIR/install/setup.sh"
