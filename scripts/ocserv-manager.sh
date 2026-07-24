#!/bin/bash

ACTION=$1
USERNAME=$2
PASSWORD=$3


OCFILE="/etc/ocserv/ocpasswd"


case "$ACTION" in


add)

echo "$PASSWORD" | ocpasswd -c "$OCFILE" "$USERNAME"

systemctl restart ocserv

;;


delete)

ocpasswd -c "$OCFILE" -d "$USERNAME"

systemctl restart ocserv

;;


restart)

systemctl restart ocserv

;;


*)

echo "Invalid action"

exit 1

;;


esac
