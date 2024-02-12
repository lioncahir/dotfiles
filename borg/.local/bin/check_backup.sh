#!/bin/bash

if [ -z $(find ~/ -maxdepth 1 -mtime -5 -name "NASBackup.log") ]
then
    ~/.local/bin/borg_backup.sh &>> ~/NASBackup.log
fi

