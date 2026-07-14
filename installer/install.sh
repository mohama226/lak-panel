#!/bin/bash
set -e

APP_NAME="l-panel"
INSTALL_DIR="/opt/l-panel"
TMP_DIR="/tmp/l-panel-install"

REPO_ZIP="https://github.com/mohama226/l-panel/archive/refs/heads/main.zip"

echo "=========================="
echo " Installing L-Panel"
echo " ZIP Installer Mode"
echo "=========================="

apt update

apt install -y curl unzip python3 python3-pip python3-venv

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo "[1/5] Downloading package..."

curl -L "$REPO_ZIP" -o "$TMP_DIR/l-panel.zip"


echo "[2/5] Extracting..."

unzip -q "$TMP_DIR/l-panel.zip" -d "$TMP_DIR"


echo "[3/5] Installing files..."

rm -rf "$INSTALL_DIR"

mv "$TMP_DIR/l-panel-main" "$INSTALL_DIR"


echo "[4/5] Installing python environment..."

cd "$INSTALL_DIR"

python3 -m venv venv

source venv/bin/activate

if [ -f requirements.txt ]; then
    pip install --upgrade pip
    pip install -r requirements.txt
fi

deactivate


echo "[5/5] Creating command..."

cat > /usr/local/bin/l-panel <<EOF
#!/bin/bash
bash $INSTALL_DIR/installer/menu.sh
EOF

chmod +x /usr/local/bin/l-panel


echo ""
echo "=========================="
echo " L-Panel Installed"
echo " Type: l-panel"
echo "=========================="
