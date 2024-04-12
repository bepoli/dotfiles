# ~/.config/shell/fzf-completion.bash

# Run only if fzf has been initialized
if ! declare -F _fzf_complete &>/dev/null; then
	return 0
fi

# Slurm process IDs
_fzf_complete_slurm() {
	_fzf_complete --multi --header-lines=1 -- "$@" < <(squeue -u $USER)
}
_fzf_complete_slurm_post() {
	awk '{print $1}'
}
complete -F _fzf_complete_slurm -o default -o bashdefault scancel

