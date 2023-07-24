#
# ~/.bashrc: executed by bash for non-login shells
#

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# Bash History configuration
export HISTFILE="$XDG_STATE_HOME"/bash/history
HISTSIZE=50000
HISTFILESIZE=50000

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Make tab-completion case-insensitive
bind "set completion-ignore-case on"

# Make less more friendly for non-text input files, see lesspipe(1)
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

# Execute an expression suppressing the exit status
__silent_eval() {
	local exit="$?"
	eval "$1"
	return $exit
}

# Set prompt
__build_ps1() {
        local Bla='\[\e[0m\]'  Gra='\[\e[90m\]' Red='\[\e[91m\]'
	local Gre='\[\e[92m\]' Yel='\[\e[93m\]' Blu='\[\e[94m\]'
	local Mag='\[\e[95m\]' Cya='\[\e[96m\]' Whi='\[\e[97m\]'
	local Job='$(__silent_eval "[ \j -gt 0 ] && echo \(\j\)")'
	[ -n "$SSH_TTY" ] && local Hos="${Yel}\h${Bla}:"
	declare -F __git_ps1 &>/dev/null && local Git='$(__git_ps1 "%s ")'
	local Arr='\[\e[$(($??91:92))m\]▸'
        echo "${Gra}${Job}${Hos}${Blu}\W ${Mag}${Git}${Arr}${Bla} "
}
PS1=$(__build_ps1) && unset __build_ps1

# Enable colored output on some commands
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$($HOME'/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
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

# Local configuration file
if [ -f "$XDG_CONFIG_HOME/bash/bash.local" ]; then
	. "$XDG_CONFIG_HOME/bash/bash.local"
fi

# Alias definitions
if [ -f "$HOME/.bash_aliases" ]; then
	. "$HOME/.bash_aliases"
fi

# Add autocompletion to all aliases (https://github.com/cykerway/complete-alias)
if declare -F _complete_alias &>/dev/null; then
	complete -F _complete_alias "${!BASH_ALIASES[@]}"
fi

