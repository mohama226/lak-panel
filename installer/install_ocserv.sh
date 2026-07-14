#!/bin/bash
set -e

echo "=============================="
echo " L-PANEL OCServ Installer"
echo " OCServ 1.5.0"
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
curl \
tar \
openssl \
git

mkdir -p /usr/local/src
cd /usr/local/src

rm -rf ocserv-1.5.0

echo "Downloading OCServ..."

wget -O ocserv.tar.gz \
https://www.infradead.org/ocserv/download/ocserv-1.5.0.tar.xz


tar xf ocserv.tar.gz

cd ocserv-1.5.0

echo "Building OCServ..."

./configure \
--sysconfdir=/etc/ocserv \
--enable-geoip \
--enable-seccomp

make -j$(nproc)

make install


mkdir -p /etc/ocserv

echo "Creating config..."

cat > /etc/ocserv/ocserv.conf <<EOF
auth = "plain[passwd=/etc/ocserv/ocpasswd]"

tcp-port = 443
udp-port = 443

run-as-user = nobody
run-as-group = nogroup

max-clients = 1024
max-same-clients = 1

server-cert = /etc/ocserv/server-cert.pem
server-key = /etc/ocserv/server-key.pem

default-domain = vpn

ipv4-network = 10.10.10.0
ipv4-netmask = 255.255.255.0

dns = 8.8.8.8

keepalive = 32400

dpd = 90
mobile-dpd = 1800
EOF


echo "Generating certificate..."

openssl req -x509 -newkey rsa:4096 \
-keyout /etc/ocserv/server-key.pem \
-out /etc/ocserv/server-cert.pem \
-days 3650 \
-nodes \
-subj "/CN=L-PANEL VPN"


touch /etc/ocserv/ocpasswd


cat >/etc/systemd/system/ocserv.service <<EOF
[Unit]
Description=OCServ VPN Server
After=network.target

[Service]
ExecStart=/usr/local/sbin/ocserv -c /etc/ocserv/ocserv.conf
Restart=always

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl enable ocserv
systemctl restart ocserv


echo ""
echo "=============================="
echo " OCServ Installed Successfully"
echo " Config: /etc/ocserv"
echo "=============================="
