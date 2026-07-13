#!/usr/bin/env bash


source "$(dirname "$0")/variables.sh"

source "$(dirname "$0")/functions.sh"


blue "Installing PostgreSQL..."


apt install -y postgresql postgresql-contrib


systemctl enable postgresql

systemctl start postgresql



sudo -u postgres psql <<EOF

DO \$\$

BEGIN

IF NOT EXISTS (
SELECT FROM pg_roles WHERE rolname='${POSTGRES_USER}'
)

THEN

CREATE ROLE ${POSTGRES_USER} LOGIN PASSWORD '${POSTGRES_PASSWORD}';

END IF;

END

\$\$;



CREATE DATABASE ${POSTGRES_DB}
OWNER ${POSTGRES_USER};

EOF



green "PostgreSQL configured."
