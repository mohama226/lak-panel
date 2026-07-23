#!/usr/bin/env bash

set -e


BASE="/opt/l-panel/backend"


echo "=============================="
echo " Installing L-Panel Backend"
echo "=============================="


cd "$BASE"



echo "[1/5] Installing python tools"


dnf install -y python3 python3-pip python3-devel gcc


echo "[2/5] Creating virtual environment"



if [ ! -d "venv" ]; then

    python3 -m venv venv

fi



source venv/bin/activate



echo "[3/5] Installing requirements"


pip install --upgrade pip

pip install gunicorn

pip install -r requirements.txt



echo "[4/5] Creating systemd service"



cat > /etc/systemd/system/l-panel-backend.service <<EOF

[Unit]

Description=L-Panel Backend

After=network.target



[Service]

Type=simple

User=root

WorkingDirectory=/opt/l-panel/backend

Environment="PATH=/opt/l-panel/backend/venv/bin"

ExecStart=/opt/l-panel/backend/venv/bin/gunicorn wsgi:app --bind 127.0.0.1:8000 --workers 3


Restart=always

RestartSec=5



[Install]

WantedBy=multi-user.target

EOF



echo "[5/5] Starting service"


systemctl daemon-reload

systemctl enable l-panel-backend

systemctl restart l-panel-backend



echo "Backend installation completed"
