#!/usr/bin/env bash

source "$(dirname "$0")/variables.sh"


mkdir -p "$CONFIG_DIR"


cat > "$CONFIG_DIR/.env" <<EOF

APP_NAME=L-Panel

DATABASE_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@127.0.0.1/${POSTGRES_DB}

PORT=${PANEL_PORT}

EOF


echo "Environment created."
