#!/bin/bash

set -e

echo "======================================"
echo "       LAK PANEL ZIP INSTALLER"
echo "======================================"

BASE="/opt/lak-panel"

apt update

apt install -y wget unzip python3 python3-venv python3-pip


cd /opt


rm -rf lak-panel


echo "Downloading LAK PANEL ZIP..."


wget -O lak-panel.zip \
https://github.com/mohama226/lak-panel/archive/refs/heads/main.zip


echo "Extracting..."


unzip -o lak-panel.zip


mv lak-panel-main lak-panel


echo "Project installed:"
echo "$BASE"


cd $BASE/backend


python3 -m venv venv


source venv/bin/activate


pip install --upgrade pip


pip install -r requirements.txt


echo "Creating service..."


cp $BASE/systemd/lak-panel.service \
/etc/systemd/system/lak-panel.service


systemctl daemon-reload


systemctl enable lak-panel


systemctl restart lak-panel


echo ""
echo "======================================"
echo " LAK PANEL READY"
echo " PATH:"
echo "$BASE"
echo "======================================"
