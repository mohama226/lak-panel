#!/bin/bash
set -e
echo "Installing L-Panel..."

# Update and install dependencies including PostgreSQL
apt update
apt install -y curl unzip python3 python3-pip python3-venv postgresql postgresql-contrib

# Start and enable PostgreSQL
echo "Starting PostgreSQL service..."
systemctl start postgresql.service
systemctl enable postgresql.service

# Create PostgreSQL database and user
echo "Creating PostgreSQL database and user..."
sudo -u postgres psql <<EOF
CREATE USER lpanel_user WITH PASSWORD 'lpanel_pass';
CREATE DATABASE lpanel OWNER lpanel_user;
GRANT ALL PRIVILEGES ON DATABASE lpanel TO lpanel_user;
EOF

# متوقف کردن سرویس قبلی (در صورت وجود)
systemctl stop l-panel 2>/dev/null || true

# حذف نسخه قبلی و دانلود نسخه جدید
rm -rf /opt/l-panel
mkdir -p /opt
cd /tmp

echo "Downloading L-Panel..."
curl -L -o l-panel.zip \
https://github.com/mohama226/l-panel/archive/refs/heads/main.zip

unzip -o l-panel.zip
mv l-panel-main /opt/l-panel

# ========================
# تنظیم مجوزها (ابتدا)
# ========================
echo "Setting permissions..."
chmod +x /opt/l-panel/installer/*.sh
chmod +x /opt/l-panel/scripts/*
chmod +x /opt/l-panel/scripts/l-panel

# ========================
# اجرای setup_database.sh قبل از ساخت venv
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
cd /opt/l-panel
/opt/l-panel/venv/bin/python3 -c "
from backend import create_app
app = create_app()
print('Database initialized successfully')
"

# ایجاد symlink
echo "Creating command symlink..."
ln -sf /opt/l-panel/scripts/l-panel /usr/local/bin/l-panel

# اجرای دستور اصلی l-panel (احتمالاً برای تنظیم اولیه)
echo "Running initial l-panel command..."
l-panel || echo "Warning: l-panel command returned non-zero exit code (may be normal)."

# ========================
# تنظیم نهایی مجوزها (دوباره برای اطمینان)
# ========================
echo "Finalizing permissions..."
chmod +x /opt/l-panel/scripts/l-panel
chmod +x /opt/l-panel/installer/*.sh
chmod +x /opt/l-panel/scripts/*

# ========================
# تنظیم و راه‌اندازی سرویس systemd
# ========================
echo "Setting up systemd service..."

# بررسی وجود python در venv
if [ ! -f /opt/l-panel/venv/bin/python3 ]; then
    echo "Error: Python venv not properly created at /opt/l-panel/venv/bin/python3"
    exit 1
fi

# اجرای مجدد setup_database برای اطمینان
echo "Ensuring database is ready..."
cd /opt/l-panel
bash installer/setup_database.sh

systemctl daemon-reload
systemctl enable l-panel
systemctl restart l-panel

echo "=========================================="
echo "L-Panel Installed Successfully!"
echo "Service is running."
echo "You can manage it with: systemctl status l-panel"
echo "=========================================="
