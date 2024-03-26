# ~/.config/zsh/zshrc

# export SHELL variable for tmux
export SHELL=$(which zsh)

# Set propmpt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT="$([ -n "$SSH_TTY" ] && echo '%F{yellow}%M%F{white}:' || echo '')"'%F{cyan}%2c %F{magenta}${vcs_info_msg_0_}%(?.%F{green}.%F{red})%\▸%f '

# History settings
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/.history"
[ -d "${HISTFILE%/*}" ] || mkdir -p "${HISTFILE%/*}"
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
export HISTSIZE=50000        # History lines stored in mememory
export SAVEHIST=50000        # History lines stored on disk
setopt INC_APPEND_HISTORY    # Immediately append commands to history file
setopt HIST_IGNORE_ALL_DUPS  # Never add duplicate entries
setopt HIST_IGNORE_SPACE     # Ignore commands that start with a space
setopt HIST_REDUCE_BLANKS    # Remove unnecessary blank lines

# Key bindings
bindkey '\e[H' beginning-of-line
bindkey '\e[1~' beginning-of-line
bindkey '\e[7~' beginning-of-line
bindkey '\e[F' end-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[8~' end-of-line
bindkey '\e[3~' delete-char
bindkey '\e[1;5D' backward-word
bindkey '\e[1;5C' forward-word

# Enable completion
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
autoload -Uz compinit
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION

# Enable completion for special dirs (. and ..)
zstyle ':completion:*' special-dirs true

# Make tab-completion case insensitive
setopt NO_CASE_GLOB

# Enable comments when working in an interactive shell
setopt interactive_comments

# Do not return error on empty for loops
setopt nullglob

# Plugins management
# Using zsh_unplugged (https://github.com/mattmc3/zsh_unplugged)
function plugin-load {
  local repo plugdir initfile initfiles=()
  : ${ZPLUGINDIR:=${ZDOTDIR:-~/.config/zsh}/plugins}
  for repo in $@; do
    plugdir=$ZPLUGINDIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh
    if [[ ! -d $plugdir ]]; then
      echo "Cloning $repo..."
      git clone -q --depth 1 --recursive --shallow-submodules \
        https://github.com/$repo $plugdir
    fi
    if [[ ! -e $initfile ]]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( $#initfiles )) || { echo >&2 "No init file found '$repo'." && continue }
      ln -sf $initfiles[1] $initfile
    fi
    fpath+=$plugdir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}
repos=(
	zsh-users/zsh-autosuggestions
)
plugin-load $repos
unset repos

# Initialize micromamba/conda if installed
# "${SHELL}" <(curl -L micro.mamba.pm/install.sh)
if [ -x "$(command -v micromamba)" ]; then
	export MAMBA_EXE="$(command -v micromamba)"
	export MAMBA_ROOT_PREFIX="$($MAMBA_EXE info | grep 'base environment' | awk '{print $4}')"
	__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
	if [ $? -eq 0 ]; then
		eval "$__mamba_setup"
	fi
	unset __mamba_setup
	if [ -x "$(command -v conda)" ]; then
		export CONDA_EXE="$(command -v conda)"
		__conda_setup="$($CONDA_EXE 'shell.zsh' 'hook' 2> /dev/null)"
		if [ $? -eq 0 ]; then
			eval "$__conda_setup"
		else
			export PATH="$MAMBA_ROOT_PREFIX/bin:$PATH"
		fi
	fi
	unset __conda_setup
	if [ -f "$MAMBA_ROOT_PREFIX/etc/profile.d/mamba.sh" ]; then
		. "$MAMBA_ROOT_PREFIX/etc/profile.d/mamba.sh"
	fi
fi

# Load additional configuration files
if [ -d ${XDG_CONFIG_HOME:-$HOME/.config}/shellcommons ]; then
	for i in ${XDG_CONFIG_HOME:-$HOME/.config}/shellcommons/*; do
		. $i
	done
fi

# Load aliases
if [ -f $ZDOTDIR/aliases ]; then
	. $ZDOTDIR/aliases
fi

