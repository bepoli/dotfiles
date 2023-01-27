#
# ~/.bash_aliases
#

# alias to manage dotfiles in a bare repo
alias config='/usr/bin/git --git-dir=$HOME/.config/dotfiles --work-tree=$HOME'

# quality-of-life aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
if [ ! -x "$(command -v realpath)" ]; then
  if [ -x "$(command -v readlink)" ]; then
    alias realpath='readlink -f'
  fi
fi
[ -x "$(command -v batcat)" ] && alias bat='batcat'
[ -x "$(command -v tmux)" ] && alias tm='tmux attach-session -d'
[ -x "$(command -v vim)" ] && alias vi='vim'
command -v micromamba &>/dev/null && alias mm='micromamba'

# remove lines starting with "ibwarn" from slurm stderr
sedibwarn() {
  if [[ "$1" =~ "^slurm-.+" ]]; then
    sed -i '/^ibwarn/d' $1
  else
    echo 'Error: not a slurm output file'
  fi
}

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
  ps aux | awk '
  BEGIN {print "USER\t%CPU\tRSS(GB)"}
  { rss[$1]+=$6; cpu[$1]+=$3 }
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
