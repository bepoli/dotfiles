# ~/.zshenv

export LC_ALL=C.UTF-8 LANG=C.UTF-8
export PATH="$HOME/.local/bin:$PATH:$HOME/bin"
export SHELL="$(command -v zsh)"
export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export PYENV_ROOT="$HOME/.local/share/pyenv"
if [ -d $PYENV_ROOT/bin ]; then
	export PATH="$PYENV_ROOT/bin:$PATH"
fi
