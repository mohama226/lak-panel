#!/usr/bin/env bash

clear

echo "======================================"
echo "            L-PANEL"
echo "======================================"

echo

echo "1) Start Panel"

echo "2) Stop Panel"

echo "3) Restart Panel"

echo "4) Status"

echo "5) Update"

echo "6) Exit"

echo

read -rp "Select: " choice

case "$choice" in

1)

systemctl start l-panel

;;

2)

systemctl stop l-panel

;;

3)

systemctl restart l-panel

;;

4)

systemctl status l-panel

;;

5)

bash /opt/l-panel/install/update.sh

;;

6)

exit

;;

*)

echo "Invalid Option"

;;

esac
