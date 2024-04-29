# ~/.bash_profile

export LC_ALL=C.UTF-8 LANG=C.UTF-8
export PATH="$HOME/.local/bin:$PATH:$HOME/bin"
if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi
