#!/bin/bash


ACTION=$1


USER=$2

PASS=$3


OCUSER="/etc/ocserv/ocpasswd"



case $ACTION in


add)

if [ -z "$USER" ] || [ -z "$PASS" ]; then
exit 1
fi


echo "$PASS" | /usr/bin/ocpasswd \
-c "$OCUSER" \
"$USER"


systemctl restart ocserv


;;



delete)


sed -i "/^$USER:/d" "$OCUSER"


systemctl restart ocserv


;;


*)

echo "Usage:"
echo "add username password"
echo "delete username"

exit 1


;;

esac

exit 0
