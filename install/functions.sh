#!/usr/bin/env bash

green() {
    echo -e "\e[32m$1\e[0m"
}

red() {
    echo -e "\e[31m$1\e[0m"
}

yellow() {
    echo -e "\e[33m$1\e[0m"
}

blue() {
    echo -e "\e[36m$1\e[0m"
}

error_exit() {
    red "$1"
    exit 1
}

check_root() {

    if [ "$EUID" -ne 0 ]; then
        error_exit "Please run installer as root."
    fi

}

check_os() {

    source /etc/os-release

    if [ "$ID" != "ubuntu" ]; then
        error_exit "Only Ubuntu is supported."
    fi

}

create_directories() {

    mkdir -p "$INSTALL_DIR"

    mkdir -p "$CONFIG_DIR"

    mkdir -p "$LOG_DIR"

    mkdir -p "$BACKUP_DIR"

    mkdir -p "$UPLOAD_DIR"

    mkdir -p "$TMP_DIR"

}

install_packages() {

    blue "Installing required packages..."

    apt update

    apt install -y \
        git \
        curl \
        wget \
        unzip \
        python3 \
        python3-pip \
        python3-venv \
        build-essential

}
