#!/bin/bash
set -e

echo "[+] Installing systemd service..."

cp install/lpanel.service /etc/systemd/system/lpanel.service
systemctl daemon-reload
systemctl enable lpanel
systemctl restart lpanel

echo "[+] L-Panel service installed and running."
