#!/bin/sh

# parse arguments and set defaults
if [ ! -d "$HOME/.config" ]; then
    mkdir -p "$HOME/.config"
fi
REPODIR="$HOME/.config/dotfiles"
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
    config checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs dirname | xargs -I{} mkdir -p "$REPODIR"-backup/{}
    config checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} mv {} "$REPODIR"-backup/{}
    config checkout
fi
config sparse-checkout set --no-cone '/**' '!init.sh' '!README.md'
config config --local status.showUntrackedFiles no
