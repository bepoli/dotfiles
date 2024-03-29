#!/bin/bash

# alias to manage dotfiles in a bare repo
alias config='git --git-dir=$HOME/.config/dotfiles --work-tree=$HOME'

# colored outputs
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# quality-of-life aliases
[ -x "$(command -v batcat)" ] && alias bat='batcat'
alias la='ls -A'
alias l='ls -CF'
alias ll='ls -alF'
if [ ! -x "$(command -v realpath)" ] && [ -x "$(command -v readlink)" ]; then
	alias realpath='readlink -f'
fi
alias fsort='LC_ALL=C sort'
[ -x "$(command -v stow)" ] && alias stow='stow --no-folding'
if [ -x "$(command -v tmux)" ]; then
	alias tm='tmux attach-session -d'
	alias tmc='tmux load-buffer'
	alias tmv='tmux save-buffer'
fi
[ -x "$(command -v vim)" ] && alias vi='vim'
[ -x "$(command -v nvim)" ] && alias vim='nvim'

# store wget cache in XDG_STATE_HOME
alias wget="wget --hsts-file=${XDG_DATA_HOME:-$HOME/.local/share}/wget-hsts"

# slurm shortcuts
if [ -x "$(command -v sbatch)" ]; then
	__jobcols() { printf $((${COLUMNS}/4)); }
	alias squeue='squeue -o "%.18i %.9P %.$(__jobcols)j %.8u %.2t %.10M %.6D %R"'
	alias sacct='sacct -o "jobid,jobname%$(__jobcols),alloccpus,MaxRSS,state,exitcode,Start,End"'
fi

# conda aliases
if command -v micromamba &>/dev/null; then
	#alias conda='micromamba'
	alias c='micromamba'
elif command -v mamba &>/dev/null; then
	#alias conda='mamba'
	alias c='mamba'
elif command -v conda &>/dev/null; then
	alias c='conda'
fi
alias ca='c activate' cda='c deactivate'

