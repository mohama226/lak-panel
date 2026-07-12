#!/bin/bash

source installer/paths.sh


echo "
====================================
 LAK PANEL CONFIGURATION
====================================
"


read -p "SuperAdmin username: " ADMIN_USER


while true
do
read -s -p "SuperAdmin password: " ADMIN_PASS
echo

read -s -p "Repeat password: " ADMIN_PASS2
echo


if [ "$ADMIN_PASS" = "$ADMIN_PASS2" ]
then
break
fi

echo "Password mismatch"

done



read -p "Panel port [2096]: " PORT


if [ -z "$PORT" ]
then
PORT=2096
fi



cat > $CONFIG_FILE <<EOF

ADMIN_USER=$ADMIN_USER
ADMIN_PASS=$ADMIN_PASS
PANEL_PORT=$PORT

EOF



echo "
Configuration saved:

Path:
$CONFIG_FILE

Panel:
$PANEL_ROOT

Port:
$PORT

"
