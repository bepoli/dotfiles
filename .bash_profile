# ~/.bash_profile

# Allow teammates to edit my files
umask 002

# Set locale
export LC_ALL=C.UTF-8 LANG=C.UTF-8

# Add user's trailing and leading PATH
export PATH="$HOME/.local/bin:$PATH:$HOME/bin"

# History settings
export HISTCONTROL=ignoreboth
export HISTIGNORE=?:??
export HISTSIZE=50000
export HISTFILESIZE=50000

# Shell options
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

# Configure tab-completion
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'

# Make less more friendly for non-text input files with lesspipe
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc). This also enables `__git_ps1`.
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Source all dotfiles
if [ -d ~/.config/bash ]; then
	for f in ~/.config/bash/*; do
		[ -r "$f" ] && [ -f "$f" ] && . "$f"
	done
	unset f
fi

# Enable fzf shell integration
[ -x "$(command -v fzf)" ] && eval "$(fzf --bash)"

# Add autocompletion to all aliases (https://github.com/cykerway/complete-alias)
if declare -F _complete_alias &>/dev/null; then
	complete -F _complete_alias "${!BASH_ALIASES[@]}"
fi

