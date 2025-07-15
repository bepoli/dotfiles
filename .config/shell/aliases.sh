# Alias to manage dotfiles in a bare repo
alias config='git --git-dir=$HOME/.config/dotfiles --work-tree=$HOME'

# Colored outputs
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Quality-of-life aliases
[ -x "$(command -v batcat)" ] && alias bat='batcat'
alias la='ls -A'
alias l='ls -CF'
alias ll='ls -alF'
if [ ! -x "$(command -v realpath)" ] && [ -x "$(command -v readlink)" ]; then
	alias realpath='readlink -f'
fi
alias fsort='LC_ALL=C sort'
[ -x "$(command -v stow)" ] && alias stow='stow --no-folding'
[ -x "$(command -v zoxide)" ] && [ -x "$(command -v fzf)" ] && alias z='zi'

# Tmux aliases
if [ -x "$(command -v tmux)" ]; then
	tm() {
		if [ -n "$1" ]; then
			tmux attach-session -d -t "$1"
		else
			tmux attach-session -d
		fi

	}
	alias tmc='tmux load-buffer'
	alias tmv='tmux save-buffer'
fi

# Conda aliases
if command -v micromamba &>/dev/null; then
	alias c='micromamba'
	! command -v mamba &>/dev/null && alias mamba='micromamba'
	! command -v conda &>/dev/null && alias conda='micromamba'
elif command -v mamba &>/dev/null; then
	alias c='mamba'
elif command -v conda &>/dev/null; then
	alias c='conda'
fi
alias ca='c activate' cda='c deactivate'

# Slurm aliases
if [ -x "$(command -v sbatch)" ]; then
	__jobcols() { printf '%s' "$((COLUMNS / 4))"; }
	alias squeue='squeue -o "%.18i %.9P %.$(__jobcols)j %.8u %.2t %.10M %.6D %R"'
	alias sq='squeue' squ='squeue -u $USER'
	alias sacct='sacct -o "jobid,jobname%$(__jobcols),alloccpus,MaxRSS,state,exitcode,Start,End"'
	alias ssj='scontrol show job'
fi
