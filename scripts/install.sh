#!/usr/bin/env bash
set -e

REPO_USER="mohama226"
REPO_NAME="l-panel"
INSTALL_DIR="/opt/${REPO_NAME}"
BIN_PATH="/usr/local/bin/l-panel"

echo "[l-panel] نصب در حال انجام..."

sudo apt update
sudo apt install -y python3 python3-venv python3-pip unzip curl

TMP_ZIP="/tmp/${REPO_NAME}.zip"
curl -L "https://github.com/${REPO_USER}/${REPO_NAME}/archive/refs/heads/main.zip" -o "$TMP_ZIP"

sudo rm -rf "$INSTALL_DIR"
sudo mkdir -p "$INSTALL_DIR"
sudo unzip -q "$TMP_ZIP" -d /opt
sudo mv "/opt/${REPO_NAME}-main" "$INSTALL_DIR"

cd "$INSTALL_DIR"
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

sudo tee "$BIN_PATH" >/dev/null <<'EOF'
#!/usr/bin/env bash
INSTALL_DIR="/opt/l-panel"

echo "=== l-panel ==="
echo "1) اجرای پنل"
echo "2) آپدیت"
echo "0) خروج"
read -p "انتخاب: " c

case "$c" in
    1)
        cd "$INSTALL_DIR"
        source venv/bin/activate
        uvicorn app.main:app --host 0.0.0.0 --port 8000
        ;;
    2)
        TMP_ZIP="/tmp/l-panel.zip"
        curl -L "https://github.com/mohama226/l-panel/archive/refs/heads/main.zip" -o "$TMP_ZIP"
        rm -rf "$INSTALL_DIR"
        mkdir -p "$INSTALL_DIR"
        unzip -q "$TMP_ZIP" -d /opt
        mv "/opt/l-panel-main" "$INSTALL_DIR"
        cd "$INSTALL_DIR"
        source venv/bin/activate
        pip install -r requirements.txt
        echo "آپدیت انجام شد."
        ;;
esac
EOF

sudo chmod +x "$BIN_PATH"

echo "[l-panel] نصب کامل شد. برای اجرا بنویسید: l-panel"
