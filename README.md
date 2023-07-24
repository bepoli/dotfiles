# dotfiles

## Install
Install `curl` and `git`, then:
```
sh <(curl -s https://raw.githubusercontent.com/bepoli/dotfiles/main/.config/dotfiles/init.sh)
```

## Uninstall
Undo dotfiles checkout and restore backup
```
config sparse-checkout set --no-cone '!/*'
shopt -s dotglob
cp ~/.config/dotfiles-backup/* ~/
shopt -u dotglob
```
