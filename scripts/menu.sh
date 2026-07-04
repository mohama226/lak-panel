#!/bin/bash

clear

echo "======================================"
echo "        LAK PANEL MANAGER"
echo "======================================"
echo
echo "1) Install"
echo "2) Update"
echo "3) Restart"
echo "4) Stop"
echo "5) Start"
echo "6) Status"
echo "7) Logs"
echo "8) Uninstall"
echo
echo "0) Exit"
echo
read -p "Select: " option

case $option in

1)
echo "Install selected"
;;

2)
echo "Update selected"
;;

3)
systemctl restart lak-panel
;;

4)
systemctl stop lak-panel
;;

5)
systemctl start lak-panel
;;

6)
systemctl status lak-panel --no-pager
;;

7)
journalctl -u lak-panel -n 50 --no-pager
;;

8)
echo "Uninstall selected"
;;

0)
exit
;;

*)
echo "Invalid option"
;;

esac
