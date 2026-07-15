#!/bin/bash

set -e

source /opt/l-panel/installer/lib.sh

echo "Running post install..."

create_venv

install_python

fix_permissions

create_symlink

install_systemd

restart_services

echo "Finished."
