#!/bin/bash

set -e

echo "=============================="
echo " Installing OCServ 1.5.0"
echo "=============================="

if [ -f /etc/os-release ]; then
    source /etc/os-release
fi

echo "Detected: $PRETTY_NAME"

echo "Installing dependencies..."

if command -v dnf >/dev/null
then

    dnf install -y epel-release
    dnf config-manager --set-enabled crb || true

    dnf install -y \
        gcc \
        gcc-c++ \
        make \
        git \
        wget \
        openssl-devel \
        libnl3-devel \
        libseccomp-devel \
        pam-devel \
        readline-devel \
        zlib-devel \
        gnutls-devel \
        autoconf \
        automake \
        libtool \
        pkgconf-pkg-config \
        libtasn1-devel \
        lz4-devel \
        cyrus-sasl-devel

    # 🔥 بخش جدید: نصب کتابخانه‌های موردنیاز AlmaLinux
    echo "Installing missing libraries"

    dnf install -y protobuf-c protobuf protobuf-devel || true
    dnf install -y libev libev-devel || true

else

    apt update

    apt install -y \
        gcc \
        make \
        git \
        wget \
        openssl-dev \
        libnl3-dev \
        libseccomp-dev \
        libpam-dev \
        libreadline-dev \
        zlib1g-dev \
        libgnutls28-dev \
        protobuf-c-compiler \
        libev-dev \
        autoconf \
        automake \
        libtool

fi

cd /usr/local/src

rm -rf ocserv

git clone \
    --depth 1 \
    --branch v1.5.0 \
    https://gitlab.com/openconnect/ocserv.git ocserv

cd ocserv

./autogen.sh

./configure \
    --prefix=/usr \
    --sysconfdir=/etc

make -j$(nproc)

make install

echo "OCServ installed"

mkdir -p /etc/ocserv

cp /var/www/html/l-panel/scripts/ocserv.conf \
    /etc/ocserv/ocserv.conf

cp /var/www/html/l-panel/scripts/ocserv.service \
    /etc/systemd/system/ocserv.service

systemctl daemon-reload
systemctl enable ocserv
systemctl restart ocserv

echo ""
echo "=============================="
echo "OCServ 1.5.0 Installed"
echo "=============================="
