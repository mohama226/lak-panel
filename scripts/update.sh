#!/bin/bash

set -e

source /opt/lak-panel/scripts/common.sh

echo "Updating LAK Panel..."

cd "$INSTALL_DIR"

git pull

cd "$BACKEND_DIR"

source venv/bin/activate

pip install -r requirements.txt

systemctl restart $SERVICE_NAME

echo
echo "Update completed successfully."
