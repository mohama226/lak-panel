#!/bin/bash

set -e

BASE_DIR="/opt/lak-panel"
BACKEND_DIR="$BASE_DIR/backend"
VENV_DIR="$BACKEND_DIR/venv"

echo "========================================="
echo "       LAK PANEL INSTALL PANEL"
echo "========================================="

echo ""

echo "Install Path:"
echo "$BASE_DIR"

echo ""

if [ ! -d "$BACKEND_DIR" ]; then
    echo "ERROR: backend directory not found"
    exit 1
fi


echo "[1/6] Installing dependencies..."

apt update

apt install -y \
python3 \
python3-pip \
python3-venv \
sqlite3


echo "[2/6] Creating Virtual Environment..."

if [ ! -d "$VENV_DIR" ]; then

python3 -m venv "$VENV_DIR"

fi


echo "[3/6] Installing Python Packages..."

source "$VENV_DIR/bin/activate"

pip install --upgrade pip

pip install -r "$BACKEND_DIR/requirements.txt"


echo "[4/6] Creating Environment File..."

if [ ! -f "$BACKEND_DIR/.env" ]; then


read -p "SuperAdmin Username: " ADMIN_USER

read -s -p "SuperAdmin Password: " ADMIN_PASS

echo ""


read -p "Panel Port [2096]: " PANEL_PORT


if [ -z "$PANEL_PORT" ]; then
PANEL_PORT=2096
fi


cat > "$BACKEND_DIR/.env" <<EOF

ADMIN_USERNAME=$ADMIN_USER
ADMIN_PASSWORD=$ADMIN_PASS
PORT=$PANEL_PORT

EOF


else

source "$BACKEND_DIR/.env"

fi



echo "[5/6] Initializing Database..."

cd "$BACKEND_DIR"


if [ -f init_db.py ]; then

"$VENV_DIR/bin/python3" init_db.py

fi



echo "[6/6] Creating Systemd Service..."


cat > /etc/systemd/system/lak-panel.service <<EOF

[Unit]

Description=LAK Panel

After=network.target



[Service]

Type=simple

WorkingDirectory=$BACKEND_DIR

Environment=PYTHONUNBUFFERED=1

ExecStart=$VENV_DIR/bin/python3 $BACKEND_DIR/run.py

Restart=always

RestartSec=3

User=root



[Install]

WantedBy=multi-user.target

EOF



systemctl daemon-reload

systemctl enable lak-panel

systemctl restart lak-panel



echo ""

echo "========================================="
echo " LAK PANEL INSTALLED"
echo "========================================="

echo ""

echo "Path:"
echo "$BASE_DIR"

echo ""

echo "Backend:"
echo "$BACKEND_DIR"

echo ""

echo "Service:"
echo "/etc/systemd/system/lak-panel.service"

echo ""

echo "Status:"

systemctl status lak-panel --no-pager -l
