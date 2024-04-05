# ~/.bash_profile

# Allow teammates to edit my files
umask 002

# Set locale
export LC_ALL=C.UTF-8 LANG=C.UTF-8

# Add user's trailing and leading PATH
export PATH="$HOME/.local/bin:$PATH:$HOME/bin"

# Source ~/.bashrc
if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi

