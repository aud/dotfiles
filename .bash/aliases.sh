# Shutdown all Railgun vms
rsa() {
  local railgun_stop_all="railgun status -a -H -o name | xargs -n1 railgun stop"
  local kill_node="kill -9 `ps aux | rg 'bin/[n]ode' | awk '{print $2}'` 2>/dev/null"
  local kill_sewing_kit="kill -9 `ps aux | rg '.bin/[s]ewing-kit' | awk '{print $2}'` 2>/dev/null"

  echo "running ${railgun_stop_all}"
  eval "$railgun_stop_all"

  echo "running ${kill_node}"
  eval "$kill_node"

  echo "running ${kill_sewing_kit}"
  eval "$kill_sewing_kit"
}

# Common
alias c="clear"
alias ls="ls -Ga"

# Overwrite default install with brew package
alias ctags="/usr/local/bin/ctags"

# Use neovim instead
alias vim="/usr/local/bin/nvim"
alias vi="/usr/local/bin/nvim"

# Default to xterm with ssh
alias ssh='TERM=xterm ssh'

# Remove newline
alias nn="tr -d '\n'"
