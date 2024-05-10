#!/bin/bash

if [ ! -f ~/.config/tmux/blacklist ]; then
	touch ~/.config/tmux/blacklist
fi

if [ -x "$(command -v sacct)" ]; then
	#cat <(command sacct -n -o 'jobid,state' -S 'now-24hours') <(command squeue -u $USER -h -o '%i %t' -t PD) \
	cat <(command sacct -n -o 'jobid,state' -S 'now-24hours') \
	| grep -vwf ~/.config/tmux/blacklist \
	| awk '$1!~/batch/ && $2!~/CANCELLED/ {
		a[substr($2,1,1)]+=1;next
	} END {
		outline="";
		for(i in a) outline=outline""i":"a[i]" ";
		sub(/ $/,"",outline);
		if(outline) print " | "outline
	}'
fi

