# ~/.config/zsh/zshrc

# export SHELL variable for tmux
export SHELL=$(which zsh)

# Set propmpt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT="%F{yellow}$([ -n "$SSH_TTY" ] && echo '%M' || echo '')%F{white}:"'%F{cyan}%2c %F{magenta}${vcs_info_msg_0_}%(?.%F{green}.%F{red})%\▸%f '

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

# Load local configuration file
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/zsh.local ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/zsh.local
fi

# Load aliases
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/sh/aliases ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}"/sh/aliases
fi

