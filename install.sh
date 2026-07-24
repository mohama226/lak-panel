#!/bin/bash

set -e

echo "=============================="
echo " L-PANEL PHP INSTALLER"
echo "=============================="

read -p "Super Admin Username: " ADMIN_USER

# اصلاح بخش گرفتن پسورد (نباید خالی باشد)
while [ -z "$ADMIN_PASS" ]
do
    read -s -p "Super Admin Password: " ADMIN_PASS
    echo

    if [ -z "$ADMIN_PASS" ]; then
        echo "Password cannot be empty"
    fi
done

read -p "Panel Port [8080]: " PORT
PORT=${PORT:-8080}

if [ -f /etc/debian_version ]; then

    echo "Ubuntu/Debian detected"

    apt update

    apt install -y \
        apache2 \
        php \
        php-mysql \
        mariadb-server \
        git \
        curl \
        unzip

    systemctl enable apache2
    systemctl enable mariadb

    systemctl start apache2
    systemctl start mariadb

elif [ -f /etc/redhat-release ]; then

    echo "AlmaLinux detected"

    dnf install -y \
        httpd \
        php \
        php-mysqlnd \
        mariadb-server \
        git \
        curl \
        unzip

    systemctl enable httpd
    systemctl enable mariadb

    systemctl start httpd
    systemctl start mariadb

fi

echo "Configuring ocserv permissions"

if [ -f /etc/ocserv/ocpasswd ]; then
    chmod 640 /etc/ocserv/ocpasswd
    chown apache:apache /etc/ocserv/ocpasswd
fi

echo "Downloading L-PANEL"

rm -rf /var/www/html/l-panel

git clone https://github.com/mohama226/l-panel.git /var/www/html/l-panel

mkdir -p /var/www/html/l-panel/storage

echo "Creating database"

mysql <<EOF
DROP DATABASE IF EXISTS lpanel;

CREATE DATABASE lpanel;

CREATE USER IF NOT EXISTS 'lpanel'@'localhost'
IDENTIFIED BY 'lpanel123';

GRANT ALL PRIVILEGES ON lpanel.*
TO 'lpanel'@'localhost';

FLUSH PRIVILEGES;
EOF

mysql lpanel < /var/www/html/l-panel/database/schema.sql

HASH=$(php -r 'echo password_hash($argv[1], PASSWORD_DEFAULT);' "$ADMIN_PASS")

mysql lpanel <<EOF
DELETE FROM admins;

INSERT INTO admins
(username,password,role)
VALUES
('$ADMIN_USER','$HASH','superadmin');
EOF

if [ -f /etc/debian_version ]; then

    cat >/etc/apache2/sites-available/lpanel.conf <<EOF
Listen $PORT

<VirtualHost *:$PORT>
    DocumentRoot /var/www/html/l-panel/public

    <Directory /var/www/html/l-panel/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

    a2ensite lpanel.conf
    systemctl restart apache2

else

    cat >/etc/httpd/conf.d/lpanel.conf <<EOF
Listen $PORT

<VirtualHost *:$PORT>
    DocumentRoot /var/www/html/l-panel/public

    <Directory /var/www/html/l-panel/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

    systemctl restart httpd

fi

# 🔥 نصب Agent
echo "Installing L-PANEL Agent..."

mkdir -p /usr/local/bin

cp /var/www/html/l-panel/agent/lpanel-agent.php \
/usr/local/bin/lpanel-agent.php

chmod +x /usr/local/bin/lpanel-agent.php

cp /var/www/html/l-panel/systemd/lpanel-agent.service \
/etc/systemd/system/lpanel-agent.service

systemctl daemon-reload
systemctl enable lpanel-agent
systemctl restart lpanel-agent

echo "L-PANEL Agent Installed"

# 🔥 نصب CLI Manager
echo "Installing CLI Manager"

mkdir -p /usr/local/bin

cp /var/www/html/l-panel/cli/l-panel /usr/local/bin/l-panel

chmod +x /usr/local/bin/l-panel

echo "Command installed:"
echo "Type: l-panel"

# 🔥 بخش جدید: کپی اسکریپت‌ها
echo "Copying scripts..."

mkdir -p /var/www/html/l-panel/scripts

chmod +x /var/www/html/l-panel/scripts/install-ocserv.sh

echo "Scripts installed"

# 🔥 اجرای post-install اصلی پنل
if [ -f /var/www/html/l-panel/scripts/post-install.sh ]; then
    echo "Running post-install..."
    cd /var/www/html/l-panel
    bash scripts/post-install.sh
else
    echo "post-install.sh not found — skipping"
fi

# 🔥 اجرای OCServ post-install
echo "Running OCServ post installation..."
bash /var/www/html/l-panel/scripts/post-install.sh

echo ""
echo "=============================="
echo " L-PANEL INSTALLED"
echo ""
echo "Open:"
echo "http://SERVER-IP:$PORT"
echo "=============================="
