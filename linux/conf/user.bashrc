#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Basic env vars
if [ "`id -u`" -eq 0 ]; then
    HOME=/root
fi
SHELL=/bin/bash
ENV=$HOME/.bashrc
export TERM SHELL

# use update-alternatives or create symbolic links manually;
# or add these to root aliases to use with sudo
#alias editor='nano' #vi, vim, nano, ...
#alias pager='most' #less, more, most, ...

EDITOR=editor
PAGER=pager
MANPAGER=pager
export EDITOR PAGER MANPAGER

# Bash history
HISTSIZE=-1
HISTFILESIZE=-1
HISTCONTROL=ignoredups #remove timestamps to use properly
HISTTIMEFORMAT="%F %T "
PROMPT_COMMAND='history -a'
HISTFILE=$HOME/.bash_history
export HISTFILE HISTSIZE HISTFILESIZE HISTCONTROL HISTTIMEFORMAT PROMPT_COMMAND

# Change colors
# If dircolors is not found probably you have
# busybox instead of coreutils
d=.dircolors
test -r $d && eval "$(dircolors $d)"

# Aliases
alias mkdir='mkdir -p'
md () { mkdir "$@" && cd "$@"; }

alias df='df -h'
alias du='du -h'
alias dush='du -sh *|sort -nr'

alias grep='grep --color=always'
alias grepin='grep -in'
alias egrep='grep -E'
alias cls='clear'
alias jobs='jobs -l'

alias ls='ls -hp --color=auto'
alias ll='ls -l'
alias la='ls -la'

alias brce="$EDITOR ~/.bashrc"
alias brcu='source ~/.bashrc'

# Avoid errors... use -f to skip confirmation.
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Package managers basic commands
# Debian - apt
# alias pkgi='apt install'
# alias pkgu='apt upgrade'
# alias pkgs='apt search'
# alias pkgr='apt purge'
# Archlinux - pacman
# alias pkgi='pacman -S'
# alias pkgu='pacman -Syu'
# alias pkgs='pacman -Ss'
# alias pkgr='pacman -Rs'
# Termux - pkg
# alias pkgi='pkg install'
# alias pkgu='pkg upgrade'
# alias pkgs='pkg search'
# alias pkgr='pkg uninstall'
# Tinycore - tce
# alias pkgi='tce-load -wi'
# alias pkgu='tce-update'
# alias pkgr='tce-remove'

# Colors
BK="\[\033[1;30m\]" #bold black
BR="\[\033[1;31m\]" #bold red
BG="\[\033[1;32m\]" #bold green
BY="\[\033[1;33m\]" #bold yellow
BB="\[\033[1;34m\]" #bold blue
BP="\[\033[1;35m\]" #bold purple
BC="\[\033[1;36m\]" #bold cyan
BW="\[\033[1;37m\]" #bold white
R="\[\033[0m\]"     #reset

# Prompt string
# \u user
# \h host
# \w pwd
PS1="$BB.-$BY[$BP \u$BY@$BB\h $BY]$BB:$BY[$BB \w $BY]$R\n$BB|___$BY[ $BB\$ $BY] $R"
# if you have unicode support:
# PS1="$BB┌╴$BY[$BP \u$BY@$BB\h $BY]$BB:$BY[$BB \w $BY]$R\n$BB└─╴$BY[ $BB\$ $BY] $R"

# Other options

# Termux
# Display variable for vnc server
# export DISPLAY=:1
# Pulseaudio
# export PULSE_SERVER=127.0.0.1
# Change libllvm version
# export PATH="$PATH:$PREFIX/opt/libllvm-11/bin/"

# Dotnet
# export DOTNET_ROOT="$HOME/.dotnet"
# export PATH="$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools"

# Pnpm
# export PNPM_HOME="$HOME/.local/share/pnpm"
# export PATH="$PATH:$PNPM_HOME"
