#!/bin/bash

# Prerequisites:
# -Installed Borg (https://borgbackup.readthedocs.io/en/stable/installation.html#standalone-binary)
# -Borg copied into /usr/local/bin/, with symbolic link created for borgfs
# -Created folder for repository, mkdir -pv /media/NAS/Media/Backup/${USER^}/$HOSTNAME-borg
# -Initiated repository: borg init --encryption=repokey /media/NAS/Media/Backup/${USER^}/$HOSTNAME-borg
# -This script is placed within PATH, e.g. under ~/.local/bin
# -Passphrase is stored in file $HOME/.borg-passphrase

# For Rclone sync to google drive:
# -rclone is installed and configured (https://rclone.org/install/), with name 'remote'
# -rclone_sync is set to 1 in variables
# -rclone_dest contains path to Google Drive's folder

# Usage:
# The script assumes repository under /media/NAS/Media/Backup/${USER^}/$HOSTNAME-borg, this can be changed in variables (BORG_REPO)
# The script assumes passphrase for repository in file $HOME/.borg-passphrase, it's important to keep permissions 600 on this file
# Simple execution: borg_backup.sh &>> ~/NASBackup.log
# Execution can be scheduled using check_backup.sh (add to Cinnamon Startup Applications), which checks last modified date of NASBackup.log

# Define variables
mountpoint=/media/NAS/Media
rclone_sync=1
rclone_dest='remote:Backup/dell-eos'
export BORG_REPO=/media/NAS/Media/Backup/${USER^}/$HOSTNAME-borg
export BORG_PASSCOMMAND="cat $HOME/.borg-passphrase"

# Nice output for log, with date stamp
info () {
    echo -e "$(date '+%F %T') $@" 
}


echo "========================================================================================================================"

# mount NAS if not already mounted
(mount | grep $mountpoint &> /dev/null) || mount $mountpoint
if [ $? -eq 0 ] 
then 
    info "$mountpoint mounted" 
else 
    notify-send "Cannot mount NAS, backup is due"
    info "Cannot mount $mountpoint, run backup manually as soon as possible"
    exit 1
fi

notify-send "Starting backup, do not unmount NAS"
info "Starting backup"

cp /etc/fstab ~/.config/
pacman -Qeq > ~/.config/packages.list 2>/dev/null

borg create                                     \
    --verbose                                   \
    --filter AME                                \
    --list                                      \
    --stats                                     \
    --show-rc                                   \
    --compression zstd,10                       \
    --exclude-caches                            \
    --exclude 'home/*/Downloads'                \
    --exclude 'home/*/Applications'             \
    --exclude 'home/*/Games'                    \
    --exclude 'home/*/Videos'                   \
    --exclude 'home/*/.cache'                   \
    --exclude 'home/*/.mozilla'                 \
    --exclude 'home/*/.cinnamon/spices.cache'   \
    --exclude 'home/*/.local/share/Trash'       \
    --exclude 'home/*/.local/share/lutris'      \
    --exclude 'home/*/.local/share/Steam'       \
    --exclude 'home/*/.local/share/ice/firefox' \
    --exclude 'home/*/.local/share/webkitgtk'   \
    --exclude 'home/*/.var/app/*/cache'         \
                                                \
    ::'{now}'                                   \
    /home/$USER                               

info "Pruning repository"

borg prune                          \
    --list                          \
    --show-rc                       \
    --keep-within 3m               

info "Compacting repository"

borg compact

if [ $rclone_sync -eq 1 ]
then
    info "Synchronising with Google Drive"
    rclone sync $BORG_REPO/ $rclone_dest/ -v
else
    info "Rclone sync was not requested"
fi

info "Backup completed\n"
notify-send "Backup completed"
