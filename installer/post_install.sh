#!/bin/bash

set -e

echo "==> Fix permissions..."

find /opt/l-panel -type f -name "*.sh" -exec chmod +x {} \;
chmod +x /opt/l-panel/scripts/l-panel

echo "==> Create symlink..."

ln -sf /opt/l-panel/scripts/l-panel /usr/local/bin/l-panel

echo "==> Create Virtualenv..."

if [ ! -d /opt/l-panel/venv ]; then
    python3 -m venv /opt/l-panel/venv
fi

echo "==> Install Python packages..."

/opt/l-panel/venv/bin/pip install --upgrade pip
/opt/l-panel/venv/bin/pip install -r /opt/l-panel/requirements.txt

echo "==> Install systemd..."

cp -f /opt/l-panel/systemd/system/l-panel.service /etc/systemd/system/l-panel.service

systemctl daemon-reload
systemctl enable l-panel

echo "==> Restart L-Panel..."

systemctl restart l-panel

echo "Done."
