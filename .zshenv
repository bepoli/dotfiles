export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
export R_HOME_USER="$XDG_CONFIG_HOME/R"
export R_PROFILE_USER="$R_HOME_USER/profile"
export R_HISTFILE="$XDG_STATE_HOME/R/history"
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
export WGETRC="$XDG_CONFIG_HOME"/wgetrc
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

export LC_ALL=C.UTF-8 LANG=C.UTF-8
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export PATH="$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"

export SHELL="$(command -v zsh)"
