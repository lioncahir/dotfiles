# How to setup repository on GitHub to store dotfiles

1. create an account on github.com

1. setup public repository (e.g. lioncahir/dotfiles)

1. create local repository:
   
   ```shell
   git init
   git remote add origin git@github.com:lioncahir/dotfiles.git
   git config --global user.email "you@example.com"
   git config --global user.name "Your Name"
   ```

1. generate SSH key for authentication:
   
   ```shell
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```

1. locate **~/.ssh/id_ed25519.pub**, copy its contents to your GitHub profile (Settings->SSH and GPG keys)

1. if this is a new computer, pull data from repo:
   
   ```shell
   git pull origin master
   ```

1. For adding first set of files, use `git add <filename>`, then `git commit -m "your message"`

1. first push:
   
   ```shell
   git push -u origin master
   ```

Afterwards: `git add -u` to add modified files, `git commit -m "your message"` to commit, and `git push` to upload
