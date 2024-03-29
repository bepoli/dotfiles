#!/bin/bash

# Print the header (the first line of input)
# and then run the specified command on the body (the rest of the input)
# use it in a pipeline, e.g. ps | body grep somepattern
# (ref:https://unix.stackexchange.com/a/11859)
body() {
	IFS= read -r header
	printf '%s\n' "$header"
	"$@"
}

# Reverse complement a DNA sequence
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

# Add the executed command line to output's header
cmdump() {
	cat <( history | tail -1 | sed 's/\ [0-9]\+\ \+/#\ /') -
}

# Create directory and enter it
cmkdir() {
	mkdir -p $1 && cd $1
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
	if [ -z $2 ]; then
		local n=10
	else
		local n=$2
	fi
	zcat $1 | head -n $n
}

# Quickly remove large directories with rsync
rsyncrm() {
	mkdir rsrm_empty
	rsync -a --delete rsrm_empty/ $1
	rmdir rsrm_empty $1
}

# Scrape biocontainers
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
