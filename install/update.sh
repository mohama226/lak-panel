#!/bin/bash
set -e

cd /opt/l-panel

echo "[+] Updating l-panel..."
git pull
pip3 install -r requirements.txt

date "+%Y-%m-%d %H:%M:%S" > last_update.txt

echo "[+] Updated."
