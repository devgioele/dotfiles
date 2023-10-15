#
# ~/.zshrc
#

#
# Env vars required for interactivity
#

# GPG-agent
export GPG_TTY="$(tty)"

# FNM, the fast Node version manager
eval "$(fnm env --use-on-cd)"

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
PROMPT='%F{069}%n%f%F{11}@%f%F{069}%m%f%F{11}:%f%F{7}%~%f%F{11}>%f '

#
# Key bindings
#

# Use vi-like defaults
bindkey -v
# option as alt
bindkey "\e[1;5D" alt
# ctrl-left and ctrl-right
bindkey "\e[1;5D"      backward-word
bindkey "\e[1;5C"      forward-word
# ctrl-delete-forwards, ctrl-delete-backwards
bindkey "\e[3;5~"      kill-word
bindkey "\x15"         vi-backward-kill-word
# del, home, end
bindkey "^[[3~"        delete-char
# bindkey "\e[H"         beginning-of-line
# bindkey "\e[F"         end-of-line
# bindkey "^[^M"         self-insert-unmeta
# shift+del, shift+left, shift+right, shift+up, shift+down
bindkey "^[[3;2~"      delete-char
bindkey "^[[1;2D"      backward-word
bindkey "^[[1;2C"      forward-word
bindkey "^[[1;2A"      beginning-of-line
bindkey "^[[1;2B"      end-of-line

#
# Directory aliases
#

#
# Aliases & Functions
#

alias vi="nvim"
alias vim="nvim"
alias ls="ls -la --color=auto"
alias du="du -hc -d 1"
alias dus="du | sort -h"
alias diff="diff --color"
alias gemini="amfora"
alias cp="cp -i"
alias df="df -Th"
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
alias fzf="fzf --bind=tab:down,btab:up"
# Git
alias gitc="git checkout"
alias gitd="git diff --color-words"
alias gitdl="git diff"
alias gitdw="gitd --word-diff"
alias gitb="git branch"
function gitbc {
    git branch $1 && git checkout $1
}
alias gitps="git push"
alias gitpl="git pull"
# GitHub
alias ghpr="gh pr create -a '@me'"
alias ghpr="gh pr create -a '@me'"
alias docker-psql-app="docker-compose exec postgres psql app -x"
alias cdfzf='cd "$(dirname "$(fzf)")"'
alias rsyncp="rsync -rlptD --info=progress2"

function timer {
    if [ -z "$1" ]
    then
        echo "Missing number of seconds!"
    else
        TIME=$(echo "$1" | bc -lq)
        echo "$TIME seconds starting from now!"
        sleep $TIME
        echo "Time is over!"
        osascript -e 'tell app "System Events" to display dialog "Time is over!"' >/dev/null
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
    qrencode -o - "$1" | feh -
}

# Use lf to switch directories
lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM EXIT' HUP INT QUIT TERM EXIT
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

# Move through history with up and down keys
bindkey '^k' history-beginning-search-backward
bindkey '^j' history-beginning-search-forward
# cd using lf
bindkey -s '^o' '^ulfcd^M'
# bc, the arbitrary precision calculator, but with the mathlib and quiet
bindkey -s '^a' '^ubc -lq^M'
# open with nvim, search by file name
bindkey -s '^f' '^unvim -c "Telescope find_files"^M'
# open with nvim, search by file content
bindkey -s '^g' '^unvim -c "Telescope live_grep"^M'
# Git
bindkey -s '^s' '^ugit status^M'
# lazygit
bindkey -s '^x' '^ulazygit^M'

setopt autocd           # Automatically cd into typed directory.
stty stop undef         # Disable ctrl-s to freeze terminal.
setopt interactive_comments

# Autocompletion for programs installed with homebrew
FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
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

# FINAL STEPS
#

# SDKMAN
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Fish-like autosuggestions
# Repo: https://github.com/zsh-users/zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting
# The repo: https://github.com/zdharma/fast-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Prevent comments (strings starting with a '#') from being invisible
ZSH_HIGHLIGHT_STYLES[comment]='fg=8,bold'
