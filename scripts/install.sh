#!/usr/bin/env bash
set -e

echo "[l-panel] شروع نصب..."

REPO_USER="mohama226"
REPO_NAME="l-panel"
INSTALL_DIR="/opt/${REPO_NAME}"
BIN_PATH="/usr/local/bin/l-panel"

echo "[l-panel] نصب پیش‌نیازها..."

sudo dnf install -y python3 python3-pip unzip curl

# نصب virtualenv از pip (سازگار با AlmaLinux)
if ! command -v virtualenv &> /dev/null; then
    echo "[l-panel] virtualenv پیدا نشد، نصب می‌کنیم..."
    sudo pip3 install virtualenv
fi

TMP_ZIP="/tmp/${REPO_NAME}.zip"
ZIP_URL="https://github.com/${REPO_USER}/${REPO_NAME}/archive/refs/heads/main.zip"

echo "[l-panel] دانلود ZIP از گیت‌هاب..."
curl -L "$ZIP_URL" -o "$TMP_ZIP"

echo "[l-panel] استخراج فایل‌ها..."
sudo rm -rf "$INSTALL_DIR"
sudo mkdir -p "$INSTALL_DIR"
sudo unzip -q "$TMP_ZIP" -d /opt
sudo mv "/opt/${REPO_NAME}-main" "$INSTALL_DIR"

echo "[l-panel] ساخت محیط مجازی..."
cd "$INSTALL_DIR"
virtualenv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "[l-panel] ساخت دستور اجرایی..."
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
    0)
        exit 0
        ;;
esac
EOF

sudo chmod +x "$BIN_PATH"

echo "[l-panel] نصب کامل شد!"
echo "برای اجرا بنویسید: l-panel"
