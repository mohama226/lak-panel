#!/bin/bash


while true
do

clear


echo "================================="
echo "          LAK PANEL"
echo "================================="


echo "1) Status"
echo "2) Restart"
echo "3) Stop"
echo "4) Start"
echo "5) Logs"
echo "6) Update"
echo "0) Exit"


read -p "Select: " c


case $c in


1)
systemctl status lak-panel --no-pager
read
;;


2)
systemctl restart lak-panel
echo "Restarted"
read
;;


3)
systemctl stop lak-panel
read
;;


4)
systemctl start lak-panel
read
;;


5)
journalctl -u lak-panel -n 100 --no-pager
read
;;


6)
/opt/lak-panel/scripts/update.sh
read
;;


0)
exit
;;


esac


done
