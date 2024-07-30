# dotfiles

## Install
### Quickstart
```
sh <(curl -s https://bepoli.github.io/dotfiles/bootstrap)
```

### Not-as-quick start
Install `curl` and `git`.

Check `bootstrap` to find out the default local and remote repository location.

To configure local and remote dotfiles repository location:
```
Usage: bootstrap [-d OUTPUT_DIRECTORY] [-r REMOTE_URL]
Example:
./bootstrap -d $HOME/.dotfiles -r https://github.com/$USER/dotfiles.git
```

## Uninstall
Undo dotfiles checkout and restore backup
```
config sparse-checkout set --no-cone '!/*'
shopt -s dotglob
cp ~/.config/dotfiles-backup/* ~/
shopt -u dotglob
```
