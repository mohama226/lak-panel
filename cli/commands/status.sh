#!/usr/bin/env bash

source "$(dirname "$0")/../lib/colors.sh"
source "$(dirname "$0")/../lib/common.sh"

header "SYSTEM STATUS"

printf "%-20s %s\n" "L-Panel" "$(panel_status)"
printf "%-20s %s\n" "Version" "$(get_version)"
printf "%-20s %s\n" "Last Update" "$(get_last_update)"

echo

if command_exists ocserv
then
    OCVERSION=$(ocserv -v | head -1)

    printf "%-20s %s\n" "Ocserv" "Installed"
    printf "%-20s %s\n" "Version" "$OCVERSION"
    printf "%-20s %s\n" "Service" "$(service_status ocserv)"

else

    printf "%-20s %s\n" "Ocserv" "Not Installed"

fi

echo

printf "%-20s %s\n" "Firewalld" "$(service_status firewalld)"
printf "%-20s %s\n" "Fail2Ban" "$(service_status fail2ban)"
printf "%-20s %s\n" "PostgreSQL" "$(service_status postgresql)"

echo

pause
