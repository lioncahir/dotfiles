#!/bin/bash

options=(\
"Add NAS to /etc/fstab" \
"Add PPAs (LibreOffice, Flatpak, Papirus Icons)" \
"Disable automatic printer discovery" \
"Decrease swappiness" \
"Perform software changes" \
"Install flatpaks" \
"Install Micro text editor" \
"Install Borg backup" \
"Install nnn file manager" \
"Install Hack Nerd font" \
"Install Starship prompt"
"Configure Cinnamon apps (Nemo, xed, xview)" \
"Perform Cinnamon theming" \
"Quit" \
)

add_nas () {
    sudo mkdir -pv /media/NAS/Media
    sudo groupadd -g 1500 nasmedia
    sudo usermod -a -G nasmedia $USER
    sudo cp /etc/fstab /etc/fstab.old
    echo "//192.168.0.5/Media   /media/NAS/Media   cifs   guest,user,noauto,nofail,uid=$UID,gid=1500,file_mode=0770,dir_mode=0770,_netdev,iocharset=utf8   0   0" | sudo tee -a /etc/fstab
    sudo mount -a
}

add_ppas () {
    sudo add-apt-repository ppa:libreoffice/ppa
    sudo add-apt-repository ppa:flatpak/stable
    sudo add-apt-repository ppa:papirus/papirus
    sudo apt update
}

disable_printer_discovery () {
    sudo systemctl stop cups-browsed
    sudo systemctl disable cups-browsed
}

decrease_swappiness () {
    echo "vm.swappiness = 20" | sudo tee -a /etc/sysctl.conf
}

software_changes () {
    sudo apt remove hexchat onboard
    sudo apt install grub2-theme-mint git fonts-crosextra-carlito fonts-crosextra-caladea exa gthumb papirus-folders papirus-icon-theme mpv mediainfo
}

install_flatpaks () {
    flatpak install org.gtk.Gtk3theme.Mint-Y-Dark
    flatpak install com.github.johnfactotum.Foliate
}

