#
# ~/.bash_profile: executed by bash for login shells
#

# set default umask
umask 002

# set locale
export LC_ALL=C.UTF-8 LANG=C.UTF-8

# set XDG Base Directory Specification
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
export HISTFILE="$XDG_STATE_HOME"/bash/history
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME"/bash-completion/bash_completion
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel

# include user's tailing and leading PATH
PATH="$HOME/.local/bin:$PATH:$HOME/bin"

# load bashrc
[ -n "$BASH_VERSION" ] && [ -f "$HOME"/.bashrc ] && . "$HOME"/.bashrc
