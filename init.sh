#!/bin/sh

git clone --bare https://github.com/bepoli/dotfiles ~/.config/dotfiles
alias config='git --git-dir=$HOME/.config/dotfiles --work-tree=$HOME'
config checkout
if [ $? -gt 0 ]; then
  mkdir -p ~/.config/dotfiles-backup
  config checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} mv {} ~/.config/dotfiles-backup/{}
  config checkout
fi
config config --local status.showUntrackedFiles no
