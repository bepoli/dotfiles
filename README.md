# dotfiles

## Install
### Quickstart
```sh
sh <(curl -s https://bepoli.github.io/dotfiles/bootstrap)
```

### Manual install
Install `curl` and `git`.

Check [bootstrap](bootstrap) to find out what it does, then run it.
```sh
bootstrap [-d OUTPUT_DIRECTORY] [-r REMOTE_URL]
```
Example:
```sh
./bootstrap -d ~/.config/dotfiles -r https://github.com/$USER/dotfiles.git
```

## Uninstall
Undo dotfiles checkout and restore backup
```sh
# Use "config" alias defined in bootstrap and dotfiles
config sparse-checkout set --no-cone '!/*'
shopt -s dotglob
cp ~/.config/dotfiles-backup/* ~/
shopt -u dotglob
```
