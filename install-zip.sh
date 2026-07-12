#!/bin/bash

set -e

BASE="/opt/lak-panel"

echo "======================================"
echo "       LAK PANEL ZIP INSTALLER"
echo "======================================"

rm -rf /tmp/lak-panel-main
rm -rf $BASE

cd /opt

wget -O lak-panel.zip https://github.com/mohama226/lak-panel/archive/refs/heads/main.zip

unzip -o lak-panel.zip

mv lak-panel-main $BASE


echo "Project installed:"
echo "$BASE"


chmod +x $BASE/install.sh

bash $BASE/install.sh
