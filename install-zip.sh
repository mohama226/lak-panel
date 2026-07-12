#!/bin/bash

set -e

BASE="/opt/lak-panel"

echo "======================================"
echo "       LAK PANEL ZIP INSTALLER"
echo "======================================"


rm -rf $BASE

mkdir -p /opt


cd /opt


echo "Downloading LAK Panel..."

wget -O lak-panel.zip \
https://github.com/mohama226/lak-panel/archive/refs/heads/main.zip


echo "Extracting..."

unzip -o lak-panel.zip


mv lak-panel-main lak-panel


rm lak-panel.zip


echo ""
echo "Project installed:"
echo "$BASE"


bash $BASE/install.sh
