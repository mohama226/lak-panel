#!/usr/bin/env bash

set -Eeuo pipefail


#############################################
# Path
#############################################

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"

SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

CLI_DIR="$(dirname "$SCRIPT_DIR")"



source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"



require_root



#############################################
# Variables
#############################################

OCSERV_VERSION="1.5.0"

BUILD_DIR="/usr/local/src"

SOURCE_DIR="$BUILD_DIR/ocserv-$OCSERV_VERSION"

CONFIG_DIR="/etc/ocserv"

CONFIG_FILE="$CONFIG_DIR/ocserv.conf"

SERVICE_FILE="/etc/systemd/system/ocserv.service"



#############################################
# Ask Port
#############################################

ask_port(){

    echo

    read -rp "Ocserv Port [443]: " OCSERV_PORT


    OCSERV_PORT=${OCSERV_PORT:-443}


}



#############################################
# Install Dependencies
#############################################

install_dependencies(){


    info "Installing Ocserv dependencies..."



    dnf install -y epel-release



    dnf install -y dnf-plugins-core



    dnf config-manager --set-enabled crb || true



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
    pkgconf-pkg-config \
    readline-devel \
    zlib-devel \
    gnutls-devel \
    libnl3-devel \
    libseccomp-devel \
    pam-devel \
    lz4-devel \
    protobuf-c \
    protobuf-c-compiler \
    krb5-devel \
    openssl-devel



    ok "Dependencies installed."

}#############################################
# Prepare Build Directory
#############################################

prepare_build(){


    info "Preparing build directory..."


    mkdir -p "$BUILD_DIR"


    cd "$BUILD_DIR"



    rm -rf "ocserv-$OCSERV_VERSION"



    ok "Build directory ready."


}



#############################################
# Download Ocserv Source
#############################################

download_ocserv(){


    info "Downloading Ocserv ${OCSERV_VERSION}..."



    cd "$BUILD_DIR"



    wget -q \
    "https://www.infradead.org/ocserv/download/ocserv-${OCSERV_VERSION}.tar.xz" \
    -O ocserv.tar.xz



    tar -xf ocserv.tar.xz



    rm -f ocserv.tar.xz



    ok "Source downloaded."



}



#############################################
# Configure Build
#############################################

configure_ocserv(){


    info "Configuring Ocserv..."



    cd "$SOURCE_DIR"



    if [[ -f autogen.sh ]]; then

        ./autogen.sh

    fi



    ./configure \
    --prefix=/usr \
    --sysconfdir=/etc/ocserv \
    --enable-seccomp \
    --enable-libnl



    ok "Configure completed."


}



#############################################
# Compile Ocserv
#############################################

compile_ocserv(){


    info "Compiling Ocserv..."



    cd "$SOURCE_DIR"



    make -j"$(nproc)"



    ok "Compilation completed."



}



#############################################
# Install Ocserv
#############################################

install_ocserv(){


    info "Installing Ocserv..."



    cd "$SOURCE_DIR"



    make install



    ldconfig



    ok "Ocserv installed."



}#############################################
# Create Directories
#############################################

create_directories(){


    info "Creating Ocserv directories..."



    mkdir -p "$CONFIG_DIR"

    mkdir -p /var/lib/ocserv

    mkdir -p /var/log/ocserv

    mkdir -p /var/run/ocserv



    ok "Directories created."


}



#############################################
# Generate Certificate
#############################################

