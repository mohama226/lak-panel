#!/bin/bash
set -e

echo "[+] Installing system dependencies..."

dnf install -y epel-release
dnf install -y git
dnf install -y python3 python3-pip python3-devel gcc gcc-c++ make \
               postgresql postgresql-server postgresql-devel \
               ocserv

echo "[+] Dependencies installed."
