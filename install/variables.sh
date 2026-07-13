#!/bin/bash

########################################
# L-Panel Variables
########################################

APP_NAME="L-Panel"
APP_VERSION="1.0.0"

REPO_URL="https://github.com/mohama226/l-panel.git"
BRANCH="main"

INSTALL_DIR="/opt/l-panel"

CONFIG_DIR="/etc/l-panel"

LOG_DIR="/var/log/l-panel"

BACKUP_DIR="/var/backups/l-panel"

TMP_DIR="/var/lib/l-panel/tmp"

UPLOAD_DIR="/var/lib/l-panel/uploads"

SERVICE_NAME="l-panel"

SYSTEMD_FILE="/etc/systemd/system/l-panel.service"

NGINX_AVAILABLE="/etc/nginx/sites-available/l-panel"

NGINX_ENABLED="/etc/nginx/sites-enabled/l-panel"

PYTHON_VERSION="3.12"

POSTGRES_DB="lpanel"

POSTGRES_USER="lpanel"

POSTGRES_PASSWORD=""

PANEL_PORT="8000"

SUPERADMIN_USER=""

SUPERADMIN_PASS=""
