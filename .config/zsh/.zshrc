# ~/.config/zsh/zshrc

# export SHELL variable for tmux
export SHELL=$(which zsh)

# Set propmpt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT="%F{yellow}$([ -n "$SSH_TTY" ] && echo '%M' || echo '')%F{white}:"'%F{cyan}%2c %F{magenta}${vcs_info_msg_0_}%(?.%F{green}.%F{red})%\▸%f '

# Key bindings
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Enable completion
autoload -Uz compinit && compinit

# Make tab-completion case insensitive
setopt NO_CASE_GLOB

# Load local configuration file
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/zsh.local ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/zsh.local
fi

# Load aliases
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/sh/aliases ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}"/sh/aliases
fi
