#!/bin/bash

options=(\
"Add NAS to /etc/fstab" \
"Disable automatic printer discovery" \
"Decrease swappiness" \
"Perform software changes" \
"Replace LibreOffice with flatpak" \
"Install fzf" \
"Install Borg backup" \
"Install lf file manager" \
"Install JetBrains Mono Nerd font" \
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

disable_printer_discovery () {
    sudo systemctl stop cups-browsed
    sudo systemctl disable cups-browsed
}

decrease_swappiness () {
    echo "vm.swappiness = 20" | sudo tee -a /etc/sysctl.conf
}

software_changes () {
    sudo add-apt-repository ppa:flatpak/stable
    sudo add-apt-repository ppa:papirus/papirus
    sudo apt update
    sudo apt remove yaru-theme-icon onboard
    sudo apt install vim stow grub2-theme-mint git fonts-crosextra-carlito fonts-crosextra-caladea eza gthumb mpv bat btop kitty
    rm ~/.bashrc
    cd ~/.dotfiles
    stow -v bat btop kitty mint22 vim mpv
    batcat cache --build
}

replace_libreoffice () {
    sudo apt purge libreoffice*
    sudo apt autoremove
    flatpak install org.libreoffice.LibreOffice
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
        cd ~/.dotfiles
        stow -v borg
        echo "Borg installed"
    else
        echo "Could not download Borg from GitHub"
    fi
}

install_lf () {
    asset=""
    asset=$(curl -s https://api.github.com/repos/gokcehan/lf/releases/latest | grep "browser_download_url.*lf-linux-amd64.tar.gz\"" | cut -d : -f 2,3 | tr -d \")
    if [ -n "$asset" ]
    then
        cd $(xdg-user-dir DOWNLOAD)
        asset_file=$(basename $asset)
        echo "Downloading $asset"
        wget -q $asset
        tar -xvzf $asset_file
        sudo mv lf /usr/local/bin/
        sudo chown root:root /usr/local/bin/lf
        rm $asset_file 
        echo "LF installed"
    else
        echo "Could not download LF from GitHub"
    fi
}

install_fzf () {
    asset=""
    asset=$(curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | grep "browser_download_url.*linux_amd64.tar.gz\"" | cut -d : -f 2,3 | tr -d \")
    if [ -n "$asset" ]
    then
        cd $(xdg-user-dir DOWNLOAD)
        asset_file=$(basename $asset)
        echo "Downloading $asset"
        wget -q $asset
        tar -xvzf $asset_file
        sudo mv fzf /usr/local/bin/
        sudo chown root:root /usr/local/bin/fzf
        rm $asset_file
        echo "fzf installed"
    else
        echo "Could not download fzf from GitHub"
    fi
}

install_font () {
    asset=""
    asset=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep "browser_download_url.*JetBrainsMono.zip" | cut -d : -f 2,3 | tr -d \")
    if [ -n "$asset" ]
    then
    	mkdir -pv ~/.local/share/fonts/JetBrainsMono
        cd ~/.local/share/fonts/JetBrainsMono
        asset_file=$(basename $asset)
        echo "Downloading $asset"
        wget -q $asset
	    unzip -o $asset_file
	    rm $asset_file
	    fc-cache -fv
        echo "JetBrains Mono font installed in $HOME/.local/share/fonts"
    else
        echo "Could not download JetBrains Mono font from GitHub"
    fi
}

install_starship () {
    curl -sS https://starship.rs/install.sh | sh
    cd ~/.dotfiles
    stow -v starship
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
        2) disable_printer_discovery ;;
        3) decrease_swappiness ;;
        4) software_changes ;;
        5) replace_libreoffice ;;
        6) install_fzf ;;
        7) install_borg ;;
        8) install_lf ;;
        9) install_font ;;
        10) install_starship ;;
        11) cinnamon_apps ;;
        12) cinnamon_theming ;;
        13) break 2 ;;
        *) echo "Invalid option" >&2
    esac
    REPLY=
    COLUMNS=12
    echo
done


