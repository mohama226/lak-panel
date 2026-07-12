#!/bin/bash

set -e

BASE="/opt/lak-panel"

echo "================================="
echo "      LAK PANEL INSTALLER"
echo "================================="

if [ "$EUID" -ne 0 ]; then
    echo "Run as root"
    exit 1
fi


echo "[1/8] Installing packages..."

apt update

apt install -y \
python3 \
python3-pip \
python3-venv \
git \
curl \
nginx


echo "[2/8] Creating directories..."

mkdir -p $BASE/backend
mkdir -p $BASE/frontend/templates
mkdir -p $BASE/frontend/static
mkdir -p $BASE/scripts
mkdir -p $BASE/systemd
mkdir -p $BASE/backups
mkdir -p $BASE/logs
mkdir -p $BASE/data


echo "[3/8] Creating python venv..."

python3 -m venv $BASE/backend/venv


echo "[4/8] Installing backend packages..."

$BASE/backend/venv/bin/pip install --upgrade pip

if [ -f "$BASE/backend/requirements.txt" ]; then
    $BASE/backend/venv/bin/pip install -r $BASE/backend/requirements.txt
fi


echo "[5/8] Creating service..."

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


echo "[6/8] Creating command..."

cat > /usr/local/bin/lak-panel <<EOF
#!/bin/bash
exec $BASE/scripts/menu.sh
EOF

chmod +x /usr/local/bin/lak-panel


echo "[7/8] Reload systemd..."

systemctl daemon-reload


echo "[8/8] Enable service..."

systemctl enable lak-panel


echo
echo "================================="
echo " INSTALL FINISHED"
echo "================================="

echo "Run:"
echo "lak-panel"
