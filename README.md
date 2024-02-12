# Clone and link dotfiles using GNU stow

1. Clone repository
   
   ```shell
   git clone https://github.com/lioncahir/dotfiles.git .dotfiles
   cd .dotfiles
   ```

1. Use GNU stow to create symlinks for selected application (use -v option fo verbose output)

   ```shell
   stow -v mpv
   stow -v vim
   ```

## Special considerations

- do not stow **Scripts**
- do not stow **firefox**, it contains file *user.js* which should be symlinked to *~/.mozilla/firefox/<profileXXX>/*
