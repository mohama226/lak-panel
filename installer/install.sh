#!/bin/bash
set -e
echo "Installing L-Panel..."

# بررسی اجرای به عنوان root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root"
    exit 1
fi

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

# Source the library
source /opt/l-panel/installer/lib.sh

# Install dependencies using the function
echo "Installing dependencies..."
install_dependencies

# ========================
# Configuring PostgreSQL (بهبود یافته)
# ========================
echo "Configuring PostgreSQL..."
sudo -u postgres psql <<EOF
DO \$\$
BEGIN
IF NOT EXISTS (
SELECT FROM pg_roles WHERE rolname='lpanel_user'
) THEN
CREATE ROLE lpanel_user LOGIN PASSWORD 'lpanel_pass';
ELSE
ALTER ROLE lpanel_user PASSWORD 'lpanel_pass';
END IF;
END
\$\$;
SELECT 'CREATE DATABASE lpanel OWNER lpanel_user'
WHERE NOT EXISTS (
SELECT FROM pg_database WHERE datname='lpanel'
)
\gexec
GRANT ALL PRIVILEGES ON DATABASE lpanel TO lpanel_user;
EOF

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

# ========================
# تنظیم مجوزها و symlink
# ========================
echo "Setting permissions and creating command..."
ln -sf /opt/l-panel/scripts/l-panel /usr/local/bin/l-panel

# ========================
# کپی فایل سرویس systemd
# ========================
echo "Setting up systemd service..."
cp /opt/l-panel/installer/systemd/l-panel.service /etc/systemd/system/l-panel.service

# ========================
# Testing database connection (قبل از راه‌اندازی سرویس)
# ========================
echo "Testing database connection..."
PGPASSWORD=lpanel_pass psql \
-h localhost \
-U lpanel_user \
-d lpanel \
-c "SELECT 1;" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Database connection failed"
    exit 1
fi
echo "Database connection successful."

echo "L-Panel Installed Successfully!"
echo "=================================="
echo "Command: l-panel"
echo "Service: systemctl status l-panel"
echo "Web Panel should be available shortly (check port in config)"

bash /opt/l-panel/installer/post_install.sh

# ========================
# systemd + migration
# ========================
systemctl daemon-reload

cd /opt/l-panel
/opt/l-panel/venv/bin/python3 -m backend.database.migrate

systemctl enable l-panel
systemctl restart l-panel
