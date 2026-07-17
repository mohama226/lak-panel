#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/version.sh"

#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

get_cpu_usage() {
top -bn1 | awk '/Cpu/ {print int($2+$4)"%"}'
}

get_ram_usage() {
free | awk '/Mem:/ {printf "%.0f%%", ($3/$2)*100}'
}

get_disk_usage() {
df -h / | awk 'NR==2 {print $5}'
}

get_uptime() {
uptime -p | sed 's/up //'
}

get_load() {
awk '{print $1" "$2" "$3}' /proc/loadavg
}

get_online_users() {
who | wc -l
}

get_ip() {
hostname -I | awk '{print $1}'
}

get_kernel() {
uname -r
}

get_os() {
source /etc/os-release
echo "$PRETTY_NAME"
}

service_status(){

systemctl is-active "$1" >/dev/null 2>&1 \
&& echo "RUNNING" \
|| echo "STOPPED"

}

title

echo

echo "=============================================="
echo "              L-PANEL DASHBOARD"
echo "=============================================="

printf "%-28s %s\n" "Hostname"        "$(hostname)"
printf "%-28s %s\n" "IP Address"      "$(get_ip)"
printf "%-28s %s\n" "Operating System" "$(get_os)"
printf "%-28s %s\n" "Kernel"          "$(get_kernel)"

echo

printf "%-28s %s\n" "CPU Usage"       "$(get_cpu_usage)"
printf "%-28s %s\n" "RAM Usage"       "$(get_ram_usage)"
printf "%-28s %s\n" "Disk Usage"      "$(get_disk_usage)"
printf "%-28s %s\n" "Load Average"    "$(get_load)"
printf "%-28s %s\n" "Uptime"          "$(get_uptime)"

echo

printf "%-28s %s\n" "Ocserv"          "$(service_status ocserv)"
printf "%-28s %s\n" "Firewalld"       "$(service_status firewalld)"
printf "%-28s %s\n" "Fail2Ban"        "$(service_status fail2ban)"
printf "%-28s %s\n" "SSH"             "$(service_status sshd)"

echo

printf "%-28s %s\n" "Online Users"    "$(get_online_users)"

echo

pause
