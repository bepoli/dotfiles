#!/bin/sh

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

git clone --bare https://github.com/bepoli/dotfiles $XDG_CONFIG_HOME/dotfiles
alias config='git --git-dir=$XDG_CONFIG_HOME/dotfiles --work-tree=$HOME'
config sparse-checkout set --no-cone '/*' '!init.sh'
config checkout
if [ $? -gt 0 ]; then
  mkdir -p $XDG_CONFIG_HOME/dotfiles-backup
  config checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} mv {} $XDG_CONFIG_HOME/dotfiles-backup/{}
  config checkout
fi
config config --local status.showUntrackedFiles no

mkdir -p $XDG_STATE_HOME/bash