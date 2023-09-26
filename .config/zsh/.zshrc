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
#
# Directory aliases
#

#
# Aliases & Functions
#

alias lsblk="lsblk -f"
alias vi="nvim"
alias vim="nvim"
alias ls="ls -la --color=auto"
alias du="du -ahc --max-depth 1"
alias du="du -hc -d 1"
alias dus="du | sort -h"
alias diff="diff --color"
alias gemini="amfora"
alias cp="cp -i"
alias df="df -h"
alias free="free -m"
alias torrent="stig"
alias calc="bc -lq"
alias irc="catgirl"
alias mail="neomutt"
alias gemini="amfora"
alias notify-play="mpv --no-terminal /usr/share/sounds/notification.mp3"
alias rss="newsboat"
# Pass the URL to a VIDEO to get the ID of the channel that uploaded that video.
# Do not pass the URL of the channel itself.
alias yt-channel-id="pipe-viewer --no-interactive --extract '*CHANNELID*'"
alias metadata="exiv2"
alias android-mount="aft-mtp-mount"
alias poweroffdisk="udisksctl power-off -b"
alias media="cd /mnt/turtle/media"
alias fzf="fzf --bind=tab:down,btab:up"
alias gitc="git checkout"
alias gitd="git diff --color-words"
alias gitdl="git diff"
alias gitdw="gitd --word-diff"
alias gitb="git branch"
function gitbc {
    git branch $1 && git checkout $1
}
alias ghpr="gh pr create -a '@me'"
alias cdfzf='cd "$(dirname "$(fzf)")"'
alias start-nginx-php="sudo rc-service nginx start && sudo rc-service php-fpm start"
alias stop-nginx-php="sudo rc-service nginx stop && sudo rc-service php-fpm stop"
alias colorpicker="hyprpicker"

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

for-filenames-matching () {
    for file in **/*(.); do
        if echo "$file" | grep -qi "$1"; then
            "$2"
        fi
    done
}

replace-with () {
    sed -i '' "s/$1/$2/g" "$3"
}

#
# Key bindings
#
# See `man zshzle`

# cd using lf
bindkey -s '^o' '^ulfcd^M'
# bc, the arbitrary precision calculator, but with the mathlib and quiet
bindkey -s '^a' '^ubc -lq^M'
# open with nvim, search by file name
bindkey -s '^f' '^unvim -c "Telescope find_files"^M'
# open with nvim, search by file content
bindkey -s '^g' '^unvim -c "Telescope live_grep"^M'
# git status
bindkey -s '^s' '^ugit status^M'
# Move through suggestions with up and down keys
bindkey '^k' history-beginning-search-backward
bindkey '^j' history-beginning-search-forward

setopt autocd           # Automatically cd into typed directory.
stty stop undef         # Disable ctrl-s to freeze terminal.
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
# FINAL STEPS
#

# FNM, the fast Node.js manager
eval "$(fnm env --use-on-cd)"

# SDKMAN
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Fish-like autosuggestions
# https://github.com/zsh-users/zsh-autosuggestions
# source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting
# The repo: https://github.com/zdharma/fast-syntax-highlighting
source /usr/share/zsh/plugins/fast-syntax-highlighting/F-Sy-H.plugin.zsh 2>/dev/null
