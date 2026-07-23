#!/bin/bash

set -e

echo "=============================="
echo " L-PANEL PHP INSTALLER"
echo "=============================="

read -p "Super Admin Username: " ADMIN_USER
read -s -p "Super Admin Password: " ADMIN_PASS
echo

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



echo "Downloading L-PANEL"


rm -rf /var/www/html/l-panel


git clone https://github.com/mohama226/l-panel.git /var/www/html/l-panel



mkdir -p /var/www/html/l-panel/storage



echo "Creating database"


mysql <<EOF

CREATE DATABASE lpanel;

CREATE USER 'lpanel'@'localhost'
IDENTIFIED BY 'lpanel123';

GRANT ALL PRIVILEGES ON lpanel.*
TO 'lpanel'@'localhost';

FLUSH PRIVILEGES;

EOF



mysql lpanel < /var/www/html/l-panel/database/schema.sql



HASH=$(php -r 'echo password_hash($argv[1], PASSWORD_DEFAULT);' "$ADMIN_PASS")

mysql lpanel <<EOF

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



echo ""
echo "=============================="
echo " L-PANEL INSTALLED"
echo ""
echo "Open:"
echo "http://SERVER-IP:$PORT"
echo "=============================="
