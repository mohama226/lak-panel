#!/usr/bin/env bash


mkdir -p /etc/l-panel


cat > /etc/l-panel/.env <<EOF

DATABASE_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost/${POSTGRES_DB}

PANEL_PORT=${PANEL_PORT}

APP_NAME=L-Panel

EOF


green "Environment created."
