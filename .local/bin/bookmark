#!/bin/sh

#
# Universal bookmark manager
#

file="$HOME/.local/share/bookmarks"

alias help="echo \"Choose 'add', 'remove' or 'pick'\""
alias ask_bookmark="cat $file | tofi"

if [ "$#" -ne 1 ]
then
  echo "Too many arguments."
  help
  exit 1
fi

if [ "$1" = "add" ]
then
  # Add the current selection to the file
  bookmark="$(wl-paste --primary)"
  if [ -n "$bookmark" ]
  then
    if grep -q "^$bookmark$" "$file"
    then
      notify-send "Already bookmarked!"
    else
      echo "$bookmark" >> "$file"
      notify-send "Bookmark added!" "$bookmark"
    fi
  fi
elif [ "$1" = "remove" ]
then
  # Remove the chosen bookmark from the file
  bookmark="$(ask_bookmark)"
  if [ -n "$bookmark" ]
  then
    if sed -i "s|$bookmark||" "$file"
    then
      notify-send "Bookmark removed!" "$bookmark"
    else
      notify-send "Bookmark does not exist!" "$bookmark"
    fi
  fi
elif [ "$1" = "pick" ]
then
  # Let the user choose a bookmark with tofi, which is like dmenu,
  # and paste the chosen bookmark
  bookmark="$(ask_bookmark)"
  if [ -n "$bookmark" ]
  then
    if grep -q "^$bookmark$" "$file"
    then
      wl-copy "$bookmark"
      notify-send "Bookmark copied!"
    else
      notify-send "Bookmark does not exist!" "$bookmark"
    fi
  fi
else
  echo "Unknown option!"
  help
fi