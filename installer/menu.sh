#!/bin/bash

source /opt/l-panel/installer/core.sh

while true
do
    lp_header

    echo " Installation"
    echo "--------------------------------"
    echo "1) Install / Repair L-Panel"
    echo "2) Update L-Panel"
    echo "3) Install Ocserv 1.5.0"
    echo "4) Upgrade Ocserv"

    echo

    echo " Configuration"
    echo "--------------------------------"
    echo "5) SSL Certificate"
    echo "6) Configure Domain"
    echo "7) Configure Firewall"
    echo "8) Configure PostgreSQL"

    echo

    echo " Services"
    echo "--------------------------------"
    echo "9) Panel Service"
    echo "10) Ocserv Service"
    echo "11) Restart All Services"

    echo

    echo " Backup"
    echo "--------------------------------"
    echo "12) Backup"
    echo "13) Restore"

    echo

    echo " Tools"
    echo "--------------------------------"
    echo "14) Change Panel Port"
    echo "15) Change Admin Password"
    echo "16) System Information"
    echo "17) Logs"

    echo

    echo " Maintenance"
    echo "--------------------------------"
    echo "18) Uninstall L-Panel"
    echo "19) Reset L-Panel"

    echo
    echo "0) Exit"

    echo

    read -rp "Select: " opt

    case $opt in

    1)
        bash /opt/l-panel/installer/install.sh
        ;;

    2)
        bash /opt/l-panel/installer/update.sh
        ;;

    3)
        bash /opt/l-panel/installer/install_ocserv.sh
        ;;

    4)
        bash /opt/l-panel/installer/upgrade_ocserv.sh
        ;;

    5)
        lp_message "SSL module coming soon"
        ;;

    6)
        lp_message "Domain module coming soon"
        ;;

    7)
        lp_message "Firewall module coming soon"
        ;;

    8)
        lp_message "PostgreSQL module coming soon"
        ;;

    9)
        bash /opt/l-panel/installer/panel_service.sh
        ;;

    10)
        bash /opt/l-panel/installer/ocserv_service.sh
        ;;

    11)
        bash /opt/l-panel/installer/restart_services.sh
        ;;

    12)
        lp_message "Backup module coming soon"
        ;;

    13)
        lp_message "Restore module coming soon"
        ;;

    14)
        lp_message "Port module coming soon"
        ;;

    15)
        lp_message "Password module coming soon"
        ;;

    16)
        bash /opt/l-panel/installer/system_info.sh
        ;;

    17)
        bash /opt/l-panel/installer/logs.sh
        ;;

    18)
        bash /opt/l-panel/installer/uninstall.sh
        ;;

    19)
        lp_message "Reset module coming soon"
        ;;

    0)
        exit 0
        ;;

    *)
        lp_message "Invalid option"
        ;;

    esac
done
