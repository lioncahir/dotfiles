#!/usr/bin/env bash

if [[ -r "$HOME/.borg-passphrase" ]]; then
    cp /etc/fstab ~/.config/
    pacman -Qeq > ~/.config/packages.list 2>/dev/null

    notify-send --icon="gtk-dialog-info" "Borgmatic" "Starting Borgmatic backups"
    borgmatic --config ~/.config/borgmatic/config.yaml

    if mountpoint -q /media/NAS/Media || mount /media/NAS/Media; then
        borgmatic --config ~/.config/borgmatic/NAS.yaml
    else
        notify-send --icon="gtk-dialog-warning" --urgency=critical "Borgmatic" "NAS not reachable, skipping NAS backup"
    fi
fi

