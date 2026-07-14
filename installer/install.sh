#!/bin/bash
set -e

APP_DIR="/opt/l-panel"
ZIP_URL="https://github.com/mohama226/l-panel/archive/refs/heads/main.zip"

echo "Installing L-Panel..."

apt update
apt install -y curl unzip python3 python3-pip python3-venv

rm -rf "$APP_DIR"
mkdir -p /opt

cd /tmp
rm -f l-panel.zip
curl -L "$ZIP_URL" -o l-panel.zip
unzip -oq l-panel.zip
mv l-panel-main "$APP_DIR"

cd "$APP_DIR"

python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# ===== اضافه شده طبق درخواست شما =====
cp installer/systemd/l-panel.service /etc/systemd/system/

systemctl daemon-reload

systemctl enable l-panel

systemctl restart l-panel
# =====================================
