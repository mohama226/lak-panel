#!/usr/bin/env bash

set -Eeuo pipefail

echo "=================================="
echo " Installing Python Environment"
echo "=================================="


if command -v python3 >/dev/null 2>&1; then

    echo "Python already installed:"
    python3 --version

else

    if command -v dnf >/dev/null 2>&1; then

        dnf install -y python3 python3-pip python3-devel gcc gcc-c++

    elif command -v yum >/dev/null 2>&1; then

        yum install -y python3 python3-pip python3-devel gcc gcc-c++

    elif command -v apt >/dev/null 2>&1; then

        apt update

        apt install -y \
            python3 \
            python3-pip \
            python3-venv \
            python3-dev \
            build-essential

    else

        echo "Unsupported operating system."

        exit 1

    fi

fi


echo
echo "Python Version:"
python3 --version


echo
echo "Pip Version:"
pip3 --version


echo
echo "Creating Backend Virtual Environment"


BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

BACKEND_DIR="$BASE_DIR/backend"

VENV_DIR="$BACKEND_DIR/venv"


if [ -d "$BACKEND_DIR" ]; then

    if [ ! -d "$VENV_DIR" ]; then

        python3 -m venv "$VENV_DIR"

    fi

fi


echo
echo "Python environment ready."

echo "Virtual Env:"
echo "$VENV_DIR"
