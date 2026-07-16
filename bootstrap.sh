#!/usr/bin/env bash

set -Eeuo pipefail

REPO="mohama226/l-panel"
BRANCH="main"

ZIP_URL="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.zip"

TMP_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$TMP_DIR"
}

trap cleanup EXIT

echo "======================================="
echo "        L-PANEL Bootstrap"
echo "======================================="
echo

########################################
# Root Check
########################################

if [[ $EUID -ne 0 ]]; then
    echo "Please run as root."
    exit 1
fi

########################################
# Detect Package Manager
########################################

if command -v dnf >/dev/null 2>&1; then
    PKG="dnf"
elif command -v yum >/dev/null 2>&1; then
    PKG="yum"
else
    echo "Unsupported Linux."
    exit 1
fi

########################################
# Install dependency if missing
########################################

install_pkg() {

    BIN=$1
    PKGNAME=$2

    if ! command -v "$BIN" >/dev/null 2>&1; then

        echo "Installing $PKGNAME ..."

        $PKG install -y "$PKGNAME"

    fi

}

install_pkg curl curl
install_pkg unzip unzip
install_pkg python3 python3
install_pkg zip zip

########################################
# Download
########################################

echo
echo "Downloading L-Panel..."

curl -L "$ZIP_URL" -o "$TMP_DIR/l-panel.zip"

########################################
# Extract
########################################

echo "Extracting..."

unzip -q "$TMP_DIR/l-panel.zip" -d "$TMP_DIR"

########################################
# Run installer
########################################

cd "$TMP_DIR/l-panel-main"

chmod +x installer/install.sh

bash installer/install.sh
