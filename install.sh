#!/usr/bin/env bash

set -e

echo "================================="
echo " L-PANEL INSTALLER"
echo "================================="

apt update
apt install -y python3 python3-venv python3-pip git

PROJECT_DIR="/opt/l-panel"

if [ ! -d "$PROJECT_DIR" ]; then
    git clone https://github.com/USERNAME/l-panel.git "$PROJECT_DIR"
fi

cd "$PROJECT_DIR"

python3 -m venv venv

source venv/bin/activate

pip install --upgrade pip

pip install -r requirements.txt

chmod +x run.py

echo ""
echo "Installation Finished."
echo ""
echo "Run:"
echo ""
echo "cd $PROJECT_DIR"
echo "source venv/bin/activate"
echo "python run.py"
