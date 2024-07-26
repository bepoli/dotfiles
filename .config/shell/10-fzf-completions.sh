# ~/.config/shell/fzf-completion.bash

# Run only if fzf has been initialized
if ! declare -F _fzf_complete &>/dev/null; then
	return 0
fi

# Slurm process IDs
_fzf_complete_scancel() {
	_fzf_complete --multi --header-lines=1 -- "$@" < <(squeue -u $USER)
}
_fzf_complete_scancel_post() {
	awk '{print $1}'
}
[ -n "$BASH" ] && complete -F _fzf_complete_scancel -o default -o bashdefault scancel || :

_fzf_complete_scontrol() {
	_fzf_complete --header-lines=1 -- "$@" < <(squeue)
}
_fzf_complete_scontrol_post() {
	awk '{print $1}'
}
[ -n "$BASH" ] && complete -F _fzf_complete_scontrol -o default -o bashdefault scancel || :

# Z integration (https://github.com/junegunn/fzf/wiki/examples#z)
if type -w _z &>/dev/null; then
	unalias z 2> /dev/null
	function z() {
		[ $# -gt 0 ] && _z "$*" && return
		cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
	}
fi
