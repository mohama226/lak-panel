#!/bin/bash

source /opt/lak-panel/scripts/common.sh

echo
read -p "Are you sure? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    exit 0
fi

systemctl stop $SERVICE_NAME

systemctl disable $SERVICE_NAME

rm -f $SERVICE_FILE

systemctl daemon-reload

rm -rf $INSTALL_DIR

rm -f /usr/local/bin/lak-panel

echo

echo "LAK Panel removed successfully."
