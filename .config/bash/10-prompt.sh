#/bin/bash

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

