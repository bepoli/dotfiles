#!/bin/sh

# set up XDG environment as in dotfiles
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# create bash state dir used to store HISTFILE
mkdir -p "$XDG_STATE_HOME"/bash

# parse arguments and set defaults
REPODIR="$XDG_CONFIG_HOME"/dotfiles
REMOTE='https://github.com/bepoli/dotfiles'
while getopts 'd:r:' opt; do
    case "$opt" in
        'd')
            REPODIR="$OPTARG"
            ;;
        'r')
            REMOTE="$OPTARG"
            ;;
    esac
done

# initialize dotfiles
git clone --bare "$REMOTE" "$REPODIR"
alias config='git --git-dir="$REPODIR" --work-tree="$HOME"'
config checkout
if [ $? -gt 0 ]; then
    mkdir -p ${REPODIR}-backup
    config checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} rsync -vaR --remove-source-files {} "$REPODIR"-backup/
    config checkout
fi
config sparse-checkout set --no-cone '/*' '!init.sh' '!README.md'
config config --local status.showUntrackedFiles no
