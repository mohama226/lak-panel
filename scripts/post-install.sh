#!/bin/bash

echo "Configuring L-PANEL OCServ..."


mkdir -p /etc/ocserv


touch /etc/ocserv/ocpasswd

chown root:apache /etc/ocserv/ocpasswd
chmod 660 /etc/ocserv/ocpasswd


chmod +x /var/www/html/l-panel/scripts/*.sh


cat >/etc/sudoers.d/l-panel-ocserv <<EOF

apache ALL=(root) NOPASSWD: /var/www/html/l-panel/scripts/ocserv-manager.sh

EOF


chmod 440 /etc/sudoers.d/l-panel-ocserv


echo "OCServ integration ready"
