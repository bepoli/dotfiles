#!/bin/bash

if [ ! -f ~/.config/tmux/blacklist ]; then
	touch ~/.config/tmux/blacklist
fi

if [ -x "$(command -v sacct)" ]; then
	cat <(command sacct -n -o 'jobid,state' -S 'now-24hours') \
	| sed 's/ \+/ /' | sed -r 's/^([0-9]+)\.[^ ]+ /\1 /' | sort -u \
	| grep -vwf ~/.config/tmux/blacklist \
	| awk '$1!~/[0-9]+\.b/ && $2!~/CANCELLED/ {
		a[substr($2,1,1)]+=1;next
	} END {
		outline="";
		for(i in a) outline=outline""i":"a[i]" ";
		sub(/ $/,"",outline);
		if(outline) print " | "outline
	}'
fi

