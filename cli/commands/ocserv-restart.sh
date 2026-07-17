#!/usr/bin/env bash


systemctl restart ocserv


if systemctl is-active --quiet ocserv
then

    echo "[ OK ] Ocserv restarted"

else

    echo "[ FAIL ] Ocserv failed"

fi


read -rp "Press ENTER..."
