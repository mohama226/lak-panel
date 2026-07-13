#!/usr/bin/env bash

green(){

echo -e "\033[32m$1\033[0m"

}

red(){

echo -e "\033[31m$1\033[0m"

}

yellow(){

echo -e "\033[33m$1\033[0m"

}

blue(){

echo -e "\033[36m$1\033[0m"

}

error_exit(){

red "$1"

exit 1

}

check_root(){

if [ "$EUID" -ne 0 ]; then

error_exit "Run installer as root."

fi

}

wait_for_apt(){

while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1

do

yellow "Waiting apt..."

sleep 5

done

}

create_directories(){

mkdir -p "$CONFIG_DIR"

mkdir -p "$DATA_DIR"

mkdir -p "$LOG_DIR"

mkdir -p "$BACKUP_DIR"

mkdir -p "$TMP_DIR"

}
