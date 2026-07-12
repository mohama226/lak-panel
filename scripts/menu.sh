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
    echo " 1) Install"
    echo " 2) Update"
    echo " 3) Restart Service"
    echo " 4) Stop Service"
    echo " 5) Start Service"
    echo " 6) Service Status"
    echo " 7) View Logs"
    echo " 8) Uninstall"
    echo
    echo " 0) Exit"
    echo
    read -rp "Select an option: " option

    case "$option" in

        1)
            if [ -f "$SCRIPT_DIR/install.sh" ]; then
                bash "$SCRIPT_DIR/install.sh"
            else
                echo
                echo "Install script not found."
            fi
            ;;

        2)
            if [ -f "$SCRIPT_DIR/update.sh" ]; then
                bash "$SCRIPT_DIR/update.sh"
            else
                echo
                echo "Update script not found."
            fi
            ;;

        3)
            bash "$SCRIPT_DIR/service.sh" restart
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
