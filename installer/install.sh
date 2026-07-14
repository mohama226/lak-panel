#!/bin/bash

set -e

echo "Installing L-Panel..."

apt update
apt install -y curl unzip python3 python3-pip python3-venv

rm -rf /opt/l-panel

mkdir -p /opt

cd /tmp

curl -L -o l-panel.zip \
https://github.com/mohama226/l-panel/archive/refs/heads/main.zip

unzip -o l-panel.zip

mv l-panel-main /opt/l-panel

# === بخش جدید اضافه شده ===
cd /opt/l-panel
python3 -m venv venv
/opt/l-panel/venv/bin/pip install --upgrade pip
/opt/l-panel/venv/bin/pip install -r requirements.txt
# ============================

chmod +x /opt/l-panel/installer/*.sh
chmod +x /opt/l-panel/scripts/*

ln -sf /opt/l-panel/scripts/l-panel /usr/local/bin/l-panel

echo "L-Panel Installed"

# === دستورات سرویس systemd ===
systemctl daemon-reload
systemctl enable l-panel
systemctl restart l-panel
# ============================

l-panel
