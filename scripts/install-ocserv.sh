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

    dnf install -y gperf || {
        echo "Installing gperf from source"

        cd /usr/local/src

        rm -rf gperf

        wget https://ftp.gnu.org/pub/gnu/gperf/gperf-3.1.tar.gz

        tar xf gperf-3.1.tar.gz

        cd gperf-3.1

        ./configure

        make -j$(nproc)

        make install

        cd /
    }

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
        meson \
        ninja-build \
        pkgconf-pkg-config \
        gettext \
        which \
        gperf

    echo "Installing missing libraries"

    dnf install -y \
        protobuf-c \
        protobuf-c-devel \
        protobuf-c-compiler \
        protobuf \
        protobuf-devel || true

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

echo "Preparing source directory..."

rm -rf /usr/local/src/ocserv
mkdir -p /usr/local/src
cd /usr/local/src

echo "Cloning OCServ repository..."
git clone https://gitlab.com/openconnect/ocserv.git ocserv

cd ocserv

git fetch --tags

echo "Available versions:"
git tag | grep 1.5

VERSION=$(git tag | grep -E "^1\.5\.0$")

if [ -z "$VERSION" ]; then
    echo "OCServ 1.5.0 tag not found"
    exit 1
fi

echo "Installing version: $VERSION"

git checkout "$VERSION"

gperf --version

echo "Building OCServ with meson"

meson setup build \
    --prefix=/usr

cd build

ninja -j$(nproc)

ninja install

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
echo "OCServ $VERSION Installed"
echo "=============================="
