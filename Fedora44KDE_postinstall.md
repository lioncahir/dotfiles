# Fedora Post-Install guide

This document describes various activities which may be executed after installing fresh Fedora 44 KDE Edition.

## Disable Baloo file indexing

    balooctl6 suspend

    balooctl6 disable

    balooctl6 purge


## Adjust DNF options and update system

```sh
sudo dnf config-manager setopt max_parallel_downloads=10 fastestmirror=True defaultyes=True

sudo dnf upgrade --refresh --offline
```


## Add RPMFusion and Terra repository

```sh
sudo dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

sudo dnf update @core
```

## Fix multimedia codecs with RPMFusion version

```sh
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing

sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

sudo dnf group upgrade -y multimedia
```

## Add Flathub as Flatpak source

    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

To remove Fedora flatpak repository:

    flatpak remote-delete fedora


## Install Brave Browser

    sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    
    sudo dnf install brave-browser



## Disable Akonadi autostart

This is not needed if Korganizer is uninstalled

```sh
mkdir -pv ~/.config/autostart

cat > "~/.config/autostart/org.kde.kalendarac.desktop" <<'EOF'
[Desktop Entry]
Hidden=true
EOF
```


## Uninstall unnecessary software

    sudo dnf remove plasma-discover-notifier firefox kmahjongg kmines kpat akregator kmail korganizer kaddressbook neochat dragon



## Install additional software

Requires Terra repository to be active

    sudo dnf install plasma-browser-integration bat eza duf vim fzf haruna rsms-inter-fonts jetbrainsmono-nerd-fonts ubuntu-nerd-fonts yazi borgmatic foot foot-terminfo kdotool gdu
    

## Mount NAS

First create mountpoint:

    sudo mkdir -pv /media/NAS/Media

Then add this line to `/etc/fstab`:

    //192.168.0.5/Media   /media/NAS/Media   cifs   sec=none,users,noauto,nofail,_netdev,uid=0,gid=0,file_mode=0777,dir_mode=0777,iocharset=utf8,comment=x-gvfs-show   0   0


