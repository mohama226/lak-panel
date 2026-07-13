#!/usr/bin/env bash

set -e

INSTALL_DIR="/opt/l-panel"

REPO="https://github.com/mohama226/l-panel.git"

apt update

apt install -y git

rm -rf "$INSTALL_DIR"

git clone "$REPO" "$INSTALL_DIR"

chmod -R +x "$INSTALL_DIR/install"

chmod -R +x "$INSTALL_DIR/cli"

exec bash "$INSTALL_DIR/install/setup.sh"
