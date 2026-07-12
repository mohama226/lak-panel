#!/bin/bash

APP_NAME="LAK Panel"

SERVICE_NAME="lak-panel"

INSTALL_DIR="/opt/lak-panel"

REPO_URL="https://github.com/mohama226/lak-panel.git"

BACKEND_DIR="$INSTALL_DIR/backend"

VENV_DIR="$BACKEND_DIR/venv"

SERVICE_FILE="/etc/systemd/system/lak-panel.service"

BACKEND_PORT="8000"

PANEL_PORT="2096"
