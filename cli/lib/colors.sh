#!/usr/bin/env bash

# ======================================
# L-PANEL Color Library
# ======================================

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
WHITE="\033[1;37m"
GRAY="\033[0;90m"

BOLD="\033[1m"
RESET="\033[0m"

ok() {
    echo -e "${GREEN}[ OK ]${RESET} $1"
}

warn() {
    echo -e "${YELLOW}[ WARN ]${RESET} $1"
}

fail() {
    echo -e "${RED}[ FAIL ]${RESET} $1"
}

info() {
    echo -e "${CYAN}[ INFO ]${RESET} $1"
}

title() {

    clear

    echo -e "${BLUE}"
    echo "==============================================="
    echo "                 L-PANEL"
    echo "==============================================="
    echo -e "${RESET}"

}
