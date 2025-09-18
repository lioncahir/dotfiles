#!/bin/bash

if [ -z $(find ~/ -maxdepth 1 -mtime -5 -name "NASBackup.log") ]
then
#    ~/.local/bin/borg_backup.sh &>> ~/NASBackup.log
    cp /etc/fstab ~/.config/
    pacman -Qeq > ~/.config/packages.list 2>/dev/null
    mount /media/NAS/Media

    borgmatic --config ~/.config/borgmatic/config.yaml
    borgmatic --config ~/.config/borgmatic/NAS.yaml
fi

