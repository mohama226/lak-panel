#!/bin/bash

source /opt/lak-panel/scripts/common.sh

case "$1" in

start)

systemctl start $SERVICE_NAME
;;

stop)

systemctl stop $SERVICE_NAME
;;

restart)

systemctl restart $SERVICE_NAME
;;

status)

systemctl status $SERVICE_NAME --no-pager
;;

logs)

journalctl -u $SERVICE_NAME -n 50 --no-pager
;;

*)

echo "Usage: service.sh start|stop|restart|status|logs"

;;

esac
