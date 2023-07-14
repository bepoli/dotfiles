#
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash, if ~/.bash_profile or ~/.bash_login exists.
#

# set default umask
umask 002

# set XDG Base Directory Specification
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

# set locale
export LC_ALL=C.UTF-8 LANG=C.UTF-8

# default editor
export EDITOR=vim

# local config
if [ -f "$XDG_CONFIG_HOME"/shell/profile.local ]; then
	. "$XDG_CONFIG_HOME"/shell/profile.local
fi

# load bashrc
[ -n "$BASH_VERSION" ] && [ -f "$HOME"/.bashrc ] && . "$HOME"/.bashrc

# include user's tailing and leading PATH
PATH="$HOME/.local/bin:$PATH:$HOME/bin"
