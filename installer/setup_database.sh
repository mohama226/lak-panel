#!/bin/bash

set -e

echo "Installing PostgreSQL..."

apt update

apt install -y postgresql postgresql-contrib libpq-dev


systemctl enable postgresql
systemctl start postgresql


echo "Creating database..."


sudo -u postgres psql <<EOF

CREATE USER lpanel_user WITH PASSWORD 'lpanel_password';

CREATE DATABASE lpanel OWNER lpanel_user;

GRANT ALL PRIVILEGES ON DATABASE lpanel TO lpanel_user;

EOF


echo "PostgreSQL Ready"
