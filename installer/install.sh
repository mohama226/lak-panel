#!/bin/bash
set -e

APP_DIR="/opt/l-panel"

apt update
apt install -y git python3 python3-pip python3-venv

rm -rf "$APP_DIR"

git clone https://github.com/mohama226/l-panel.git "$APP_DIR"

cd "$APP_DIR"

python3 -m venv venv
source venv/bin/activate

pip install --upgrade pip
pip install -r requirements.txt

python3 run.py
