#!/bin/bash

echo "Updating L-Panel..."

echo "Coming Soon"

# ایجاد فایل ocserv.info با فرمت جدید و صحیح
cat > /etc/l-panel/ocserv.info <<EOF
VERSION="${VERSION}"
PORT="${PORT}"
CONFIG="${CONFIG}"
INSTALL_DATE="$(date '+%F %T')"
STATUS="installed"
EOF

# بخش جدید که خواستی قبل از پایان فایل اضافه شود
echo "Updating backend..."

bash /opt/l-panel/scripts/setup-backend.sh

# بخش جدیدی که گفتی در آخر فایل اضافه کنم
echo "Setting up Nginx..."

bash /opt/l-panel/scripts/setup-nginx.sh

# بخش جدیدی که گفتی قبل از restart اضافه کنم
echo "Testing backend..."

bash /opt/l-panel/scripts/test-backend.sh

# اجرای دوباره backend بعد از تست
bash /opt/l-panel/scripts/setup-backend.sh

echo "Rebuilding backend service..."

bash /opt/l-panel/scripts/setup-backend.sh

systemctl daemon-reload

systemctl restart l-panel-backend
