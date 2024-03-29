#!/bin/bash

# Mamba documentation:
# 	https://mamba.readthedocs.io/en/latest/
# Micromamba auto-install:
# 	"${SHELL}" <(curl -L micro.mamba.pm/install.sh)

__conda_setup="$($HOME'/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/conda/etc/profile.d/conda.sh" ]; then
        . "$HOME/conda/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/conda/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "$HOME/conda/etc/profile.d/mamba.sh" ]; then
    . "$HOME/conda/etc/profile.d/mamba.sh"
fi

export MAMBA_EXE="$HOME/bin/micromamba";
export MAMBA_ROOT_PREFIX="$HOME/conda";
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup

