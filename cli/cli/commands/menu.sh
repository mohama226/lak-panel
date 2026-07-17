#!/usr/bin/env bash

show_menu(){

clear

title

cat <<EOF

==============================================
Version      : $(get_version)
Status       : Installed
Last Update  : $(get_last_update)
==============================================

==============================
 SYSTEM
==============================

1) Install L-Panel
2) Update L-Panel
3) Uninstall L-Panel

==============================
 VPN
==============================

4) Install Ocserv
5) Ocserv Status
6) Restart Ocserv
7) Stop Ocserv
8) Start Ocserv

==============================
 USERS
==============================

9) User Manager

10) Online Users

11) Disconnect User

12) User Statistics

==============================
 SECURITY
==============================

13) SSL Manager

14) Firewall

15) Fail2Ban

==============================
 BACKUP
==============================

16) Backup

17) Restore

==============================
 MONITORING
==============================

18) Dashboard

19) System Status

20) Services

21) Logs

22) Versions

0) Exit

EOF

}
