#!/bin/bash

echo "Updating L-Panel..."

echo "Coming Soon"

# ایجاد فایل ocserv.info با فرمت جدید و صحیح
cat > /etc/l-panel/ocserv.info <<EOF
VERSION="${VERSION}"
PORT="${PORT}"
CONFIG="${CONFIG}"
INSTALL_DATE="$(date '+%F %T')"
STATUS="installed"
EOF
