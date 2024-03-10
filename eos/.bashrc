# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Basic aliases
alias ls='ls -lh --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'


[[ "$(whoami)" = "root" ]] && return

## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
## Plus other shell options related to history
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# one command to update dotfiles
gitupdate () {
    cd ~/.dotfiles
    git add --all
    git status
    git commit -m "Updates from $(date '+%F')"
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

# change working directory after quitting LF
lf () {
    cd "$(command lf -print-last-dir "$@")"
}

# set editor
if command -v vim &> /dev/null
then
	export EDITOR="/usr/bin/vim"
	export VISUAL="/usr/bin/vim"
fi

# set man pager to BAT
if command -v bat &> /dev/null
then
#    export BAT_THEME="gruvbox-dark"
    export BAT_THEME="Visual Studio Dark+"
    export BAT_PAGER="less -r"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export MANROFFOPT="-c"
fi

# set fzf options
if command -v fzf &> /dev/null
then
	export FZF_DEFAULT_COMMAND='find . -mount ! -path '*/.cache/*' ! -path '*/.git/*' ! -path '*/.mozilla/*' 2>/dev/null'
	export FZF_CTRL_T_COMMAND='find . -mount ! -path '*/.cache/*' ! -path '*/.git/*' ! -path '*/.mozilla/*' 2>/dev/null'
	source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
    alias fzf='fzf --cycle --info=inline'
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


