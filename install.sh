#!/bin/bash

set -e

echo "
==============================
 L-PANEL PHP INSTALLER
==============================
"

read -p "Super Admin Username: " ADMIN_USER
read -s -p "Super Admin Password: " ADMIN_PASS
echo

read -p "Panel Port [8080]: " PORT
PORT=${PORT:-8080}


echo "Installing dependencies..."

dnf install -y \
httpd \
php \
php-mysqlnd \
mariadb-server \
git \
curl \
unzip


systemctl enable mariadb
systemctl start mariadb


echo "Removing old panel..."

rm -rf /var/www/html/l-panel


echo "Downloading L-PANEL"


git clone \
https://github.com/mohama226/l-panel.git \
/var/www/html/l-panel



cd /var/www/html/l-panel



echo "Checking structure..."

if [ ! -f database/schema.sql ]; then

echo "ERROR:"
echo "database/schema.sql missing"

find . -maxdepth 2 -type f

exit 1

fi



echo "Fixing permissions"


chown -R apache:apache /var/www/html/l-panel

chmod -R 755 /var/www/html/l-panel


echo "Creating database"


mysql <<EOF

CREATE DATABASE IF NOT EXISTS lpanel
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;


CREATE USER IF NOT EXISTS
'lpanel'@'localhost'
IDENTIFIED BY 'lpanel123';


GRANT ALL PRIVILEGES
ON lpanel.*
TO 'lpanel'@'localhost';


FLUSH PRIVILEGES;

EOF



mysql lpanel < database/schema.sql



HASH=$(php -r "echo password_hash('$ADMIN_PASS', PASSWORD_DEFAULT);")


mysql lpanel <<EOF

DELETE FROM admins;


INSERT INTO admins
(username,password,role)
VALUES
('$ADMIN_USER','$HASH','superadmin');

EOF



echo "Creating apache config"


cat >/etc/httpd/conf.d/lpanel.conf <<EOF

Listen $PORT

<VirtualHost *:$PORT>

DocumentRoot /var/www/html/l-panel/public


<Directory /var/www/html/l-panel/public>

AllowOverride All
Require all granted

</Directory>


DirectoryIndex index.php


</VirtualHost>

EOF



echo "Fixing PHP paths"



sed -i \
's#../../../app/session.php#../../app/session.php#g' \
public/modiran/index.php



systemctl restart php-fpm
systemctl restart httpd



echo "
==============================
 INSTALL COMPLETE
==============================

URL:

http://SERVER:$PORT/modiran/


User:
$ADMIN_USER

"
