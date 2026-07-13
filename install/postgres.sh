#!/usr/bin/env bash

blue "Installing PostgreSQL..."

apt install -y postgresql postgresql-contrib

systemctl enable postgresql

systemctl start postgresql


blue "Creating Database..."


sudo -u postgres psql <<EOF

CREATE USER ${POSTGRES_USER} WITH PASSWORD '${POSTGRES_PASSWORD}';

CREATE DATABASE ${POSTGRES_DB};

GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO ${POSTGRES_USER};

EOF


green "PostgreSQL Ready."
