export LC_ALL=C.UTF-8 LANG=C.UTF-8

export EDITOR=vim

export HISTFILE=~/.zsh_history
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
export HISTSIZE=50000
export SAVEHIST=50000

export WORDCHARS='*?!_-.~=/&;|#$%^()[]{}<>'
export KEYTIMEOUT=1

export PATH="$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"

# pixi - https://pixi.sh/latest/
export PIXI_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pixi"
export PATH="$PIXI_HOME/bin:$PATH"
