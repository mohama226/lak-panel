#!/bin/bash

clear

while true
do

clear

echo "========================================"
echo "           L-PANEL MANAGER"
echo "========================================"
echo
echo "1) Install / Repair L-Panel"
echo "2) Update L-Panel"
echo "3) Install Ocserv 1.5.0"
echo "4) Uninstall L-Panel"
echo
echo "0) Exit"
echo

read -p "Select: " OPTION

case $OPTION in

1)
bash /opt/l-panel/installer/install.sh
;;

2)
bash /opt/l-panel/installer/update.sh
;;

3)
bash /opt/l-panel/installer/install_ocserv.sh
;;

4)
bash /opt/l-panel/installer/uninstall.sh
;;

0)
exit
;;

*)
echo "Wrong option"
sleep 1
;;

esac

done
