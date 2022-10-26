#
# ~/.zshrc
#
# - Inspure by https://github.com/LukeSmithxyz/voidrice
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#
# History settings
#

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

#
# Key bindings
# - Inspired by https://silvercircle.subspace.cc/2017/10/26/cygwin-zsh-delete-home-end-keys/
#

# Use vi-like defaults
bindkey -v
# ctrl-left and ctrl-right
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word
# ctrl-bs and ctrl-del
bindkey "\e[3;5~" kill-word
bindkey "^H"      backward-kill-word
# del, home and end
bindkey "\e[3~"   delete-char
bindkey "\e[H"    beginning-of-line
bindkey "\e[F"    end-of-line

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

alias ls="ls -la --color=auto"
alias du="du -ahc --max-depth 1"

#
# Configure akward commands that are akward
# because they must be sourced here
#

# nvm, the Nodejs version manager
# WARNING: ~200ms slow
#source /usr/share/nvm/init-nvm.sh

#
# FINAL STEPS
#

# Load syntax highlighting
# The repo: https://github.com/zdharma/fast-syntax-highlighting
source /usr/share/zsh/plugins/fast-syntax-highlighting/F-Sy-H.plugin.zsh 2>/dev/null
