#!/bin/bash


BASE="/opt/lak-panel"


DATE=$(date +"%Y-%m-%d_%H-%M-%S")


mkdir -p $BASE/backup/backups



tar -czf \
$BASE/backup/backups/backup-$DATE.tar.gz \
$BASE/panel \
$BASE/config



echo "Backup:"
echo "$BASE/backup/backups/backup-$DATE.tar.gz"
