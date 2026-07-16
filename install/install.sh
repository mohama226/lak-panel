#!/bin/bash
set -e

PROJECT_DIR=$(cd "$(dirname "$0")/.."; pwd)
cd "$PROJECT_DIR"

echo "=== Installing l-panel ==="

read -p "Enter superadmin username: " ADMIN_USER
read -p "Enter superadmin password: " ADMIN_PASS

bash install/deps.sh

# Initialize PostgreSQL only if needed
if [ ! -f /var/lib/pgsql/data/PG_VERSION ]; then
    echo "[+] Initializing PostgreSQL..."
    postgresql-setup --initdb
fi

systemctl enable postgresql
systemctl start postgresql

# Create DB user if not exists
sudo -u postgres psql -tc "SELECT 1 FROM pg_roles WHERE rolname='lpanel'" | grep -q 1 || \
sudo -u postgres psql -c "CREATE USER lpanel WITH PASSWORD '1234';"

# Create database if not exists
sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname='lpanel'" | grep -q 1 || \
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

# Save update time
date "+%Y-%m-%d %H:%M:%S" > last_update.txt

echo "[+] l-panel installed successfully."
