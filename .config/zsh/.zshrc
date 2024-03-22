# ~/.config/zsh/zshrc

# export SHELL variable for tmux
export SHELL=$(which zsh)

# Set propmpt
PROMPT='%F{cyan}%~ %(?.%F{green}.%F{red})%\▸%f '

# Key bindings
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

# Enable completion
autoload -Uz compinit && compinit

# Load local configuration file
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/zsh.local ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/zsh.local
fi

# Load aliases
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/sh/aliases ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}"/sh/aliases
fi
