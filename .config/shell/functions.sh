# Print the header (the first line of input)
# and then run the specified command on the body (the rest of the input)
# use it in a pipeline, e.g. ps | body grep somepattern
# (ref:https://unix.stackexchange.com/a/11859)
body() {
	IFS= read -r header
	printf '%s\n' "$header"
	"$@"
}

# Complement a DNA sequence
cdna() {
	if [ -n "$1" ]; then
		echo "$1" | tr 'ACGTRYKMBDHV' 'TGCAYRMKVHDB'
	else
		tr 'ACGTRYKMBDHV' 'TGCAYRMKVHDB'
	fi
}

# Reverse complement a DNA sequence
revc() {
	if [ -n "$1" ]; then
		echo "$1" | rev | tr 'ACGTRYKMBDHV' 'TGCAYRMKVHDB'
	else
		rev | tr 'ACGTRYKMBDHV' 'TGCAYRMKVHDB'
	fi
}

# count unique lines; sortcut for `sort -u | wc -l`
wcu() {
	if [ -n "$1" ]; then
		sort -u "$1" | wc -l
	else
		sort -u | wc -l
	fi
}

# Add the executed command line to output's header
cmdump() {
	echo -E "# $*"
	"$@"
}

# Create directory and enter it
cmkdir() {
	mkdir -p "$1" && cd "$1" || return
}

# Check resource usage by user
userusage() {
	ps aux | awk '{print $1,$3,$6,$8}' | sort -u | awk '
  BEGIN {print "USER\t%CPU\tRSS(GB)"}
  { rss[$1]+=$3; cpu[$1]+=$2 }
  END { for(i in rss){OFS="\t"; print i,cpu[i],rss[i]/1000000} }'
}

# Wrapper for `zcat <file.gz> | head`
# usage: zhead <file.gz> [10]
zhead() {
	if [ -z "$2" ]; then
		local n=10
	else
		local n="$2"
	fi
	zcat "$1" | head -n "$n"
}

# Quickly remove large directories with rsync
rsyncrm() {
	mkdir rsrm_empty
	rsync -a --delete rsrm_empty/ "$1"
	rmdir rsrm_empty "$1"
}

# Scrape biocontainers
biocontainers() {
	local url="https://quay.io/api/v1/repository/biocontainers"
	local sprefix="https://depot.galaxyproject.org/singularity"
	local dprefix="quay.io/biocontainers"
	curl -s -X GET "$url"/"$1"/tag/ |
		python3 -c "import json,sys;from datetime import datetime;\
    obj=json.load(sys.stdin);\
    print('docker_image\tsingularity_image\tlast_modified');\
    [print('$dprefix/$1:{}\t$sprefix/$1:{}\t{}'.format(\
      x['name'], x['name'], datetime.strptime(x['last_modified'], '%a, %d %b %Y %H:%M:%S -0000')\
    )) for x in obj['tags']]"
}
biocontainers_galaxy() {
	local url="https://depot.galaxyproject.org/singularity/"
	curl -s $url | sed 's/\r$//' | grep -v "\-$" | grep "^<a href" |
		sed 's/<[^<>]*>//g' |
		awk -vurl=$url '{print url""$1"\t"$2"-"$3}'
}

# SSH to current directory
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
	ssh -t "$1" "cd $PWD; $shell $args"
}

# Get numbered header COLUMNS
nheader() {
	head -n 1 "$1" | tr '\t' '\n' | nl
}

# Generate duckduckgo email alias
duck() {
	curl -s -H "Content-Type: application/json" \
		-H "Authorization: Bearer ${DUCK_TOKEN:-$1}" \
		-X POST \
		https://quack.duckduckgo.com/api/email/addresses |
		sed 's/.*"\([^"]\+\)"}/\1@duck.com\n/'
}

# Automatize python virtual environments
venv() {
	local venv_dir="${1:-.venv}"
	if [ ! -d "$venv_dir" ]; then
		python -m venv "$venv_dir"
	fi
	source "$venv_dir/bin/activate"
}
