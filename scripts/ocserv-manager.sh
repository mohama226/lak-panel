#!/bin/bash

OCSERV_PASS="/etc/ocserv/ocpasswd"
SERVICE="ocserv"


ACTION=$1


case "$ACTION" in


add)

USERNAME=$2
PASSWORD=$3


if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
    exit 1
fi


/usr/bin/ocpasswd \
-c "$OCSERV_PASS" \
-g "$USERNAME" \
"$USERNAME" <<EOF
$PASSWORD
$PASSWORD
EOF


systemctl restart $SERVICE


;;


delete)

USERNAME=$2


if [ -z "$USERNAME" ]; then
    exit 1
fi


/usr/bin/ocpasswd \
-c "$OCSERV_PASS" \
-d "$USERNAME"


systemctl restart $SERVICE


;;


*)

exit 1


;;

esac
