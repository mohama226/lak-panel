#!/bin/bash
set -e

echo "[+] Installing L-Panel service..."

# Copy service file
cp install/lpanel.service /etc/systemd/system/lpanel.service

# Reload systemd
systemctl daemon-reload

# Enable service on boot
systemctl enable lpanel

# Start service
systemctl restart lpanel

echo "[+] L-Panel service installed and running."
