# ~/.bash_profile

export LC_ALL=C.UTF-8 LANG=C.UTF-8
export PATH="$HOME/.local/bin:$PATH:$HOME/bin"
export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"

export PYENV_ROOT="$HOME/.local/share/pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi
