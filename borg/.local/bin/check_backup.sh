#!/usr/bin/env bash

if [[ -r "$HOME/.borg-passphrase" ]] && [[ -z $(find "$HOME" -maxdepth 1 -mtime -5 -name "NASBackup.log") ]]; then
    cp /etc/fstab ~/.config/
    pacman -Qeq > ~/.config/packages.list 2>/dev/null
    mount /media/NAS/Media
    notify-send --app-name="Borgmatic" "Starting Borgmatic backups"

    borgmatic --config ~/.config/borgmatic/config.yaml
    borgmatic --config ~/.config/borgmatic/NAS.yaml
fi

