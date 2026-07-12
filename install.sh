#!/bin/bash

set -e

REPO="https://github.com/mohama226/lak-panel.git"
DIR="/opt/lak-panel"

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root${NC}"
    exit 1
fi

echo -e "${GREEN}Updating packages...${NC}"

apt-get update

apt-get install -y \
git \
python3 \
python3-pip \
python3-venv

if [ -d "$DIR" ]; then
    rm -rf "$DIR"
fi

echo -e "${GREEN}Downloading LAK Panel...${NC}"

git clone "$REPO" "$DIR"

cd "$DIR/backend"

python3 -m venv venv

source venv/bin/activate

pip install --upgrade pip

pip install -r requirements.txt

if [ ! -f ".env" ]; then
    cp .env.example .env
fi

cp "$DIR/systemd/lak-panel.service" /etc/systemd/system/

systemctl daemon-reload

systemctl enable lak-panel

systemctl restart lak-panel

chmod +x "$DIR/scripts/menu.sh"

cat > /usr/local/bin/lak-panel << 'EOF'
#!/bin/bash
bash /opt/lak-panel/scripts/menu.sh
EOF

chmod +x /usr/local/bin/lak-panel


sleep 2

IP=$(hostname -I | awk '{print $1}')

echo

echo "========================================"

echo "LAK Panel Installed"

echo

echo "Open:"

echo "http://$IP:8000"

echo

echo "Health:"

echo "http://$IP:8000/health"

echo

echo "========================================"
