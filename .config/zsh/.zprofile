# ~/.config/zsh/.zprofile

# set default umask
umask 002

# set locale
export LC_ALL=C.UTF-8 LANG=C.UTF-8

# set XDG variables for software using them
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# include user's trailing and leading PATH
export PATH="$HOME/.local/bin:$PATH:$HOME/bin"

