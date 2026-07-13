#!/usr/bin/env bash


source "$(dirname "$0")/variables.sh"



cat > /etc/systemd/system/l-panel.service <<EOF


[Unit]

Description=L-Panel VPN Management Panel

After=network.target



[Service]

WorkingDirectory=${INSTALL_DIR}/backend

EnvironmentFile=${CONFIG_DIR}/.env

ExecStart=${INSTALL_DIR}/backend/venv/bin/gunicorn main:app \
-k uvicorn.workers.UvicornWorker \
--bind 0.0.0.0:${PANEL_PORT}


Restart=always



[Install]

WantedBy=multi-user.target


EOF



systemctl daemon-reload


systemctl enable l-panel


systemctl restart l-panel



echo "L-Panel service created."
