# ~/.zshrc

# Set propmpt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='%(1j.[%j] .)'\
"$([ -n "$SSH_TTY" ] && echo '%F{yellow}%M%F{white}:' || :)"\
'%F{cyan}%2c %F{magenta}${vcs_info_msg_0_}%(?.%F{green}.%F{red})%\▸%f '

# History settings
export HISTFILE="$XDG_STATE_HOME"/zsh/history
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
export HISTSIZE=50000        # History lines stored in mememory
export SAVEHIST=50000        # History lines stored on disk
setopt INC_APPEND_HISTORY    # Immediately append commands to history file
setopt HIST_IGNORE_ALL_DUPS  # Never add duplicate entries
setopt HIST_IGNORE_SPACE     # Ignore commands that start with a space
setopt HIST_REDUCE_BLANKS    # Remove unnecessary blank lines

# Key bindings
bindkey '\e[H' beginning-of-line
bindkey '^[OH' beginning-of-line
bindkey '\e[1~' beginning-of-line
bindkey '\e[7~' beginning-of-line
bindkey '\e[F' end-of-line
bindkey '^[OF' end-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[8~' end-of-line
bindkey '\e[3~' delete-char
bindkey '\e[1;5D' backward-word
bindkey '\e[1;5C' forward-word

# Enable completion
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
fpath+="$XDG_DATA_HOME"/zsh/site-functions
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION

# Enable completion for special dirs (. and ..)
zstyle ':completion:*' special-dirs true

# Make tab-completion case insensitive
setopt NO_CASE_GLOB

# Enable comments when working in an interactive shell
setopt interactive_comments

# Customize characters used as word separators
export WORDCHARS='*?!_-.~=/&;|#$%^()[]{}<>'

# Enable command-not-found, if present
if [ -f /etc/zsh_command_not_found ]; then
	source /etc/zsh_command_not_found
fi

# Enable fzf shell integration - https://github.com/junegunn/fzf.
if [ -x "$(command -v fzf)" ]; then
	source <(fzf --zsh)
fi

# Enable z shell integration - https://github.com/rupa/z.
if [ -f "$XDG_DATA_HOME/z/z.sh" ]; then
        export _Z_DATA="$XDG_STATE_HOME/z"
        source "$XDG_DATA_HOME/z/z.sh"
fi

# Initialize micromamba - https://mamba.readthedocs.io.
if [ -x "$(command -v micromamba)" ]; then
	export MAMBA_EXE="$(command -v micromamba)"
	export MAMBA_ROOT_PREFIX="$XDG_DATA_HOME/conda"
	eval "$("$MAMBA_EXE" shell hook --shell zsh \
		--root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
fi

# Source additional files
if [ -d "$XDG_CONFIG_HOME/shell" ]; then
	for f in "$XDG_CONFIG_HOME"/shell/*.(z|)sh; do
		source $f
	done
	unset f
fi

# Plugins management (https://github.com/mattmc3/zsh_unplugged)
function plugin-load {
  local repo plugdir initfile initfiles=()
  : ${ZPLUGINDIR:=${HOME}/.local/share/zsh/plugins}
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
      (( $#initfiles )) || {echo >&2 "No init file found '$repo'." && continue}
      ln -sf $initfiles[1] $initfile
    fi
    fpath+=$plugdir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

# Load plugins
plugin-load zsh-users/zsh-autosuggestions
plugin-load zsh-users/zsh-syntax-highlighting
plugin-load zsh-users/zsh-history-substring-search && \
	bindkey '^[[A' history-substring-search-up && \
	bindkey '^[[B' history-substring-search-down
