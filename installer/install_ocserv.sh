#!/bin/bash

set -e

BASE="/opt/l-panel"
VERSION="1.5.0"

echo "=============================="
echo " L-PANEL OCServ Installer"
echo " OCServ Version $VERSION"
echo "=============================="


apt update


apt install -y \
build-essential \
pkg-config \
libgnutls28-dev \
libreadline-dev \
libnl-route-3-dev \
libseccomp-dev \
liblz4-dev \
libprotobuf-c-dev \
protobuf-c-compiler \
autoconf \
automake \
libtool \
wget \
tar \
openssl


mkdir -p /usr/local/src


cd /usr/local/src


if [ -d "ocserv" ]; then
    rm -rf ocserv
fi


echo "Downloading OCServ source..."


wget -O ocserv.tar.xz \
https://github.com/openconnect/ocserv/releases/download/v1.5.0/ocserv-1.5.0.tar.xz


tar xf ocserv.tar.xz


mv ocserv-1.5.0 ocserv


cd ocserv


echo "Configuring..."


./configure \
--prefix=/usr \
--sysconfdir=/etc


echo "Building..."


make -j$(nproc)


echo "Installing..."


make install


echo "Creating folders..."


mkdir -p /etc/ocserv
mkdir -p /var/lib/ocserv
mkdir -p /var/log/ocserv
mkdir -p /var/run/ocserv


cp $BASE/installer/files/ocserv/ocserv.conf \
/etc/ocserv/ocserv.conf


openssl req \
-x509 \
-newkey rsa:4096 \
-keyout /etc/ocserv/server-key.pem \
-out /etc/ocserv/server-cert.pem \
-days 3650 \
-nodes \
-subj "/CN=L-PANEL"


touch /etc/ocserv/ocpasswd


echo "Creating systemd service"


cat >/etc/systemd/system/ocserv.service <<EOF
[Unit]
Description=OpenConnect VPN Server
After=network.target

[Service]
ExecStart=/usr/sbin/ocserv -c /etc/ocserv/ocserv.conf
Restart=always

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload

systemctl enable ocserv


echo
echo "OCServ Installed Successfully"
echo


ocserv -v
