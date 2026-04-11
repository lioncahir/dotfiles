#!/usr/bin/env bash

# Main launcher for Borgmatic backups, which executes backups to both BorgBase online repository
# and to NAS. It is started from a systemd user unit.
#
# Prerequisites:
# 1) all files correctly stowed (this script, Borgmatic config files, systemd user units)
# 2) file ~/.borg-passphrase must exist and contain password to repositories
# 3) systemd timer needs to be enabled with 'systemctl --user enable borgbackup.timer'
#
# Backup can be executed also manually by running 'systemctl --user start borgbackup.service'
# or for individual repositories by running one of the borgmatic commands from this script.

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

