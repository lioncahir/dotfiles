# Clone and link dotfiles using GNU stow

Welcome to my dotfiles. Follow the instructions below to clone the repo and stow configuration for various applications. Obvious pre-requisite is installation of `git` and `stow` packages. 

1. Clone repository
   
   ```shell
   git clone https://github.com/lioncahir/dotfiles.git .dotfiles
   cd .dotfiles
   ```

1. Use GNU stow to create symlinks for selected application (use -v option for verbose output)

   ```shell
   stow -v mpv
   stow -v vim
   ```

## Special considerations

- do not stow **Scripts**
- do not stow **firefox**, it contains file *user.js* which should be symlinked to *~/.mozilla/firefox/profileXXX/*
- it is recommended to install (or run first time) the applications (mpv, vim, lf etc.) *after*
  stowing their dotfiles

## Installation of full i3 environment

This has been tested on EndeavourOS.

1. Install minimal (base) EndeavourOs. Do NOT select i3wm in the installer

1. Install git: `sudo pacman -S git`

1. Clone repository
   
   ```shell
   git clone https://github.com/lioncahir/dotfiles.git .dotfiles
   cd .dotfiles
   ```

1. Run `neweos.sh` from **Scripts** directory and select option *Install and configure i3wm*

   ```shell
   cd Scripts
   ./neweos.sh
   ``` 
