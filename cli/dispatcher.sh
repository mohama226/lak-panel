#!/usr/bin/env bash


case "$1" in


start)

systemctl start l-panel

;;


stop)

systemctl stop l-panel

;;


restart)

systemctl restart l-panel

;;


status)

systemctl status l-panel

;;


update)

bash /opt/l-panel/install/update.sh

;;


*)

echo "Usage:"

echo "l-panel start"

echo "l-panel stop"

echo "l-panel restart"

echo "l-panel status"

echo "l-panel update"


;;

esac
