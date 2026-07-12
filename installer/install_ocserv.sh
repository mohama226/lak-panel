#!/bin/bash

set -e


BASE_DIR="/opt/lak-panel"

OCSERV_DIR="$BASE_DIR/ocserv"


echo "========================================="
echo "          OCServ INSTALLER"
echo "========================================="


echo ""

read -p "Install OCServ now? (y/n): " INSTALL


if [ "$INSTALL" != "y" ]; then

echo "Skipped"

exit 0

fi



echo "[1/5] Installing packages..."

apt update

apt install -y \
ocserv \
openssl \
iptables \
ufw



echo "[2/5] Creating OCServ directory..."

mkdir -p "$OCSERV_DIR"



echo "[3/5] Backup original config..."

if [ -f /etc/ocserv/ocserv.conf ]; then

cp /etc/ocserv/ocserv.conf \
"$OCSERV_DIR/ocserv.conf.backup"

fi



echo "[4/5] Writing OCServ config..."

cat > /etc/ocserv/ocserv.conf <<EOF

auth = "plain[passwd=/etc/ocserv/ocpasswd]"

tcp-port = 443

udp-port = 443


run-as-user = nobody

run-as-group = nogroup


max-clients = 1000

max-same-clients = 1


device = vpns

ipv4-network = 10.10.10.0

ipv4-netmask = 255.255.255.0


dns = 8.8.8.8

dns = 1.1.1.1


compression = true


EOF



echo "[5/5] Enable service..."


systemctl enable ocserv

systemctl restart ocserv



echo ""

echo "========================================="
echo " OCServ Installed"
echo "========================================="


systemctl status ocserv --no-pager -l
