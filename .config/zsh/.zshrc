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
export HISTFILE="${XDG_CACHE_HOME}/zsh/.history"
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
autoload -Uz compinit && compinit

# Enable completion for special dirs (. and ..)
zstyle ':completion:*' special-dirs true

# Make tab-completion case insensitive
setopt NO_CASE_GLOB

# Enable comments when working in an interactive shell
setopt interactive_comments

# Initialize conda/mamba if installed
# >>> conda initialize >>>
__conda_setup="$($HOME'/conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/conda/etc/profile.d/conda.sh" ]; then
        . "$HOME/conda/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/conda/bin:$PATH"
    fi
fi
unset __conda_setup
if [ -f "$HOME/conda/etc/profile.d/mamba.sh" ]; then
    . "$HOME/conda/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

# Plugins management
# zsh_unplugged - https://github.com/mattmc3/zsh_unplugged
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
# Load plugins
repos=(
	zsh-users/zsh-autosuggestions
)
plugin-load $repos

# Load local configuration file
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/zsh.local ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/zsh.local
fi

# Load aliases
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/sh/aliases ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}"/sh/aliases
fi

