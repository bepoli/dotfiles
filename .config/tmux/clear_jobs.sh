#!/bin/sh

command sacct -n -o 'jobid,state' -S 'now-24hours' \
	| grep -vw RUNNING | grep -vw PENDING \
	| cut -f1 -d' ' > ~/.config/tmux/blacklist
