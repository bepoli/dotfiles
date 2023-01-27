#!/bin/bash

mkdir -p $XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME $XDG_STATE_HOME

while getopts ":w:hm" opt; do
	case $opt in
		h)
			echo 'Usage ...'
			;;
		m)
			if [ -x "$(command -v bzip2)" ]; then
				m=1
			else
				echo "Error: installing micromamba requires bzip2"
				exit 1
			fi
			;;
		w)
			if [ -n "$OPTARG" ]; then
				w=$OPTARG
			else
				w=$USER
			fi
			;;
		:)
			echo "Option -$OPTARG requires an argument." >&2
			exit 1
			;;
	esac
done

if [ "$m" == "1" ]; then
	mkdir -p ~/.local/bin && \
	curl -L https://micro.mamba.pm/api/micromamba/linux-64/latest \
	| tar -xvj -C ~/.local/bin --strip-components=1 bin/micromamba
fi

if [ -n "$w" ]; then
	[ ! -e ~/win ] && ln -s /mnt/c/Users/$w ~/win
	[ ! -e ~/.ssh ] && ln -s /mnt/c/Users/$w/.ssh ~/.ssh
fi
