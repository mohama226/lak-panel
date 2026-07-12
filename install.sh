#!/bin/bash

set -e

BASE="/opt/lak-panel"

echo "
=========================================
        LAK PANEL INSTALLER
=========================================
"

if [ "$EUID" -ne 0 ]; then
    echo "Run as root"
    exit 1
fi


mkdir -p $BASE


echo "[1/6] Installing dependencies"

apt update

apt install -y \
python3 \
python3-venv \
python3-pip \
curl \
wget \
unzip \
nginx \
sqlite3 \
git


echo "[2/6] Loading installer"

bash installer/install_menu.sh
