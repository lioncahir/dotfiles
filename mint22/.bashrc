# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

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
# If not running interactively, don't do anything 
case $- in
    *i*) ;;
      *) return;;
esac

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# alias for update checking
alias aptupdate='sudo apt update && apt list --upgradeable'

# alias for full update
alias fullupdate='sudo apt update && sudo apt upgrade ; sudo apt autoremove ; flatpak update && flatpak remove --unused'

# alias for flatpak list
alias flatlist='flatpak list --columns=name,application,version,branch,size'

# set man pager to BAT
if command -v batcat &> /dev/null
then
    export BAT_THEME="Catppuccin Mocha"
    export BAT_PAGER="less -r"
    export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
    export MANROFFOPT="-c"
    alias bat='batcat'
fi

# replace ls with eza of installed
if command -v eza &> /dev/null
then
    alias ls='eza -lg --group-directories-first --sort=ext --icons'
fi

# one command to update dotfiles
gitupdate () {
    cd ~/.dotfiles
    git add --all
    git status
    git commit -m "Updates from $(date '+%F')"
    git push
    cd $OLDPWD
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

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if command -v starship &> /dev/null
then
    eval "$(starship init bash)"
fi

