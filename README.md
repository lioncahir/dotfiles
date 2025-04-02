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
- it is recommended to install (or run first time) the applications (mpv, vim, lf etc.) *after*
  stowing their dotfiles



# Installation of full Sway environment

This has been tested on EndeavourOS.

1. Install minimal (base) EndeavourOS, without any desktop environment

1. Install git: `sudo pacman -S git`

1. Clone repository
   
   ```shell
   git clone https://github.com/lioncahir/dotfiles.git .dotfiles
   cd .dotfiles
   ```

1. Run `neweos.sh` from **Scripts** directory

   ```shell
   cd Scripts
   ./neweos.sh
   ``` 

1. Select option *Install and configure SwayWM*
1. From `neweos.sh` you can also select other useful options, such as
    - Install GreetD login manager
    - Customize Reflector and Paccache - this will set Reflector to start 10 minutes after boot, every week. It will also add a pacman hook to clear cache after each pacman operation
