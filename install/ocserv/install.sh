#!/bin/bash

set -e


echo "Installing ocserv 1.5"


apt update


apt install -y \
git \
gcc \
make \
pkg-config \
autoconf \
automake \
libtool \
libgnutls28-dev \
libseccomp-dev \
libnl-route-3-dev \
libreadline-dev \
libwrap0-dev \
libprotobuf-c-dev \
protobuf-c-compiler \
libhttp-parser-dev \
wget


cd /usr/local/src


rm -rf ocserv


git clone https://github.com/openconnect/ocserv.git


cd ocserv


git checkout ocserv-1.5.0


./autogen.sh


./configure


make -j$(nproc)


make install


echo "ocserv compiled"



mkdir -p /etc/ocserv


cp /opt/lak-panel/install/ocserv/ocserv.conf \
/etc/ocserv/ocserv.conf


touch /etc/ocserv/ocpasswd

chmod 600 /etc/ocserv/ocpasswd



systemctl daemon-reload


systemctl enable ocserv


systemctl restart ocserv


echo "ocserv 1.5 installed successfully"
