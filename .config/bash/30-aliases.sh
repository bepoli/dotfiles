
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

# remove lines starting with "ibwarn" from slurm stderr
sedibwarn() { sed -i '/^ibwarn/d' $1; }
catibwarn() { grep -v '^ibwarn' $1; }

# print the header (the first line of input)
# and then run the specified command on the body (the rest of the input)
# use it in a pipeline, e.g. ps | body grep somepattern
# (ref:https://unix.stackexchange.com/a/11859)
body() {
  IFS= read -r header
  printf '%s\n' "$header"
  "$@"
}

# reverse complement a DNA sequence
revcom() {
  if [ -n "$1" ]; then
    echo "$1" | rev | tr "TACG" "ATGC"
  else
    rev | tr "TACG" "ATGC"
  fi
}

# count unique lines; sortcut for `sort -u | wc -l`
wcu() {
  sort -u $1 | wc -l
}

# add header to the output with the command used to generate it
cmdump() {
  cat <( history | tail -1 | sed 's/\ [0-9]\+\ \+/#\ /') -
}

# create directory and enter it
cmkdir() {
  mkdir -p $1 && cd $1
}

# check resource usage by user
userusage() {
  ps aux | awk '{print $1,$3,$6,$8}' | sort -u | awk '
  BEGIN {print "USER\t%CPU\tRSS(GB)"}
  { rss[$1]+=$3; cpu[$1]+=$2 }
  END { for(i in rss){OFS="\t"; print i,cpu[i],rss[i]/1000000} }'
}

# wrapper for `zcat <file.gz> | head`
# usage: zhead <file.gz> [10]
zhead() {
  if [ -z $2 ]; then
    local n=10
  else
    local n=$2
  fi
  zcat $1 | head -n $n
}

# quickly remove large directories with rsync
rsyncrm() {
  mkdir rsrm_empty
  rsync -a --delete rsrm_empty/ $1
  rmdir rsrm_empty $1
}

# scrape biocontainers
biocontainers() {
  local url="https://quay.io/api/v1/repository/biocontainers"
  local sprefix="https://depot.galaxyproject.org/singularity"
  local dprefix="quay.io/biocontainers"
  curl -s -X GET $url/$1/tag/ \
  | python3 -c "import json,sys;from datetime import datetime;\
    obj=json.load(sys.stdin);\
    print('docker_image\tsingularity_image\tlast_modified');\
    [print('$dprefix/$1:{}\t$sprefix/$1:{}\t{}'.format(\
      x['name'], x['name'], datetime.strptime(x['last_modified'], '%a, %d %b %Y %H:%M:%S -0000')\
    )) for x in obj['tags']]"
}
biocontainers_galaxy() {
  local url="https://depot.galaxyproject.org/singularity/"
  curl -s $url | sed 's/\r$//' | grep -v "\-$" | grep "^<a href" \
  | sed 's/<[^<>]*>//g' \
  | awk -vurl=$url '{print url""$1"\t"$2"-"$3}'
}

# ssh to PWD
sshpwd() {
  local shell=${SHELL:-bash}
  case "$shell" in
  	*/sh)
		local args=""
		;;
	*)
		local args=${2:-"--login"}
		;;
  esac
  ssh -t $1 "cd $PWD; $shell $args"
}

# get numbered header COLUMNS
nheader() {
	head -n 1 $1 | tr '\t' '\n' | nl
}
