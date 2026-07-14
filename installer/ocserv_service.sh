#!/bin/bash

while true
do

clear

echo "========== OCSERV SERVICE =========="
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

1) systemctl start ocserv ;;
2) systemctl stop ocserv ;;
3) systemctl restart ocserv ;;
4) systemctl status ocserv ;;
0) exit ;;

esac

echo
read -p "Press Enter..."

done
