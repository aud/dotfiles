alias rsa="$HOME/dotfiles/scripts/kill.rb"
alias latest="chruby ruby"

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

alias vim="/opt/homebrew/bin/nvim"
alias vi="/opt/homebrew/bin/nvim"

alias cat="bat --paging=never"

# Default to xterm with ssh
# alias ssh='TERM=xterm ssh'

# Remove newline
alias nn="tr -d '\n'"

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

alias python=python3
