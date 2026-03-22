#!/usr/bin/env bash

if [[ -r "$HOME/.borg-passphrase" ]]; then
    cp /etc/fstab ~/.config/
    pacman -Qeq > ~/.config/packages.list 2>/dev/null
    mountpoint -q /media/NAS/Media || mount /media/NAS/Media
    notify-send --icon="gtk-dialog-info" "Borgmatic" "Starting Borgmatic backups"

    borgmatic --config ~/.config/borgmatic/config.yaml
    borgmatic --config ~/.config/borgmatic/NAS.yaml
fi

