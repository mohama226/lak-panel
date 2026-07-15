#!/bin/bash
set -e

echo "Installing L-Panel..."

# بررسی اجرای به عنوان root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root"
    exit 1
fi

# Update and install dependencies
apt update
apt install -y curl unzip python3 python3-pip python3-venv postgresql postgresql-contrib libpq-dev

# Start and enable PostgreSQL
echo "Starting PostgreSQL service..."
systemctl start postgresql.service
systemctl enable postgresql.service

# Create PostgreSQL database and user (هماهنگ با setup_database.sh)
echo "Creating PostgreSQL database..."
sudo -u postgres psql <<EOF
CREATE USER lpanel_user WITH PASSWORD 'lpanel_password';
CREATE DATABASE lpanel OWNER lpanel_user;
GRANT ALL PRIVILEGES ON DATABASE lpanel TO lpanel_user;
EOF

# متوقف کردن سرویس قبلی (در صورت وجود)
systemctl stop l-panel 2>/dev/null || true

# پاک‌سازی و دانلود آخرین نسخه
rm -rf /opt/l-panel
mkdir -p /opt
cd /tmp
echo "Downloading L-Panel..."
curl -L -o l-panel.zip \
https://github.com/mohama226/l-panel/archive/refs/heads/main.zip

unzip -o l-panel.zip
mv l-panel-main /opt/l-panel
rm l-panel.zip

# ========================
# اجرای setup_database.sh
# ========================
echo "Running database setup..."
cd /opt/l-panel
bash installer/setup_database.sh

# ========================
# ایجاد محیط مجازی پایتون
# ========================
echo "Creating Python virtual environment..."
cd /opt/l-panel
python3 -m venv venv
/opt/l-panel/venv/bin/pip install --upgrade pip
/opt/l-panel/venv/bin/pip install -r requirements.txt

echo "Initializing database..."
/opt/l-panel/venv/bin/python3 -c "
from backend import create_app
app = create_app()
print('Database initialized successfully')
"

# ========================
# تنظیم مجوزها و symlink
# ========================
echo "Setting permissions and creating command..."
chmod +x /opt/l-panel/installer/*.sh
chmod +x /opt/l-panel/scripts/*
ln -sf /opt/l-panel/scripts/l-panel /usr/local/bin/l-panel

# ========================
# کپی فایل سرویس systemd
# ========================
echo "Setting up systemd service..."
cp /opt/l-panel/installer/systemd/l-panel.service /etc/systemd/system/l-panel.service

# ========================
# راه‌اندازی سرویس
# ========================
systemctl daemon-reload
systemctl enable l-panel
systemctl restart l-panel

echo "L-Panel Installed Successfully!"
echo "=================================="
echo "Command: l-panel"
echo "Service: systemctl status l-panel"
echo "Web Panel should be available shortly (check port in config)"
