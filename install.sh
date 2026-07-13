#!/bin/bash


echo "
=====================
 L-PANEL INSTALL
=====================
"



read -p "Superadmin username: " ADMIN_USER

read -s -p "Superadmin password: " ADMIN_PASS

echo


read -p "Panel port [2096]: " PANEL_PORT

PANEL_PORT=${PANEL_PORT:-2096}



read -p "Install ocserv 1.5.0 ? (y/n): " INSTALL_OCSERV



apt update


apt install -y \
python3 \
python3-pip \
python3-venv \
postgresql \
postgresql-contrib \
git



mkdir -p /opt/l-panel


cd /opt/l-panel


git clone https://github.com/YOURUSER/l-panel.git .



python3 -m venv venv


source venv/bin/activate


pip install -r requirements.txt



DBPASS=$(openssl rand -hex 16)



sudo -u postgres psql <<EOF

CREATE DATABASE lpanel;

CREATE USER lpanel WITH PASSWORD '$DBPASS';

GRANT ALL PRIVILEGES ON DATABASE lpanel TO lpanel;

EOF



export DB_USER=lpanel
export DB_PASS=$DBPASS
export DB_NAME=lpanel



python3 <<EOF

from app import app
from database import db
from models import Admin
from werkzeug.security import generate_password_hash


with app.app_context():

    db.create_all()

    a=Admin(
    username="$ADMIN_USER",
    password=generate_password_hash("$ADMIN_PASS")
    )

    db.session.add(a)
    db.session.commit()

EOF




cat >/etc/systemd/system/l-panel.service <<EOF

[Unit]
Description=L Panel

After=network.target



[Service]

WorkingDirectory=/opt/l-panel

Environment="DB_USER=lpanel"
Environment="DB_PASS=$DBPASS"
Environment="DB_NAME=lpanel"

ExecStart=/opt/l-panel/venv/bin/gunicorn \
--bind 0.0.0.0:$PANEL_PORT app:app


Restart=always



[Install]

WantedBy=multi-user.target

EOF



systemctl daemon-reload

systemctl enable l-panel

systemctl restart l-panel



echo "

========================

L-PANEL INSTALLED

PORT : $PANEL_PORT

========================

"
