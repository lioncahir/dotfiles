#!/bin/bash

# Function to display desktop notification
notify-current () {
   sudo -u $username DISPLAY=${display:1:-1} \
                          DBUS_SESSION_BUS_ADDRESS=$dbus \
                          notify-send "$@"
}

# This script is typically run as a systemd service under root, so we need to find the current (active) user
tty_user=($(who | grep -E "\(:[0-9](\.[0-9])*\)" | awk '{print $1 "@" $NF}'))
username=${tty_user%@*}
display=${tty_user#*@}
dbus=unix:path=/run/user/$(id -u $username)/bus

# Define directories
source_dir=/home/$username
backup_dir=/media/NAS/Media/Backup/${username^}/$HOSTNAME
mkdir -pv ${backup_dir}

notify-current "Starting backup, do not unmount NAS"

# The service has output redirection, so all echos go directly to a logfile
echo "================================================================"
echo "$(date '+%F %T') Starting backup"
echo "$(date '+%F %T') Source directory: ${source_dir}"
echo -e "$(date '+%F %T') Backup directory: ${backup_dir}\n"

rsync -avhL --no-perms --no-owner --no-group --delete --delete-excluded \
  --exclude 'Downloads' \
  --exclude 'Videos' \
  --exclude '.cache' \
  --exclude '.mozilla' \
  --exclude '.cinnamon/spices.cache' \
  --exclude '.local/share/Trash' \
  --exclude '.local/share/ice/firefox' \
  --exclude '.local/share/webkitgtk' \
  "${source_dir}/" \
  "${backup_dir}/"

echo "$(date '+%F %T') Backup finished"

notify-current "Backup completed"



