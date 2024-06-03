# dotfiles

## Install
### Quickstart
```
sh <(curl -s https://bepoli.github.io/dotfiles/init.sh)
```

### Not-as-quick start
Install `curl` and `git`.

Check `init.sh` to find out the default local and remote repository location.

To configure local and remote dotfiles repository location:
```
Usage: init.sh [-d OUTPUT_DIRECTORY] [-r REMOTE_URL]
Example:
./init.sh -d $HOME/.dotfiles -r https://a_galaxy_far_far_away.com/this_is_me/these_are_my_dotfiles.git
```

## Uninstall
Undo dotfiles checkout and restore backup
```
config sparse-checkout set --no-cone '!/*'
shopt -s dotglob
cp ~/.config/dotfiles-backup/* ~/
shopt -u dotglob
```
