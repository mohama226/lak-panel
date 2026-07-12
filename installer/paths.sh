#!/bin/bash


export PANEL_ROOT="/opt/lak-panel"

export BACKEND="$PANEL_ROOT/panel/backend"

export VENV="$BACKEND/venv"

export SYSTEMD_FILE="/etc/systemd/system/lak-panel.service"

export BACKUP_DIR="/opt/lak-panel/backups"

export CONFIG_FILE="/opt/lak-panel/config.env"

export PANEL_PORT="2096"
