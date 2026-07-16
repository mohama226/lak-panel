#!/usr/bin/env bash

set -Eeuo pipefail


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_DIR="$(dirname "$SCRIPT_DIR")"


source "$CLI_DIR/../lib/colors.sh"
source "$CLI_DIR/../lib/common.sh"


require_root


#############################################
# Variables
#############################################

OCSERV_VERSION="1.5.0"

OCSERV_PORT=""

OCSERV_DIR="/opt/ocserv"

OCSERV_CONFIG="/etc/ocserv"


#############################################
# Ask Ocserv Port
#############################################

ask_port(){

    while true; do

        echo

        read -rp "Ocserv Port [443]: " OCSERV_PORT


        [[ -z "$OCSERV_PORT" ]] && OCSERV_PORT=443


        if [[ "$OCSERV_PORT" =~ ^[0-9]+$ ]]; then

            if (( OCSERV_PORT >= 1 && OCSERV_PORT <= 65535 )); then

                break

            fi

        fi


        fail "Invalid port."

    done

}



#############################################
# Check OS
#############################################

check_os(){

    if [[ ! -f /etc/almalinux-release ]]; then

        warn "This installer is optimized for AlmaLinux."

    fi

}
#############################################
# Install Dependencies
#############################################

install_dependencies(){

    info "Installing Ocserv dependencies..."


    if command -v dnf >/dev/null 2>&1; then

        dnf install -y epel-release

        dnf groupinstall -y "Development Tools"


        dnf install -y \
        wget \
        curl \
        tar \
        gzip \
        make \
        gcc \
        gcc-c++ \
        autoconf \
        automake \
        libtool \
        pkgconfig \
        readline-devel \
        zlib-devel \
        gnutls-devel \
        libnl3-devel \
        libseccomp-devel \
        pam-devel \
        lz4-devel \
        protobuf-c-devel \
        krb5-devel \
        openssl-devel


    elif command -v yum >/dev/null 2>&1; then


        yum install -y epel-release

        yum groupinstall -y "Development Tools"


        yum install -y \
        wget \
        curl \
        tar \
        gzip \
        make \
        gcc \
        gcc-c++ \
        autoconf \
        automake \
        libtool \
        pkgconfig \
        readline-devel \
        zlib-devel \
        gnutls-devel \
        libnl3-devel \
        libseccomp-devel \
        pam-devel \
        lz4-devel \
        protobuf-c-devel \
        krb5-devel \
        openssl-devel


    else

        fail "Unsupported package manager."

        exit 1

    fi


    ok "Dependencies installed."

}



#############################################
# Prepare Build Directory
#############################################

prepare_build(){

    BUILD_DIR="/usr/local/src"


    mkdir -p "$BUILD_DIR"


    cd "$BUILD_DIR"


}



#############################################
# Download Ocserv Source
#############################################

download_ocserv(){


    cd "$BUILD_DIR"


    if [[ -d "ocserv-$OCSERV_VERSION" ]]; then

        warn "Ocserv source already exists."

        return

    fi


    info "Downloading Ocserv $OCSERV_VERSION..."


    wget \
    "https://github.com/openconnect/ocserv/releases/download/v${OCSERV_VERSION}/ocserv-${OCSERV_VERSION}.tar.xz" \
    -O ocserv.tar.xz



    tar -xf ocserv.tar.xz


    ok "Ocserv source downloaded."

}#############################################
# Build Ocserv
#############################################

build_ocserv(){

    cd "$BUILD_DIR/ocserv-$OCSERV_VERSION"


    info "Configuring Ocserv..."


    ./configure \
    --prefix=/usr \
    --sysconfdir=/etc/ocserv \
    --enable-tcp-wrapper=no



    info "Compiling Ocserv..."


    make -j"$(nproc)"



    info "Installing Ocserv..."


    make install



    ldconfig



    ok "Ocserv installed."

}



#############################################
# Create Directories
#############################################

create_directories(){


    mkdir -p /etc/ocserv

    mkdir -p /var/lib/ocserv

    mkdir -p /var/log/ocserv



    ok "Ocserv directories created."

}



#############################################
# Create Config
#############################################

create_config(){


CONFIG_FILE="/etc/ocserv/ocserv.conf"


if [[ -f "$CONFIG_FILE" ]]; then

    warn "Config already exists."

    return

fi



cat > "$CONFIG_FILE" <<EOF
auth = "plain[passwd=/etc/ocserv/ocpasswd]"

tcp-port = $OCSERV_PORT
udp-port = $OCSERV_PORT

run-as-user = nobody
run-as-group = nobody

socket-file = /var/run/ocserv-socket

max-clients = 100

keepalive = 32400

dpd = 90

mobile-dpd = 1800

try-mtu-discovery = true

ipv4-network = 10.10.10.0
ipv4-netmask = 255.255.255.0

dns = 8.8.8.8
dns = 1.1.1.1

route = default

isolate-workers = true

EOF



ok "Ocserv configuration created."

}



#############################################
# Create Password Database
#############################################

create_password_db(){


touch /etc/ocserv/ocpasswd


chmod 600 /etc/ocserv/ocpasswd



ok "Password database created."

}#############################################
# Create Systemd Service
#############################################

create_service(){


cat > /etc/systemd/system/ocserv.service <<EOF
[Unit]
Description=OpenConnect VPN Server
After=network.target


[Service]
Type=simple
ExecStart=/usr/sbin/ocserv -c /etc/ocserv/ocserv.conf
Restart=always


[Install]
WantedBy=multi-user.target
EOF



systemctl daemon-reload


systemctl enable ocserv


ok "Systemd service created."

}



#############################################
# Firewall
#############################################

configure_firewall(){


if systemctl is-active firewalld >/dev/null 2>&1; then


    firewall-cmd --permanent \
    --add-port=${OCSERV_PORT}/tcp


    firewall-cmd --permanent \
    --add-port=${OCSERV_PORT}/udp


    firewall-cmd --reload


    ok "Firewall configured."


else

    warn "Firewalld is not running."

fi


}



#############################################
# Save Installation Info
#############################################

save_ocserv_info(){


mkdir -p /etc/l-panel



cat > /etc/l-panel/ocserv.conf <<EOF

OCSERV_VERSION=$OCSERV_VERSION
OCSERV_PORT=$OCSERV_PORT
INSTALL_DATE=$(date "+%Y-%m-%d %H:%M:%S")

EOF



}



#############################################
# Start Service
#############################################

start_service(){


systemctl restart ocserv


sleep 2



if systemctl is-active ocserv >/dev/null 2>&1; then

    ok "Ocserv is running."

else

    fail "Ocserv failed to start."

    systemctl status ocserv --no-pager

    exit 1

fi


}



#############################################
# Main Installer
#############################################

main(){


title


echo

info "Installing Ocserv ${OCSERV_VERSION}"

echo



ask_port


install_dependencies


prepare_build


download_ocserv


build_ocserv


create_directories


create_config


create_password_db


create_service


configure_firewall


save_ocserv_info


start_service



echo

ok "Ocserv ${OCSERV_VERSION} installation completed."

echo

echo "Port : ${OCSERV_PORT}"

echo


pause


}



main
