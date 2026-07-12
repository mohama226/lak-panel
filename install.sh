#!/bin/bash

set -e

BASE="/opt/lak-panel"

echo "================================="
echo "       LAK PANEL INSTALLER"
echo "================================="

if [ "$EUID" -ne 0 ]; then
    echo "Run as root"
    exit 1
fi


echo "[1/8] Installing packages..."

apt update

apt install -y \
python3 \
python3-venv \
python3-pip \
git \
nginx \
curl \
systemd


echo "[2/8] Creating directories..."

mkdir -p $BASE

mkdir -p \
$BASE/backend \
$BASE/frontend/templates \
$BASE/frontend/static \
$BASE/scripts \
$BASE/backups \
$BASE/logs \
$BASE/data


echo "[3/8] Creating virtual environment..."

if [ ! -d "$BASE/backend/venv" ]; then

python3 -m venv \
$BASE/backend/venv

fi


echo "[4/8] Installing python packages..."

$BASE/backend/venv/bin/pip install --upgrade pip


if [ -f "$BASE/backend/requirements.txt" ]; then

$BASE/backend/venv/bin/pip install \
-r $BASE/backend/requirements.txt

fi


echo "[5/8] Creating environment..."

if [ ! -f "$BASE/backend/.env" ]; then

cat > $BASE/backend/.env <<EOF
APP_NAME=LAK PANEL
PORT=2096
DATABASE=/opt/lak-panel/data/database.db
EOF

fi


echo "[6/8] Installing service..."


cat > /etc/systemd/system/lak-panel.service <<EOF

[Unit]
Description=LAK Panel
After=network.target


[Service]

Type=simple

WorkingDirectory=$BASE/backend

Environment=PYTHONUNBUFFERED=1

ExecStart=$BASE/backend/venv/bin/python3 $BASE/backend/run.py

Restart=always

RestartSec=5

User=root

Group=root


[Install]

WantedBy=multi-user.target

EOF



echo "[7/8] Installing command..."


cat > /usr/local/bin/lak-panel <<EOF

#!/bin/bash

exec $BASE/scripts/menu.sh

EOF


chmod +x /usr/local/bin/lak-panel



echo "[8/8] Starting service..."

systemctl daemon-reload

systemctl enable lak-panel

systemctl restart lak-panel || true


echo ""
echo "================================="
echo " INSTALL COMPLETE"
echo "================================="

echo ""

systemctl status lak-panel --no-pager || true
