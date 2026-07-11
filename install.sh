#!/bin/bash
set -e

REPO="https://github.com/mohama226/lak-panel.git"
DIR="/opt/lak-panel"

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

echo "================================="
echo " LAK PANEL INSTALL"
echo "================================="

read -rp "Panel Port [8000]: " PANEL_PORT
PANEL_PORT=${PANEL_PORT:-8000}

read -rp "Superadmin Username: " ADMIN_USER

while true
do
    read -rsp "Superadmin Password: " ADMIN_PASS
    echo
    read -rsp "Confirm Password: " ADMIN_PASS2
    echo
    if [ "$ADMIN_PASS" = "$ADMIN_PASS2" ]; then
        break
    fi
    echo "Passwords do not match"
done

# نصب پکیج‌های مورد نیاز
apt-get update
apt-get install -y \
    git \
    curl \
    wget \
    unzip \
    python3 \
    python3-pip \
    python3-venv

# حذف پوشه قبلی اگر وجود داشت
if [ -d "$DIR" ]; then
    rm -rf "$DIR"
fi

echo "Downloading LAK Panel..."

cd /opt
rm -rf "$DIR"
rm -rf /opt/lak-panel-main
rm -f /tmp/lak-panel.zip

# دانلود با wget (اولویت)
if wget -q -O /tmp/lak-panel.zip https://github.com/mohama226/lak-panel/archive/refs/heads/main.zip; then
    echo "Download successful with wget"
else
    echo "wget failed, trying curl..."
    curl -L -s -o /tmp/lak-panel.zip https://github.com/mohama226/lak-panel/archive/refs/heads/main.zip
fi

unzip -q /tmp/lak-panel.zip -d /opt
mv /opt/lak-panel-main "$DIR"
rm -f /tmp/lak-panel.zip

cd "$DIR/backend"

chmod +x "$DIR/install/setup_config.sh"

python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "Creating environment..."
cat > .env <<EOF
PORT=$PANEL_PORT
SUPERADMIN_USERNAME=$ADMIN_USER
SUPERADMIN_PASSWORD=$ADMIN_PASS
EOF

echo "Creating systemd service"
cat > /etc/systemd/system/lak-panel.service <<EOF
[Unit]
Description=LAK Panel
After=network.target

[Service]
WorkingDirectory=/opt/lak-panel/backend
ExecStart=/opt/lak-panel/backend/venv/bin/python3 main.py --port $PANEL_PORT
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable lak-panel
systemctl restart lak-panel

chmod +x "$DIR/scripts/menu.sh"

cat > /usr/local/bin/lak-panel <<EOF
#!/bin/bash
bash /opt/lak-panel/scripts/menu.sh
EOF

chmod +x /usr/local/bin/lak-panel

IP=$(hostname -I | awk '{print $1}')

echo
echo "================================="
echo " LAK PANEL INSTALLED SUCCESSFULLY"
echo
echo "URL:   http://$IP:$PANEL_PORT"
echo "Admin: $ADMIN_USER"
echo
echo "You can run 'lak-panel' command for management menu."
echo "================================="
