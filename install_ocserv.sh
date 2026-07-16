#!/bin/bash
set -e

echo "=== Installing ocserv 1.5.0 ==="

read -p "Enter ocserv port (default 443): " OCPORT
OCPORT=${OCPORT:-443}

dnf install -y epel-release
dnf install -y ocserv

sed -i "s/^tcp-port = .*/tcp-port = $OCPORT/" /etc/ocserv/ocserv.conf
sed -i "s/^udp-port = .*/udp-port = $OCPORT/" /etc/ocserv/ocserv.conf

systemctl enable ocserv
systemctl restart ocserv

echo "Ocserv installed on port $OCPORT"
