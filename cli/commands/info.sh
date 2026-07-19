#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

INFO_FILE="/etc/l-panel/ocserv.info"
VERSION_FILE="/opt/l-panel/VERSION"

title

echo
echo "=============================================="
echo "             SERVER INFORMATION"
echo "=============================================="
echo

PANEL_VERSION="-"

if [[ -f "$VERSION_FILE" ]]; then
    PANEL_VERSION=$(cat "$VERSION_FILE")
fi

VPN_VERSION="-"
VPN_PORT="-"

if [[ -f "$INFO_FILE" ]]; then
    source "$INFO_FILE"
    VPN_VERSION="${VERSION:-Unknown}"
    VPN_PORT="${PORT:-Unknown}"
fi

echo "Panel Version  : $PANEL_VERSION"
echo "Ocserv Version : $VPN_VERSION"
echo "VPN Port       : $VPN_PORT"

echo
#############################################
# OPERATING SYSTEM
#############################################

OS_NAME=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')

HOSTNAME=$(hostname)

KERNEL=$(uname -r)

ARCH=$(uname -m)

echo "Operating System"
echo "--------------------------------"

echo "OS        : $OS_NAME"

echo "Hostname  : $HOSTNAME"

echo "Kernel    : $KERNEL"

echo "Arch      : $ARCH"

echo



#############################################
# CPU
#############################################

CPU_MODEL=$(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2- | xargs)

CPU_CORES=$(nproc)

LOAD=$(cat /proc/loadavg | awk '{print $1" "$2" "$3}')

echo "CPU"
echo "--------------------------------"

echo "Model     : $CPU_MODEL"

echo "Cores     : $CPU_CORES"

echo "Load Avg  : $LOAD"

echo



#############################################
# MEMORY
#############################################

MEM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')

MEM_USED=$(free -h | awk '/Mem:/ {print $3}')

MEM_FREE=$(free -h | awk '/Mem:/ {print $4}')

echo "Memory"
echo "--------------------------------"

echo "Total     : $MEM_TOTAL"

echo "Used      : $MEM_USED"

echo "Free      : $MEM_FREE"

echo



#############################################
# DISK
#############################################

DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')

DISK_USED=$(df -h / | awk 'NR==2 {print $3}')

DISK_FREE=$(df -h / | awk 'NR==2 {print $4}')

DISK_USE=$(df -h / | awk 'NR==2 {print $5}')

echo "Disk"
echo "--------------------------------"

echo "Total     : $DISK_TOTAL"

echo "Used      : $DISK_USED"

echo "Free      : $DISK_FREE"

echo "Usage     : $DISK_USE"

echo
#############################################
# NETWORK
#############################################

PUBLIC_IP=$(curl -4 -fsS https://api.ipify.org 2>/dev/null || echo "Unavailable")

PRIVATE_IP=$(hostname -I 2>/dev/null | awk '{print $1}')

echo "Network"
echo "--------------------------------"

echo "Public IP : $PUBLIC_IP"

echo "Private IP: ${PRIVATE_IP:-Unavailable}"

echo



#############################################
# UPTIME
#############################################

UPTIME=$(uptime -p)

BOOT_TIME=$(who -b | awk '{print $3" "$4}')

echo "System"

echo "--------------------------------"

echo "Uptime    : $UPTIME"

echo "Boot Time : $BOOT_TIME"

echo



#############################################
# OCSERV
#############################################

STATUS="Stopped"

if systemctl is-active ocserv >/dev/null 2>&1
then
    STATUS="Running"
fi

ONLINE_USERS=0

if command -v occtl >/dev/null 2>&1
then
    ONLINE_USERS=$(occtl show users 2>/dev/null | tail -n +2 | wc -l)
fi

REGISTERED_USERS=0

if [[ -f /etc/ocserv/ocpasswd ]]
then
    REGISTERED_USERS=$(grep -vc '^$' /etc/ocserv/ocpasswd)
fi

echo "Ocserv"

echo "--------------------------------"

echo "Status      : $STATUS"

echo "Users       : $REGISTERED_USERS"

echo "Online      : $ONLINE_USERS"

echo



#############################################
# L-PANEL
#############################################

echo "L-Panel"

echo "--------------------------------"

echo "Install Dir : /opt/l-panel"

echo "Config Dir  : /etc/l-panel"

echo "Command     : /usr/local/bin/l-panel"

if [[ -f /opt/l-panel/.last_update ]]
then
    echo "Last Update : $(cat /opt/l-panel/.last_update)"
fi

echo

echo "=============================================="

pause

exit 0
