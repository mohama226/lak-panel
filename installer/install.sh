#!/usr/bin/env bash

set -Eeuo pipefail

INSTALL_DIR="/opt/l-panel"

echo
echo "Installing L-Panel..."
echo

mkdir -p "$INSTALL_DIR"

cp -r ./* "$INSTALL_DIR"

chmod +x "$INSTALL_DIR/cli/l-panel"

ln -sf "$INSTALL_DIR/cli/l-panel" /usr/local/bin/l-panel

echo
echo "Installation Complete."
echo

echo "Run:"
echo

echo "l-panel"
