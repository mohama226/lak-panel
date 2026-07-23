#!/usr/bin/env bash

set -e

BASE="/opt/l-panel"

echo "== Installing Backend =="


cd "$BASE/backend"


if ! command -v python3 >/dev/null; then

    echo "Python3 not found"

    exit 1

fi


if [ ! -d "venv" ]; then

    python3 -m venv venv

fi


source venv/bin/activate


pip install --upgrade pip

pip install -r requirements.txt



cat > /etc/systemd/system/l-panel-backend.service <<EOF

[Unit]
Description=L-Panel Backend
After=network.target


[Service]
Type=simple

User=root

WorkingDirectory=/opt/l-panel/backend

Environment="PATH=/opt/l-panel/backend/venv/bin"

ExecStart=/opt/l-panel/backend/venv/bin/gunicorn main:app --bind 127.0.0.1:8000 --workers 3

Restart=always

RestartSec=5


[Install]
WantedBy=multi-user.target

EOF



systemctl daemon-reload

systemctl enable l-panel-backend

systemctl restart l-panel-backend


echo "Backend Ready"
