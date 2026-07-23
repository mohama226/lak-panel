#!/usr/bin/env bash

set -e

BASE_DIR="/opt/l-panel"

echo "Installing L-Panel Backend"


cd "$BASE_DIR/backend"


if [ ! -d "venv" ]; then

    echo "Creating Python venv"

    python3 -m venv venv

fi


source venv/bin/activate


echo "Installing requirements"

pip install --upgrade pip

pip install -r requirements.txt



echo "Installing systemd service"


cat > /etc/systemd/system/l-panel-backend.service <<EOF
[Unit]
Description=L-Panel Backend
After=network.target


[Service]
Type=simple
User=root

WorkingDirectory=/opt/l-panel/backend

Environment="PATH=/opt/l-panel/backend/venv/bin"

ExecStart=/opt/l-panel/backend/venv/bin/gunicorn \
main:app \
--bind 127.0.0.1:8000 \
--workers 3


Restart=always


[Install]
WantedBy=multi-user.target
EOF



systemctl daemon-reload

systemctl enable l-panel-backend

systemctl restart l-panel-backend


echo "Backend installed successfully"
