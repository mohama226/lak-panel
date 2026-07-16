#!/bin/bash
set -e

PROJECT_DIR=$(dirname "$(readlink -f "$0")")
cd "$PROJECT_DIR/.."

echo "[+] Updating l-panel..."
git pull
pip3 install -r requirements.txt

date "+%Y-%m-%d %H:%M:%S" > last_update.txt

echo "[+] Updated."
