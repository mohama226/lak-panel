#!/bin/bash

set -e

BASE="/opt/lak-panel"

echo "======================================"
echo "        LAK PANEL INSTALLER"
echo "======================================"

read -p "SuperAdmin Username: " ADMIN_USER
read -s -p "SuperAdmin Password: " ADMIN_PASS
echo

read -p "Panel Port [2096]: " PANEL_PORT

if [ -z "$PANEL_PORT" ]; then
    PANEL_PORT=2096
fi


read -p "Install OCServ? (y/n): " INSTALL_OCSERV
read -p "Enable Backup? (y/n): " INSTALL_BACKUP
read -p "Enable Restore? (y/n): " INSTALL_RESTORE
read -p "Install Colob Script? (y/n): " INSTALL_COLOB


echo ""
echo "Install Path:"
echo "$BASE"


apt update

apt install -y \
python3 \
python3-venv \
python3-pip \
sqlite3 \
unzip


mkdir -p $BASE


if [ ! -f "$BASE/backend/run.py" ]; then
    echo "ERROR:"
    echo "Panel files not found!"
    echo "Project must be extracted before install."
    exit 1
fi


cd $BASE/backend


python3 -m venv venv

source venv/bin/activate


pip install --upgrade pip

pip install -r requirements.txt


cat > $BASE/backend/.env <<EOF
ADMIN_USERNAME=$ADMIN_USER
ADMIN_PASSWORD=$ADMIN_PASS
PORT=$PANEL_PORT
EOF



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

[Install]
WantedBy=multi-user.target
EOF



systemctl daemon-reload

systemctl enable lak-panel

systemctl restart lak-panel



echo ""
echo "Checking service..."

sleep 3

systemctl status lak-panel --no-pager



echo ""
echo "======================================"
echo " LAK PANEL INSTALLED"
echo ""
echo "PATH:"
echo "$BASE"
echo ""
echo "PORT:"
echo "$PANEL_PORT"
echo ""
echo "URL:"
echo "http://SERVER-IP:$PANEL_PORT"
echo "======================================"
