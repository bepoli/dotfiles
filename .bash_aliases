# quality-of-life aliases
if [ ! -x "$(command -v bat)" ]; then
  if [ -x "$(command -v batcat)" ]; then
    alias bat='batcat'
  fi
fi
if [ ! -x "$(command -v realpath)" ]; then
  if [ -x "$(command -v readlink)" ]; then
    alias realpath='readlink -f'
  fi
fi
[ -x "$(command -v tmux)" ] && alias tm='tmux attach-session -d'
[ -x "$(command -v vim)" ] && alias vi='vim'

# conda shortcuts
if command -v conda &>/dev/null; then
  alias ca='conda activate'
  alias cas='conda activate --stack'
  alias cda='conda deactivate'
fi

# containers
jlab() {
  docker run -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -v "${PWD}":/home/jovyan/work $1 jupyter/base-notebook:latest
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
