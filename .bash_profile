# ~/.bash_profile

# Allow teammates to edit my files
umask 002

# Set locale
export LC_ALL=C.UTF-8 LANG=C.UTF-8

# XDG base directory specs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Add user's trailing and leading PATH
export PATH="$HOME/.local/bin:$PATH:$HOME/bin"

# Source ~/.bashrc
if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi

