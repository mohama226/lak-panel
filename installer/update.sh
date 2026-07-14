#!/bin/bash
set -e

INSTALL_DIR="/opt/l-panel"
BACKUP_DIR="/opt/l-panel-backup"
TMP_DIR="/tmp/l-panel-update"

REPO_ZIP="https://github.com/mohama226/l-panel/archive/refs/heads/main.zip"


echo "=========================="
echo " Updating L-Panel"
echo " ZIP Update Mode"
echo "=========================="


apt install -y curl unzip


echo "[1/4] Backup..."

rm -rf "$BACKUP_DIR"

mkdir -p "$BACKUP_DIR"

cp -a "$INSTALL_DIR" "$BACKUP_DIR/"


echo "[2/4] Download..."

rm -rf "$TMP_DIR"

mkdir -p "$TMP_DIR"

curl -L "$REPO_ZIP" -o "$TMP_DIR/l-panel.zip"


echo "[3/4] Extract..."

unzip -q "$TMP_DIR/l-panel.zip" -d "$TMP_DIR"


echo "[4/4] Replace files..."

# حفظ فایل های مهم
mkdir -p /tmp/l-panel-save

[ -d "$INSTALL_DIR/data" ] && cp -a "$INSTALL_DIR/data" /tmp/l-panel-save/
[ -d "$INSTALL_DIR/config" ] && cp -a "$INSTALL_DIR/config" /tmp/l-panel-save/


rm -rf "$INSTALL_DIR"

mv "$TMP_DIR/l-panel-main" "$INSTALL_DIR"


# برگرداندن دیتا

[ -d /tmp/l-panel-save/data ] && cp -a /tmp/l-panel-save/data "$INSTALL_DIR/"
[ -d /tmp/l-panel-save/config ] && cp -a /tmp/l-panel-save/config "$INSTALL_DIR/"


echo "Fixing permissions..."

chmod +x /opt/l-panel/installer/*.sh
chmod +x /opt/l-panel/scripts/*

systemctl daemon-reload


echo "Restarting services..."

systemctl daemon-reload || true

systemctl restart l-panel.service 2>/dev/null || true


echo ""
echo "=========================="
echo " Update Finished"
echo "=========================="
