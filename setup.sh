#!/bin/bash

dotfiles=(
  .bash_aliases
  .bashrc
  .condarc
  .gitignore
  .parallel
  .profile
  .tmux.conf
  .vim
  .vimrc
)

for df in ${dotfiles[@]}; do
  old_df="${HOME}/${df}"
  if [ -e "$old_df" ]; then
    if [ -h "$old_df" ]; then
      rm -rf "$old_df"
    else
      mkdir -p $HOME/.dotfiles_bkp && mv $old_df $HOME/.dotfiles_bkp/$df
    fi
  fi
  rm -rf $old_df && ln -s $(readlink -f $df) $old_df
  unset old_df
done
unset dotfiles

if grep -q "[Mm]icrosoft\|WSL" /proc/version &>/dev/null; then
  GIT_EXE=$(command -v git.exe)
  if [ "$GIT_EXE" ]; then
    if [[ "$GIT_EXE" =~ "scoop" ]] && [ -x $(command -v scoop) ] && [ -x $(command -v wslpath) ]; then
      GIT_PREFIX="$(wslpath "$(scoop prefix git | sed 's/\r$//')")"
      GCM="$GIT_PREFIX/mingw64/libexec/git-core/git-credential-manager-core.exe"
    else
      GIT_PREFIX="$(dirname "$(dirname "$(command -v git.exe)")")"
      GCM="$GIT_PREFIX/mingw64/libexec/git-core/git-credential-manager-core.exe"
    fi
    git config --global credential.helper "$GCM"
  fi
  unset GIT_EXE GIT_PREFIX GCM
fi
