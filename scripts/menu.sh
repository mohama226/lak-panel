#!/bin/bash

SCRIPT_DIR="/opt/lak-panel/scripts"

while true
do
    clear

    echo "========================================="
    echo "          LAK PANEL MANAGER"
    echo "               Version 0.0.2"
    echo "========================================="
    echo
    echo " 1) Install Panel"
    echo " 2) Install ocserv"
    echo " 3) Update"
    echo " 4) Restart Service"
    echo " 5) Stop Service"
    echo " 6) Start Service"
    echo " 7) Service Status"
    echo " 8) View Logs"
    echo " 9) Uninstall"
    echo
    echo " 0) Exit"
    echo
    read -rp "Select an option: " option

    case "$option" in

        1)
            if [ -f "/opt/lak-panel/install.sh" ]; then
                bash /opt/lak-panel/install.sh
            else
                echo
                echo "Main install script not found."
            fi
            ;;

        2)
            if [ -f "/opt/lak-panel/install/install_ocserv.sh" ]; then
        
                bash /opt/lak-panel/install/install_ocserv.sh
        
            else
        
                echo
                echo "ocserv installer not found."
        
            fi
            ;;

        3)
            if [ -f "$SCRIPT_DIR/update.sh" ]; then
                bash "$SCRIPT_DIR/update.sh"
            else
                echo
                echo "Update script not found."
            fi
            ;;

        4)
            bash "$SCRIPT_DIR/service.sh" stop
            ;;

        5)
            bash "$SCRIPT_DIR/service.sh" start
            ;;

        6)
            bash "$SCRIPT_DIR/service.sh" status
            ;;

        7)
            bash "$SCRIPT_DIR/service.sh" logs
            ;;

        8)
            if [ -f "$SCRIPT_DIR/uninstall.sh" ]; then
                bash "$SCRIPT_DIR/uninstall.sh"
            else
                echo
                echo "Uninstall script not found."
            fi
            ;;

        0)
            exit 0
            ;;

        *)
            echo
            echo "Invalid option!"
            ;;

    esac

    echo
    read -n 1 -s -r -p "Press any key to continue..."
done