generate_certificate(){


    info "Generating SSL certificate..."



    if [[ -f "$CONFIG_DIR/server-key.pem" ]]; then


        warn "Certificate already exists."

        return


    fi



    cat > "$CONFIG_DIR/ca.tmpl" <<EOF
cn = "L-Panel VPN CA"
organization = "L-Panel"
serial = 1
expiration_days = 3650
ca
signing_key
cert_signing_key
crl_signing_key
EOF



    cat > "$CONFIG_DIR/server.tmpl" <<EOF
cn = "VPN Server"
organization = "L-Panel"
expiration_days = 3650
signing_key
encryption_key
tls_www_server
EOF



    certtool \
    --generate-privkey \
    --outfile "$CONFIG_DIR/ca-key.pem"



    certtool \
    --generate-self-signed \
    --load-privkey "$CONFIG_DIR/ca-key.pem" \
    --template "$CONFIG_DIR/ca.tmpl" \
    --outfile "$CONFIG_DIR/ca-cert.pem"




    certtool \
    --generate-privkey \
    --outfile "$CONFIG_DIR/server-key.pem"



    certtool \
    --generate-certificate \
    --load-privkey "$CONFIG_DIR/server-key.pem" \
    --load-ca-certificate "$CONFIG_DIR/ca-cert.pem" \
    --load-ca-privkey "$CONFIG_DIR/ca-key.pem" \
    --template "$CONFIG_DIR/server.tmpl" \
    --outfile "$CONFIG_DIR/server-cert.pem"



    chmod 600 "$CONFIG_DIR"/*key.pem



    ok "Certificate generated."


}



#############################################
# Create User Database
#############################################

create_user_database(){


    info "Creating user database..."



    touch "$CONFIG_DIR/ocpasswd"



    chmod 600 "$CONFIG_DIR/ocpasswd"



    ok "User database created."



}



#############################################
# Create Ocserv Config
#############################################

create_config(){


    info "Creating configuration..."



    cat > "$CONFIG_FILE" <<EOF
auth = "plain[passwd=$CONFIG_DIR/ocpasswd]"


tcp-port = $OCSERV_PORT
udp-port = $OCSERV_PORT


server-cert = $CONFIG_DIR/server-cert.pem
server-key = $CONFIG_DIR/server-key.pem


run-as-user = nobody
run-as-group = nobody


max-clients = 500


keepalive = 32400


dpd = 90


mobile-dpd = 1800


try-mtu-discovery = true


ipv4-network = 10.10.10.0
ipv4-netmask = 255.255.255.0


dns = 8.8.8.8
dns = 1.1.1.1


route = default


compression = true


EOF



    ok "Configuration created."


}#############################################
# Enable IP Forward
#############################################

enable_forwarding(){


    info "Enabling IP forwarding..."



    cat > /etc/sysctl.d/99-l-panel-ocserv.conf <<EOF
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
EOF



    sysctl --system >/dev/null



    ok "IP forwarding enabled."

}



#############################################
# Create Systemd Service
#############################################

create_service(){


    info "Creating systemd service..."



    cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=OpenConnect VPN Server (Ocserv)
After=network.target


[Service]
Type=simple
ExecStart=/usr/sbin/ocserv -c $CONFIG_FILE
Restart=always
RestartSec=5


[Install]
WantedBy=multi-user.target
EOF



    systemctl daemon-reload


    systemctl enable ocserv



    ok "Systemd service created."


}



#############################################
# Configure Firewall
#############################################

configure_firewall(){


    info "Configuring firewall..."



    if systemctl is-active firewalld >/dev/null 2>&1; then


        firewall-cmd \
        --permanent \
        --add-port=${OCSERV_PORT}/tcp



        firewall-cmd \
        --permanent \
        --add-port=${OCSERV_PORT}/udp



        firewall-cmd --reload



        ok "Firewall configured."



    else


        warn "Firewalld not active."


    fi



}



#############################################
# Start Ocserv
#############################################

start_ocserv(){


    info "Starting Ocserv..."



    systemctl restart ocserv



    sleep 3



    if systemctl is-active ocserv >/dev/null 2>&1; then


        ok "Ocserv is running."



    else


        fail "Ocserv failed to start."


        systemctl status ocserv --no-pager


        exit 1


    fi



}



#############################################
# Save Installation Data
#############################################

save_install_info(){


    mkdir -p /etc/l-panel



    cat > /etc/l-panel/ocserv.info <<EOF
VERSION=$OCSERV_VERSION
PORT=$OCSERV_PORT
INSTALL_DATE=$(date "+%Y-%m-%d %H:%M:%S")
EOF



}#############################################
# Final Report
#############################################

show_result(){


    echo

    echo "=============================================="

    ok "Ocserv installation completed."

    echo "=============================================="

    echo

    echo "Version : $OCSERV_VERSION"

    echo "Port    : $OCSERV_PORT"

    echo "Config  : $CONFIG_FILE"

    echo

    echo "Service status:"

    systemctl status ocserv --no-pager -l

    echo


}



#############################################
# Main Installer
#############################################

main(){


    title


    info "Installing Ocserv $OCSERV_VERSION"


    ask_port



    install_dependencies



    prepare_build



    download_ocserv



    configure_ocserv



    compile_ocserv



    install_ocserv



    create_directories



    generate_certificate



    create_user_database



    create_config



    enable_forwarding



    create_service



    configure_firewall



    save_install_info



    start_ocserv



    show_result



    pause


}



main
