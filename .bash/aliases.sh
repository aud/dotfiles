# Shutdown all Railgun vms
rsa() {
  ruby $HOME/dotfiles/scripts/kill.rb
}

ssa() {
  spin list | awk '{print $1}' | sed "1,2d" | xargs -n1 -I{} spin destroy {}
}

# Scripting to see most common bash commands (bash_history out of ~50k)
# revealed that `gi tpull` and `gi ts` (`git pull`, `git status`) are fairly
# common commands. This is probably because the t key is sticky. Recover this
# command gracefully.
gi() {
  if [[ "$1" == "tpull" ]]; then
    git pull
  elif [[ "$1" == "ts" ]]; then
    git status
  else
    echo "-bash: gi: command not found" >&2
  fi
}

# Common
alias c="clear"
alias ls="ls -Ga"

# Overwrite default install with brew package
alias ctags="/usr/local/bin/ctags"

# Use neovim instead
if [[ $SPIN ]]; then
  alias vim="/usr/bin/nvim"
  alias vi="/usr/bin/nvim"
else
  alias vim="/usr/local/bin/nvim"
  alias vi="/usr/local/bin/nvim"
fi

# Default to xterm with ssh
# alias ssh='TERM=xterm ssh'

# Remove newline
alias nn="tr -d '\n'"
