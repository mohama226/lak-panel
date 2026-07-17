#!/usr/bin/env bash

set -Eeuo pipefail


########################################
# Paths
########################################

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

require_root


########################################
# Variables
########################################

OCSERV_VERSION="1.5.0"
CONFIG_DIR="/etc/ocserv"
CONFIG_FILE="$CONFIG_DIR/ocserv.conf"
SERVICE_FILE="/etc/systemd/system/ocserv.service"
BUILD_DIR="/usr/local/src"


########################################
# Ask Port
########################################

ask_port(){

    echo
    read -rp "Ocserv Port [443]: " PORT
    PORT=${PORT:-443}

}


########################################
# Dependencies (FINAL VERSION)
########################################

install_dependencies(){

    info "Installing dependencies..."

    dnf install -y epel-release
    dnf install -y dnf-plugins-core

    dnf config-manager --set-enabled crb

    dnf groupinstall -y "Development Tools"

    dnf install -y \
        meson \
        ninja-build \
        libev-devel \
        gperf \
        ipcalc \
        protobuf-c-devel \
        protobuf-c-compiler \
        gnutls-devel \
        readline-devel \
        pam-devel \
        libnl3-devel \
        libseccomp-devel \
        lz4-devel \
        krb5-devel \
        openssl-devel \
        gettext-devel \
        help2man \
        xz \
        wget \
        curl \
        tar

    ok "Dependencies installed."

}


########################################
# Install Ocserv Binary (MESON BUILD)
########################################

install_ocserv(){

    cd /

    info "Checking Ocserv installation..."

    ########################################
    # REMOVE OLD VERSION IF INSTALLED
    ########################################

    if command -v ocserv >/dev/null 2>&1; then

        CURRENT=$(ocserv --version | head -1 | awk '{print $4}')

        if [[ "$CURRENT" == "$OCSERV_VERSION" ]]; then
            ok "Ocserv ${CURRENT} already installed."
            return
        fi

        warn "Removing old version ${CURRENT}"
        dnf remove -y ocserv || true
    fi


    ########################################
    # DOWNLOAD SOURCE (NEW VERSION)
    ########################################

    info "Downloading Ocserv ${OCSERV_VERSION}..."

    cd /usr/local/src

    rm -rf ocserv-${OCSERV_VERSION}
    rm -f ocserv.tar.xz

    wget \
        https://www.infradead.org/ocserv/download/ocserv-${OCSERV_VERSION}.tar.xz \
        -O ocserv.tar.xz

    tar -xf ocserv.tar.xz

    cd ocserv-${OCSERV_VERSION}


    ########################################
    # MESON BUILD SYSTEM
    ########################################

    info "Configuring Meson..."

    rm -rf build

    meson setup build \
        --prefix=/usr \
        --sysconfdir=/etc/ocserv

    info "Compiling..."

    meson compile -C build

    info "Installing..."

    meson install -C build

    ldconfig


    ########################################
    # VERSION CHECK
    ########################################

    if ! command -v ocserv >/dev/null 2>&1; then
        fail "Ocserv installation failed."
        exit 1
    fi

    VERSION=$(ocserv --version | head -1)

    ok "$VERSION installed successfully."

}


########################################
# Create Directories
########################################

create_directories(){

    info "Creating directories..."

    mkdir -p "$CONFIG_DIR"
    mkdir -p /var/lib/ocserv
    mkdir -p /var/log/ocserv
    mkdir -p /var/run/ocserv
    mkdir -p /run

    ok "Directories created."

}


########################################
# Generate Certificates
########################################

generate_certificates(){

    info "Generating certificates..."

    if [[ -f "$CONFIG_DIR/server-cert.pem" ]]; then
        warn "Certificates already exist."
        return
    fi

    cat > "$CONFIG_DIR/ca.tmpl" <<'EOF'
cn = L-Panel CA
organization = L-Panel
serial = 1
expiration_days = 3650
ca
signing_key
cert_signing_key
crl_signing_key
EOF

    cat > "$CONFIG_DIR/server.tmpl" <<'EOF'
cn = VPN Server
organization = L-Panel
expiration_days = 3650
signing_key
encryption_key
tls_www_server
EOF

    certtool --generate-privkey --outfile "$CONFIG_DIR/ca-key.pem"

    certtool \
        --generate-self-signed \
        --load-privkey "$CONFIG_DIR/ca-key.pem" \
        --template "$CONFIG_DIR/ca.tmpl" \
        --outfile "$CONFIG_DIR/ca-cert.pem"

    certtool --generate-privkey --outfile "$CONFIG_DIR/server-key.pem"

    certtool \
        --generate-certificate \
        --load-ca-certificate "$CONFIG_DIR/ca-cert.pem" \
        --load-ca-privkey "$CONFIG_DIR/ca-key.pem" \
        --load-privkey "$CONFIG_DIR/server-key.pem" \
        --template "$CONFIG_DIR/server.tmpl" \
        --outfile "$CONFIG_DIR/server-cert.pem"

    chmod 600 "$CONFIG_DIR"/*key.pem

    ok "Certificates created."

}


########################################
# Create Ocserv Config
########################################

create_config(){

    info "Creating ocserv configuration..."

    cat > "$CONFIG_FILE" <<EOF
auth = "plain[passwd=$CONFIG_DIR/ocpasswd]"

tcp-port = $PORT
udp-port = $PORT

server-cert = $CONFIG_DIR/server-cert.pem
server-key = $CONFIG_DIR/server-key.pem

socket-file = /run/ocserv-socket

run-as-user = nobody
run-as-group = nobody

device = vpns

pid-file = /run/ocserv.pid

isolate-workers = true

max-clients = 500
max-same-clients = 2

keepalive = 32400
dpd = 90
mobile-dpd = 1800

try-mtu-discovery = true

ipv4-network = 10.10.10.0
ipv4-netmask = 255.255.255.0

dns = 1.1.1.1
dns = 8.8.8.8

route = default

compression = true
EOF

    touch "$CONFIG_DIR/ocpasswd"
    chmod 600 "$CONFIG_DIR/ocpasswd"

    ok "Configuration created."

}


########################################
# Enable Forwarding
########################################

enable_forwarding(){

    info "Enabling IP forwarding..."

    cat > /etc/sysctl.d/99-l-panel-vpn.conf <<EOF
net.ipv4.ip_forward=1
EOF

    sysctl --system >/dev/null

    ok "IP forwarding enabled."

}


########################################
# Create Systemd Service
########################################

create_service(){

    info "Creating systemd service..."

    cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=L-Panel Ocserv VPN
After=network.target

[Service]
Type=simple
ExecStart=/usr/sbin/ocserv \
    -c /etc/ocserv/ocserv.conf \
    --foreground
Restart=always
RestartSec=5

RuntimeDirectory=ocserv
RuntimeDirectoryMode=755

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable ocserv

    ok "Systemd service created."

}


########################################
# Configure Firewall
########################################

configure_firewall(){

    info "Configuring firewall..."

    if systemctl is-active firewalld >/dev/null 2>&1; then

        firewall-cmd --permanent --add-port=${PORT}/tcp
        firewall-cmd --permanent --add-port=${PORT}/udp
        firewall-cmd --reload

        ok "Firewall updated."

    else
        warn "Firewalld not running."
    fi

}


########################################
# Start Ocserv
########################################

start_ocserv(){

    info "Starting ocserv..."

    systemctl restart ocserv
    sleep 3

    if systemctl is-active ocserv >/dev/null 2>&1; then
        ok "Ocserv is running."
    else
        fail "Ocserv failed to start."
        echo
        journalctl -u ocserv --no-pager -n 50
        exit 1
    fi

}


########################################
# Save Info
########################################

save_info(){

    mkdir -p /etc/l-panel

    cat > /etc/l-panel/ocserv.info <<EOF
VERSION=$OCSERV_VERSION
PORT=$PORT
INSTALL_DATE=$(date "+%Y-%m-%d %H:%M:%S")
EOF

}


########################################
# Final Result
########################################

show_result(){

    echo
    echo "=============================================="
    ok "Ocserv installation completed"
    echo "=============================================="
    echo

    echo "Version : $OCSERV_VERSION"
    echo "Port    : $PORT"
    echo "Config  : $CONFIG_FILE"
    echo

    ocserv --version || true
    echo

}


########################################
# Main
########################################

main(){

    title

    info "Installing Ocserv ${OCSERV_VERSION}"

    ask_port
    install_dependencies
    install_ocserv
    create_directories
    generate_certificates
    create_config
    enable_forwarding
    create_service
    configure_firewall
    save_info
    start_ocserv
    show_result

    pause

}

main
