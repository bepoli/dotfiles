#
# ~/.bash_profile: executed by bash for login shells
#

# set default umask
umask 002

# set locale
export LC_ALL=C.UTF-8 LANG=C.UTF-8

# include user's tailing and leading PATH
PATH="$HOME/.local/bin:$PATH:$HOME/bin"

# load bashrc
[ -n "$BASH_VERSION" ] && [ -f "$HOME"/.bashrc ] && . "$HOME"/.bashrc
