#!/bin/bash
set -e

echo "=== Installing l-panel ==="

read -p "Enter superadmin username: " ADMIN_USER
read -p "Enter superadmin password: " ADMIN_PASS

dnf install -y python3 python3-pip postgresql-server postgresql-contrib
postgresql-setup --initdb
systemctl enable postgresql
systemctl start postgresql

sudo -u postgres psql -c "CREATE USER lpanel WITH PASSWORD '1234';"
sudo -u postgres psql -c "CREATE DATABASE lpanel OWNER lpanel;"

pip3 install -r requirements.txt

sudo -u postgres psql lpanel <<EOF
CREATE TABLE IF NOT EXISTS superadmin (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    password VARCHAR(255)
);

INSERT INTO superadmin (username, password)
VALUES ('$ADMIN_USER', '$ADMIN_PASS');
EOF

echo "Installation complete."
