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
bootstrap [--repodir OUTPUT_DIRECTORY] [--remote REMOTE_URL] [--github GITHUB_USERNAME] [--gitname FULL_NAME]
```
Example:
```sh
./bootstrap --repodir ~/.config/dotfiles --remote https://github.com/GITHUB_USERNAME/dotfiles.git --github GITHUB_USERNAME --gitname "FULL NAME"
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
