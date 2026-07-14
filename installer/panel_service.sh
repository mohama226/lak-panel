#!/bin/bash

while true
do

clear

echo "========== PANEL SERVICE =========="
echo
echo "1) Start"
echo "2) Stop"
echo "3) Restart"
echo "4) Status"
echo
echo "0) Back"
echo

read -rp "Select: " op

case $op in

1) systemctl start l-panel ;;
2) systemctl stop l-panel ;;
3) systemctl restart l-panel ;;
4) systemctl status l-panel ;;
0) exit ;;
esac

echo
read -p "Press Enter..."

done
