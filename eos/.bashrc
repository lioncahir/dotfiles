# ~/.bashrc
#

# If not running interactively, or running as root, don't do anything
[[ $- != *i* ]] && return
[[ "$(whoami)" = "root" ]] && return

# Basic aliases
alias ls='ls -lh --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'


# Use the up and down arrow keys for finding a command in history
# (you can write some initial letters of the command first).
# Plus other shell options related to history
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
HISTCONTROL=ignoreboth
HISTSIZE=20000
HISTFILESIZE=20000
shopt -s histappend
shopt -s checkwinsize

# function to extract data from all archive types
extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1     ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
}

# one command to update dotfiles
gitupdate () {
    default_msg="Updates from $(date '+%F')"
    commit_msg=${1:-"$default_msg"}
    cd ~/.dotfiles
    git add --all
    git status
    git commit -m "$commit_msg"
    git push
    cd $OLDPWD
}

# function to recursively uninstall orphaned packages while keeping optional dependencies
orph() {
	while [[ $(pacman -Qdtq) ]]
	 do	sudo pacman -R $(pacman -Qdtq)
	done
    echo "No more orphaned packages found."
}

# start service and network for virt-manager
startvm() {
    sudo systemctl start libvirtd.service
    sudo virsh net-start default
}

# change working directory to where Yazi exited
y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# set editor
if command -v vim &> /dev/null
then
	export EDITOR="/usr/bin/vim"
	export VISUAL="/usr/bin/vim"
    alias svim='sudo -E vim'
    [ -f ~/.vim/write.vimrc ] && alias vimw='vim -u ~/.vim/write.vimrc'
fi

# set man pager to BAT
if command -v bat &> /dev/null
then
    export BAT_THEME="Catppuccin Mocha"
    export BAT_PAGER="less -r"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export MANROFFOPT="-c"
fi

# set fzf options
if command -v fzf &> /dev/null
then
    eval "$(fzf --bash)"
    export FZF_DEFAULT_OPTS="
        --cycle 
        --info=inline 
        --walker=file,dir,follow,hidden 
        --walker-skip=.git,.cache,.mozilla,Steam,.steam"

    export FZF_ALT_C_OPTS="
        --walker=dir,follow,hidden"

    export FZF_CTRL_T_OPTS="
        --walker=file,follow,hidden 
        --walker-skip=.git,.cache,.mozilla,Steam,.steam 
        --height=~80%
        --preview 'bat -n --color=always {}'"
fi

# replace ls with eza of installed
if command -v eza &> /dev/null
then
    alias ls='eza -lg --group-directories-first --sort=ext --icons'
fi

# start starship prompt
if command -v starship &> /dev/null
then
    eval "$(starship init bash)"
fi