install_micro () {
    cd $(xdg-user-dir DOWNLOAD)
    asset=""
    asset=$(curl -s https://api.github.com/repos/zyedidia/micro/releases/latest | grep "browser_download_url.*deb" | cut -d : -f 2,3 | tr -d \")
    if [ -n "$asset" ]
    then
        asset_file=$(basename $asset)
        echo "Downloading $asset"
        wget -q $asset
        sudo apt deb ./$asset_file
        rm $asset_file
        echo "Micro editor installed"
    else
        echo "Could not download Micro from GitHub"
    fi
}

install_borg () {
    asset=""
    asset=$(curl -s https://api.github.com/repos/borgbackup/borg/releases/latest | grep "browser_download_url.*borg-linux64\"" | cut -d : -f 2,3 | tr -d \")
    if [ -n "$asset" ]
    then
        cd $(xdg-user-dir DOWNLOAD)
        asset_file=$(basename $asset)
        echo "Downloading $asset"
        wget -q $asset
        sudo cp $asset_file /usr/local/bin/borg
        sudo chown root:root /usr/local/bin/borg
        sudo chmod 755 /usr/local/bin/borg
        sudo ln -sf /usr/local/bin/borg /usr/local/bin/borgfs
        rm $asset_file
        echo "Borg installed"
    else
        echo "Could not download Borg from GitHub"
    fi
}

install_nnn () {
    asset=""
    asset=$(curl -s https://api.github.com/repos/jarun/nnn/releases/latest | grep "browser_download_url.*nnn-nerd-static" | cut -d : -f 2,3 | tr -d \")
    if [ -n "$asset" ]
    then
        cd $(xdg-user-dir DOWNLOAD)
        asset_file=$(basename $asset)
        echo "Downloading $asset"
        wget -q $asset
        tar -xf $asset_file
        sudo cp nnn-nerd-static /usr/local/bin/nnn
        sudo chown root:root /usr/local/bin/nnn
        sudo chmod 755 /usr/local/bin/nnn
        rm nnn-nerd-static
        rm $asset_file
        echo "nnn installed"
    else
        echo "Could not download nnn from GitHub"
    fi
}

install_hack () {
    asset=""
    asset=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep "browser_download_url.*Hack.zip" | cut -d : -f 2,3 | tr -d \")
    if [ -n "$asset" ]
    then
    	mkdir -pv ~/.local/share/fonts
        cd ~/.local/share/fonts
        asset_file=$(basename $asset)
        echo "Downloading $asset"
        wget -q $asset
	    unzip -o $asset_file
	    rm $asset_file
	    fc-cache -fv
        dconf write /org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default)/font "'Hack Nerd Font 13'"
        echo "Hack font installed in $HOME/.local/share/fonts and set in Terminal"
    else
        echo "Could not download Hack font from GitHub"
    fi
}

install_starship () {
    curl -sS https://starship.rs/install.sh | sh
}

cinnamon_apps () {
    gsettings set org.cinnamon.sounds login-enabled false
    gsettings set org.cinnamon.sounds logout-enabled false

    gsettings set org.nemo.desktop network-icon-visible false
    gsettings set org.nemo.desktop computer-icon-visible false
    gsettings set org.nemo.desktop volumes-visible false
    gsettings set org.nemo.desktop trash-icon-visible false
    gsettings set org.nemo.desktop home-icon-visible false

    gsettings set org.nemo.list-view default-zoom-level 'smaller'
    gsettings set org.nemo.preferences date-format 'iso'
    gsettings set org.nemo.preferences default-folder-viewer 'icon-view'
    gsettings set org.nemo.preferences default-sort-order 'type'
    gsettings set org.nemo.preferences ignore-view-metadata true
    gsettings set org.nemo.preferences inherit-show-thumbnails false
    gsettings set org.nemo.preferences show-hidden-files false
    gsettings set org.nemo.preferences show-image-thumbnails 'local-only'
    gsettings set org.nemo.preferences show-location-entry true
    gsettings set org.nemo.preferences show-show-thumbnails-toolbar false

    gsettings set org.x.editor.preferences.editor bracket-matching false
    gsettings set org.x.editor.preferences.editor display-line-numbers true
    gsettings set org.x.editor.preferences.editor display-right-margin false
    gsettings set org.x.editor.preferences.editor draw-whitespace false
    gsettings set org.x.editor.preferences.editor draw-whitespace-inside false
    gsettings set org.x.editor.preferences.editor draw-whitespace-leading false
    gsettings set org.x.editor.preferences.editor draw-whitespace-newline false
    gsettings set org.x.editor.preferences.editor draw-whitespace-trailing false
    gsettings set org.x.editor.preferences.editor editor-font 'Monospace 12'
    gsettings set org.x.editor.preferences.editor scheme 'oblivion'
    gsettings set org.x.editor.preferences.editor highlight-current-line false
    gsettings set org.x.editor.preferences.editor use-default-font false
    gsettings set org.x.editor.preferences.ui minimap-visible false
    gsettings set org.x.editor.preferences.ui statusbar-visible true

    gsettings set org.x.viewer.ui image-gallery false
    gsettings set org.x.viewer.ui sidebar false
    gsettings set org.x.viewer.ui statusbar true
    gsettings set org.x.viewer.ui toolbar true
    gsettings set org.x.viewer.view background-color 'rgb(0,0,0)'
    gsettings set org.x.viewer.view control-scroll-action 0
    gsettings set org.x.viewer.view scroll-action 3
    gsettings set org.x.viewer.view shift-control-scroll-action 5
    gsettings set org.x.viewer.view shift-scroll-action 5
    gsettings set org.x.viewer.view use-background-color true
    gsettings set org.x.viewer.window maximized true
}

cinnamon_theming () {
    gsettings set org.cinnamon.theme name 'Mint-Y-Dark'
    gsettings set org.cinnamon.desktop.interface gtk-theme 'Mint-Y-Dark'
    gsettings set org.cinnamon.desktop.interface icon-theme 'Papirus-Dark'
    gsettings set org.cinnamon.desktop.wm.preferences theme 'Mint-Y'
    papirus-folders -C paleorange --theme Papirus-Dark
}


clear

echo -e "\033[1;32m"
echo -e "*****************************************"
echo -e "* Post-install script for Linux Mint 21 *"
echo -e "*****************************************"
echo -e "\033[0m"

PS3="Choose an option: "
COLUMNS=12
select opt in "${options[@]}"; do
    echo
    case $REPLY in
        1) add_nas ;;
        2) add_ppas ;;
        3) disable_printer_discovery ;;
        4) decrease_swappiness ;;
        5) software_changes ;;
        6) install_flatpaks ;;
        7) install_micro ;;
        8) install_borg ;;
        9) install_nnn ;;
        10) install_hack ;;
        11) install_starship ;;
        12) cinnamon_apps ;;
        13) cinnamon_theming ;;
        14) break 2 ;;
        *) echo "Invalid option" >&2
    esac
    REPLY=
    COLUMNS=12
    echo
done


