#!/usr/bin/env bash

source "$(dirname "$0")/variables.sh"

source "$(dirname "$0")/functions.sh"

source "$(dirname "$0")/logo.sh"

check_root

check_os

create_directories

install_packages

bash "$(dirname "$0")/postgres.sh"
bash "$(dirname "$0")/env.sh"
bash "$(dirname "$0")/python.sh"

bash "$(dirname "$0")/nginx.sh"

bash "$(dirname "$0")/service.sh"

bash "$(dirname "$0")/ssl.sh"

bash "$(dirname "$0")/firewall.sh"

bash "$(dirname "$0")/ocserv.sh"

green "Installation Finished."
