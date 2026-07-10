#!/bin/bash

set -e


echo "Installing ocserv..."


apt update


apt install -y \
git \
wget \
curl \
build-essential \
pkg-config \
libgnutls28-dev \
libev-dev \
libwrap0-dev \
libseccomp-dev \
libnl-route-3-dev \
liblz4-dev \
libreadline-dev \
libpam0g-dev


echo "Downloading ocserv 1.5"


cd /usr/local/src


rm -rf ocserv-1.5


wget https://www.infradead.org/ocserv/download/ocserv-1.5.0.tar.xz


tar xf ocserv-1.5.0.tar.xz


cd ocserv-1.5.0


./configure


make -j$(nproc)


make install


echo "ocserv installed"


mkdir -p /etc/ocserv


cp /opt/lak-panel/install/configs/ocserv.conf \
/etc/ocserv/ocserv.conf


touch /etc/ocserv/ocpasswd


chmod 600 /etc/ocserv/ocpasswd


systemctl daemon-reload


systemctl enable ocserv


systemctl restart ocserv


echo "ocserv is ready"
