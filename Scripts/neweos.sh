#!/bin/bash

options=(\
"Add NAS to /etc/fstab" \
"Install and configure i3wm" \
"Install and configure SwayWM" \
"Install and configure Niri" \
"Install Greetd login manager" \
"Configure Cinnamon DE" \
"Install printer & scanner (Samsung M2070)" \
"Enable Bluetooth" \
"Customize Reflector and Paccache" \
"Quit" \
)

add_nas () {
    sudo mkdir -pv /media/NAS/Media
    sudo groupadd -g 1500 nasmedia
    sudo usermod -a -G nasmedia $USER
    sudo cp /etc/fstab /etc/fstab.old
    echo "//192.168.0.5/Media   /media/NAS/Media   cifs   sec=none,user,noauto,nofail,uid=$UID,gid=1500,file_mode=0770,dir_mode=0770,_netdev,iocharset=utf8,comment=x-gvfs-show   0   0" | sudo tee -a /etc/fstab
    sudo mount -a
}


i3wm () {
    cd ~/.dotfiles
    sudo pacman -S --needed - < ~/.dotfiles/i3pkg
    yay -S --needed - < ~/.dotfiles/i3aur
    rm ~/.bashrc ~/.bash_profile
    stow -v eos i3 kitty vim yazi bat btop borg mpv starship yazi zathura
    ya pkg upgrade
    bat cache --build
    feh --bg-scale ~/Pictures/endeavour-black-4k.png
    papirus-folders -t Papirus-Dark -C cat-mocha-lavender
    vim +PlugInstall +qall
    sudo systemctl enable lightdm.service
}

swaywm () {
    cd ~/.dotfiles
    yay -S --needed - < ~/.dotfiles/swaypkg
    rm ~/.bashrc ~/.bash_profile
    stow -v eos bat borg btop foot fuzzel mako mpv networkmanager-dmenu starship sway swayimg swaylock vim waybar yazi zathura
    ya pkg upgrade
    bat cache --build
    ln -s ~/Pictures/endeavour-black-4k.png ~/.wallpaper
    papirus-folders -t Papirus-Dark -C cat-mocha-lavender
    vim +PlugInstall +qall
    sudo cp ~/.dotfiles/Scripts/eos/sway /usr/local/bin/
    sudo cp ~/.dotfiles/Scripts/eos/waitwinch /usr/local/bin/
}

niri () {
    cd ~/.dotfiles
    yay -S --needed - < ~/.dotfiles/niripkg
    rm ~/.bashrc ~/.bash_profile
    stow -v eos bat borg btop foot fuzzel mako mpv networkmanager-dmenu niri starship swayimg swaylock vim waybar yazi zathura
    ya pkg upgrade
    bat cache --build
    ln -s ~/Pictures/endeavour-black-4k.png ~/.wallpaper
    papirus-folders -t Papirus-Dark -C cat-mocha-lavender
    vim +PlugInstall +qall
    sudo cp ~/.dotfiles/Scripts/eos/waitwinch /usr/local/bin/
}

greetd () {
    sudo pacman -S --needed greetd-regreet cage
    sudo cp ~/.dotfiles/Scripts/regreet/* /etc/greetd/
    sudo systemctl disable lightdm.service
    sudo systemctl enable greetd.service
}

cinnamon () {
    sudo pacman -Syu
    sudo pacman -S --needed borg python-llfuse eza starship mediainfo vim ttf-jetbrains-mono-nerd kitty bat gdu fzf yazi fastfetch btop unarchiver papirus-icon-theme
    sudo pacman -S --needed libreoffice-fresh foliate gnome-disk-utility xarchiver
    sudo pacman -S --needed gvfs-google gvfs-goa gnome-keyring gnome-calendar 
    sudo pacman -R gnome-calculator nemo-fileroller file-roller gnome-system-monitor
    yay -S nemo-mediainfo-tab gnome-calculator-gtk3 baobab-gtk3 hunspell-sk gnome-online-accounts-gtk mint-themes papirus-folders
    papirus-folders -C violet --theme Papirus-Dark
}

scanner () {
    yay -S simple-scan-linuxmint samsung-unified-driver-scanner samsung-unified-driver-printer
    sudo ufw allow 22161/udp
}

bluetooth () {
    sudo systemctl enable --now bluetooth
    sudo pacman -S --needed blueman
}

timers () {
    sudo cp ~/.dotfiles/Scripts/eos/paccache.hook /usr/share/libalpm/hooks/
    sudo cp ~/.dotfiles/Scripts/eos/reflector.timer /etc/systemd/system/
    sudo cp ~/.dotfiles/Scripts/eos/reflector.conf /etc/xdg/reflector/reflector.conf
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
        2) i3wm ;;
        3) swaywm ;;
        4) niri ;;
        5) greetd ;;
        6) cinnamon;;
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


