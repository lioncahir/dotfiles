#!/bin/bash

options=(\
"Add NAS to /etc/fstab" \
"Disable automatic printer discovery" \
"Decrease swappiness" \
"Perform software changes" \
"Configure Cinnamon apps (Nemo, xed)" \
"Perform Cinnamon theming" \
"Install printer & scanner (Samsung M2070)" \
"Enable Bluetooth" \
"Set systemd timers (reflector)" \
"Quit" \
)

add_nas () {
    sudo mkdir -pv /media/NAS/Media
    sudo groupadd -g 1500 nasmedia
    sudo usermod -a -G nasmedia $USER
    sudo cp /etc/fstab /etc/fstab.old
    echo "//192.168.0.5/Media   /media/NAS/Media   cifs   guest,user,noauto,nofail,uid=$UID,gid=1500,file_mode=0770,dir_mode=0770,_netdev,iocharset=utf8,comment=x-gvfs-show   0   0" | sudo tee -a /etc/fstab
    sudo mount -a
}


disable_printer_discovery () {
    sudo systemctl disable --now cups-browsed
}

decrease_swappiness () {
    echo vm.swappiness=10 | sudo tee /etc/sysctl.d/99-swappiness.conf
}

software_changes () {
    sudo pacman -Syu
    sudo pacman -S --needed borg python-llfuse eza starship mediainfo vim ttf-jetbrains-mono-nerd kitty bat gdu fzf yazi fastfetch btop unarchiver
    sudo pacman -S --needed libreoffice-fresh foliate gnome-disk-utility xarchiver
    sudo pacman -S --needed gvfs-google gvfs-goa gnome-keyring gnome-calendar gnome-online-accounts
    sudo pacman -R gnome-calculator nemo-fileroller file-roller gnome-system-monitor
    yay -S nemo-mediainfo-tab gnome-calculator-gtk3 baobab-gtk3 hunspell-sk gnome-online-accounts-gtk
}

cinnamon_apps () {
    gsettings set org.cinnamon.sounds login-enabled false
    gsettings set org.cinnamon.sounds logout-enabled false

    gsettings set org.nemo.list-view default-zoom-level 'small'
    gsettings set org.nemo.preferences date-format 'iso'
    gsettings set org.nemo.preferences default-folder-viewer 'icon-view'
    gsettings set org.nemo.preferences default-sort-order 'type'
    gsettings set org.nemo.preferences ignore-view-metadata true
    gsettings set org.nemo.preferences inherit-show-thumbnails false
    gsettings set org.nemo.preferences show-hidden-files false
    gsettings set org.nemo.preferences show-image-thumbnails 'local-only'
    gsettings set org.nemo.preferences show-location-entry true
    gsettings set org.nemo.preferences show-show-thumbnails-toolbar false
    gsettings set org.nemo.preferences show-advanced-permissions true

    gsettings set org.x.editor.preferences.editor bracket-matching false
    gsettings set org.x.editor.preferences.editor display-line-numbers true
    gsettings set org.x.editor.preferences.editor display-right-margin false
    gsettings set org.x.editor.preferences.editor draw-whitespace false
    gsettings set org.x.editor.preferences.editor draw-whitespace-inside false
    gsettings set org.x.editor.preferences.editor draw-whitespace-leading false
    gsettings set org.x.editor.preferences.editor draw-whitespace-newline false
    gsettings set org.x.editor.preferences.editor draw-whitespace-trailing false
    gsettings set org.x.editor.preferences.editor scheme 'oblivion'
    gsettings set org.x.editor.preferences.editor highlight-current-line false
    gsettings set org.x.editor.preferences.editor use-default-font false
    gsettings set org.x.editor.preferences.ui minimap-visible false
    gsettings set org.x.editor.preferences.ui statusbar-visible true
}

cinnamon_theming () {
    sudo pacman -S --needed papirus-icon-theme
    yay -S mint-themes papirus-folders
    gsettings set org.cinnamon.theme name 'Mint-Y-Dark-Purple'
    gsettings set org.cinnamon.desktop.interface gtk-theme 'Mint-Y-Dark-Purple'
    gsettings set org.cinnamon.desktop.interface icon-theme 'Papirus-Dark'
    gsettings set org.cinnamon.desktop.interface font-name 'Ubuntu 10'
    gsettings set org.cinnamon.desktop.wm.preferences titlebar-font 'Ubuntu Semi-Bold 10'
    gsettings set org.nemo.desktop font 'Ubuntu 10'
    gsettings set org.gnome.desktop.interface document-font-name 'Sans 10'
    gsettings set org.gnome.desktop.interface monospace-font-name 'Monospace 10'
    gsettings set org.cinnamon.desktop.interface text-scaling-factor 1.2
    papirus-folders -C violet --theme Papirus-Dark
}

scanner () {
    sudo pacman -S --needed simple-scan
    yay -S samsung-unified-driver-scanner samsung-unified-driver-printer
}

bluetooth () {
    sudo systemctl enable --now bluetooth
    sudo pacman -S --needed blueman
}

timers () {
    sudo sed -i "/^--sort/c\--sort rate" /etc/xdg/reflector/reflector.conf
    sudo sed -i "/^# --country/c\--country Slovakia,Czechia,Austria,Germany" /etc/xdg/reflector/reflector.conf
    sudo systemctl enable reflector.timer
}

clear

echo -e "\033[1;35m"
echo -e "****************************************"
echo -e "* Post-install script for Endeavour OS *"
echo -e "****************************************"
echo -e "\033[0m"

PS3="Choose an option: "
COLUMNS=12
select opt in "${options[@]}"; do
echo
    case $REPLY in
        1) add_nas ;;
        2) disable_printer_discovery ;;
        3) decrease_swappiness ;;
        4) software_changes ;;
        5) cinnamon_apps ;;
        6) cinnamon_theming ;;
        7) scanner ;;
        8) bluetooth ;;
        9) timers ;;
        10) break 2 ;;
        *) echo "Invalid option" >&2
    esac
    REPLY=
    COLUMNS=12
    echo
done


