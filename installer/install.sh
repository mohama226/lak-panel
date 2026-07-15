#!/bin/bash

set -e

echo "Installing L-Panel..."

apt update
apt install -y curl unzip python3 python3-pip python3-venv

# متوقف کردن سرویس قبلی (در صورت وجود)
systemctl stop l-panel 2>/dev/null || true

rm -rf /opt/l-panel

mkdir -p /opt

cd /tmp

curl -L -o l-panel.zip \
https://github.com/mohama226/l-panel/archive/refs/heads/main.zip

unzip -o l-panel.zip

mv l-panel-main /opt/l-panel

# ========================
# اجرای setup_database.sh قبل از ساخت venv
# ========================
echo "Running database setup..."
cd /opt/l-panel
bash installer/setup_database.sh

# ========================
# ایجاد محیط مجازی پایتون
# ========================
echo "Creating Python environment..."

cd /opt/l-panel

python3 -m venv venv

/opt/l-panel/venv/bin/pip install --upgrade pip
/opt/l-panel/venv/bin/pip install -r requirements.txt

echo "Initializing database..."

cd /opt/l-panel

/opt/l-panel/venv/bin/python3 -c "
from backend import create_app
app=create_app()
print('Database initialized')
"
# ========================

chmod +x /opt/l-panel/installer/*.sh
chmod +x /opt/l-panel/scripts/*

ln -sf /opt/l-panel/scripts/l-panel /usr/local/bin/l-panel

echo "L-Panel Installed"

# اجرای دستور اصلی l-panel (احتمالاً سرویس را هم تنظیم می‌کند)
l-panel

# ========================
# تنظیم و راه‌اندازی سرویس systemd
# ========================
echo "Setting up and starting L-Panel service..."

# بررسی وجود python در venv
if [ ! -f /opt/l-panel/venv/bin/python3 ]; then
    echo "Error: Python venv not properly created at /opt/l-panel/venv/bin/python3"
    exit 1
fi

# اطمینان از فعال بودن PostgreSQL
if ! systemctl is-active --quiet postgresql.service; then
    echo "Starting and enabling PostgreSQL service..."
    systemctl start postgresql.service
    systemctl enable postgresql.service
fi

# اجرای مجدد setup_database برای اطمینان از ساخته شدن دیتابیس
echo "Ensuring database is ready..."
cd /opt/l-panel
bash installer/setup_database.sh

systemctl daemon-reload
systemctl enable l-panel
systemctl restart l-panel

echo "L-Panel service has been enabled and started."
