#!/usr/bin/env bash

INSTALL_PATH="/opt/l-panel"

COMMAND="${1:-menu}"

case "$COMMAND" in

    menu)
        bash "${INSTALL_PATH}/install/menu.sh"
        ;;

    update)
        bash "${INSTALL_PATH}/install/update.sh"
        ;;

    uninstall)
        bash "${INSTALL_PATH}/install/uninstall.sh"
        ;;

    install)
        bash "${INSTALL_PATH}/install/install.sh"
        ;;

    status)
        systemctl status l-panel
        ;;

    start)
        systemctl start l-panel
        ;;

    stop)
        systemctl stop l-panel
        ;;

    restart)
        systemctl restart l-panel
        ;;

    *)

        echo ""

        echo "L-Panel CLI"

        echo ""

        echo "Usage:"

        echo "  l-panel"

        echo "  l-panel start"

        echo "  l-panel stop"

        echo "  l-panel restart"

        echo "  l-panel status"

        echo "  l-panel update"

        echo "  l-panel uninstall"

        echo ""

        exit 1
        ;;

esac
