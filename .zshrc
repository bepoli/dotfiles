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

# Enable command-not-found, if present
if ! typeset -f command_not_found_handler &>/dev/null; then
  if [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
    source /usr/share/doc/pkgfile/command-not-found.zsh
  elif [ -f /etc/zsh_command_not_found ]; then
    source /etc/zsh_command_not_found
  fi
fi

# fzf - https://github.com/junegunn/fzf
[ -x "$(command -v fzf)" ] && source <(fzf --zsh) ||:

# zoxide - https://github.com/ajeetdsouza/zoxide
[ -x "$(command -v zoxide)" ] && eval "$(zoxide init zsh)" ||:

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

# plugins management, edited from https://github.com/mattmc3/zsh_unplugged
function plugin-load {
  local repo plugdir initfile initfiles zpd=()
  local ZPLUGDIRS=(
    "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
    '/usr/local/share/zsh/plugins'
    '/usr/share/zsh/plugins'
  )
  for repo in $@; do
    for zpd in $ZPLUGDIRS; do
      plugdir="$zpd/${repo:t}"
      if [[ -d "$plugdir" ]]; then
        break
      fi
    done
    if [[ ! -d "$plugdir" ]]; then
      printf "Clone $repo ? [yN]"
      if read -q; then
        git clone -q --depth 1 --recursive --shallow-submodules \
          https://github.com/"$repo" "$plugdir"
      else
        continue
      fi
    fi
    initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
    (( $#initfiles )) || {echo >&2 "No init file found '$repo'." && continue}
    source $initfiles[1]
  done
}
plugin-load zsh-users/zsh-autosuggestions
plugin-load zsh-users/zsh-syntax-highlighting
plugin-load zsh-users/zsh-history-substring-search && \
  bindkey '^[[A' history-substring-search-up && \
  bindkey '^[[B' history-substring-search-down
