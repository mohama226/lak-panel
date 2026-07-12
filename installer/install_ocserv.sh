#!/bin/bash

BASE="/opt/lak-panel"

source $BASE/installer/functions.sh


title "Installing OCServ"


apt update -y

apt install -y ocserv openssl


mkdir -p /etc/ocserv


if [ ! -f /etc/ocserv/ocserv.conf ]
then

cat > /etc/ocserv/ocserv.conf <<EOF

auth = "plain[passwd=/etc/ocserv/ocpasswd]"

tcp-port = 443
udp-port = 443

run-as-user = nobody
run-as-group = nogroup

max-clients = 100

max-same-clients = 1

default-domain = vpn


ipv4-network = 10.10.10.0

dns = 8.8.8.8

EOF

fi



if [ ! -f /etc/ocserv/ocpasswd ]
then

touch /etc/ocserv/ocpasswd

fi



systemctl enable ocserv

systemctl restart ocserv



success "OCServ Installed"

echo

systemctl status ocserv --no-pager
