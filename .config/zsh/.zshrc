#
# ~/.zshrc
#
# - Inspired by https://github.com/LukeSmithxyz/voidrice
#

#
# Env vars required for interactivity
#

# GPG-agent
export GPG_TTY="$(tty)"

#
# History settings
#

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
cachedir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$cachedir"
HISTFILE="${cachedir}/history"

# Extended globs
setopt extended_glob
setopt globdots

#
# Prompt theme
#

# For prompt escapes:
# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
# For xterm-256 colors:
# https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
PROMPT='%F{069}%n%f%F{11}@%f%F{069}%M%f%F{11}:%f%F{7}%~%f%F{11}>%f '

#
# Aliases
#

alias lsblk="lsblk -f"
alias ls="ls -la --color=auto"
alias du="du -ahc --max-depth 1"
alias diff="diff --color"
alias gemini="amfora"
alias cp="cp -i"
alias df="df -h"
alias free="free -m"
alias torrent="stig"
alias calc="bc -lq"
alias irc="catgirl"
alias mail="neomutt"
alias scanqr="~/scripts/qr-from-screen.sh"
alias gemini="amfora"
alias notify-play="mpv --no-terminal /usr/share/sounds/notification.mp3"
alias rss="newsboat"
# Pass the URL to a VIDEO to get the ID of the channel that uploaded that video.
# Do not pass the URL of the channel itself.
alias yt-channel-id="pipe-viewer --no-interactive --extract '*CHANNELID*'"
alias metadata="exiv2"
alias android-mount="aft-mtp-mount"
alias poweroffdisk="udisksctl power-off -b"

#
# Directory aliases
#

alias media="cd /mnt/turtle/media"

#
# Functions
#

function dus {
    du "$@" | sort -h
}

function timer { 
    if [ -z "$1" ]
    then
        echo "Missing number of seconds!"
    else
        TIME=$(echo "$1" | bc -lq)
        echo "$TIME seconds starting from now!"
        sleep $TIME
        echo "Time is over!"
        notify-send --urgency=critical "Time is over!"
        notify-play 
    fi
}

function stopwatch {
    echo "Stopwatch started!"
    # Wierdly enough, 'time' sends the result to stderr.
    # '2>&1' is to redirect the stderr of 'time' to stdout
    TIME=$(2>&1 time sh -c "read REPLY")
    echo "$TIME seconds have elapsed." | sed "s/\(.*cpu \| total\)//g"
}

function qrshow {
    if [ "$1" = "--" ] || [ -z "$1" ]; then
        read payload
    else
        payload="$1"
    fi
    if [ -z "$payload" ]; then
        echo "Missing payload!"
    else
        qrencode -o - "$payload" | feh - & disown
    fi
}


# Use lf to switch directories
lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

#
# Key bindings
#

# cd using lf
bindkey -s '^o' '^ulfcd\n'
# bc, the arbitrary precision calculator, but with the mathlib and quiet
bindkey -s '^a' '^ubc -lq\n'
# cd with fuzzy finding
bindkey -s '^s' '^ucd "$(dirname "$(fzf)")"\n'
# open with helix, search by file name
bindkey -s '^f' '^uhx .\n'
# git status
bindkey -s '^g' '^ugit status\n'

setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' file-list all
zmodload zsh/complist
compinit
# Include hidden files
_comp_options+=(globdots)

#
# Configure akward commands that are akward
# because they must be sourced here
#

# nvm, the Nodejs version manager
# WARNING: ~200ms slow
source /usr/share/nvm/nvm.sh
source /usr/share/nvm/bash_completion
source /usr/share/nvm/install-nvm-exec

#
# FINAL STEPS
#

# Load syntax highlighting
# The repo: https://github.com/zdharma/fast-syntax-highlighting
source /usr/share/zsh/plugins/fast-syntax-highlighting/F-Sy-H.plugin.zsh 2>/dev/null
