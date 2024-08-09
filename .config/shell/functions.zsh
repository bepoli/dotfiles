# plugins management, edited from https://github.com/mattmc3/zsh_unplugged
plugin-load() {
  local repo plugdir initfiles zpd=()
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

