#  _____    _
# |__  /___| |__  _ __ ___
#   / // __| '_ \| '__/ __|
#  / /_\__ \ | | | | | (__
# /____|___/_| |_|_|  \___|
# vim: ts=2 sts=2 sw=2 et

setopt PROMPT_SUBST
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt NO_CASE_GLOB
setopt INTERACTIVE_COMMENTS

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
PROMPT='%(1j.[%j] .)'\
"$([ -n "$SSH_TTY" ] && echo '%F{yellow}%M%F{white}:' ||:)"\
'%F{cyan}%2c %F{magenta}${vcs_info_msg_0_}%(?.%F{green}.%F{red})%\▸%f '

bindkey '\e[H' beginning-of-line
bindkey '^[OH' beginning-of-line
bindkey '\e[1~' beginning-of-line
bindkey '\e[7~' beginning-of-line
bindkey '\e[F' end-of-line
bindkey '^[OF' end-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[8~' end-of-line
bindkey '\e[3~' delete-char
bindkey '\e[1;5D' backward-word
bindkey '\e[1;5C' forward-word

fpath+="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions"
autoload -Uz compinit
compinit
zstyle ':completion:*' special-dirs true

# Set LS_COLORS
[ -x "$(command -v dircolors)" ] && eval "$(dircolors -b)"

# Enable command-not-found, if present and not already enabled
if ! typeset -f command_not_found_handler &>/dev/null; then
  if [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
    source /usr/share/doc/pkgfile/command-not-found.zsh
  elif [ -f /etc/zsh_command_not_found ]; then
    source /etc/zsh_command_not_found
  fi
fi

# fzf - https://github.com/junegunn/fzf
if [ -x "$(command -v fzf)" ]; then
  if zsh --version | grep -qE '^((0\.(4[8-9])|([5-9][0-9]))|1)'; then
    source <(fzf --zsh)
  fi
fi

# zoxide - https://github.com/ajeetdsouza/zoxide
[ -x "$(command -v zoxide)" ] && eval "$(zoxide init zsh)"

# micromamba - https://mamba.readthedocs.io
if [ -x "$(command -v micromamba)" ]; then
  export MAMBA_EXE="$(command -v micromamba)"
  export MAMBA_ROOT_PREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/conda"
  eval "$("$MAMBA_EXE" shell hook --shell zsh \
    --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
fi

# source other config files
for f in "${XDG_CONFIG_HOME:-$HOME/.config}"/shell/*.(sh|zsh); do
  source "$f"
done
unset f

# load plugins
plugin-load zsh-users/zsh-autosuggestions
plugin-load zsh-users/zsh-syntax-highlighting
plugin-load zsh-users/zsh-history-substring-search && \
  bindkey '^[[A' history-substring-search-up && \
  bindkey '^[[B' history-substring-search-down
