#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

require_root

CERT_DIR="/etc/ocserv"

clear
title

while true
do

clear

title

echo
echo "=============================================="
echo "              SSL MANAGER"
echo "=============================================="
echo

echo "1) Show Current Certificate"

echo "2) Generate Self-Signed Certificate"

echo "3) Install Custom Certificate"

echo "4) Renew Let's Encrypt"

echo "0) Back"

echo

read -rp "Select option: " ACTION

case "$ACTION" in

1)
        echo

        if [[ ! -f "$CERT_DIR/server-cert.pem" ]]; then

            fail "Certificate not found."

            pause

            continue

        fi

        echo "Certificate Information"
        echo "--------------------------------"

        openssl x509 \
            -in "$CERT_DIR/server-cert.pem" \
            -noout \
            -subject \
            -issuer \
            -dates

        echo
        pause
        ;;

    2)

        echo

        read -rp "Replace existing certificate? (y/n): " CONFIRM

        [[ "$CONFIRM" != "y" ]] && continue

        info "Generating certificate..."

        rm -f "$CERT_DIR"/server-cert.pem
        rm -f "$CERT_DIR"/server-key.pem
        rm -f "$CERT_DIR"/ca-cert.pem
        rm -f "$CERT_DIR"/ca-key.pem
        rm -f "$CERT_DIR"/ca.tmpl
        rm -f "$CERT_DIR"/server.tmpl

        cat > "$CERT_DIR/ca.tmpl" <<EOF
cn = L-Panel CA
organization = L-Panel
serial = 1
expiration_days = 3650
ca
signing_key
cert_signing_key
crl_signing_key
EOF

        cat > "$CERT_DIR/server.tmpl" <<EOF
cn = VPN Server
organization = L-Panel
expiration_days = 3650
signing_key
encryption_key
tls_www_server
EOF

        certtool --generate-privkey \
            --outfile "$CERT_DIR/ca-key.pem"

        certtool \
            --generate-self-signed \
            --load-privkey "$CERT_DIR/ca-key.pem" \
            --template "$CERT_DIR/ca.tmpl" \
            --outfile "$CERT_DIR/ca-cert.pem"

        certtool --generate-privkey \
            --outfile "$CERT_DIR/server-key.pem"

        certtool \
            --generate-certificate \
            --load-ca-certificate "$CERT_DIR/ca-cert.pem" \
            --load-ca-privkey "$CERT_DIR/ca-key.pem" \
            --load-privkey "$CERT_DIR/server-key.pem" \
            --template "$CERT_DIR/server.tmpl" \
            --outfile "$CERT_DIR/server-cert.pem"

        chmod 600 "$CERT_DIR"/*key.pem

        systemctl restart ocserv

        ok "New certificate generated."

        pause
        ;;
            3)

        echo

        read -rp "Full path to certificate (.pem): " CERT_FILE
        read -rp "Full path to private key (.pem): " KEY_FILE

        if [[ ! -f "$CERT_FILE" ]]; then
            fail "Certificate file not found."
            pause
            continue
        fi

        if [[ ! -f "$KEY_FILE" ]]; then
            fail "Private key file not found."
            pause
            continue
        fi

        cp -f "$CERT_FILE" "$CERT_DIR/server-cert.pem"
        cp -f "$KEY_FILE" "$CERT_DIR/server-key.pem"

        chmod 600 "$CERT_DIR/server-key.pem"
        chmod 644 "$CERT_DIR/server-cert.pem"

        if systemctl restart ocserv; then

            ok "Custom certificate installed."

        else

            fail "Ocserv failed to restart."

        fi

        pause
        ;;

    4)

        echo

        if ! command -v certbot >/dev/null 2>&1; then

            fail "Certbot is not installed."

            pause

            continue

        fi

        info "Renewing Let's Encrypt certificates..."

        certbot renew

        if [[ -f /etc/letsencrypt/live/$(hostname)/fullchain.pem ]] && \
           [[ -f /etc/letsencrypt/live/$(hostname)/privkey.pem ]]; then

            cp -f \
            /etc/letsencrypt/live/$(hostname)/fullchain.pem \
            "$CERT_DIR/server-cert.pem"

            cp -f \
            /etc/letsencrypt/live/$(hostname)/privkey.pem \
            "$CERT_DIR/server-key.pem"

            chmod 600 "$CERT_DIR/server-key.pem"

            systemctl restart ocserv

            ok "Let's Encrypt certificate updated."

        else

            warn "No Let's Encrypt certificate found for $(hostname)."

        fi

        pause
        ;;

    0)

        break

        ;;

    *)

        warn "Invalid option."

        sleep 1

        ;;

esac

done

exit 0
