# ~/.bashrc: executed by bash for non-login shells.

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=50000
HISTFILESIZE=50000

# Shell options
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

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

# Set prompt
__silent_eval() { local exit="$?"; eval "$1"; return $exit; }
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

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Enable fzf shell integration (github.com/junegunn/fzf). Install with:
#  git clone --depth 1 -b 0.49.0 https://github.com/junegunn/fzf ~/.local/share/fzf
#  ~/.local/share/fzf/install --xdg --key-bindings --completion --no-update-rc
if [ -f ~/.config/fzf/fzf.bash ]; then
	. ~/.config/fzf/fzf.bash
fi

# Enable z shell integration (github.com/rupa/z). Install with:
#  git clone --depth 1 -b v1.12 https://github.com/rupa/z ~/.local/share/z
#  mkdir -p ~/.local/state/z
if [ -f ~/.local/share/z/z.sh ]; then
	export _Z_DATA="$HOME/.local/state/z/z_data"
	. ~/.local/share/z/z.sh
fi

# Initialize conda/mamba/micromamba (mamba.readthedocs.io). Install with:
#  curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest \
#  | tar -C ~/.local -xvj bin/micromamba
if [ -x "$HOME/conda/bin/conda" ]; then
	eval "$($HOME'/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
	if [ -f "$HOME/conda/etc/profile.d/mamba.sh" ]; then
		. "$HOME/conda/etc/profile.d/mamba.sh"
	fi
fi
if [ -x "$(command -v micromamba)" ]; then
	export MAMBA_EXE="$(command -v micromamba)"
	export MAMBA_ROOT_PREFIX="$HOME/conda"
	eval "$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
fi

# Source aliases
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# Source additional files
if [ -d ~/.config/shell ]; then
	for f in ~/.config/shell/*.?(ba)sh; do
		. $f
	done
	unset f
fi

# Add autocompletion to all aliases (github.com/cykerway/complete-alias).
if declare -F _complete_alias &>/dev/null; then
	complete -F _complete_alias "${!BASH_ALIASES[@]}"
fi

