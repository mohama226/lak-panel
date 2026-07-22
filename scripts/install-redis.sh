#!/usr/bin/env bash

set -Eeuo pipefail

echo "=================================="
echo " Installing Redis"
echo "=================================="


if command -v redis-server >/dev/null 2>&1; then

    echo "Redis already installed:"

    redis-server --version

    exit 0

fi


if command -v dnf >/dev/null 2>&1; then

    dnf install -y redis


elif command -v yum >/dev/null 2>&1; then

    yum install -y redis


elif command -v apt >/dev/null 2>&1; then

    apt update

    apt install -y redis-server


else

    echo "Unsupported operating system."

    exit 1

fi



systemctl enable redis

systemctl start redis



echo

echo "Checking Redis status..."



if systemctl is-active --quiet redis; then

    echo "Redis is running."

else

    echo "Redis failed to start."

    exit 1

fi



echo
echo "=================================="
echo " Redis Ready"
echo "=================================="
